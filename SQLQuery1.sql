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
  

SELECT 'Customers' AS TableName, COUNT(*) AS TotalRows FROM dbo.Customers
UNION ALL
SELECT 'Products', COUNT(*) FROM dbo.Products
UNION ALL
SELECT 'Orders', COUNT(*) FROM dbo.Orders
UNION ALL
SELECT 'Returns', COUNT(*) FROM dbo.Returns;



SELECT OrderID, COUNT(*) AS DuplicateCount
FROM dbo.Orders
GROUP BY OrderID
HAVING COUNT(*) > 1;


SELECT
    SUM(CASE WHEN OrderID IS NULL THEN 1 ELSE 0 END) AS MissingOrderID,
    SUM(CASE WHEN CustomerID IS NULL THEN 1 ELSE 0 END) AS MissingCustomerID,
    SUM(CASE WHEN ProductID IS NULL THEN 1 ELSE 0 END) AS MissingProductID,
    SUM(CASE WHEN OrderDate IS NULL THEN 1 ELSE 0 END) AS MissingOrderDate,
    SUM(CASE WHEN Quantity IS NULL THEN 1 ELSE 0 END) AS MissingQuantity,
    SUM(CASE WHEN TotalSales IS NULL THEN 1 ELSE 0 END) AS MissingTotalSales,
    SUM(CASE WHEN TotalCost IS NULL THEN 1 ELSE 0 END) AS MissingTotalCost,
    SUM(CASE WHEN Profit IS NULL THEN 1 ELSE 0 END) AS MissingProfit
FROM dbo.Orders;



SELECT *
FROM dbo.Orders
WHERE Quantity < 0;



SELECT *
FROM dbo.Orders
WHERE Discount < 0 OR Discount > 1;



SELECT *
FROM dbo.Orders
WHERE TotalSales < 0 OR TotalCost < 0;



SELECT o.OrderID, o.CustomerID
FROM dbo.Orders AS o
LEFT JOIN dbo.Customers AS c
    ON o.CustomerID = c.CustomerID
WHERE c.CustomerID IS NULL;



SELECT o.OrderID, o.ProductID
FROM dbo.Orders AS o
LEFT JOIN dbo.Products AS p
    ON o.ProductID = p.ProductID
WHERE p.ProductID IS NULL;


SELECT r.OrderID
FROM dbo.Returns AS r
LEFT JOIN dbo.Orders AS o
    ON r.OrderID = o.OrderID
WHERE o.OrderID IS NULL;




-- Sales validation
SELECT
    OrderID,
    Quantity,
    UnitPrice,
    Discount,
    TotalSales,
    Quantity * UnitPrice * (1 - Discount) AS CalculatedSales
FROM dbo.Orders
WHERE ABS(
    TotalSales - (Quantity * UnitPrice * (1 - Discount))
) >= 0.01;



SELECT
    o.OrderID,
    o.ProductID,
    o.Quantity,
    p.CostPrice,
    o.TotalCost,
    ABS(o.Quantity) * p.CostPrice AS CalculatedCost
FROM dbo.Orders AS o
INNER JOIN dbo.Products AS p
    ON o.ProductID = p.ProductID
WHERE ABS(
    o.TotalCost - (ABS(o.Quantity) * p.CostPrice)
) >= 0.01;



SELECT
    OrderID,
    TotalSales,
    TotalCost,
    Profit,
    TotalSales - TotalCost AS CalculatedProfit
FROM dbo.Orders
WHERE ABS(
    Profit - (TotalSales - TotalCost)
) >= 0.01;


SELECT
    COUNT(DISTINCT OrderID) AS TotalOrders,
    COUNT(DISTINCT CustomerID) AS UniqueCustomers,
    SUM(Quantity) AS NetQuantity,
    SUM(TotalSales) AS TotalSales,
    SUM(TotalCost) AS TotalCost,
    SUM(Profit) AS TotalProfit,
    CAST(
        100.0 * SUM(Profit) / NULLIF(SUM(TotalSales), 0)
        AS DECIMAL(10,2)
    ) AS ProfitMarginPercent
