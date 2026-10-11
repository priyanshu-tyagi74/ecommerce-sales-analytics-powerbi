DROP DATABASE Ecommerce_Analytics;
GO


create database Ecommerce_Analytics;
use Ecommerce_Analytics;

create table Products(
ProductID varchar (50) PRIMARY KEY,
ProductName varchar(20),
Category varchar(20),
SubCategory varchar(50),
Costprice decimal (10,2));



create table orders(
 OrderID varchar(50) PRIMARY KEY,
    OrderDate DATE,
    CustomerID varchar(50),
    ProductID varchar(50),
    City VARCHAR(50),
    Region VARCHAR(20),
    Quantity INT,
    UnitPrice DECIMAL(10,2),
    Discount DECIMAL(5,4),
    PaymentMethod VARCHAR(30),
    OrderStatus VARCHAR(20),
    TotalSales DECIMAL(12,2),
    TotalCost DECIMAL(12,2),
    Profit DECIMAL(12,2)
);










CREATE TABLE Customers (
    CustomerID VARCHAR(50) PRIMARY KEY,
    CustomerName VARCHAR(255),
    CustomerSegment VARCHAR(100)
);




USE Ecommerce_Analytics;

-- Total count check karne ke liye (3000 aana chahiye)
SELECT COUNT(*) AS TotalCustomers FROM customers;

-- Top 5 rows dekhne ke liye
SELECT TOP 5 * FROM customers;




CREATE TABLE returns (
    OrderID VARCHAR(50) PRIMARY KEY,
    ReturnDate DATE,
    ReturnReason VARCHAR(255)
);

USE Ecommerce_Analytics;

SELECT 'Customers' AS TableName, COUNT(*) AS TotalRows FROM customers
UNION ALL
SELECT 'Products', COUNT(*) FROM products
UNION ALL
SELECT 'Orders', COUNT(*) FROM orders
UNION ALL
SELECT 'Returns', COUNT(*) FROM returns;
