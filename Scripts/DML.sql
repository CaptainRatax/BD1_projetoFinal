/*==================================================================================================*/
/*                                       INSERÇÃO DE DADOS                                          */
/*==================================================================================================*/

/*--------Tabela Centros--------*/
INSERT INTO GeoCenters (Name, Location)
VALUES 
('Viseu', 'Viseu'),
('Lisboa Norte', 'Lisboa'),
('Lisboa Sul', 'Lisboa'),
('Porto Norte', 'Porto'),
('Porto Sul', 'Porto'),
('Coimbra', 'Coimbra');

SELECT * FROM GeoCenters;

/*-------- Tabela Roles --------*/
INSERT INTO Roles (
	Code,
	Name,
	ReserveRooms,
	CreateRooms,
	EditRooms,
	CreateGeoCenters,
	EditGeoCenters,
	CreateUsers,
	EditUsers
) VALUES
(0, 'Administrador', 1, 1, 1, 1, 1, 1, 1),
(1, 'Utilizador Básico', 1, 0, 0, 0, 0, 0, 0),
(2, 'Gestor de Utilizadores', 1, 0, 0, 0, 0, 1, 1),
(3, 'Gestor de Salas e Centros', 1, 1, 1, 1, 1, 0, 0);

SELECT * FROM Roles;

/*-------- Tabela Users --------*/
INSERT INTO Users (
	NIF,
	Name,
	Email,
	PhoneN,
	Password,
	RoleID
) VALUES
('123456789', 'Adolfo Dias', 'adolfo.dias@gmail.com', '+351963849504', 'd48df65995b1a57b141deeb5ba0b6b570a1df6931368e733c474d6f7d97de8caabcac9e7327eaad3a4bc1269fdd630d56d353de3a784d760ece738c7b6c0e49b', 1),
('829303928', 'Amilcar Alho', 'amilcar._.alho@gmail.com', '+351919282928', 'd48df65995b1a57b141deeb5ba0b6b570a1df6931368e733c474d6f7d97de8caabcac9e7327eaad3a4bc1269fdd630d56d353de3a784d760ece738c7b6c0e49b', 2),
('109829382', 'Mike Hawk', 'mikehawk@gmail.com', '+12163547758', 'd48df65995b1a57b141deeb5ba0b6b570a1df6931368e733c474d6f7d97de8caabcac9e7327eaad3a4bc1269fdd630d56d353de3a784d760ece738c7b6c0e49b', 2),
('092837283', 'Sokaga Nakama', 'sokaganakama@gmail.com', '+810291029303', 'd48df65995b1a57b141deeb5ba0b6b570a1df6931368e733c474d6f7d97de8caabcac9e7327eaad3a4bc1269fdd630d56d353de3a784d760ece738c7b6c0e49b', 3),
('110920923', 'Jacinto Pinto Aquino Rego', 'jacintopinto@gmail.com', '+351920392039', 'd48df65995b1a57b141deeb5ba0b6b570a1df6931368e733c474d6f7d97de8caabcac9e7327eaad3a4bc1269fdd630d56d353de3a784d760ece738c7b6c0e49b', 4);

SELECT
	Users.Id,
	Users.NIF,
	Users.Name,
	Users.Email,
	Users.PhoneN,
	Users.Password,
	Roles.Name AS [Role],
	Users.IsFirstLogin,
	Users.IsActive,
	Users.CreatedAt
FROM Users
INNER JOIN Roles ON Roles.ID = Users.RoleID;

/*-------- Tabela Rooms --------*/
INSERT INTO Rooms (
	Name,
	MaximumCapacity,
	Restrictions,
	GeoCenter,
	IsCleaned,
	CleaningTime
) VALUES
('Sala Trabalho Principal', 50, 50, 1, 1, 10),
('Sala Reuniões Principal', 20, 70, 2, 1, 5),
('Auditório Principal', 150, 50, 3, 1, 30),
('Sala Reuniões Auxiliar', 10, 75, 4, 1, 5),
('Sala Trabalho 1', 40, 50, 5, 1, 15),
('Sala Apresentações Principal', 80, 50, 6, 1, 30),
('Sala Reuniões Principal', 20, 50, 1, 1, 10),
('Sala Trabalho Principal', 50, 50, 2, 0, 20),
('Sala Reuniões', 20, 60, 3, 1, 15),
('Sala Trabalho', 40, 50, 4, 1, 30),
('Sala Reuniões Principal', 20, 70, 5, 1, 10),
('Sala Trabalho Principal', 50, 50, 6, 1, 25),
('Sala Apresentações Principal', 100, 40, 1, 1, 45),
('Sala Reuniões Auxiliar', 10, 80, 1, 1, 10);

