/*
============================================================================
************************  TOM GREEN HANDYMAN DATABASE  *********************
============================================================================
*/


CREATE DATABASE TomGreenHandyman	--Create DataBase TomGreenHandyman.
--DROP DATABASE TomGreenHandyman
GO
USE TomGreenHandyman				--Using TomGreenHandyman Database.
--DROP DATABASE TomGreenHandyman
GO
SET NOCOUNT ON

/*
DROP TABLE tblCustomer
DROP TABLE tblCode
DROP TABLE tblCompany
DROP TABLE tblContractor
DROP TABLE tblCrew
DROP TABLE tblList
DROP TABLE tblService
*/

CREATE TABLE tblCompany						--Creating a Table for Company (tblCompany).
(
 CompanyID INT IDENTITY(1,1) PRIMARY KEY,	--Surrogate key for Company Table.
 Name VARCHAR(25),
 StreetAddress  NVARCHAR(150),
 City VARCHAR(25),
 State VARCHAR (25),
 Zipcode CHAR(5),
 TaxID INT
)
GO

CREATE TABLE tblCustomer(					--Creating a Table for Customer (tblCustomer).
 CustomerID INT IDENTITY(1,1) PRIMARY KEY,	--Surrogate key for Customer Table.
 FirstName NVARCHAR(50),
 LastName NVARCHAR(50),
 StreetAddress NVARCHAR(150),
 City VARCHAR(25),
 State VARCHAR(25),
 ZipCode CHAR(5)
 )
GO

CREATE TABLE tblInvoice(					--Creating a Table for Invoice (tblInvoice).
 InvoiceSerial INT IDENTITY(1,1) PRIMARY KEY,--Surrogate key for Invoice Table.
 Invoice INT,
 InvoiceDate DATETIME,
 Total FLOAT,
 ProjectDescription nvarchar(250),
 StartDate DATETIME,
 EndDate DATETIME
)
Go

CREATE TABLE tblList(						--Creating a Table for List (tblList).
 Quantity float,	
 Cost FLOAT
)
GO

CREATE TABLE tblService(					--Creating a Table for Service (tblService).
 ServiceID INT IDENTITY(1,1) PRIMARY KEY,	--Surrogate key for Service Table.
 Description VARCHAR(150),
 UnitPrice FLOAT,
 )
GO

CREATE TABLE tblCode(						--Creating a Table for Code (tblCode).
 CodeID INT IDENTITY(1,1) PRIMARY KEY,		--Surrogate key for Code Table.
 Name VARCHAR(25)
 )
 GO

 CREATE TABLE tblContractor(				--Creating a Table for Contractor (tblContractor).
  ContractorID INT IDENTITY(1,1) PRIMARY KEY, --Surrogate key for Contractor Table.
  Name VARCHAR(25)
  )
  GO

  CREATE TABLE tblCrew(						--Creating a Table for Crew (tblCrew).
   CrewID INT IDENTITY(1,1) PRIMARY KEY,	--Surrogate key for Crew Table.
   TeamName VARCHAR(25)
   )
   GO
PRINT 'Tables successfully Created...'
GO

SET NOCOUNT OFF

/*
=========================================================
********CREATING RELATIONS BETWEEN EACH TABLE************
=========================================================
*/

/*
The Relation between Company and Invoice is One to Many(1:M).

tblCompany ||---------o< tblInvoice
*/
SET NOCOUNT ON

ALTER TABLE tblInvoice
ADD CompanyID INT NOT NULL			
GO

ALTER TABLE tblInvoice
ADD CONSTRAINT Company_Invoice_FK FOREIGN KEY (CompanyID) --Creating Foreign key Constraint on Table Inovice and Company.
REFERENCES tblCompany(CompanyID)
GO

/*
In case if it is necessary to drop Constraint..!

ALTER TABLE tblInvoice
DROP CONSTRAINT Company_Invoice_FK
*/

/*
The relation between Cusotmer and Invoice is One to Many(1:M).

tblCustomer ||---------o< tblInvoice
*/

ALTER TABLE tblInvoice
ADD CustomerID INT NOT NULL
GO

ALTER TABLE tblInvoice
ADD CONSTRAINT Customer_Invoice_FK FOREIGN KEY (CustomerID)--Creating Foreign key Constraint on Table Inovice and Customer.
REFERENCES tblCustomer(CustomerID)
GO

