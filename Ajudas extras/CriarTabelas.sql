IF OBJECT_ID('tblPlaceReport','U') IS NOT NULL
	DROP TABLE tblPlaceReport

IF OBJECT_ID('tblWarning','U') IS NOT NULL
	DROP TABLE tblWarning

IF OBJECT_ID('tblPlace','U') IS NOT NULL
	DROP TABLE tblPlace

IF OBJECT_ID('tblGroup','U') IS NOT NULL
	DROP TABLE tblGroup

IF OBJECT_ID('tblUser','U') IS NOT NULL
	DROP TABLE tblUser

CREATE TABLE tblUser(
	[IdUser] [int] IDENTITY(1,1) PRIMARY KEY NOT NULL,
	[Name] [varchar](100) NOT NULL,
	[Email] [varchar](150) NOT NULL,
	[Password] [varchar](100) NOT NULL,
	[CreatedIn] [datetime] NOT NULL,
)
GO

CREATE TABLE tblGroup
(
	[IdGroup] [int] IDENTITY(1,1) PRIMARY KEY NOT NULL,
	[Name] [varchar](100) NOT NULL,
	[CreatedIn] [datetime] NOT NULL
)
GO

CREATE TABLE tblPlace
(
	[IdPlace] [int] IDENTITY(1,1) PRIMARY KEY NOT NULL,
	[IdGroup] [int] NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	CONSTRAINT FK_PlaceGroup FOREIGN KEY ([IdGroup]) REFERENCES tblGroup ([IdGroup]),
	CONSTRAINT FK_PlaceUser FOREIGN KEY ([CreatedBy]) REFERENCES tblUser ([IdUser])
)
GO

CREATE TABLE tblPlaceReport
(
	[IdPlaceReport] [int] IDENTITY(1,1) PRIMARY KEY NOT NULL,
	[IdPlace] [int] NOT NULL,
	[Level] [int] NOT NULL,
	[CreatedIn] [datetime] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	CONSTRAINT FK_PlaceReportPlace FOREIGN KEY ([IdPlace]) REFERENCES tblPlace ([IdPlace]) ON DELETE CASCADE,
	CONSTRAINT FK_PlaceReportUser FOREIGN KEY ([CreatedBy])	REFERENCES tblUser ([IdUser]) ON DELETE CASCADE
)
GO

CREATE TABLE tblWarning
(
	[IdWarning] [int] IDENTITY(1,1) PRIMARY KEY NOT NULL,
	[IdPlace] [int] NOT NULL,
	[Description] [varchar](100) NOT NULL,
	[CreatedIn] [datetime] NOT NULL,
	CONSTRAINT FK_WarningPlace FOREIGN KEY ([IdPlace]) REFERENCES tblPlace ([IdPlace]) ON DELETE CASCADE,
)