FROM dbo.Orders;



SELECT
    Region,
    COUNT(DISTINCT OrderID) AS TotalOrders,
    SUM(TotalSales) AS TotalSales,
    SUM(Profit) AS TotalProfit,
    CAST(
        100.0 * SUM(Profit) / NULLIF(SUM(TotalSales), 0)
        AS DECIMAL(10,2)
    ) AS ProfitMarginPercent
FROM dbo.Orders
GROUP BY Region
ORDER BY TotalSales DESC;



SELECT
    p.Category,
    SUM(o.TotalSales) AS TotalSales,
    SUM(o.TotalCost) AS TotalCost,
    SUM(o.Profit) AS TotalProfit,
    CAST(
        100.0 * SUM(o.Profit) / NULLIF(SUM(o.TotalSales), 0)
        AS DECIMAL(10,2)
    ) AS ProfitMarginPercent
FROM dbo.Orders AS o
INNER JOIN dbo.Products AS p
    ON o.ProductID = p.ProductID
GROUP BY p.Category
ORDER BY TotalSales DESC;




SELECT
    c.CustomerSegment,
    COUNT(DISTINCT o.OrderID) AS TotalOrders,
    COUNT(DISTINCT o.CustomerID) AS UniqueCustomers,
    SUM(o.TotalSales) AS TotalSales,
    SUM(o.Profit) AS TotalProfit,
    AVG(o.TotalSales) AS AverageSalesPerRow
FROM dbo.Orders AS o
INNER JOIN dbo.Customers AS c
    ON o.CustomerID = c.CustomerID
GROUP BY c.CustomerSegment
ORDER BY TotalSales DESC;



SELECT
    YEAR(OrderDate) AS SalesYear,
    MONTH(OrderDate) AS SalesMonth,
    SUM(TotalSales) AS TotalSales,
    SUM(Profit) AS TotalProfit,
    COUNT(DISTINCT OrderID) AS TotalOrders
FROM dbo.Orders
GROUP BY
    YEAR(OrderDate),
    MONTH(OrderDate)
ORDER BY
    SalesYear,
    SalesMonth;


SELECT
    PaymentMethod,
    COUNT(DISTINCT OrderID) AS TotalOrders,
    SUM(TotalSales) AS TotalSales,
    SUM(Profit) AS TotalProfit
FROM dbo.Orders
GROUP BY PaymentMethod
ORDER BY TotalSales DESC;



SELECT
    OrderStatus,
    COUNT(DISTINCT OrderID) AS TotalOrders,
    SUM(TotalSales) AS TotalSales,
    SUM(Profit) AS TotalProfit
FROM dbo.Orders
GROUP BY OrderStatus
ORDER BY TotalSales DESC;



SELECT
    ReturnReason,
    COUNT(*) AS ReturnRecords
FROM dbo.Returns
GROUP BY ReturnReason
ORDER BY ReturnRecords DESC;



SELECT
    (SELECT COUNT(DISTINCT OrderID)
     FROM dbo.Orders) AS TotalDistinctOrders,

    (SELECT COUNT(*)
     FROM dbo.Returns) AS TotalReturnRecords,

    CAST(
        100.0 * (SELECT COUNT(*) FROM dbo.Returns)
        / NULLIF(
            (SELECT COUNT(DISTINCT OrderID) FROM dbo.Orders),
            0
        )
        AS DECIMAL(10,2)
    ) AS ReturnRecordPercentOfDistinctOrders;


SELECT
    OBJECT_NAME(parent_object_id) AS TableName,
    name AS ForeignKeyName
FROM sys.foreign_keys
WHERE parent_object_id IN (
    OBJECT_ID('dbo.Orders'),
    OBJECT_ID('dbo.Returns')
);
