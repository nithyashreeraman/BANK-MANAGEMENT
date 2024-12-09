CREATE TABLE BANK_BRANCH (
    BID CHAR(5) PRIMARY KEY, -- Branch ID
    BName VARCHAR(50) NOT NULL, -- Branch Name
    BAsset DECIMAL(15, 2) NOT NULL, -- Branch Asset
    City VARCHAR(50),
    State CHAR(2),
    ZipCode CHAR(5),
    BManager CHAR(9), -- Branch Manager
    BAssManager CHAR(9) -- Assistant Manager
);

CREATE TABLE EMPLOYEE (
    ESSN CHAR(9) PRIMARY KEY,
    EName VARCHAR(50),
    EPhone VARCHAR(15),
    ManagerSSN CHAR(9),
    StartDate DATE,
    BID CHAR(5) REFERENCES BANK_BRANCH(BID)
    ON DELETE CASCADE 
);

CREATE TABLE DEPENDENT (
    DName VARCHAR(50),
    Relationship VARCHAR(20),
    ESSN CHAR(9),
    PRIMARY KEY(ESSn,DName),
    FOREIGN KEY (ESSN) REFERENCES EMPLOYEE(ESSN) 
    ON DELETE CASCADE 
);

CREATE TABLE CUSTOMERS (
    CSSN CHAR(9) PRIMARY KEY, -- Customer SSN
    CName VARCHAR(50) NOT NULL, -- Customer Name
    AptNo VARCHAR(10),
    StreetNo VARCHAR(50),
    City VARCHAR(50),
    State CHAR(2),
    ZipCode CHAR(5),
    ESSN CHAR(9), -- Personal Banker (Employee SSN)
    BID CHAR(5), -- Branch ID
    FOREIGN KEY (ESSN) REFERENCES EMPLOYEE(ESSN) ON DELETE CASCADE,
    FOREIGN KEY (BID) REFERENCES BANK_BRANCH(BID) ON DELETE CASCADE
);

CREATE TABLE ACCOUNT (
    AccNo CHAR(10) PRIMARY KEY, -- Account Number
    AccBalance DECIMAL(15, 2), -- Account Balance
    AccType VARCHAR(20) NOT NULL, -- Account Type (e.g., Checking, Savings)
    RecentDate DATE, -- Most recent access date
    BID CHAR(5), -- Branch ID
    FOREIGN KEY (BID) REFERENCES BANK_BRANCH(BID) ON DELETE CASCADE
);

CREATE TABLE CUST_ACC (
    CSSN CHAR(9), -- Customer SSN
    AccNo CHAR(10), -- Account Number
    PRIMARY KEY (CSSN, AccNo),
    FOREIGN KEY (CSSN) REFERENCES CUSTOMERS(CSSN) ON DELETE CASCADE,
    FOREIGN KEY (AccNo) REFERENCES ACCOUNT(AccNo) ON DELETE CASCADE
);

CREATE TABLE TRANSACTION (
    TCode CHAR(5) PRIMARY KEY, -- Transaction Code
    TName VARCHAR(50), -- Transaction Type (e.g., Withdrawal, Deposit)
    TCharge DECIMAL(10, 2), -- Transaction Charge
    TAmount DECIMAL(15, 2), -- Transaction Amount
    TDate DATE, -- Transaction Date
    THour TIMESTAMP, -- Transaction Hour (using TIMESTAMP to store time)
    AccNo CHAR(10), -- Account Number (FK)
    FOREIGN KEY (AccNo) REFERENCES ACCOUNT(AccNo) ON DELETE CASCADE
);

CREATE TABLE LOAN (
    LoanNo CHAR(10) PRIMARY KEY, -- Loan Number
    LAmount DECIMAL(15, 2), -- Loan Amount
    LInterestRate DECIMAL(5, 2), -- Loan Interest Rate
    LRepayment DECIMAL(15, 2), -- Loan Repayment Amount
    AccNo CHAR(10), -- Related Account Number
    FOREIGN KEY (AccNo) REFERENCES ACCOUNT(AccNo) ON DELETE CASCADE
);

CREATE TABLE CUST_LOAN (
    CSSN CHAR(9), -- Customer SSN
    LoanNo CHAR(10), -- Loan Number
    PRIMARY KEY (CSSN, LoanNo),
    FOREIGN KEY (CSSN) REFERENCES CUSTOMERS(CSSN) ON DELETE CASCADE,
    FOREIGN KEY (LoanNo) REFERENCES LOAN(LoanNo) ON DELETE CASCADE
);

CREATE TABLE CHECKING (
    AccNo CHAR(10) PRIMARY KEY, -- Account Number (FK)
    OverDraft DECIMAL(15, 2), -- Overdraft Amount
    FOREIGN KEY (AccNo) REFERENCES ACCOUNT(AccNo) ON DELETE CASCADE
);

CREATE TABLE SAVINGS (
    AccNo CHAR(10) PRIMARY KEY, -- Account Number (FK)
    SInterestRate DECIMAL(5, 2), -- Savings Interest Rate
    FOREIGN KEY (AccNo) REFERENCES ACCOUNT(AccNo) ON DELETE CASCADE
);

CREATE TABLE MONEY_MARKET (
    AccNo CHAR(10) PRIMARY KEY, -- Account Number (FK)
    MInterestRate DECIMAL(5, 2), -- Money Market Interest Rate
    FOREIGN KEY (AccNo) REFERENCES ACCOUNT(AccNo) ON DELETE CASCADE
);

