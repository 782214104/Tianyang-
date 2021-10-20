--SkiResort Database
--Phase 1 Written By Tianyang Yang
-- Date: 04/26/2021

--changed by Tianyang Yang
-- Date: 05/16/2021

IF NOT EXISTS(SELECT * FROM sys.databases
	WHERE NAME = N'SkiResort')
	CREATE DATABASE SkiResort
GO
Use SkiResort
--
--Alter the path
--
DECLARE
	@data_path NVARCHAR(256);
SELECT @data_path = 'C:\Phase3\';
-- 
-- Delete existing tables
--
-- 
--
IF EXISTS(
	Select *
	From sys.tables
	WHERE NAME = N'Enrollment'
	    )
	DROP TABLE Enrollment;
--
IF EXISTS(
	Select *
	From sys.tables
	WHERE NAME = N'Class'
		)
	DROP TABLE Class;
--
IF EXISTS(
	Select *
	From sys.Tables
	WHERE NAME = N'ClassLevel'
	    )
	DROP TABLE ClassLevel;
--
IF EXISTS(
	Select *
	From sys.Tables
	WHERE NAME = N'Instructor'
		)
	DROP TABLE Instructor;
--
IF EXISTS(
	Select *
	From sys.tables
	WHERE NAME = N'Resort'
		)
	DROP TABLE Resort;
--
IF EXISTS(
	Select *
	From sys.Tables
	WHERE NAME = N'Student'
		)
	DROP TABLE Student;
--
IF EXISTS(
	Select *
	From sys.Tables
	WHERE NAME = N'Gender'
		)
	DROP TABLE Gender;
--
--Create Tables
--

CREATE TABLE Instructor (
  InstructorID int CONSTRAINT pk_Intructor_id Primary Key,
  FirstName nvarchar(15) CONSTRAINT nn_instructor_first_name NOT NULL,
  LastName nvarchar(30) CONSTRAINT nn_instructor_last_name NOT NULL 
);

--
CREATE TABLE Resort (
  ResortID int CONSTRAINT pk_resort Primary Key,
  ResortName nvarchar(50) CONSTRAINT nn_resort_name NOT NULL,
  ZipCode nvarchar(11) CONSTRAINT nn_resort_zip_code NOT NULL 
);

--
CREATE TABLE Gender (
  GenderID int CONSTRAINT pk_gender Primary Key,
  Gender nchar(1) CONSTRAINT nn_gender_name NOT NULL 
);

--
CREATE TABLE ClassLevel (
  LevelID int CONSTRAINT pk_level_id Primary Key,
  Description nvarchar(500) CONSTRAINT nn_class_level_description NOT NULL
);
--
CREATE TABLE Class (
  ClassID int CONSTRAINT pk_class_id Primary Key,
  ClassName nvarchar(40) CONSTRAINT nn_class_name NOT NULL,
  LevelID INT CONSTRAINT fk_level_id Foreign Key(LevelID) References ClassLevel(LevelID),
  InstructorID INT CONSTRAINT fk_class_instructor_id Foreign Key(InstructorID) References Instructor(InstructorID),
  Price money  NOT NULL,
  ResortID int CONSTRAINT fk_class_resort_id Foreign Key(ResortID) References Resort(ResortID),
);

--
CREATE TABLE Student (
  StudentID int CONSTRAINT pk_student_id Primary Key,
  FirstName nvarchar(15) CONSTRAINT nn_student_first_name NOT NULL,
  LastName nvarchar(30) CONSTRAINT nn_student_last_name NOT NULL,
  DateOfBirth nvarchar(30),
  PhoneNumber nvarchar(14),
  AddressState nvarchar(2) CONSTRAINT nn_student_state NOT NULL,
  AddressCity nvarchar(50) CONSTRAINT nn_student_city NOT NULL,
  Gender INT  CONSTRAINT fk_student_gender_id Foreign Key(Gender) References Gender(GenderID),
  Zipcode nvarchar(11) CONSTRAINT nn_student_zip_code NOT NULL
);

