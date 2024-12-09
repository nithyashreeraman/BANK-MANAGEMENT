from flask import Flask, render_template, request, redirect, flash, session
import cx_Oracle
import os

app = Flask(__name__)

# Set the secret key for sessions and flash messages
app.secret_key = os.urandom(24) 

# Database connection details
dsn_tns = cx_Oracle.makedsn("prophet.njit.edu", 1521, sid="course")
connection = cx_Oracle.connect(user="nr588", password="tyra27COSX!!", dsn=dsn_tns)

# Hardcoded credentials for customers and employees
CUSTOMER_CREDENTIALS = {"nith": "nith1", "sharath": "sha1","tanu":"tanu1"}
EMPLOYEE_CREDENTIALS = {"bob": "bob1", "john": "john1"}


@app.route('/', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form.get('username')
        password = request.form.get('password')
        user_type = request.form.get('user_type')  # 'customer' or 'employee'

        if user_type == 'customer':
            # Validate customer credentials
            if username in CUSTOMER_CREDENTIALS and CUSTOMER_CREDENTIALS[username] == password:
                session['logged_in'] = True
                session['user_type'] = 'customer'
                session['username'] = username
                return redirect('/customer')
            else:
                flash("Invalid Customer username or password.")
        elif user_type == 'employee':
            # Validate employee credentials
            if username in EMPLOYEE_CREDENTIALS and EMPLOYEE_CREDENTIALS[username] == password:
                session['logged_in'] = True
                session['user_type'] = 'employee'
                session['username'] = username
                return redirect('/employee')
            else:
                flash("Invalid Employee username or password.")
        else:
            flash("Please select a valid user type.")

    return render_template('login.html')


@app.route('/customer', methods=['GET', 'POST'])
def customer():
    # Check if the user is logged in and is a customer
    if not session.get('logged_in') or session.get('user_type') != 'customer':
        return redirect('/')

    if request.method == 'POST':
        action = request.form.get('action')
        cssn = request.form.get('cssn')

        if action == 'view_balance':
            cursor = connection.cursor()
            try:
                query = """
                    SELECT SUM(Account.AccBalance) 
                    FROM ACCOUNT, CUST_ACC 
                    WHERE CSSN = :cssn AND Account.AccNo = Cust_Acc.AccNo
                """
                cursor.execute(query, {'cssn': cssn})
                result = cursor.fetchone()
                balance = result[0] if result else None
            except cx_Oracle.DatabaseError as e:
                print("Database Error:", e)
                balance = None
            finally:
                cursor.close()
            return render_template('customer_balance.html', cssn=cssn, balance=balance)

        elif action == 'add_customer':
            cname = request.form.get('cname')
            city = request.form.get('city')
            cursor = connection.cursor()
            try:
                query = "INSERT INTO CUSTOMERS (CSSN, CNAME, CITY) VALUES (:cssn, :cname, :city)"
                cursor.execute(query, {'cssn': cssn, 'cname': cname, 'city': city})
                connection.commit()
                flash("Customer added successfully!")
            except cx_Oracle.DatabaseError as e:
                print("Database Error:", e)
                flash("Failed to add customer.")
            finally:
                cursor.close()
            return redirect('/customer')

        elif action == 'view_loan_details':
            cursor = connection.cursor()
            try:
                query = """
                    SELECT DISTINCT c.CName, l.LoanNo, l.LAmount, l.LInterestRate, l.LRepayment, l.AccNo
                    FROM CUSTOMERS c
                    JOIN CUST_LOAN cl ON c.CSSN = cl.CSSN
                    JOIN LOAN l ON cl.LoanNo = l.LoanNo
                    WHERE c.CSSN = :cssn
                """
                cursor.execute(query, {'cssn': cssn})
                loans = cursor.fetchall()
            except cx_Oracle.DatabaseError as e:
                print("Database Error:", e)
                loans = []
            finally:
                cursor.close()

            if not loans:
                flash("Loan details aren't available for this particular customer.")
            return render_template('loan_details.html', cssn=cssn, loans=loans)

        elif action == 'view_account_type':
            cursor = connection.cursor()
            try:
                query = """
                    SELECT DISTINCT c.CName, a.AccType
                    FROM CUSTOMERS c
                    JOIN CUST_ACC ca ON c.CSSN = ca.CSSN
                    JOIN ACCOUNT a ON ca.AccNo = a.AccNo
                    WHERE c.CSSN = :cssn
                """
                cursor.execute(query, {'cssn': cssn})
                accounts = cursor.fetchall()
            except cx_Oracle.DatabaseError as e:
                print("Database Error:", e)
                accounts = []
            finally:
                cursor.close()

            if not accounts:
                flash("Account details aren't available for this particular customer.")
            return render_template('account_details.html', cssn=cssn, accounts=accounts)

    return render_template('customer.html')


@app.route('/employee', methods=['GET', 'POST'])
def employee():
    # Check if the user is logged in and is an employee
    if not session.get('logged_in') or session.get('user_type') != 'employee':
        return redirect('/')

    employee_details = None
    dependents = []
    message = ""

    if request.method == 'POST':
        essn = request.form.get('essn')
        if not essn:
            message = "Please enter a valid Employee SSN."
        else:
            try:
                with connection.cursor() as cursor:
                    # Fetch employee details
                    query_employee = """
                        SELECT ESSN, EName, EPhone, ManagerSSN, BID
                        FROM EMPLOYEE
                        WHERE ESSN = :essn
                    """
                    cursor.execute(query_employee, {'essn': essn})
                    employee_details = cursor.fetchone()

                    # Fetch dependents for the employee
                    query_dependents = """
                        SELECT DName, Relationship
                        FROM DEPENDENT
                        WHERE ESSN = :essn
                    """
                    cursor.execute(query_dependents, {'essn': essn})
                    dependents = cursor.fetchall()

                    if not employee_details:
                        message = f"No employee found with SSN: {essn}"

            except cx_Oracle.DatabaseError as e:
                error_obj = e.args[0]
                message = f"Database error: {error_obj.message}"

    return render_template('employee.html', employee=employee_details, dependents=dependents, message=message)


@app.route('/logout')
def logout():
    session.clear()
    flash("You have been logged out.")
    return redirect('/')


if __name__ == '__main__':
    app.run(debug=True)