ALTER TABLE BANK_BRANCH
ADD CONSTRAINT FK_BManager FOREIGN KEY (BManager) REFERENCES EMPLOYEE(ESSN);

ALTER TABLE BANK_BRANCH
ADD CONSTRAINT FK_BAssistantManager FOREIGN KEY (BAssManager) REFERENCES EMPLOYEE(ESSN);

-- BANK_BRANCH Table
INSERT INTO BANK_BRANCH (BID, BName, BAsset, City, State, ZipCode, BManager, BAssManager) 
VALUES ('B001', 'Main Branch', 5000000.00, 'New York', 'NY', '10001', NULL, NULL);

INSERT INTO BANK_BRANCH (BID, BName, BAsset, City, State, ZipCode, BManager, BAssManager) 
VALUES ('B002', 'Downtown Branch', 3000000.00, 'Los Angeles', 'CA', '90001', NULL, NULL);

INSERT INTO BANK_BRANCH (BID, BName, BAsset, City, State, ZipCode, BManager, BAssManager) 
VALUES ('B003', 'Uptown Branch', 4000000.00, 'Chicago', 'IL', '60601', NULL, NULL);

INSERT INTO BANK_BRANCH (BID, BName, BAsset, City, State, ZipCode, BManager, BAssManager) 
VALUES ('B004', 'East Side Branch', 2500000.00, 'Houston', 'TX', '77001', NULL, NULL);

INSERT INTO BANK_BRANCH (BID, BName, BAsset, City, State, ZipCode, BManager, BAssManager) 
VALUES ('B005', 'West Side Branch', 3500000.00, 'Phoenix', 'AZ', '85001', NULL, NULL);

INSERT INTO BANK_BRANCH (BID, BName, BAsset, City, State, ZipCode, BManager, BAssManager) 
VALUES ('B006', 'Suburb Branch', 2000000.00, 'San Diego', 'CA', '92101', NULL, NULL);


-- EMPLOYEE Table

INSERT INTO EMPLOYEE (ESSN, EName, EPhone, ManagerSSN, StartDate, BID) 
VALUES ('555555555', 'Eve Davis', '5559876544', NULL, TO_DATE('2023-02-25', 'YYYY-MM-DD'), 'B001');

INSERT INTO EMPLOYEE (ESSN, EName, EPhone, ManagerSSN, StartDate, BID) 
VALUES ('666666666', 'Frank Harris', '5551234568', NULL, TO_DATE('2023-03-01', 'YYYY-MM-DD'), 'B001');

INSERT INTO EMPLOYEE (ESSN, EName, EPhone, ManagerSSN, StartDate, BID) 
VALUES ('777777777', 'Grace Johnson', '5552345679', NULL, TO_DATE('2023-03-10', 'YYYY-MM-DD'), 'B002');

INSERT INTO EMPLOYEE (ESSN, EName, EPhone, ManagerSSN, StartDate, BID) 
VALUES ('888888888', 'Hannah Lee', '5553456780', NULL, TO_DATE('2023-04-01', 'YYYY-MM-DD'), 'B002');

INSERT INTO EMPLOYEE (ESSN, EName, EPhone, ManagerSSN, StartDate, BID) 
VALUES ('999999999', 'Ian Walker', '5554567891', NULL, TO_DATE('2023-05-01', 'YYYY-MM-DD'), 'B003');

INSERT INTO EMPLOYEE (ESSN, EName, EPhone, ManagerSSN, StartDate, BID) 
VALUES ('101010101', 'Jack Young', '5555678902', NULL, TO_DATE('2023-06-15', 'YYYY-MM-DD'), 'B003');

INSERT INTO EMPLOYEE (ESSN, EName, EPhone, ManagerSSN, StartDate, BID) 
VALUES ('202020202', 'Kara Brown', '5556789012', NULL, TO_DATE('2023-07-10', 'YYYY-MM-DD'), 'B004');

INSERT INTO EMPLOYEE (ESSN, EName, EPhone, ManagerSSN, StartDate, BID) 
VALUES ('303030303', 'Liam Martinez', '5557890123', NULL, TO_DATE('2023-08-20', 'YYYY-MM-DD'), 'B004');

INSERT INTO EMPLOYEE (ESSN, EName, EPhone, ManagerSSN, StartDate, BID) 
VALUES ('404040404', 'Maya White', '5558901234', NULL, TO_DATE('2023-09-05', 'YYYY-MM-DD'), 'B005');

INSERT INTO EMPLOYEE (ESSN, EName, EPhone, ManagerSSN, StartDate, BID) 
VALUES ('505050505', 'Nina Wilson', '5559012345', NULL, TO_DATE('2023-10-10', 'YYYY-MM-DD'), 'B005');

INSERT INTO EMPLOYEE (ESSN, EName, EPhone, ManagerSSN, StartDate, BID) 
VALUES ('606060606', 'Oscar Lopez', '5550123456', NULL, TO_DATE('2023-11-01', 'YYYY-MM-DD'), 'B006');

INSERT INTO EMPLOYEE (ESSN, EName, EPhone, ManagerSSN, StartDate, BID) 
VALUES ('707070707', 'Paul Green', '5551234576', NULL, TO_DATE('2023-11-10', 'YYYY-MM-DD'), 'B006');

INSERT INTO EMPLOYEE (ESSN, EName, EPhone, ManagerSSN, StartDate, BID) 
VALUES ('808080808', 'Quinn Adams', '5552345689', NULL, TO_DATE('2023-12-05', 'YYYY-MM-DD'), 'B001');

