
/* Get Todas as reservas de uma certa sala num certo dia */
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
	CAST(StartDateTime AS DATE) = '2022-04-29' AND
	Room = 3;


/* Get todas as salas livres entre dois horários de um geocenter específico */
SELECT * FROM
Rooms
WHERE ID NOT IN (
	SELECT Reservations.Room FROM
	Reservations
	INNER JOIN Rooms ON Rooms.ID = Reservations.Room
	WHERE
		'2022-04-29 19:00:00' <= dateadd(MINUTE, CleaningTime, EndDateTime) AND
		'2022-04-29 20:00:00' >= StartDateTime
) AND
GeoCenter = 3;


/* Get status de uma sala consoante o horário atual atual */

SELECT 
	ID,
	Name,
	CASE
		WHEN ID IN (
			SELECT Room FROM 
			Reservations
			WHERE GETDATE() BETWEEN StartDateTime AND EndDateTime
		) THEN 'Reserva em curso'
		WHEN ID IN (
			SELECT Room FROM 
			Reservations
			INNER JOIN Rooms ON Rooms.ID = Reservations.Room
			WHERE GETDATE() BETWEEN EndDateTime AND dateadd(MINUTE, CleaningTime, EndDateTime) 
		) THEN 'Limpeza em curso'
		WHEN ID NOT IN (
			SELECT Room FROM 
			Reservations
			WHERE GETDATE() BETWEEN StartDateTime AND EndDateTime
		) THEN 'Sala Livre'
		ELSE 'Error'
	END AS [Status]
FROM
Rooms
WHERE ID = 3;


/* Nº de reservas por range de datas */

SELECT COUNT(Reservations.ID) AS 'Number of Reservations' FROM
Reservations
INNER JOIN Rooms ON Rooms.ID = Reservations.Room
	WHERE
		'2022-04-29' <= CAST(dateadd(MINUTE, CleaningTime, EndDateTime) AS DATE) AND
		'2022-09-06' >= CAST(StartDateTime AS DATE)


/* Nº de utilizadores registados */

SELECT COUNT(ID) AS [Number of Users] FROM
Users;


/*  */