/*
The relation between Invoice and List is One to Many(1:M). 
But here, It is mandatory to have atleast one list in the Invoice.

tblInvoice ||------|< tblList
*/
ALTER TABLE tblList
ADD InvoiceSerial INT NOT NULL
GO

ALTER TABLE tblList
ADD CONSTRAINT Invoice_List_FK FOREIGN KEY (InvoiceSerial) --Creating Foreign key Constraint on Table Inovice and List.
REFERENCES tblInvoice(InvoiceSerial)
GO

/*
The relation between Service and List is One to Many(1:M).

tblService ||----o< tblList
*/
ALTER TABLE tblList
ADD ServiceID INT NOT NULL
GO

ALTER TABLE tblList
ADD CONSTRAINT Service_List_FK FOREIGN KEY (ServiceID)--Creating Foreign key Constraint on Table List and Service.
REFERENCES tblService(ServiceID)
GO

/*
The relation between Code and Service is One to Many(1:M).

tblCode ||---o< tblService
*/
ALTER TABLE tblService
ADD CodeID INT NOT NULL
GO

ALTER TABLE tblService
ADD CONSTRAINT Code_Service_FK FOREIGN KEY (CodeID)--Creating Foreign key Constraint on Table Service and Code.
REFERENCES tblCode(CodeID)
GO


/*
The relation between Contractor and Invoice is One to Many(1:M).

tblContractor ||------o< tblInvoice
*/

ALTER TABLE tblInvoice
ADD ContractorID INT NOT NULL
GO

ALTER TABLE tblInvoice
ADD CONSTRAINT Contractor_Invoice_FK FOREIGN KEY (ContractorID)--Creating Foreign key Constraint on Table Inovice and Contractor.
REFERENCES tblContractor(ContractorID)
GO


/*
The relation between Crew and Invoice is One to Many(1:M).

tblCrew ||--------o< tblInvoice
*/
ALTER TABLE tblInvoice
ADD CrewID INT NOT NULL 
GO

ALTER TABLE tblInvoice
ADD CONSTRAINT Crew_Invoice_FK FOREIGN KEY (CrewID)--Creating Foreign key Constraint on Table Inovice and Crew.
REFERENCES tblCrew(CrewID)
GO

PRINT 'Foreign Key Constraints successfully applied...'
GO

/*
==============================================================
**********Enforce UNIQUE constraints on identifiers******
==============================================================
*/


--Add an Alternate key constraint to an existing attribute
ALTER TABLE tblCompany
ADD CONSTRAINT TaxID_Unique 
UNIQUE(TaxID)						 -- making this an alternate key
GO

ALTER TABLE tblInvoice
ADD CONSTRAINT Invoice_Unique 
UNIQUE(Invoice)						 -- making this an alternate key
GO

ALTER TABLE tblContractor
ADD CONSTRAINT ContractorName_Unique
UNIQUE(Name)						 -- making this an alternate key
GO

ALTER TABLE tblCrew
ADD CONSTRAINT CrewName_Unique
UNIQUE(TeamName)					 -- making this an alternate key
GO

ALTER TABLE tblCode
ADD CONSTRAINT CodeName_Unique 
UNIQUE(Name)						 -- making this an alternate key
GO

PRINT 'UNIQUE Constraints successfully applied...'
GO
/*
==========================================================
********* Enforce NOT NULL constraints**************
==========================================================
*/

ALTER TABLE tblCompany
ALTER COLUMN Name VARCHAR(25) NOT NULL			--Making Company Name is NOTNULL in the tblCompany.
GO

ALTER TABLE tblCustomer
ALTER COLUMN FirstName NVARCHAR(50) NOT NULL	--Making Customer FirstName is NOTNULL in the tblCustomer.
GO

ALTER TABLE tblCustomer
ALTER COLUMN LastName NVARCHAR(50) NOT NULL		--Making Customer LastName is NOTNULL in the tblCustomer.
GO


PRINT 'NOT NULL Constraints successfully applied...'
GO
/*
========================================================
******Enforce domain and range constraints*****
=======================================================
*/

ALTER TABLE tblCrew								--Making Crew table Domain Constraint.
ADD CONSTRAINT Valid_Crew_Name_Check
CHECK (tblCrew.TeamName IN('Team 1a','Team a1','1a Team', 'a1 Team', '1a')) 
GO


