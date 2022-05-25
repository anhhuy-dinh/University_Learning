USE Northwind

-- Xuất danh sách các nhà cung cấp (gồm Id, CompanyName, ContactName, City, Country, Phone) 
-- kèm theo giá min và max của các sản phẩm mà nhà cung cấp đó cung cấp. 
-- Có sắp xếp theo thứ tự Id của nhà cung cấp.
SELECT S.Id, S.CompanyName, S.ContactName, S.City, S.Country, S.Phone, 
        MIN(P.UnitPrice) AS [Gia Min Cua Cac San Pham],
        MAX(P.UnitPrice) AS [Gia Max Cua Cac San Pham]
FROM Supplier AS S
INNER JOIN [Product] AS P ON P.SupplierId = S.Id
GROUP BY S.Id, S.CompanyName, S.ContactName, S.City, S.Country, S.Phone
ORDER BY S.Id

-- Cũng câu trên nhưng chỉ xuất danh sách nhà cung cấp có sự khác biệt giá (max - min) không quá lớn (<= 30).
SELECT S.Id, S.CompanyName, S.ContactName, S.City, S.Country, S.Phone, 
        MIN(P.UnitPrice) AS [Gia Min Cua Cac San Pham],
        MAX(P.UnitPrice) AS [Gia Max Cua Cac San Pham]
FROM Supplier AS S
INNER JOIN [Product] AS P ON P.SupplierId = S.Id
GROUP BY S.Id, S.CompanyName, S.ContactName, S.City, S.Country, S.Phone
HAVING MAX(P.UnitPrice)-MIN(P.UnitPrice) <= 30
ORDER BY S.Id

-- Xuất danh sách các hóa đơn (Id, OrderNumber, OrderDate) 
-- kèm theo tổng giá chi trả (UnitPrice*Quantity) cho hóa đơn đó, 
-- bên cạnh đó có cột Description là “VIP” nếu tổng giá lớn hơn 1500 
-- và “Normal” nếu tổng giá nhỏ hơn 1500.
SELECT O.Id, O.OrderNumber, O.OrderDate, SUM(OI.UnitPrice*OI.Quantity) AS [Tong Gia Chi Tra], 'VIP' AS [Description]
FROM [Order] AS O
JOIN OrderItem AS OI ON O.Id = OI.OrderId
-- WHERE (SELECT SUM(UnitPrice*Quantity) FROM OrderItem) >= 1500
GROUP BY O.Id, O.OrderNumber, O.OrderDate
HAVING SUM(OI.UnitPrice*OI.Quantity) >= 1500
UNION
SELECT O.Id, O.OrderNumber, O.OrderDate, SUM(OI.UnitPrice*OI.Quantity) AS [Tong Gia Chi Tra], 'Normal' AS [Description]
FROM [Order] AS O
JOIN OrderItem AS OI ON O.Id = OI.OrderId
-- WHERE (SELECT SUM(UnitPrice*Quantity) FROM OrderItem) < 1500
GROUP BY O.Id, O.OrderNumber, O.OrderDate
HAVING SUM(OI.UnitPrice*OI.Quantity) < 1500

-- Xuất danh sách những hóa đơn (Id, OrderNumber, OrderDate) 
-- trong tháng 7 nhưng phải ngoại trừ ra những hóa đơn từ khách hàng France.

-- Xuất danh sách những hóa đơn (Id, OrderNumber, OrderDate, TotalAmount) 
-- nào có TotalAmount nằm trong top 5 các hóa đơn.