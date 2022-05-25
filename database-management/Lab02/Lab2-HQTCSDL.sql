USE Northwind

-- Voi moi khach hang cho biet Ma Khach Hang, Ten Khach Hang, Tong Gia Tri Trung Binh va Tong So Hoa Don
-- va sap xep theo Tong So Hoa Don
SELECT C.Id, C.FirstName + ' ' + C.LastName AS [Ho Ten],
        COUNT(O.OrderNumber) AS [Tong So Hoa Don],
        AVG(O.TotalAmount) [Tong Gia Trung Binh]
FROM Customer AS C
INNER JOIN [Order] AS O ON C.Id = O.CustomerId
GROUP BY C.Id, C.FirstName, C.LastName
ORDER BY [Tong So Hoa Don] DESC

-- Nhu cau tren nhung chi xuat danh sach khach hang khong co hoac co it hon 3 hoa don mua hang
SELECT C.FirstName + ' ' + C.LastName AS [Ho Ten],
        ISNULL(COUNT(O.OrderNumber), 0) AS [Tong So Hoa Don],
        ISNULL(AVG(O.TotalAmount), 0) [Tong Gia Trung Binh]
FROM Customer AS C
LEFT JOIN [Order] AS O ON C.Id = O.CustomerId
GROUP BY C.FirstName, C.LastName
HAVING COUNT(O.OrderNumber) < 3
ORDER BY [Tong So Hoa Don] DESC

-- Xuat danh sach cac OrderNumber kem theo Total Amount va Description
-- Description la "Under Average" neu so luong Total Amount nho hon so luong trung binh
-- va "Above Average" neu nguoc lai
SELECT OrderNumber, TotalAmount, 'Above Average' AS [Description]
FROM [Order]
WHERE TotalAmount >= (SELECT AVG(TotalAmount) FROM [Order])
UNION
SELECT OrderNumber, TotalAmount, 'Below Average' AS [Description]
FROM [Order]
WHERE TotalAmount < (SELECT AVG(TotalAmount) FROM [Order])

-- Xuat thong tin nhung quoc gia nao vua co nha cung cap va vua co khach hang
SELECT Country
FROM Customer
INTERSECT
SELECT Country
FROM Supplier

-- Xuat thong tin nhung quoc gia nao chi co khach hang ma khong co nha cung cap
SELECT Country
FROM Customer
EXCEPT
SELECT Country
FROM Supplier

-- Xuat thong tin nhung san pham nao co gia cao hon gia cac san pham cua SupplierId 8
SELECT *
FROM Product
WHERE UnitPrice >= ALL (SELECT UnitPrice FROM Product WHERE SupplierId = 8)

-- Xuat danh sach cac san pham co nha cung cap nhieu thu 4 trong cac nha cung cap
SELECT *
FROM Product
WHERE SupplierId IN (SELECT TOP 4 SupplierId FROM Product GROUP BY SupplierId ORDER BY Count(ProductName) DESC)

-- Xuat danh sach cac khach hang co hoa don vao thang 7
SELECT *
FROM Customer C
WHERE EXISTS (SELECT * FROM [Order] AS O WHERE O.CustomerId = C.Id AND MONTH(O.OrderDate) = 7)