--
CREATE TABLE Enrollment (
  EnrollmentDate DATE CONSTRAINT nn_enrollment_date NOT NULL,
  ClassID int CONSTRAINT fk_class_id_2 Foreign Key(ClassID) References Class(ClassID),
  StudentID int CONSTRAINT fk_student_id Foreign Key(StudentID) References Student(StudentID)
);
--

--Load Table Data
--
--
EXECUTE (N'BULK INSERT Instructor FROM ''' + @data_path + N'Instructor.csv''
WITH (
	CHECK_CONSTRAINTS,
	CODEPAGE=''RAW'',
	DATAFILETYPE = ''char'',
	FIELDTERMINATOR= '','',
	ROWTERMINATOR = ''\n'',
	KEEPIDENTITY,
	TABLOCK
	);
');
--
EXECUTE (N'BULK INSERT Resort FROM ''' + @data_path + N'Resort.csv''
WITH (
	CHECK_CONSTRAINTS,
	CODEPAGE=''RAW'',
	DATAFILETYPE = ''char'',
	FIELDTERMINATOR= '','',
	ROWTERMINATOR = ''\n'',
	KEEPIDENTITY,
	TABLOCK
	);
');
--
EXECUTE (N'BULK INSERT Gender FROM ''' + @data_path + N'Gender.csv''
WITH (
	CHECK_CONSTRAINTS,
	CODEPAGE=''RAW'',
	DATAFILETYPE = ''char'',
	FIELDTERMINATOR= '','',
	ROWTERMINATOR = ''\n'',
	KEEPIDENTITY,
	TABLOCK
	);
');
--
EXECUTE (N'BULK INSERT Student FROM ''' + @data_path + N'Student.csv''
WITH (
	CHECK_CONSTRAINTS,
	CODEPAGE=''RAW'',
	DATAFILETYPE = ''char'',
	FIELDTERMINATOR= '','',
	ROWTERMINATOR = ''\n'',
	KEEPIDENTITY,
	TABLOCK
	);
');
--
EXECUTE (N'BULK INSERT Classlevel FROM ''' + @data_path + N'Classlevel.csv''
WITH (
	CHECK_CONSTRAINTS,
	CODEPAGE=''RAW'',
	DATAFILETYPE = ''char'',
	FIELDTERMINATOR= '','',
	ROWTERMINATOR = ''\n'',
	KEEPIDENTITY,
	TABLOCK
	);
');
EXECUTE (N'BULK INSERT Class FROM ''' + @data_path + N'Class.csv''
WITH (
	CHECK_CONSTRAINTS,
	CODEPAGE=''RAW'',
	DATAFILETYPE = ''char'',
	FIELDTERMINATOR= '','',
	ROWTERMINATOR = ''\n'',
	KEEPIDENTITY,
	TABLOCK
	);
');
-- 
EXECUTE (N'BULK INSERT Enrollment FROM ''' + @data_path + N'Enrollment.csv''
WITH (
	CHECK_CONSTRAINTS,
	CODEPAGE=''RAW'',
	DATAFILETYPE = ''char'',
	FIELDTERMINATOR= '','',
	ROWTERMINATOR = ''\n'',
	KEEPIDENTITY,
	TABLOCK
	);
');
-- 
--
-- List table names and row counts for confirmation
--
SET NOCOUNT ON
SELECT 'Student' AS "Table",	COUNT(*) AS "Rows"	FROM Student			    UNION
SELECT 'Class',				    COUNT(*)			FROM Class				    UNION
SELECT 'Gender',	    COUNT(*)			FROM Gender	    UNION
SELECT 'ClassLevel',			COUNT(*)			FROM ClassLevel			    UNION
SELECT 'Enrollment',	        COUNT(*)			FROM Enrollment         	UNION
SELECT 'Instructor',		    COUNT(*)			FROM Instructor				UNION 
SELECT 'Resort',				COUNT(*)			FROM Resort				                
ORDER BY 1;
SET NOCOUNT OFF
GO
