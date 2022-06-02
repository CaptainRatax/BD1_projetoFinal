/*==================================================================================================*/
/*                                           DROP TABLES                                            */
/*==================================================================================================*/
IF OBJECT_ID('Reservation_Groups','U') IS NOT NULL
DROP TABLE Reservation_Groups;

IF OBJECT_ID('Reservations','U') IS NOT NULL
DROP TABLE Reservations;

IF OBJECT_ID('Users_GeoCenters','U') IS NOT NULL
DROP TABLE Users_GeoCenters;

IF OBJECT_ID('Rooms','U') IS NOT NULL
DROP TABLE Rooms;

IF OBJECT_ID('Users','U') IS NOT NULL
DROP TABLE Users;

IF OBJECT_ID('Roles','U') IS NOT NULL
DROP TABLE Roles;

IF OBJECT_ID('GeoCenters','U') IS NOT NULL
DROP TABLE GeoCenters;

IF OBJECT_ID('Logs','U') IS NOT NULL
DROP TABLE Logs;

IF OBJECT_ID('LogTypes','U') IS NOT NULL
DROP TABLE LogTypes;

/*==================================================================================================*/
/*                                         CREATE TABLES                                            */
/*==================================================================================================*/

CREATE TABLE LogTypes(
    ID  int IDENTITY(1,1)   CONSTRAINT PK_LogTypes PRIMARY KEY,
    Name varchar(50) NOT NULL
);

CREATE TABLE Logs(
    ID  int IDENTITY(1,1)   CONSTRAINT PK_Logs PRIMARY KEY,
    LogDescription varchar(2000),
    LogDate datetime NOT NULL DEFAULT GETDATE(),
    LogType int NOT NULL,
    CONSTRAINT FK_Logs_LogTypes FOREIGN KEY (LogType) REFERENCES LogTypes(ID)
);

CREATE TABLE GeoCenters (
    ID  int  IDENTITY(1,1)  CONSTRAINT PK_GeoCenters PRIMARY KEY,
    Name varchar(50)  NOT NULL,
    Location varchar(50)  NOT NULL,
    IsActive bit  NOT NULL  DEFAULT 1,
    CreatedAt datetime  NOT NULL    DEFAULT GETDATE()
);

CREATE TABLE Roles (
    ID int  IDENTITY(1,1)   CONSTRAINT PK_Roles PRIMARY KEY,
    Code int NOT NULL,
    Name varchar(50),
    ReserveRooms bit  NOT NULL   DEFAULT 1,
    CreateRooms bit  NOT NULL  DEFAULT 0,
    EditRooms bit  NOT NULL  DEFAULT 0,
    CreateGeoCenters bit  NOT NULL  DEFAULT 0,
    EditGeoCenters bit  NOT NULL  DEFAULT 0,
    CreateUsers bit  NOT NULL  DEFAULT 0,
    EditUsers bit  NOT NULL  DEFAULT 0,
    IsActive bit  NOT NULL  DEFAULT 1,
    CreatedAt datetime  NOT NULL    DEFAULT GETDATE()
);

CREATE TABLE Users (
    ID int  IDENTITY(1,1)   CONSTRAINT PK_Users PRIMARY KEY,
    NIF varchar(9)  NOT NULL,
    Name varchar(50)  NOT NULL,
    Email varchar(50),
    PhoneN varchar(25),
    Password varchar(128)  NOT NULL,
    IsFirstLogin bit  NOT NULL  DEFAULT 1,
    RoleID int  NOT NULL,
    IsActive bit  NOT NULL  DEFAULT 1,
    CreatedAt datetime  NOT NULL    DEFAULT GETDATE(),
    CONSTRAINT FK_Users_Roles FOREIGN KEY (RoleID) REFERENCES Roles(ID)
);

CREATE TABLE Rooms (
    ID int  IDENTITY(1,1)   CONSTRAINT PK_Rooms PRIMARY KEY,
    Name varchar(50)  NOT NULL,
    MaximumCapacity int  NOT NULL,
    Restrictions int  NOT NULL,
    GeoCenter int  NOT NULL,
    IsCleaned bit  NOT NULL,
    CleaningTime int,
    IsActive bit  NOT NULL  DEFAULT 1,
    CreatedAt datetime  NOT NULL    DEFAULT GETDATE(),
    CONSTRAINT FK_Rooms_GeoCenters FOREIGN KEY (GeoCenter) REFERENCES GeoCenters(ID)
);

CREATE TABLE Users_GeoCenters (
    ID int  IDENTITY(1,1)   CONSTRAINT PK_Users_GeoCenters PRIMARY KEY,
    UserID int  NOT NULL,
    GeoCenterID int  NOT NULL,
    CONSTRAINT FK_GeoCenters_Users FOREIGN KEY (GeoCenterID) REFERENCES GeoCenters(ID),
    CONSTRAINT FK_Users_GeoCenters FOREIGN KEY (UserID) REFERENCES Users(ID)
);

CREATE TABLE Reservations (
    ID int  IDENTITY(1,1)   CONSTRAINT PK_Reserves PRIMARY KEY,
    StartDateTime datetime  NOT NULL,
    EndDateTime datetime  NOT NULL,
    Responsible int  NOT NULL,
    Room int  NOT NULL,
    IsActive bit  NOT NULL  DEFAULT 1,
    CreatedAt datetime  NOT NULL    DEFAULT GETDATE(),
    CONSTRAINT FK_Reservations_Rooms FOREIGN KEY (Room) REFERENCES Rooms(ID),
    CONSTRAINT FK_Reservations_Users FOREIGN KEY (Responsible) REFERENCES Users(ID)
);

CREATE TABLE Reservation_Groups (
    ID int  IDENTITY(1,1)   CONSTRAINT PK_Reservation_Groups PRIMARY KEY,
    ReservationID int  NOT NULL,
    UserID int  NOT NULL,
    CONSTRAINT FK_Groups_Reservations FOREIGN KEY (ReservationID) REFERENCES Reservations(ID),
    CONSTRAINT FK_Groups_Users FOREIGN KEY (UserID) REFERENCES Users(ID)
);