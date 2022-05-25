USE Master;
GO
CREATE DATABASE [QueryTraining];
GO
USE [QueryTraining];
GO

CREATE TABLE [MyTable] (
    ID int,  --would normally be an INT IDENTITY
    ParentID int
    );

INSERT INTO [MyTable] (ID, ParentID) 
        VALUES (1, NULL),
               (2, 1),
               (3, 1),
               (4, 2),
               (2, 4),
               (2, 4);

SELECT * FROM [MyTable]

DECLARE @StartID AS INTEGER;
SET @StartID = 1;

;WITH links (ID, ParentID, Depth, treePath)
AS
(
    --Get the starting link
    SELECT [ID],
           [ParentID],
           [Depth] = 1, 
           CAST(':' + CAST([ID] AS VARCHAR(MAX)) AS VARCHAR(MAX)) AS treePath
      FROM [MyTable] 
     WHERE [ID] = @StartID

    UNION ALL

    --Recursively get links that are parented to links already in the CTE
    SELECT mt.[ID],
           mt.[ParentID],
           [Depth] = l.[Depth] + 1,
           CAST(l.treePath + CAST(mt.[ID] AS VARCHAR(MAX)) + ':' AS VARCHAR(MAX)) AS treePath
      FROM [MyTable] mt
     INNER JOIN links l ON mt.ParentID = l.ID
       AND CHARINDEX(':' + CAST(mt.[ID] AS VARCHAR(MAX)) + ':', l.[treePath]) = 0
     WHERE Depth < 10
)
SELECT 
    [Depth],
    [ID],
    [ParentID],
    [treePath]
FROM
    [links];