INSERT INTO EMPLOYEE (ESSN, EName, EPhone, ManagerSSN, StartDate, BID) 
VALUES ('909090909', 'Rita Clark', '5553456790', NULL, TO_DATE('2023-12-15', 'YYYY-MM-DD'), 'B001');

INSERT INTO EMPLOYEE (ESSN, EName, EPhone, ManagerSSN, StartDate, BID) 
VALUES ('111222333', 'Samantha Reed', '5554567901', NULL, TO_DATE('2023-12-25', 'YYYY-MM-DD'), 'B002');

-- UPDATE BANK_BRANCH TABLE 

UPDATE BANK_BRANCH 
SET BManager = '555555555', BAssManager = '666666666' 
WHERE BID = 'B001';

UPDATE BANK_BRANCH 
SET BManager = '777777777', BAssManager = '888888888' 
WHERE BID = 'B002';

UPDATE BANK_BRANCH 
SET BManager = '999999999', BAssManager = '101010101' 
WHERE BID = 'B003';

UPDATE BANK_BRANCH 
SET BManager = '202020202', BAssManager = '303030303' 
WHERE BID = 'B004';

UPDATE BANK_BRANCH 
SET BManager = '404040404', BAssManager = '505050505' 
WHERE BID = 'B005';

UPDATE BANK_BRANCH 
SET BManager = '606060606', BAssManager = '707070707' 
WHERE BID = 'B006';

-- UPDATE EMPLOYEE TABLE 
--Branch 1
UPDATE EMPLOYEE 
SET ManagerSSN = NULL -- Eve Davis (ESSN: 555555555) is the Manager, so no Manager for her
WHERE ESSN = '555555555' 
AND BID = 'B001';

UPDATE EMPLOYEE 
SET ManagerSSN = '555555555' 
WHERE ESSN = '666666666' 
AND BID = 'B001';

UPDATE EMPLOYEE 
SET ManagerSSN = '555555555' 
WHERE ESSN = '808080808'
AND BID = 'B001';

UPDATE EMPLOYEE 
SET ManagerSSN = '555555555' 
WHERE ESSN = '909090909' 
AND BID = 'B001';

--Branch 2
UPDATE EMPLOYEE 
SET ManagerSSN = NULL 
WHERE ESSN = '777777777' 
AND BID = 'B002';

UPDATE EMPLOYEE 
SET ManagerSSN = '777777777' 
WHERE ESSN = '888888888' 
AND BID = 'B002';

UPDATE EMPLOYEE 
SET ManagerSSN = '777777777' 
WHERE ESSN = '111222333' 
AND BID = 'B002';

-- Branch 3
UPDATE EMPLOYEE 
SET ManagerSSN = NULL 
WHERE ESSN = '999999999' 
AND BID = 'B003';

UPDATE EMPLOYEE 
SET ManagerSSN = '999999999' 
WHERE ESSN = '101010101' 
AND BID = 'B003';

-- Branch 4
UPDATE EMPLOYEE 
SET ManagerSSN = NULL 
WHERE ESSN = '202020202' 
AND BID = 'B004';

UPDATE EMPLOYEE 
SET ManagerSSN = '202020202' 
WHERE ESSN = '303030303' 
AND BID = 'B004';

-- Branch 5
UPDATE EMPLOYEE 
SET ManagerSSN = NULL 
WHERE ESSN = '404040404' 
AND BID = 'B005';

UPDATE EMPLOYEE 
SET ManagerSSN = '404040404' 
WHERE ESSN = '505050505'
AND BID = 'B005';

-- Branch 6
UPDATE EMPLOYEE 
SET ManagerSSN = NULL 
WHERE ESSN = '606060606' 
AND BID = 'B006';

UPDATE EMPLOYEE 
SET ManagerSSN = '606060606' 
WHERE ESSN = '707070707' 
AND BID = 'B006';

-- DEPENDENT Table

INSERT INTO DEPENDENT (DName, Relationship, ESSN) 
VALUES ('John Davis', 'Spouse', '555555555');

INSERT INTO DEPENDENT (DName, Relationship, ESSN) 
VALUES ('Emily Davis', 'Child', '555555555');

INSERT INTO DEPENDENT (DName, Relationship, ESSN) 
VALUES ('Anna Harris', 'Spouse', '666666666');

INSERT INTO DEPENDENT (DName, Relationship, ESSN) 
VALUES ('Ryan Harris', 'Child', '666666666');

INSERT INTO DEPENDENT (DName, Relationship, ESSN) 
VALUES ('Grace Johnson Jr.', 'Child', '777777777');

INSERT INTO DEPENDENT (DName, Relationship, ESSN) 
VALUES ('David Lee', 'Spouse', '888888888');

INSERT INTO DEPENDENT (DName, Relationship, ESSN) 
VALUES ('Ella Walker', 'Child', '999999999');

-- CUSTOMERS Table

INSERT INTO CUSTOMERS (CSSN, CName, AptNo, StreetNo, City, State, ZipCode, ESSN, BID) 
VALUES ('111223344', 'Alice Johnson', 'A1', '101 Main St', 'New York', 'NY', '10001', '555555555', 'B001');

INSERT INTO CUSTOMERS (CSSN, CName, AptNo, StreetNo, City, State, ZipCode, ESSN, BID) 
VALUES ('222334455', 'Bob Smith', 'B2', '202 Oak St', 'New York', 'NY', '10002', '555555555', 'B001');

