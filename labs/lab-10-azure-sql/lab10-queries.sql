-- Lab 10 — Azure SQL Database queries.
-- Run these in the portal Query editor:
--   Azure SQL database  >  Query editor (preview)  >  sign in  >  paste  >  Run
-- The database was created with the AdventureWorksLT sample data.

-- 1. Which tables did the sample dataset create?
SELECT TABLE_SCHEMA, TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_SCHEMA, TABLE_NAME;

-- 2. The top 20 most expensive products.
SELECT TOP 20
    p.ProductID,
    p.Name,
    p.ProductNumber,
    p.ListPrice
FROM SalesLT.Product AS p
ORDER BY p.ListPrice DESC;

-- 3. Product count and average price per category.
SELECT
    c.Name                AS Category,
    COUNT(*)              AS Products,
    AVG(p.ListPrice)      AS AvgPrice
FROM SalesLT.Product AS p
JOIN SalesLT.ProductCategory AS c
    ON p.ProductCategoryID = c.ProductCategoryID
GROUP BY c.Name
ORDER BY Products DESC;

-- 4. Create your own table, insert a row, read it back.
CREATE TABLE dbo.LabNotes (
    NoteID    INT IDENTITY(1,1) PRIMARY KEY,
    Learner   NVARCHAR(100) NOT NULL,
    Note      NVARCHAR(400) NOT NULL,
    CreatedAt DATETIME2     NOT NULL DEFAULT SYSUTCDATETIME()
);

INSERT INTO dbo.LabNotes (Learner, Note)
VALUES (N'<your name>', N'Azure SQL Database is PaaS - Microsoft patches and backs up the engine.');

SELECT * FROM dbo.LabNotes;

-- 5. Confirm the service tier you are paying for.
SELECT
    DATABASEPROPERTYEX(DB_NAME(), 'Edition')        AS ServiceTier,
    DATABASEPROPERTYEX(DB_NAME(), 'ServiceObjective') AS ComputeSize;

-- 6. Tidy up the table you created (the database itself is deleted in the lab clean-up).
DROP TABLE dbo.LabNotes;
