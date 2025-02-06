-- E-Commerce Dataset

-- Customers Table
CREATE TABLE Customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    city VARCHAR(50),
    registration_date DATE NOT NULL
);

INSERT INTO Customers (name, email, city, registration_date) VALUES
('Alice Smith', 'alice@example.com', 'New York', '2023-01-10'),
('Bob Johnson', 'bob@example.com', 'Los Angeles', '2023-02-15'),
('Charlie Brown', 'charlie@example.com', 'Chicago', '2023-03-20');

-- Orders Table
CREATE TABLE Orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    order_date DATE NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL,
    status VARCHAR(20) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

INSERT INTO Orders (customer_id, order_date, total_amount, status) VALUES
(1, '2023-05-01', 120.50, 'Completed'),
(2, '2023-05-03', 75.00, 'Pending'),
(3, '2023-05-05', 200.00, 'Completed');

-- Products Table
CREATE TABLE Products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    stock_quantity INT NOT NULL
);

INSERT INTO Products (name, category, price, stock_quantity) VALUES
('Laptop', 'Electronics', 1000.00, 50),
('Headphones', 'Electronics', 50.00, 200),
('Coffee Maker', 'Home Appliances', 80.00, 100);

-- OrderDetails Table
CREATE TABLE OrderDetails (
    order_detail_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT NOT NULL,
    price_per_unit DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

INSERT INTO OrderDetails (order_id, product_id, quantity, price_per_unit) VALUES
(1, 1, 1, 1000.00),
(2, 2, 2, 50.00),
(3, 3, 1, 80.00);

-- Employee Management Dataset

-- Employees Table
CREATE TABLE Employees (
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    manager_id INT,
    department VARCHAR(50) NOT NULL,
    hire_date DATE NOT NULL,
    salary DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (manager_id) REFERENCES Employees(employee_id)
);

INSERT INTO Employees (name, manager_id, department, hire_date, salary) VALUES
('John Doe', NULL, 'IT', '2020-01-01', 80000.00),
('Jane Smith', 1, 'IT', '2021-06-01', 70000.00),
('Emily Johnson', 1, 'HR', '2022-03-15', 60000.00);

-- Departments Table
CREATE TABLE Departments (
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    location VARCHAR(50) NOT NULL
);

INSERT INTO Departments (name, location) VALUES
('IT', 'New York'),
('HR', 'Chicago'),
('Finance', 'San Francisco');

-- Financial Transactions Dataset

-- Accounts Table
CREATE TABLE Accounts (
    account_id INT AUTO_INCREMENT PRIMARY KEY,
    account_type VARCHAR(20) NOT NULL,
    customer_id INT,
    balance DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

INSERT INTO Accounts (account_type, customer_id, balance) VALUES
('Savings', 1, 5000.00),
('Checking', 2, 1500.00),
('Savings', 3, 8000.00);

-- Transactions Table
CREATE TABLE Transactions (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    account_id INT,
    transaction_date DATE NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    transaction_type VARCHAR(20) NOT NULL,
    FOREIGN KEY (account_id) REFERENCES Accounts(account_id)
);

INSERT INTO Transactions (account_id, transaction_date, amount, transaction_type) VALUES
(1, '2023-05-01', 100.00, 'Debit'),
(2, '2023-05-02', 200.00, 'Credit'),
(3, '2023-05-03', 50.00, 'Debit');



=========== Sample Queries =========

1. Total Sales by Product Category
SELECT p.category, SUM(od.quantity * od.price_per_unit) AS total_sales
FROM OrderDetails od
JOIN Products p ON od.product_id = p.product_id
GROUP BY p.category;

2. Top 3 Selling Products in Each Category
WITH ProductSales AS (
    SELECT p.category, p.name, SUM(od.quantity) AS total_sold,
           RANK() OVER (PARTITION BY p.category ORDER BY SUM(od.quantity) DESC) AS rank
    FROM OrderDetails od
    JOIN Products p ON od.product_id = p.product_id
    GROUP BY p.category, p.name
)
SELECT category, name, total_sold
FROM ProductSales
WHERE rank <= 3;


3. Employee Hierarchy (Recursive Query)

WITH EmployeeHierarchy AS (
    SELECT employee_id, name, manager_id, 1 AS level
    FROM Employees
    WHERE manager_id IS NULL
    UNION ALL
    SELECT e.employee_id, e.name, e.manager_id, eh.level + 1
    FROM Employees e
    JOIN EmployeeHierarchy eh ON e.manager_id = eh.employee_id
)
SELECT * FROM EmployeeHierarchy
ORDER BY level, manager_id;

4. Find Employees with Above-Average Salary in Their Department
WITH DepartmentAverage AS (
    SELECT department, AVG(salary) AS avg_salary
    FROM Employees
    GROUP BY department
)
SELECT e.name, e.salary, e.department
FROM Employees e
JOIN DepartmentAverage da ON e.department = da.department
WHERE e.salary > da.avg_salary;

5. Transactions Exceeding $10,000 in the Last Month
SELECT t.transaction_id, t.account_id, t.amount, t.transaction_date
FROM Transactions t
WHERE t.amount > 10000
AND t.transaction_date >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH);