PRINT 'CHECK Constraints successfully applied...'
GO

SET NOCOUNT OFF


/*
====================================================
*********Inserting Data in the tables**************
====================================================
*/
SET NOCOUNT ON
GO

--Insert Company in tblCompany

BEGIN TRY
  BEGIN TRANSACTION

  INSERT INTO tblCompany(Name, StreetAddress, City, State, Zipcode, TaxID)
    VALUES ('Tom Green Handyman', 'Industrial Park, Lot #4', 'Mobile', 'Alabama','36658','123456')

  COMMIT TRANSACTION

  PRINT 'Company successfully inserted...'

END TRY
BEGIN CATCH
  DECLARE @ErrorMessage VARCHAR(500)
  SET @ErrorMessage = ERROR_MESSAGE() + ' Rolledback transaction: Company insertions.'
  ROLLBACK TRANSACTION
  RAISERROR (@ErrorMessage, 16,1)
END CATCH
GO
--SELECT * FROM tblcompany


--Insert Customer in tblCustomer

BEGIN TRY
  BEGIN TRANSACTION
  
  INSERT INTO tblCustomer (FirstName, LastName, StreetAddress, City, State, ZipCode)
    VALUES ('Charles', 'Fielding', '456 Mobile St', 'Mobile', 'Alabama','36655')
 
  COMMIT TRANSACTION

  PRINT 'Customer successfully inserted...'

END TRY
BEGIN CATCH
  DECLARE @ErrorMessage VARCHAR(500)
  SET @ErrorMessage = ERROR_MESSAGE() + ' Rolledback transaction: Customer insertions.'
  ROLLBACK TRANSACTION
  RAISERROR (@ErrorMessage, 16,1)
END CATCH
GO

-- SELECT * FROM tblCustomer



--Insert Contractor in tblContractor

BEGIN TRY
  BEGIN TRANSACTION
  
  INSERT INTO tblContractor (Name)
    VALUES ('Paint-boys')
 
  COMMIT TRANSACTION

  PRINT 'Contractor successfully inserted...'

END TRY
BEGIN CATCH
  DECLARE @ErrorMessage VARCHAR(500)
  SET @ErrorMessage = ERROR_MESSAGE() + ' Rolledback transaction: Contractor insertions.'
  ROLLBACK TRANSACTION
  RAISERROR (@ErrorMessage, 16,1)
END CATCH
GO
--SELECT * FROM tblContractor

--Insert crew in tblcrew
BEGIN TRY
  BEGIN TRANSACTION
  
  INSERT INTO tblcrew (TeamName)
    VALUES ('Team 1a')
 
  COMMIT TRANSACTION

  PRINT 'Crew successfully inserted...'

END TRY
BEGIN CATCH
  DECLARE @ErrorMessage VARCHAR(500)
  SET @ErrorMessage = ERROR_MESSAGE() + ' Rolledback transaction: Crew insertions.'
  ROLLBACK TRANSACTION
  RAISERROR (@ErrorMessage, 16,1)
END CATCH
GO

--SELECT * FROM tblCrew


--Insert Code in tblCode

BEGIN TRY
  BEGIN TRANSACTION
  
  INSERT INTO tblCode (Name)
    VALUES ('Billable')

  INSERT INTO tblCode (Name)
    VALUES ('Consumable')

	INSERT INTO tblCode (Name)
    VALUES ('Pass Through')
 
  COMMIT TRANSACTION

  PRINT 'Code successfully inserted...'

END TRY
BEGIN CATCH
  DECLARE @ErrorMessage VARCHAR(500)
  SET @ErrorMessage = ERROR_MESSAGE() + ' Rolledback transaction: Code insertions.'
  ROLLBACK TRANSACTION
  RAISERROR (@ErrorMessage, 16,1)
END CATCH
GO

--SELECT *FROM tblCode


--Insert Services in tblService