INSERT INTO CUSTOMERS (CSSN, CName, AptNo, StreetNo, City, State, ZipCode, ESSN, BID) 
VALUES ('333445566', 'Charlie Brown', 'C3', '303 Pine St', 'Los Angeles', 'CA', '90002', '666666666', 'B002');

INSERT INTO CUSTOMERS (CSSN, CName, AptNo, StreetNo, City, State, ZipCode, ESSN, BID) 
VALUES ('444556677', 'David White', 'D4', '404 Birch St', 'Los Angeles', 'CA', '90003', '666666666', 'B002');

INSERT INTO CUSTOMERS (CSSN, CName, AptNo, StreetNo, City, State, ZipCode, ESSN, BID) 
VALUES ('555667788', 'Eva Green', 'E5', '505 Cedar St', 'Chicago', 'IL', '60602', '999999999', 'B003');

INSERT INTO CUSTOMERS (CSSN, CName, AptNo, StreetNo, City, State, ZipCode, ESSN, BID) 
VALUES ('666778899', 'Frank Black', 'F6', '606 Elm St', 'Chicago', 'IL', '60603', '101010101', 'B003');

INSERT INTO CUSTOMERS (CSSN, CName, AptNo, StreetNo, City, State, ZipCode, ESSN, BID) 
VALUES ('777889900', 'Grace Taylor', 'G7', '707 Maple St', 'Houston', 'TX', '77001', '202020202', 'B004');

INSERT INTO CUSTOMERS (CSSN, CName, AptNo, StreetNo, City, State, ZipCode, ESSN, BID) 
VALUES ('888990011', 'Hannah Lee', 'H8', '808 Pine Ave', 'Houston', 'TX', '77002', '303030303', 'B004');

INSERT INTO CUSTOMERS (CSSN, CName, AptNo, StreetNo, City, State, ZipCode, ESSN, BID) 
VALUES ('999101112', 'Ian Walker', 'I9', '909 Oak Ave', 'Phoenix', 'AZ', '85001', '404040404', 'B005');

INSERT INTO CUSTOMERS (CSSN, CName, AptNo, StreetNo, City, State, ZipCode, ESSN, BID) 
VALUES ('101112233', 'Jack Brown', 'J10', '1010 Birch Rd', 'Phoenix', 'AZ', '85002', '505050505', 'B005');

INSERT INTO CUSTOMERS (CSSN, CName, AptNo, StreetNo, City, State, ZipCode, ESSN, BID) 
VALUES ('112233445', 'Kara White', 'K11', '1111 Oak Dr', 'San Diego', 'CA', '92103', '606060606', 'B006');

INSERT INTO CUSTOMERS (CSSN, CName, AptNo, StreetNo, City, State, ZipCode, ESSN, BID) 
VALUES ('223344556', 'Liam Black', 'L12', '1212 Elm Rd', 'San Diego', 'CA', '92104', '707070707', 'B006');

-- ACCOUNT Table
INSERT INTO ACCOUNT (AccNo, AccBalance, AccType, RecentDate, BID) 
VALUES ('ACC0000001', 15000.00, 'Checking', TO_DATE('2024-10-01', 'YYYY-MM-DD'), 'B001');

INSERT INTO ACCOUNT (AccNo, AccBalance, AccType, RecentDate, BID) 
VALUES ('ACC0000002', 2500.00, 'Savings', TO_DATE('2024-09-20', 'YYYY-MM-DD'), 'B001');

INSERT INTO ACCOUNT (AccNo, AccBalance, AccType, RecentDate, BID) 
VALUES ('ACC0000003', 5000.00, 'Checking', TO_DATE('2024-10-10', 'YYYY-MM-DD'), 'B002');

INSERT INTO ACCOUNT (AccNo, AccBalance, AccType, RecentDate, BID) 
VALUES ('ACC0000004', 10000.00, 'Money Market', TO_DATE('2024-09-15', 'YYYY-MM-DD'), 'B002');

INSERT INTO ACCOUNT (AccNo, AccBalance, AccType, RecentDate, BID) 
VALUES ('ACC0000005', 20000.00, 'Checking', TO_DATE('2024-10-05', 'YYYY-MM-DD'), 'B003');

INSERT INTO ACCOUNT (AccNo, AccBalance, AccType, RecentDate, BID) 
VALUES ('ACC0000006', 1500.00, 'Savings', TO_DATE('2024-08-25', 'YYYY-MM-DD'), 'B003');

INSERT INTO ACCOUNT (AccNo, AccBalance, AccType, RecentDate, BID) 
VALUES ('ACC0000007', 30000.00, 'Checking', TO_DATE('2024-10-12', 'YYYY-MM-DD'), 'B004');

INSERT INTO ACCOUNT (AccNo, AccBalance, AccType, RecentDate, BID) 
VALUES ('ACC0000008', 5000.00, 'Money Market', TO_DATE('2024-09-10', 'YYYY-MM-DD'), 'B004');

INSERT INTO ACCOUNT (AccNo, AccBalance, AccType, RecentDate, BID) 
VALUES ('ACC0000009', 100000.00, 'Savings', TO_DATE('2024-10-20', 'YYYY-MM-DD'), 'B005');

INSERT INTO ACCOUNT (AccNo, AccBalance, AccType, RecentDate, BID) 
VALUES ('ACC0000010', 25000.00, 'Checking', TO_DATE('2024-09-30', 'YYYY-MM-DD'), 'B005');

INSERT INTO ACCOUNT (AccNo, AccBalance, AccType, RecentDate, BID) 
VALUES ('ACC0000011', 20000.00, 'Money Market', TO_DATE('2024-10-02', 'YYYY-MM-DD'), 'B006');

