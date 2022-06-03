/* Função que retorna o status atual de uma certa sala */
IF OBJECT_ID('funGetRoomCurrentStatus') IS NOT NULL
	DROP FUNCTION funGetRoomCurrentStatus
GO
CREATE FUNCTION funGetRoomCurrentStatus(@paramIdRoom int)
RETURNS varchar(50)
AS
BEGIN
	DECLARE @status varchar(50)
	
	SELECT @status = (
		SELECT
			CASE
				WHEN ID IN (
					SELECT Room FROM 
					Reservations
					WHERE GETDATE() BETWEEN StartDateTime AND EndDateTime
				) THEN 'OCCUPIED'
				WHEN ID IN (
					SELECT Room FROM 
					Reservations
					INNER JOIN Rooms ON Rooms.ID = Reservations.Room
					WHERE GETDATE() BETWEEN EndDateTime AND dateadd(MINUTE, CleaningTime, EndDateTime) 
				) THEN 'CLEANING'
				WHEN ID NOT IN (
					SELECT Room FROM 
					Reservations
					WHERE GETDATE() BETWEEN StartDateTime AND EndDateTime
				) THEN 'AVAILABLE'
				ELSE 'Error'
			END AS [Status]
		FROM
		Rooms
		WHERE ID = @paramIdRoom
	)
	
	RETURN @status
END
GO

/* Função que devolve o número de reservas por range de datas */
IF OBJECT_ID('funGetCountReservationsByDates') IS NOT NULL
	DROP FUNCTION funGetCountReservationsByDates
GO

CREATE FUNCTION funGetCountReservationsByDates(@StartDate DATE, @EndDate DATE)
RETURNS INT
AS
BEGIN
	DECLARE @NumberOfUsers INT
	
	SELECT @NumberOfUsers = (
		SELECT COUNT(Reservations.ID) AS [Number of Reservations] FROM
		Reservations
		INNER JOIN Rooms ON Rooms.ID = Reservations.Room
			WHERE
				@StartDate <= CAST(dateadd(MINUTE, CleaningTime, EndDateTime) AS DATE) AND
				@EndDate >= CAST(StartDateTime AS DATE)
	)
	
	RETURN @NumberOfUsers
END
GO

/* Procedimento armazenado que devolve todas as reservas de uma certa sala num certo dia */
IF OBJECT_ID('proReturnAllReservationsByRoomAndDate') IS NOT NULL
	DROP PROCEDURE proReturnAllReservationsByRoomAndDate
GO

CREATE PROC proReturnAllReservationsByRoomAndDate
	@RoomID INT = NULL,
	@GivenDate DATE = NULL
AS
BEGIN
	SELECT
		Reservations.ID,
		CAST(StartDateTime AS DATE) AS [Date],
		CAST(StartDateTime AS TIME(0)) AS [Start Time],
		CAST(EndDateTime AS TIME(0)) AS [End Time],
		Room,
		CAST(EndDateTime - StartDateTime AS TIME(0)) AS [Reservation Time],
		CAST(dateadd(MINUTE, CleaningTime, '00:00:00') AS TIME(0)) AS [Cleaning Time],
		dateadd(MINUTE, CleaningTime, CAST(EndDateTime - StartDateTime AS TIME(0))) AS [Total Time],
		dateadd(MINUTE, CleaningTime, CAST(EndDateTime AS TIME(0))) AS [Available After]
	FROM
	Reservations
	INNER JOIN Rooms ON Rooms.ID = Reservations.Room
	WHERE
		CAST(StartDateTime AS DATE) = @GivenDate AND
		Room = @RoomID;
END
GO


/* Procedimento armazenado que devolve todas as salas livres dado um GeoCenter e um range de horários */
IF OBJECT_ID('proGetAvailableRoomsByGeoCenterAndDates') IS NOT NULL
	DROP PROCEDURE proGetAvailableRoomsByGeoCenterAndDates
GO

CREATE PROC proGetAvailableRoomsByGeoCenterAndDates
	@GeoCenterID INT = NULL,
	@StartSchedule DATETIME = NULL,
	@EndSchedule DATETIME = NULL