BEGIN TRY
  BEGIN TRANSACTION
   DECLARE @codeID INT

   SET @codeID = (SELECT CodeID FROM tblCode WHERE Name = 'Billable')
	INSERT INTO tblService(Description, UnitPrice, CodeID)
    VALUES ('Labor', 15.00, @codeID )

   SET @codeID = (SELECT CodeID FROM tblCode WHERE Name = 'Consumable')
    INSERT INTO tblService(Description, UnitPrice, CodeID)
    VALUES ('Nails and Screws', 0.80, @codeID )
	INSERT INTO tblService(Description, UnitPrice, CodeID)
    VALUES ('Paint and Plywood', 1000.00, @codeID )
	

   SET @codeID = (SELECT CodeID FROM tblCode WHERE Name = 'Pass Through')
	INSERT INTO tblService(Description, UnitPrice, CodeID)
    VALUES ('Freight', 150.00, @codeID)

  COMMIT TRANSACTION

  PRINT 'Service successfully inserted...'

END TRY
BEGIN CATCH
  DECLARE @ErrorMessage VARCHAR(500)
  SET @ErrorMessage = ERROR_MESSAGE() + ' Rolledback transaction: Services insertions.'
  ROLLBACK TRANSACTION
  RAISERROR (@ErrorMessage, 16,1)
END CATCH
GO

--SELECT * FROM tblService


-- Insert Invoice in tblInvoice

BEGIN TRY
	BEGIN TRANSACTION
	DECLARE @CompanyID INT
	DECLARE @CustomerID INT
	DECLARE @ContractorID INT
	DECLARE @crewID INT


	SET @CompanyID = (SELECT CompanyID FROM tblCompany  WHERE CompanyID = 1)
	SET @CustomerID = (SELECT CustomerID FROM tblCustomer  WHERE CustomerID = 1)
	SET @ContractorID  = (SELECT ContractorID  FROM tblContractor   WHERE ContractorID  = 1)
	SET @crewID  = (SELECT CrewID  FROM tblCrew   WHERE CrewID  = 1)
	INSERT INTO tblInvoice (Invoice ,InvoiceDate ,Total ,ProjectDescription ,StartDate ,EndDate , CompanyID , CustomerID ,ContractorID , CrewID )
		VALUES ( 0003521,'05-06-2013',1546.25,'Upgrade to bathroom', '05-01-2013', '05-05-2013', @CompanyID ,@CustomerID ,@ContractorID , @crewID )


	COMMIT TRANSACTION
	PRINT 'Invoice successfully inserted...'
  END TRY
  BEGIN CATCH
	DECLARE @ErrorMessage VARCHAR(500)
	SET @ErrorMessage = ERROR_MESSAGE() + ' Rolledback transaction: Invoice insertions.'
	ROLLBACK TRANSACTION
	RAISERROR (@ErrorMessage, 16,1)
  END CATCH
GO

--SELECT * FROM tblInvoice

--Insert List in tblList

  BEGIN TRY
	BEGIN TRANSACTION
	DECLARE @InvoiceSerial INT
	DECLARE @ServiceID INT

	SET @InvoiceSerial = (SELECT InvoiceSerial FROM tblInvoice WHERE Invoice = 0003521)
	SET @ServiceID = (SELECT ServiceID FROM tblService WHERE Description = 'Labor')
	INSERT INTO tblList (Quantity,Cost,InvoiceSerial,ServiceID)
		VALUES ( 23.75,356.25,@InvoiceSerial,@ServiceID)

	SET @InvoiceSerial = (SELECT InvoiceSerial FROM tblInvoice WHERE Invoice = 0003521)
	SET @ServiceID = (SELECT ServiceID FROM tblService WHERE Description = 'Nails and Screws')
	INSERT INTO tblList (Quantity,Cost,InvoiceSerial,ServiceID)
		VALUES ( 50.00,40,@InvoiceSerial,@ServiceID)

	SET @InvoiceSerial = (SELECT InvoiceSerial FROM tblInvoice WHERE Invoice = 0003521)
	SET @ServiceID = (SELECT ServiceID FROM tblService WHERE Description = 'Paint and Plywood')
	INSERT INTO tblList (Quantity,Cost,InvoiceSerial,ServiceID)
		VALUES ( 1,1000.00,@InvoiceSerial,@ServiceID)

	SET @InvoiceSerial = (SELECT InvoiceSerial FROM tblInvoice WHERE Invoice = 0003521)
	SET @ServiceID = (SELECT ServiceID FROM tblService WHERE Description = 'Freight')
	INSERT INTO tblList (Quantity,Cost,InvoiceSerial,ServiceID)
		VALUES ( 1,150.00,@InvoiceSerial,@ServiceID)


	COMMIT TRANSACTION
	PRINT 'List successfully inserted...'
  END TRY
  BEGIN CATCH
	DECLARE @ErrorMessage VARCHAR(500)
	SET @ErrorMessage = ERROR_MESSAGE() + ' Rolledback transaction: List insertions.'
	ROLLBACK TRANSACTION
	RAISERROR (@ErrorMessage, 16,1)
  END CATCH