SELECT
	Rooms.ID,
	Rooms.Name,
	Rooms.MaximumCapacity,
	Rooms.Restrictions,
	GeoCenters.Name AS [GeoCenter],
	Rooms.IsCleaned,
	Rooms.CleaningTime,
	Rooms.IsActive,
	Rooms.CreatedAt
FROM Rooms
INNER JOIN GeoCenters ON GeoCenters.ID = Rooms.GeoCenter;

/*-------- Tabela Users_GeoCenters --------*/

INSERT INTO Users_GeoCenters (
	UserID,
	GeoCenterID
) VALUES
(1, 1),
(2, 3),
(3, 6),
(4, 5),
(5, 1),
(1, 2),
(1, 5),
(1, 6),
(2, 2),
(3, 1),
(4, 4);

SELECT
	Users_GeoCenters.ID,
	Users.Name AS [User],
	GeoCenters.Name AS [GeoCenter] 
FROM Users_GeoCenters
INNER JOIN Users ON Users.ID = Users_GeoCenters.UserID
INNER JOIN GeoCenters ON GeoCenters.ID = Users_GeoCenters.GeoCenterID;

/*-------- Tabela Reservations --------*/

INSERT INTO Reservations (
	StartDateTime,
	EndDateTime,
	Responsible,
	Room
) VALUES
('2022-05-13 17:00:00', '2022-05-13 18:30:00', 2, 2),
('2022-04-29 14:00:00', '2022-04-29 16:00:00', 3, 3),
('2022-04-29 17:15:00', '2022-04-29 18:00:00', 3, 3),
('2022-04-29 14:00:00', '2022-04-29 16:00:00', 4, 14);

SELECT 
	Reservations.ID,
	StartDateTime,
	EndDateTime,
	Users.Name AS [Responsible],
	Rooms.Name AS [Room],
	GeoCenters.Name AS [GeoCenter of Room],
	Reservations.IsActive,
	Reservations.CreatedAt
FROM Reservations
INNER JOIN Users ON Users.ID = Reservations.Responsible
INNER JOIN Rooms ON Rooms.ID = Reservations.Room
INNER JOIN GeoCenters ON GeoCenters.ID = Rooms.GeoCenter;

/*-------- Tabela Reservation_Groups --------*/

INSERT INTO Reservation_Groups
(
	ReservationID,
	UserID
) VALUES 
(1, 5),
(2, 1),
(2, 2),
(2, 4),
(2, 5);

SELECT 
	Reservation_Groups.ID,
	ReservationID,
	Users2.Name AS [Responsible for Reservation],
	Users.Name AS [Group Element],
	Rooms.Name AS [Room],
	GeoCenters.Name AS [GeoCenter of Room]
FROM Reservation_Groups
INNER JOIN Reservations ON Reservations.ID = Reservation_Groups.ReservationID
INNER JOIN Users ON Users.ID = Reservation_Groups.UserID
INNER JOIN Users AS Users2 ON Users2.ID = Reservations.Responsible
INNER JOIN Rooms On Reservations.Room = Rooms.ID
INNER JOIN GeoCenters ON GeoCenters.ID = Rooms.GeoCenter

/*-------- Tabela LogTypes --------*/

INSERT INTO LogTypes
(
	Name
) VALUES
	('Email'),
	('App Notification'),
	('GeoCenter Created'),
	('GeoCenter Edited'),
	('GeoCenter Deleted'),
	('Role Created'),
	('Role Edited'),
	('Role Deleted'),
	('User Created'),
	('User Edited'),
	('User Deleted'),
	('Room Created'),
	('Room Edited'),
	('Room Deleted'),
	('Users_GeoCenters Created'),
	('Users_GeoCenters Edited'),
	('Users_GeoCenters Deleted'),
	('Reservation Created'),
	('Reservation Edited'),
	('Reservation Deleted'),
	('Reservation_Groups Created'),
	('Reservation_Groups Edited'),
	('Reservation_Groups Deleted');

SELECT * FROM LogTypes;

/*-------- Tabela Logs --------*/
INSERT INTO Logs
(
	LogDescription,
	LogType
) VALUES
('GeoCenter "Viseu" created by "Adolfo Dias"', 3),
('Role "Gestor de Utilizadores" modified by "Adolfo Dias"', 7),
('User "Sokaga Nakama" created by "Adolfo Dias"', 9);

SELECT
	Logs.ID,
	LogDescription,
	LogDate,
	Name AS [LogType]
FROM Logs
INNER JOIN LogTypes ON LogTypes.ID = Logs.LogType