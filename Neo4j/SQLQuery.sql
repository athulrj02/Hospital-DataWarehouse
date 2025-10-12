-- 1: List All User Tables
SELECT name, create_date  FROM sys.tables  ORDER BY name;

-- 2: Peek at Production.Product
SELECT TOP 10 * FROM Production.Product;

-- 3: Average List Price by Color
SELECT Color, COUNT(*) AS ProductCount, AVG(ListPrice)  AS AvgPrice
FROM Production.Product
WHERE Color IS NOT NULL
GROUP BY Color
ORDER BY AvgPrice DESC;

-- 4: Product Count by Category
SELECT c.Name AS CategoryName, COUNT(p.ProductID) AS ProductCount
FROM Production.Product       p
JOIN Production.ProductSubcategory sc
  ON p.ProductSubcategoryID = sc.ProductSubcategoryID
JOIN Production.ProductCategory      c
  ON sc.ProductCategoryID    = c.ProductCategoryID
GROUP BY c.Name
ORDER BY ProductCount DESC;

-- 5: Total sales and order count per year
SELECT YEAR(OrderDate) AS SalesYear, COUNT(*) AS OrderCount, SUM(TotalDue) AS TotalSales
FROM Sales.SalesOrderHeader
GROUP BY YEAR(OrderDate)
ORDER BY SalesYear;

-- 6: Top 5 customers by total lifetime spend
SELECT TOP (5) c.CustomerID, c.AccountNumber, p.Title + ' ' + p.FirstName + ' ' + p.LastName AS CustomerName, 
SUM(d.LineTotal) AS TotalSpent
FROM Sales.SalesOrderHeader h
JOIN Sales.SalesOrderDetail d ON h.SalesOrderID = d.SalesOrderID
JOIN Sales.Customer c ON h.CustomerID = c.CustomerID
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
GROUP BY c.CustomerID, c.AccountNumber, p.Title, p.FirstName, p.LastName
ORDER BY TotalSpent DESC;


--7:Top 5 most expensive products per category
WITH RankedProducts AS (
  SELECT p.ProductID, p.Name AS ProductName, p.ListPrice, sc.ProductCategoryID,
         ROW_NUMBER() OVER (PARTITION BY sc.ProductCategoryID ORDER BY p.ListPrice DESC) AS rn
  FROM Production.Product p
  JOIN Production.ProductSubcategory sc ON p.ProductSubcategoryID = sc.ProductSubcategoryID
)
SELECT rp.ProductCategoryID, c.Name AS CategoryName, rp.ProductID, rp.ProductName, rp.ListPrice
FROM RankedProducts rp
JOIN Production.ProductCategory c ON rp.ProductCategoryID = c.ProductCategoryID
WHERE rp.rn <= 5;