GO

--SELECT * FROM tblList


/*
==============================================
************* Store Procedure**************
===============================================
*/

--Insert Invoice in tblinvoice

--Creating (INSERT) a Store Procedure for invoice

CREATE PROC InsertInvoice
 @Invoice INT, 
 @InvoiceDate DATETIME, 
 @Total Float,
 @ProjectDescription VARCHAR(250),
 @StartDate DATETIME, 
 @EndDate DATETIME, 
 @CompanyID INT,
 @CustomerID INT,
 @ContractorID INT,
 @CrewID INT

 /*
 Created by Cherkupalli VenkatReddy 
Purpose of change: Created sproc for Inserting Data
*/

AS
BEGIN

  IF EXISTS(SELECT * FROM tblInvoice WHERE Invoice = @Invoice)
  BEGIN
     RAISERROR('The Invoice already exists...', 16, 1)
     RETURN 
  END

BEGIN TRY
  BEGIN TRANSACTION InsertInvoice

  INSERT INTO tblInvoice (Invoice, InvoiceDate,TOTAL, ProjectDescription, StartDate, EndDate,CompanyID, CustomerID, ContractorID, CrewID)
     VALUES (@Invoice,@InvoiceDate, @TOTAL, @ProjectDescription,@StartDate,@EndDate, @CompanyID, @CustomerID, @ContractorID, @CrewID );

  DECLARE @InvoiceSerial INT; SET @InvoiceSerial = SCOPE_IDENTITY();


  COMMIT TRANSACTION  InsertInvoice;
  
  PRINT 'Invoice successfully inserted...'

  END TRY

  BEGIN CATCH
    DECLARE @ErrorMessage VARCHAR(500);
    SET @ErrorMessage = ERROR_MESSAGE() + ' Rolledback transaction: Invoice insertions.';
    ROLLBACK TRANSACTION  InsertInvoice;
    RAISERROR (@ErrorMessage, 16,1);
  END CATCH 
  /*
	Test cases
DECLARE @CompanyID INT; SET @CompanyID = (SELECT CompanyID FROM tblCompany WHERE Name = 'Tom Green Handyman')
DECLARE @CustomerID INT; SET @CustomerID = (SELECT CustomerID FROM tblCustomer WHERE FirstName = 'Charles')
DECLARE @CrewID INT; SET @CrewID = (SELECT CrewID FROM tblCrew WHERE TeamName = 'Team 1a')
DECLARE @ContractorID INT; SET @ContractorID = (SELECT ContractorID FROM tblContractor WHERE Name = 'Paint-boys')

EXEC InsertInvoice 000521,'05-06-2013',1546.25, 'Upgrade to bathroom','05-01-2013','05-05-2013',@CompanyID, @CustomerID, @CrewID, @ContractorID

SELECT * FROM tblInvoice

*/

END --end sproc

GO
PRINT 'Successfully created sproc InsertInvoice...'
GO

--**********UPDATE Store Procedure*****************

--Creating (UPDATE) a Store Procedure for invoice
CREATE PROC UpdateInvoice
 @Invoice INT, 
 @InvoiceDate DATETIME, 
 @Total Float,
 @ProjectDescription VARCHAR(250),
 @StartDate DATETIME, 
 @EndDate DATETIME, 
 @CompanyID INT,
 @CustomerID INT,
 @ContractorID INT,
 @CrewID INT,
 @InvoiceSerial INT
 
 /*
 Created by Cherkupalli SVenkatReddy 
Purpose of change: Created sproc for Updating Data
*/
AS
BEGIN

  IF EXISTS(SELECT * FROM tblInvoice WHERE Invoice = @Invoice)
  BEGIN
     RAISERROR('The Invoice already exists...', 16, 1)
     RETURN 
  END