INSERT INTO ACCOUNT (AccNo, AccBalance, AccType, RecentDate, BID) 
VALUES ('ACC0000012', 7000.00, 'Savings', TO_DATE('2024-09-14', 'YYYY-MM-DD'), 'B006');


-- CUST_ACC Table

INSERT INTO CUST_ACC (CSSN, AccNo) 
VALUES ('111223344', 'ACC0000001');  

INSERT INTO CUST_ACC (CSSN, AccNo) 
VALUES ('111223344', 'ACC0000002');  

INSERT INTO CUST_ACC (CSSN, AccNo) 
VALUES ('222334455', 'ACC0000003');  

INSERT INTO CUST_ACC (CSSN, AccNo) 
VALUES ('222334455', 'ACC0000004'); 

INSERT INTO CUST_ACC (CSSN, AccNo) 
VALUES ('333445566', 'ACC0000005');  

INSERT INTO CUST_ACC (CSSN, AccNo) 
VALUES ('333445566', 'ACC0000006');  

INSERT INTO CUST_ACC (CSSN, AccNo) 
VALUES ('444556677', 'ACC0000007');  

INSERT INTO CUST_ACC (CSSN, AccNo) 
VALUES ('444556677', 'ACC0000008');  

INSERT INTO CUST_ACC (CSSN, AccNo) 
VALUES ('555667788', 'ACC0000009');  

INSERT INTO CUST_ACC (CSSN, AccNo) 
VALUES ('555667788', 'ACC0000010');  

INSERT INTO CUST_ACC (CSSN, AccNo) 
VALUES ('666778899', 'ACC0000011'); 

INSERT INTO CUST_ACC (CSSN, AccNo) 
VALUES ('666778899', 'ACC0000012');  

INSERT INTO CUST_ACC (CSSN, AccNo) 
VALUES ('777889900', 'ACC0000007');

INSERT INTO CUST_ACC (CSSN, AccNo) 
VALUES ('777889900', 'ACC0000008');  

INSERT INTO CUST_ACC (CSSN, AccNo) 
VALUES ('888990011', 'ACC0000009');  

INSERT INTO CUST_ACC (CSSN, AccNo) 
VALUES ('888990011', 'ACC0000010'); 

INSERT INTO CUST_ACC (CSSN, AccNo) 
VALUES ('999101112', 'ACC0000011');  

INSERT INTO CUST_ACC (CSSN, AccNo) 
VALUES ('999101112', 'ACC0000012'); 

INSERT INTO CUST_ACC (CSSN, AccNo) 
VALUES ('101112233', 'ACC0000009');  

INSERT INTO CUST_ACC (CSSN, AccNo) 
VALUES ('101112233', 'ACC0000010');  

INSERT INTO CUST_ACC (CSSN, AccNo) 
VALUES ('112233445', 'ACC0000005');  

INSERT INTO CUST_ACC (CSSN, AccNo) 
VALUES ('112233445', 'ACC0000006'); 

INSERT INTO CUST_ACC (CSSN, AccNo) 
VALUES ('223344556', 'ACC0000007');  

INSERT INTO CUST_ACC (CSSN, AccNo) 
VALUES ('223344556', 'ACC0000008');  

-- TRANSACTION Table

