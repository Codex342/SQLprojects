
-- Create the Careers Database

CREATE DATABASE Careers;
GO


-- Verifying The Database 
SELECT name,
       database_id,
       create_date
FROM sys.databases
WHERE name = 'Careers';
GO

-- Changing Context To Database 
USE Careers;
Go 


-- Create the Reference Schema
CREATE SCHEMA Reference;
GO 

SELECT name FROM sys.schema 
WHERE name = Reference;
GO 