BEGIN TRY
  BEGIN TRANSACTION UpdateInvoice

    UPDATE tblInvoice 
     SET Invoice  = @Invoice,
		 InvoiceDate = @InvoiceDate, 
		 TOTAL = @TOTAL,
		 ProjectDescription = @ProjectDescription,
		 StartDate = @StartDate,
		 EndDate = @EndDate,
		 CompanyID = @CompanyID,
		 CustomerID = @CustomerID, 
		 ContractorID = @ContractorID, 
		 CrewID = @CrewID 
	WHERE InvoiceSerial = @InvoiceSerial


  COMMIT TRANSACTION  UpdateInvoice;
  
  PRINT 'Invoice successfully Updated...'

  END TRY

  BEGIN CATCH
    DECLARE @ErrorMessage VARCHAR(500);
    SET @ErrorMessage = ERROR_MESSAGE() + ' Rolledback transaction: Invoice Updation.';
    ROLLBACK TRANSACTION  UpdateInvoice;
    RAISERROR (@ErrorMessage, 16,1);
  END CATCH 
  /*
	Test cases
DECLARE @CompanyID INT; SET @CompanyID = (SELECT CompanyID FROM tblCompany WHERE Name = 'Tom Green Handyman')
DECLARE @CustomerID INT; SET @CustomerID = (SELECT CustomerID FROM tblCustomer WHERE FirstName = 'Charles')
DECLARE @CrewID INT; SET @CrewID = (SELECT CrewID FROM tblCrew WHERE TeamName = 'Team 1a')
DECLARE @ContractorID INT; SET @ContractorID = (SELECT ContractorID FROM tblContractor WHERE Name = 'Paint-boys')
DECLARE @InvoiceSerial INT; SET @InvoiceSerial = 2

EXEC UpdateInvoice 9873,'2011-05-04',154.25, 'Uprade to bath','2004-05-01','2013-05-05',@CompanyID, @CustomerID, @CrewID, @ContractorID,@InvoiceSerial

SELECT * FROM tblInvoice

*/

END --end sproc

GO
PRINT 'Successfully created sproc UpdateInvoice...'
GO


--************DELETE Store Procedure**********


--Creating (DELETE) a Store Procedure for Invoice
CREATE PROC DeleteInvoice
 @InvoiceSerial INT
 
 /*
 Created by Cherkupalli VenkatReddy 
Purpose of change: Created sproc for Deleting Data
*/
AS
BEGIN

BEGIN TRY
  BEGIN TRANSACTION DeleteInvoice

    DELETE FROM tblInvoice 
	WHERE InvoiceSerial = @InvoiceSerial


  COMMIT TRANSACTION  DeleteInvoice;
  
  PRINT 'Invoice successfully Deleted...'

  END TRY

  BEGIN CATCH
    DECLARE @ErrorMessage VARCHAR(500);
    SET @ErrorMessage = ERROR_MESSAGE() + ' Rolledback transaction: Invoice Deletion.';
    ROLLBACK TRANSACTION  DeleteInvoice;
    RAISERROR (@ErrorMessage, 16,1);
  END CATCH 
  /*
	Test cases
DECLARE @InvoiceSerial INT; SET @InvoiceSerial = 2

EXEC DeleteInvoice @InvoiceSerial

SELECT * FROM tblInvoice


*/

END --end sproc

GO
PRINT 'Successfully created sproc DeleteInvoice...'
GO

/*
=====================================================
**************MIN Cardinality *******************
=====================================================
*/


CREATE TRIGGER trigMinCardinality ON tblList		--Creating Trigger for MinCardinality of the invoice.
FOR DELETE
AS
BEGIN

   IF (SELECT COUNT(*) 
       FROM tblList 
       WHERE InvoiceSerial = (SELECT DISTINCT InvoiceSerial FROM deleted)) < 1
   BEGIN
      ROLLBACK TRAN
      RAISERROR ('A Invoice must have at least one List', 16, 1)
   END
END
GO
PRINT 'Successfully created trigger trigMinCardinality...'
GO

SET NOCOUNT OFF
GO

/*
=====================================================
********************TRIGGERS***********************
=====================================================

*/
SET NOCOUNT ON
GO
--Create a shadow table for tblService
CREATE TABLE tblAuditServiceTriggerTable
(
AuditLogID INT IDENTITY(1,1) PRIMARY KEY,	-- Surrogate key for Audit table.
ServiceID INT,
Description VARCHAR(150),
UnitPrice FLOAT,
CodeID INT,
ChangeTime DATETIME DEFAULT GETDATE(),		--Time change occurred
ChangeType NVARCHAR(10),					--INSERT, UPDATE, DELETE
ImageType NVARCHAR(10)						--BEFORE, AFTER     
)
GO

