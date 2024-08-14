-- Tabel Customer Information
CREATE TABLE customer_information (
    cust_ID SERIAL PRIMARY KEY,
    custfname VARCHAR(255),
    custlname VARCHAR(255),
    address VARCHAR(255),
    status VARCHAR(255)
);

-- Tabel Payments
CREATE TABLE payments (
    payment_ID SERIAL PRIMARY KEY,
    customer_ID INT REFERENCES customer_information(cust_ID),
    payment_date TIMESTAMP
);

-- Tabel Employees
CREATE TABLE employees (
    employee_ID SERIAL PRIMARY KEY,
    fname VARCHAR(255),
    lname VARCHAR(255),
    job_department VARCHAR(255),
    address VARCHAR(255),
    contact_add INT,
    username VARCHAR(255),
    password VARCHAR(255)
);

-- Tabel Room Class
CREATE TABLE room_class (
    class_ID SERIAL PRIMARY KEY,
    name VARCHAR(255),
    description VARCHAR(255)
);

-- Tabel Room Information
CREATE TABLE room_information (
    room_ID SERIAL PRIMARY KEY,
    class_ID INT REFERENCES room_class(class_ID),
    description VARCHAR(255),
    price INT
);

-- Tabel Reservation
CREATE TABLE reservation (
    reservation_ID SERIAL PRIMARY KEY,
    customer_ID INT REFERENCES customer_information(cust_ID),
    room_ID INT REFERENCES room_information(room_ID),
    reservation_date TIMESTAMP,
    date_in TIMESTAMP,
    date_out TIMESTAMP,
    date_range INTERVAL
);

-- Tabel Transaction
CREATE TABLE transactions (
    transaction_ID SERIAL PRIMARY KEY,
    customer_ID INT REFERENCES customer_information(cust_ID),
    payment_ID INT REFERENCES payments(payment_ID),
    employee_ID INT REFERENCES employees(employee_ID),
    reservation_ID INT REFERENCES reservation(reservation_ID),
    transaction_date TIMESTAMP,
    transaction_name VARCHAR(255)
);

-- Tabel Reports
CREATE TABLE reports (
    report_ID SERIAL PRIMARY KEY,
    transaction_ID INT REFERENCES transactions(transaction_ID),
    information VARCHAR(255),
    date TIMESTAMP
);


-- Delete value tabel
TRUNCATE TABLE reports RESTART IDENTITY CASCADE;
TRUNCATE TABLE reservation RESTART IDENTITY CASCADE;
TRUNCATE TABLE payments RESTART IDENTITY CASCADE;
TRUNCATE TABLE employees RESTART IDENTITY CASCADE;
TRUNCATE TABLE room_information RESTART IDENTITY CASCADE;
TRUNCATE TABLE room_class RESTART IDENTITY CASCADE;
TRUNCATE TABLE customer_information RESTART IDENTITY CASCADE;

-- Drop tabel
DROP TABLE IF EXISTS reports;
DROP TABLE IF EXISTS transactions;
DROP TABLE IF EXISTS reservation;
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS room_information;
DROP TABLE IF EXISTS room_class;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS customer_information;