AS
BEGIN
	SELECT * FROM
	Rooms
	WHERE ID NOT IN (
		SELECT Reservations.Room FROM
		Reservations
		INNER JOIN Rooms ON Rooms.ID = Reservations.Room
		WHERE
			@StartSchedule <= dateadd(MINUTE, CleaningTime, EndDateTime) AND
			@EndSchedule >= StartDateTime
	) AND
	GeoCenter = @GeoCenterID;
END
GO


/* Procedimento armazenado que devolve os dados atuais de todas as salas por GeoCenter, ou não */
IF OBJECT_ID('proGetRoomsActualData') IS NOT NULL
	DROP PROCEDURE proGetRoomsActualData
GO

CREATE PROC proGetRoomsActualData
	@GeoCenterID INT = NULL
AS
BEGIN
	SELECT
		Rooms.ID,
		Rooms.Name,
		[scdi21220].funGetRoomCurrentStatus(Rooms.ID) AS [Status],
		MaximumCapacity,
		Restrictions,
		GeoCenters.Name AS [GeoCenter Name],
		IIF(IsCleaned = 1, 'True', 'False') AS [IsCleaned],
		IIF(Rooms.IsActive = 1, 'True', 'False') AS [IsActive],
		Rooms.CreatedAt
	FROM
	Rooms
	INNER JOIN GeoCenters ON GeoCenters.ID = Rooms.GeoCenter
	WHERE
		(@GeoCenterID IS NULL) OR
		(Rooms.GeoCenter = @GeoCenterID)
	ORDER BY GeoCenters.Name ASC
END
GO


/* Quando uma reserva é inserida é verificado se as datas são válidas */
IF OBJECT_ID('trReservationDateCheck') IS NOT NULL
	DROP TRIGGER trReservationDateCheck
GO
CREATE TRIGGER trReservationDateCheck
ON Reservations
	FOR INSERT
AS
BEGIN
	IF (SELECT inserted.StartDateTime FROM inserted) >= (SELECT inserted.EndDateTime FROM inserted)
	BEGIN
		DELETE FROM Reservations
		WHERE Reservations.ID = (SELECT inserted.ID FROM inserted)

		PRINT 'A data de início não pode ser inferior ou igual à data de fim!'
	END
END
GO



/* Processo armazenado que contém um cursor que desativa todas 
	as salas de um certo GeoCenter */
IF OBJECT_ID('proDeactivatesAllRoomsFromGeoCenter') IS NOT NULL
	DROP PROCEDURE proDeactivatesAllRoomsFromGeoCenter
GO

CREATE PROC proDeactivatesAllRoomsFromGeoCenter
	@GeoCenterID INT = NULL
AS
BEGIN
	IF  @GeoCenterID = NULL
		BEGIN
			PRINT 'É necessário mencionar um @GeoCenterID'
		END
	ELSE
		BEGIN
			DECLARE @RoomID INT
	
			DECLARE curGeoCenterDeactivation CURSOR
			FOR
				SELECT Rooms.ID
				FROM Rooms
				WHERE Rooms.GeoCenter = @GeoCenterID
			
			OPEN curGeoCenterDeactivation
				FETCH NEXT FROM curGeoCenterDeactivation
				INTO @RoomID
		
				WHILE @@FETCH_STATUS = 0
				BEGIN
					UPDATE Rooms
					SET IsActive = 0
					WHERE Rooms.ID = @RoomID
			
					FETCH NEXT FROM curGeoCenterDeactivation
					INTO @RoomID
				END
			CLOSE curGeoCenterDeactivation
			DEALLOCATE curGeoCenterDeactivation
		END
END
GO


/* Quando um GeoCenter é desativado todas as salas do mesmo seram desativadas em seguida */
IF OBJECT_ID('trGeoCenterDeactivationCheck') IS NOT NULL
	DROP TRIGGER trGeoCenterDeactivationCheck
GO
CREATE TRIGGER trGeoCenterDeactivationCheck
ON GeoCenters
	FOR UPDATE
AS
BEGIN
	DECLARE @isertedID INT = (SELECT inserted.ID FROM inserted);
	IF (SELECT inserted.isActive FROM inserted) = 0
	BEGIN
		EXEC proDeactivatesAllRoomsFromGeoCenter @GeoCenterID = @isertedID
	END
END
GO