--Create a Trigger FOR INSERT on tblService

CREATE TRIGGER trigInsertService ON tblService
FOR INSERT
AS
BEGIN
		--Echo..

		SELECT 'inserted' AS Buffer, inserted.* FROM inserted  --ECHO of the inserted table.
		
		--Action...
		INSERT INTO tblAuditServiceTriggerTable ( ServiceID, Description, UnitPrice, CodeID ,ChangeTime, ChangeType, ImageType)
			  SELECT  ServiceID, Description, UnitPrice, CodeID, GETDATE() AS ChangeTime, 'INSERT' AS ChangeType, 'AFTER' AS ImageType
			  FROM inserted
END
GO
/*

SELECT * FROM tblService

INSERT INTO tblService ( Description, UnitPrice, CodeID)
Values ( 'Brush', 2.00, 3)

*/

--Create a Trigger FOR UPDATE on tblService

CREATE TRIGGER trigUpdateService ON tblService
FOR UPDATE
AS
BEGIN
		--Echo...
		SELECT 'deleted' AS Buffer, deleted.*, 'before' AS RowImage FROM deleted
		SELECT 'inserted' AS Buffer, inserted.*, 'after' AS RowImage FROM inserted	
		
		--Action...
		
		INSERT INTO tblAuditServiceTriggerTable ( ServiceID, Description, UnitPrice, CodeID ,ChangeTime, ChangeType, ImageType)
		 SELECT ServiceID, Description, UnitPrice, CodeID, GETDATE() AS ChangeTime, 'UPDATE' AS ChangeType, 'BEFORE' AS ImageType
		 FROM deleted

		INSERT INTO tblAuditServiceTriggerTable ( ServiceID, Description, UnitPrice, CodeID ,ChangeTime, ChangeType, ImageType)
		 SELECT  ServiceID, Description, UnitPrice, CodeID, GETDATE() AS ChangeTime, 'UPDATE' AS ChangeType, 'AFTER' AS ImageType
		 FROM inserted

END
GO
/*

SELECT * FROM tblService

UPDATE tblService 
SET Description = 'wood',
	UnitPrice = 12.22
WHERE ServiceID = 5
*/

--Create a Trigger FOR DELETE on tblService


CREATE TRIGGER trigDeleteService ON tblService
FOR DELETE
AS
BEGIN
		--Echo...
		  SELECT 'deleted' AS Buffer, deleted.*, 'before' AS RowImage FROM deleted

		--Action...
		INSERT INTO tblAuditServiceTriggerTable ( ServiceID, Description, UnitPrice, CodeID ,ChangeTime, ChangeType, ImageType)
		 SELECT  ServiceID, Description, UnitPrice, CodeID, GETDATE() AS ChangeTime, 'DELETE' AS ChangeType, 'BEFORE' AS ImageType
		 FROM deleted

END
GO

/*

SELECT * FROM tblService

DELETE tblService WHERE ServiceID =5

SELECT * FROM tblAuditServiceTriggerTable

*/

SET NOCOUNT OFF
GO

/*
======================================================
**********************VIEWS***************************
======================================================
*/


SET NOCOUNT ON
GO

CREATE VIEW vwInvoice					-- Create a View with a subquary (Nested Quary)
AS
SELECT *
FROM tblInvoice 
WHERE InvoiceSerial  IN (SELECT InvoiceSerial
						 FROM tblInvoice 
						 WHERE Total  = 1546.25) 
GO


CREATE VIEW vwList						--Create a View by GROUP BY and HAVING.
AS
SELECT tblList.Quantity, COUNT(*) AS TotalCount
FROM tblList
GROUP BY tblList.Quantity
HAVING COUNT(*) >=1
GO
PRINT 'Views Successfully Created..'
GO
SET NOCOUNT OFF



/*
SELECT * FROM tblAuditServiceTriggerTable
SELECT * FROM tblCode
SELECT * FROM tblCompany
SELECT * FROM tblContractor
SELECT * FROM tblCrew
SELECT * FROM tblCustomer
SELECT * FROM tblInvoice
SELECT * FROM tblList
SELECT * FROM tblService
SELECT * FROM vwInvoice
SELECT * FROM vwList
*/