INSERT INTO TRANSACTION (TCode, TName, TCharge, TAmount, TDate, THour, AccNo) 
VALUES ('WD01', 'Withdrawal', 2.00, 500.00, TO_DATE('2024-10-05', 'YYYY-MM-DD'), TO_TIMESTAMP('2024-10-05 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'ACC0000001');

INSERT INTO TRANSACTION (TCode, TName, TCharge, TAmount, TDate, THour, AccNo) 
VALUES ('CD01', 'Customer Deposit', 0.00, 1000.00, TO_DATE('2024-10-06', 'YYYY-MM-DD'), TO_TIMESTAMP('2024-10-06 11:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'ACC0000001');

INSERT INTO TRANSACTION (TCode, TName, TCharge, TAmount, TDate, THour, AccNo) 
VALUES ('WD02', 'Withdrawal', 2.00, 200.00, TO_DATE('2024-10-07', 'YYYY-MM-DD'), TO_TIMESTAMP('2024-10-07 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'ACC0000002');

INSERT INTO TRANSACTION (TCode, TName, TCharge, TAmount, TDate, THour, AccNo) 
VALUES ('CD02', 'Customer Deposit', 0.00, 3000.00, TO_DATE('2024-10-08', 'YYYY-MM-DD'), TO_TIMESTAMP('2024-10-08 13:45:00', 'YYYY-MM-DD HH24:MI:SS'), 'ACC0000002');

INSERT INTO TRANSACTION (TCode, TName, TCharge, TAmount, TDate, THour, AccNo) 
VALUES ('WD03', 'Withdrawal', 2.00, 150.00, TO_DATE('2024-10-09', 'YYYY-MM-DD'), TO_TIMESTAMP('2024-10-09 14:20:00', 'YYYY-MM-DD HH24:MI:SS'), 'ACC0000003');

INSERT INTO TRANSACTION (TCode, TName, TCharge, TAmount, TDate, THour, AccNo) 
VALUES ('CD03', 'Customer Deposit', 0.00, 500.00, TO_DATE('2024-10-10', 'YYYY-MM-DD'), TO_TIMESTAMP('2024-10-10 15:10:00', 'YYYY-MM-DD HH24:MI:SS'), 'ACC0000003');

INSERT INTO TRANSACTION (TCode, TName, TCharge, TAmount, TDate, THour, AccNo) 
VALUES ('WD04', 'Withdrawal', 2.00, 700.00, TO_DATE('2024-10-11', 'YYYY-MM-DD'), TO_TIMESTAMP('2024-10-11 09:25:00', 'YYYY-MM-DD HH24:MI:SS'), 'ACC0000004');

INSERT INTO TRANSACTION (TCode, TName, TCharge, TAmount, TDate, THour, AccNo) 
VALUES ('AM01', 'Account Maintenance', 10.00, 0.00, TO_DATE('2024-10-12', 'YYYY-MM-DD'), TO_TIMESTAMP('2024-10-12 08:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'ACC0000001');

INSERT INTO TRANSACTION (TCode, TName, TCharge, TAmount, TDate, THour, AccNo) 
VALUES ('AM02', 'Account Maintenance', 10.00, 0.00, TO_DATE('2024-10-13', 'YYYY-MM-DD'), TO_TIMESTAMP('2024-10-13 09:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'ACC0000002');

INSERT INTO TRANSACTION (TCode, TName, TCharge, TAmount, TDate, THour, AccNo) 
VALUES ('AM03', 'Account Maintenance', 10.00, 0.00, TO_DATE('2024-10-14', 'YYYY-MM-DD'), TO_TIMESTAMP('2024-10-14 10:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'ACC0000003');

INSERT INTO TRANSACTION (TCode, TName, TCharge, TAmount, TDate, THour, AccNo) 
VALUES ('WD05', 'Withdrawal', 2.00, 250.00, TO_DATE('2024-10-12', 'YYYY-MM-DD'), TO_TIMESTAMP('2024-10-12 13:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'ACC0000005');

INSERT INTO TRANSACTION (TCode, TName, TCharge, TAmount, TDate, THour, AccNo) 
VALUES ('CD04', 'Customer Deposit', 0.00, 1500.00, TO_DATE('2024-10-14', 'YYYY-MM-DD'), TO_TIMESTAMP('2024-10-14 14:45:00', 'YYYY-MM-DD HH24:MI:SS'), 'ACC0000005');

INSERT INTO TRANSACTION (TCode, TName, TCharge, TAmount, TDate, THour, AccNo) 
VALUES ('WD06', 'Withdrawal', 2.00, 300.00, TO_DATE('2024-10-15', 'YYYY-MM-DD'), TO_TIMESTAMP('2024-10-15 11:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'ACC0000006');

INSERT INTO TRANSACTION (TCode, TName, TCharge, TAmount, TDate, THour, AccNo) 
VALUES ('CD05', 'Customer Deposit', 0.00, 7000.00, TO_DATE('2024-10-16', 'YYYY-MM-DD'), TO_TIMESTAMP('2024-10-16 15:20:00', 'YYYY-MM-DD HH24:MI:SS'), 'ACC0000006');

INSERT INTO TRANSACTION (TCode, TName, TCharge, TAmount, TDate, THour, AccNo) 
VALUES ('WD07', 'Withdrawal', 2.00, 400.00, TO_DATE('2024-10-16', 'YYYY-MM-DD'), TO_TIMESTAMP('2024-10-16 10:45:00', 'YYYY-MM-DD HH24:MI:SS'), 'ACC0000007');

-- LOAN Table
INSERT INTO LOAN (LoanNo, LAmount, LInterestRate, LRepayment, AccNo)
VALUES ('LN001', 50000.00, 5.5, 10, 'ACC0000001');

INSERT INTO LOAN (LoanNo, LAmount, LInterestRate, LRepayment, AccNo)
VALUES ('LN002', 150000.00, 6.0, 15, 'ACC0000002');

INSERT INTO LOAN (LoanNo, LAmount, LInterestRate, LRepayment, AccNo)
VALUES ('LN003', 20000.00, 7.0, 5, 'ACC0000003');

INSERT INTO LOAN (LoanNo, LAmount, LInterestRate, LRepayment, AccNo)
VALUES ('LN004', 30000.00, 5.2, 7, 'ACC0000004');

INSERT INTO LOAN (LoanNo, LAmount, LInterestRate, LRepayment, AccNo)
VALUES ('LN005', 80000.00, 4.8, 10, 'ACC0000005');

INSERT INTO LOAN (LoanNo, LAmount, LInterestRate, LRepayment, AccNo)
VALUES ('LN006', 120000.00, 6.3, 15, 'ACC0000006');

INSERT INTO LOAN (LoanNo, LAmount, LInterestRate, LRepayment, AccNo)
VALUES ('LN007', 25000.00, 5.9, 6, 'ACC0000007');

INSERT INTO LOAN (LoanNo, LAmount, LInterestRate, LRepayment, AccNo)
VALUES ('LN008', 60000.00, 5.0, 8, 'ACC0000008');

INSERT INTO LOAN (LoanNo, LAmount, LInterestRate, LRepayment, AccNo)
VALUES ('LN009', 100000.00, 4.5, 12, 'ACC0000009');

INSERT INTO LOAN (LoanNo, LAmount, LInterestRate, LRepayment, AccNo)
VALUES ('LN010', 200000.00, 3.9, 20, 'ACC0000010');

-- CUST_LOAN Table
INSERT INTO CUST_LOAN (CSSN, LoanNo) 
VALUES ('111223344', 'LN001');

INSERT INTO CUST_LOAN (CSSN, LoanNo) 
VALUES ('222334455', 'LN002');

INSERT INTO CUST_LOAN (CSSN, LoanNo) 
VALUES ('333445566', 'LN003');

INSERT INTO CUST_LOAN (CSSN, LoanNo) 
VALUES ('444556677', 'LN004');

INSERT INTO CUST_LOAN (CSSN, LoanNo) 
VALUES ('555667788', 'LN005');

INSERT INTO CUST_LOAN (CSSN, LoanNo) 
VALUES ('666778899', 'LN006');

INSERT INTO CUST_LOAN (CSSN, LoanNo) 
VALUES ('777889900', 'LN007');

INSERT INTO CUST_LOAN (CSSN, LoanNo) 
VALUES ('888990011', 'LN008');

INSERT INTO CUST_LOAN (CSSN, LoanNo) 
VALUES ('999101112', 'LN009');

INSERT INTO CUST_LOAN (CSSN, LoanNo) 
VALUES ('101112233', 'LN010');

INSERT INTO CUST_LOAN (CSSN, LoanNo) 
VALUES ('111223344', 'LN005');

INSERT INTO CUST_LOAN (CSSN, LoanNo) 
VALUES ('222334455', 'LN003');

INSERT INTO CUST_LOAN (CSSN, LoanNo) 
VALUES ('333445566', 'LN007');

-- CHECKING Table
INSERT INTO CHECKING (AccNo, OverDraft) 
VALUES ('ACC0000001', 1000.00);

INSERT INTO CHECKING (AccNo, OverDraft) 
VALUES ('ACC0000003', 500.00);

INSERT INTO CHECKING (AccNo, OverDraft) 
VALUES ('ACC0000005', 1500.00);

INSERT INTO CHECKING (AccNo, OverDraft) 
VALUES ('ACC0000007', 2000.00);

INSERT INTO CHECKING (AccNo, OverDraft) 
VALUES ('ACC0000010', 800.00);


-- SAVINGS Table
INSERT INTO SAVINGS (AccNo, SInterestRate) 
VALUES ('ACC0000002', 3.5);

INSERT INTO SAVINGS (AccNo, SInterestRate) 
VALUES ('ACC0000006', 2.8);

INSERT INTO SAVINGS (AccNo, SInterestRate) 
VALUES ('ACC0000009', 4.2);

INSERT INTO SAVINGS (AccNo, SInterestRate) 
VALUES ('ACC0000012', 3.0);

INSERT INTO SAVINGS (AccNo, SInterestRate) 
VALUES ('ACC0000010', 3.9);

-- MONEY_MARKET Table
INSERT INTO MONEY_MARKET (AccNo, MInterestRate)
VALUES ('ACC0000004', 4.0);

INSERT INTO MONEY_MARKET (AccNo, MInterestRate)
VALUES ('ACC0000008', 3.7);

INSERT INTO MONEY_MARKET (AccNo, MInterestRate)
VALUES ('ACC0000011', 4.5);

INSERT INTO MONEY_MARKET (AccNo, MInterestRate)
VALUES ('ACC0000007', 3.9);

INSERT INTO MONEY_MARKET (AccNo, MInterestRate)
VALUES ('ACC0000010', 4.1);

-- display
SELECT * FROM BANK_BRANCH;

SELECT * FROM EMPLOYEE;

SELECT * FROM DEPENDENT;

SELECT * FROM CUSTOMERS;

SELECT * FROM ACCOUNT;

SELECT * FROM CUST_ACC;

SELECT * FROM TRANSACTION;

SELECT * FROM LOAN;

SELECT * FROM CUST_LOAN;

SELECT * FROM CHECKING;

SELECT * FROM SAVINGS;

SELECT * FROM MONEY_MARKET;


-- UPDATE AND DELETE


-- BANK_BRANCH 
UPDATE BANK_BRANCH
SET BAsset = BAsset + 10000
WHERE BID = 'B005';

DELETE FROM BANK_BRANCH
WHERE BID = 'B006';
SELECT * FROM BANK_BRANCH;

-- EMPLOYEE table
UPDATE EMPLOYEE
SET EPhone = '8680858047'
WHERE ESSN = '555555555';

DELETE FROM EMPLOYEE
WHERE ESSN = '111222333';

SELECT * FROM EMPLOYEE;

-- DEPENDENT table
UPDATE DEPENDENT
SET Relationship = 'Child'
WHERE ESSN = '555555555' AND DName = 'John Davis';

DELETE FROM DEPENDENT
WHERE ESSN = '999999999';

SELECT * FROM DEPENDENT;

-- CUSTOMERS table
UPDATE CUSTOMERS
SET CName = 'Jane Smith'
WHERE CSSN = '101112233';

DELETE FROM CUSTOMERS
WHERE CSSN = '999101112';


SELECT * FROM CUSTOMERS;
-- delete from customers where BID = 'B006';

-- ACCOUNT table
-- delete from account where BID = 'B006';

UPDATE ACCOUNT
SET AccBalance = AccBalance + 5000
WHERE ACCNO = 'ACC0000007';

DELETE FROM ACCOUNT
WHERE ACCNO = 'ACC0000010';
SELECT * FROM ACCOUNT;

-- CUST_ACC table
UPDATE CUST_ACC
SET AccNo = 'ACC0000007'
WHERE CSSN = '111223344' AND AccNo = 'ACC0000002';
DELETE FROM CUST_ACC
WHERE CSSN = '222334455' AND AccNo = 'ACC0000003';

SELECT * FROM CUST_ACC;

-- TRANSACTION table
UPDATE TRANSACTION
SET TAmount = TAmount - 100
WHERE TCode = 'WD07';
DELETE FROM TRANSACTION
WHERE TCode = 'CD05';

SELECT * FROM TRANSACTION;

-- LOAN table

UPDATE LOAN
SET LAmount = LAmount + 5000
WHERE LoanNo = 'LN001';

DELETE FROM LOAN
WHERE LoanNo = 'LN009';

SELECT * FROM LOAN;

-- CUST_LOAN table

UPDATE CUST_LOAN
SET LoanNo = 'LN002'
WHERE CSSN = '111223344' AND LoanNo = 'LN001';

DELETE FROM CUST_LOAN
WHERE CSSN = '888990011' AND LoanNo = 'LN008';

SELECT * FROM CUST_LOAN;

-- CHECKING table
UPDATE CHECKING
SET OverDraft = OverDraft + 500
WHERE AccNo = 'ACC0000001';

DELETE FROM CHECKING
WHERE AccNo = 'ACC0000007';

SELECT * FROM CHECKING;
--SELECT * FROM ACCOUNT;

-- SAVINGS table
UPDATE SAVINGS
SET SInterestRate = SInterestRate - 0.1
WHERE AccNo = 'ACC0000009';

DELETE FROM SAVINGS
WHERE AccNo = 'ACC0000002';

SELECT * FROM SAVINGS;

-- MONEY_MARKET table
UPDATE MONEY_MARKET
SET MInterestRate = MInterestRate + 0.15
WHERE AccNo = 'ACC0000004';

DELETE FROM MONEY_MARKET
WHERE AccNo = 'ACC0000008';

SELECT * FROM MONEY_MARKET;

SELECT ESSN, EName, StartDate, 
       ROUND(MONTHS_BETWEEN(SYSDATE, StartDate) / 12, 2) AS DurationInYears
FROM EMPLOYEE;


SELECT AccType, SUM(AccBalance) AS TotalBalance
FROM ACCOUNT
GROUP BY AccType;


SELECT AccType, SUM(AccBalance) AS TotalBalance
FROM ACCOUNT
GROUP BY AccType
HAVING SUM(AccBalance) > 50000
ORDER BY TotalBalance;

SELECT C.CName, L.LAmount, C.BID
FROM CUSTOMERS C
JOIN CUST_ACC CA ON C.CSSN = CA.CSSN
JOIN ACCOUNT A ON CA.AccNo = A.AccNo
JOIN LOAN L ON A.AccNo = L.AccNo
WHERE L.LAmount > ALL (
    SELECT L2.LAmount
    FROM CUSTOMERS C2
    JOIN CUST_ACC CA2 ON C2.CSSN = CA2.CSSN
    JOIN ACCOUNT A2 ON CA2.AccNo = A2.AccNo
    JOIN LOAN L2 ON A2.AccNo = L2.AccNo
    WHERE C2.BID = 'B001'
);

--select * from account;
--select * from loan;
--
--SELECT C.CName, C.BID
--FROM CUSTOMERS C
--WHERE C.BID IN (
--    SELECT A.BID
--    FROM ACCOUNT A
--    WHERE A.BID IN ('B001', 'B002')
--);
--select * from dependent;
--select * from EMPLOYEE WHERE ESSN =888888888;
--select * from dependent WHERE ESSN =888888888;
--select * from customers;
--SELECT Sum(Account.AccBalance) FROM ACCOUNT, CUST_ACC where CSSN= 333445566 AND account.AccNo=Cust_Acc.AccNo;
--
--select * from loan;
--select * from cust_loan;
--
--SELECT loan.LOANNO, loan.LAMOUNT FROM LOAN,cust_loan WHERE loan.loanno=cust_loan.loanno and cust_loan.CSSN = 333445566;
--SELECT c.CName, l.LoanNo, l.LAmount, l.LInterestRate, l.LRepayment, l.AccNo
--                        FROM CUSTOMERS c
--                        JOIN CUST_LOAN cl ON c.CSSN = cl.CSSN
--                        JOIN LOAN l ON cl.LoanNo = l.LoanNo
--                        WHERE c.CSSN = 333445566;
--                        
--                  
--SELECT l.LoanNo, l.LAmount, l.LInterestRate, l.LRepayment
--FROM LOAN l
--JOIN CUST_LOAN cl ON l.LoanNo = cl.LoanNo
--WHERE cl.CSSN = 333445566;
--      
--SELECT 
--    c.CName, 
--    a.AccType
--FROM 
--    CUSTOMERS c
--JOIN 
--    CUST_ACC ca ON c.CSSN = ca.CSSN
--JOIN 
--    ACCOUNT a ON ca.AccNo = a.AccNo
--WHERE 
--    c.CSSN = 333445566; 
--select * from customers;
--
--SELECT DISTINCT c.CName, l.LoanNo, l.LAmount, l.LInterestRate, l.LRepayment, l.AccNo
--                    FROM CUSTOMERS c
--                    JOIN CUST_LOAN cl ON c.CSSN = cl.CSSN
--                    JOIN LOAN l ON cl.LoanNo = l.LoanNo
--                    WHERE c.CSSN = 333445566;
--
--SELECT DISTINCT c.CName, a.AccType
--                    FROM CUSTOMERS c
--                    JOIN CUST_ACC ca ON c.CSSN = ca.CSSN
--                    JOIN ACCOUNT a ON ca.AccNo = a.AccNo
--                    WHERE c.CSSN = 333445566;
--delete from customers where cssn=333454565          ;






















