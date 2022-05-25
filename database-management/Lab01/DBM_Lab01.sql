USE Northwind

-- Truy vấn danh sách các Customer --
SELECT * FROM Customer

-- Truy vấn danh sách các Customer theo các thông tin Id, FullName (là kết hợp FirstName-LastName), City, Country --
SELECT Id,
        CONCAT(FirstName, ' ', LastName) AS FullName,
        City, Country
FROM Customer

-- Cho biết có bao nhiêu khách hàng từ Germany và UK, đó là những khách hàng nào --
SELECT COUNT(Id) as NumberCustomerFromGermanyUK
FROM Customer
WHERE Country = 'Germany' OR Country = 'UK'

SELECT *
FROM Customer
WHERE Country = 'Germany' OR Country = 'UK'

-- Liệt kê danh sách khách hàng theo thứ tự tăng dần của FirstName và giảm dần của Country --
SELECT *
FROM Customer
ORDER BY FirstName ASC, Country DESC

-- Truy vấn danh sách các khách hàng với ID là 5, 10, từ 1-10 và từ 5-10 --
SELECT *
FROM Customer
WHERE Id = 5 OR Id = 10

SELECT TOP 10 *
FROM Customer

SELECT *
FROM Customer
ORDER BY Id
OFFSET 4 ROWS
FETCH NEXT 6 ROWS ONLY

-- Truy vấn các khách hàng ở các sản phẩm (Product) mà đóng gói dưới dạng bottles
-- có giá từ 15 đến 20 mà không từ nhà cung cấp có ID là 16 --
-- Cách 1 --
SELECT *
FROM Customer as C
WHERE C.Id IN (SELECT O.CustomerId
               FROM [Order] AS O
               WHERE O.Id IN (SELECT OI.OrderId
                              FROM OrderItem AS OI
                              WHERE OI.ProductId IN (SELECT P.Id
                                                     FROM Product AS P
                                                     WHERE (P.Package LIKE '%bottles%') 
                                                          AND (P.UnitPrice BETWEEN 15 AND 20) 
                                                          AND (P.SupplierId <> 16))))
-- Cách 2 --
SELECT DISTINCT C.*
FROM Customer C 
     LEFT JOIN [Order] O ON C.Id = O.CustomerId
     LEFT JOIN OrderItem OI ON O.Id = OI.OrderId
     LEFT JOIN Product P ON OI.ProductId = P.Id
WHERE (P.Package LIKE '%bottles%') 
      AND (P.UnitPrice BETWEEN 15 AND 20) 
      AND (P.SupplierId <> 16)