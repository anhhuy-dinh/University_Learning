USE Northwind

-- Cho biết tỷ lệ phần trăm của TotalAmount trong mỗi hoá đơn theo mỗi khách hàng
SELECT OrderNumber, OrderDate
        CustomerId, TotalAmount,
        SUM(TotalAmount) OVER (PARTITION BY CustomerId) AS TotalAmountByCustomer,
        CAST((TotalAmount / (SUM(TotalAmount) OVER (PARTITION BY CustomerId)) * 100)
                                                AS DECIMAL(6, 2)) AS PercentByCustomer
FROM [Order]
ORDER BY CustomerId, OrderNumber

-- Xuất các hoá đơn vào ngày chủ nhật của tháng tám
SELECT DATENAME(DW, OrderDate) AS [Day Name],
        DATENAME(MONTH, OrderDate) AS [Month Name], *
FROM [Order]
WHERE DATENAME(DW, OrderDate) = 'Sunday' AND DATENAME(MONTH, OrderDate) = 'August'

-- Xuất thông tin Supplier gồm CompanyName, ContactName, Country, ContactInfo, ContactType
-- Trong đó ContactInfo ưu tiên Fax, nếu không có thì dùng Phone. Còn ContactType là ghi chú đó là loại nào
SELECT CompanyName, ContactName, COALESCE(Fax, Phone) AS ContactInfo,
        CASE COALESCE(Fax, Phone) WHEN Fax THEN 'Fax' ELSE 'Phone' END AS ContactType
FROM Supplier

-- Dùng WITH phân chia cây như sau: Mức 0 là các Quốc Gia (Country),
-- mức 1 là các Thành Phố (City) thuộc Country đó,
-- và mức 2 là các Nhà Cung Cấp (Supplier) thuộc Country-City đó.
WITH SupplierCategory(Country, City, CompanyName, alevel)
AS (
    SELECT DISTINCT Country,
            City = CAST('' AS NVARCHAR(255)),
            CompanyName = CAST('' AS NVARCHAR(255)),
            alevel = 0
    FROM Supplier

    UNION ALL

    SELECT S.Country,
            City = CAST(S.City AS NVARCHAR(255)),
            CompanyName = CAST('' AS NVARCHAR(255)),
            alevel = SC.alevel + 1
    FROM SupplierCategory SC
    INNER JOIN Supplier S ON SC.Country = S.Country
    WHERE SC.alevel = 0

    UNION ALL

    SELECT S.Country,
            City = CAST(S.City AS NVARCHAR(255)),
            CompanyName = CAST(S.CompanyName AS NVARCHAR(255)),
            alevel = SC.alevel + 1
    FROM SupplierCategory SC
    INNER JOIN Supplier S ON SC.Country = S.Country AND SC.City = S.City
    WHERE SC.alevel = 1
)
SELECT [Quoc Gia] = CASE WHEN alevel = 0 THEN Country ELSE '--' END,
        [Thanh Pho] = CASE WHEN alevel = 1 THEN City ELSE '----' END,
        [Nha Cung Cap] = CompanyName,
        Cap = alevel
FROM SupplierCategory
ORDER BY Country, City, CompanyName, alevel

-- Tìm các sản phẩm từ nhà cung cấp Germany
-- mà có UnitPrice lớn hơn UnitPrice trung bình của nhà cung cấp số 3
WITH AvgBySupplier AS
(
    SELECT SupplierId, AVGUnitPrice = AVG(UnitPrice)
    FROM Product
    GROUP BY SupplierId
    HAVING SupplierId = 3
),
ProductByCountry AS
(
    SELECT P.*
    FROM Product P
    INNER JOIN Supplier S ON P.SupplierId = S.Id
    WHERE S.Country = 'Germany'
)
SELECT *
FROM ProductByCountry
WHERE UnitPrice > ALL(SELECT AVGUnitPrice FROM AvgBySupplier)

SELECT C.Id, O.OrderNumber, [Name] = C.FirstName + SPACE(1) + C.LastName, C.City, C.Country
FROM Customer C JOIN [Order] O ON C.Id = O.CustomerId
ORDER BY C.Country, C.City, O.OrderNumber