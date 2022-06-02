--Função que devolve o nome de um espaço
IF OBJECT_ID('fnBuscarNomeEspaco') IS NOT NULL
	DROP FUNCTION fnBuscarNomeEspaco
GO
CREATE FUNCTION fnBuscarNomeEspaco(@paramIdEspaco int)
RETURNS varchar(50)
AS
BEGIN
	DECLARE @nomeEspaco varchar(50)

	SELECT @nomeEspaco = (SELECT tblPlace.Name FROM tblPlace
	INNER JOIN tblGroup ON
	tblPlace.IdGroup = tblGroup.IdGroup
	INNER JOIN tblUser ON
	tblPlace.CreatedBy = tblUser.IdUser
	WHERE tblGroup.IdGroup = 1 AND tblPlace.IdPlace = @paramIdEspaco)

	RETURN @nomeEspaco
END
GO

--Função que devolve a média de reports de um espaço, dos últimos 10min.
IF OBJECT_ID('fnDevolverMediaReports') IS NOT NULL
	DROP FUNCTION fnDevolverMediaReports
GO
CREATE FUNCTION fnDevolverMediaReports(@paramIdEspaco int)
RETURNS float
AS
BEGIN
	DECLARE @media float

	SELECT @media = (SELECT AVG(Cast(tblPlaceReport.Level as float))
	FROM tblPlaceReport
	WHERE tblPlaceReport.IdPlace = @paramIdEspaco
	AND tblPlaceReport.CreatedIn BETWEEN DATEADD(MINUTE, -10, GETDATE()) AND GETDATE())

	RETURN @media
END
GO

--Procedimento armazenado para listar os espaços de um grupo e o nível de concentração baseado nos reports dos últimos 10min.
IF OBJECT_ID('spListarEspacos') IS NOT NULL
	DROP PROC spListarEspacos
GO
CREATE PROC spListarEspacos
	@PlaceName varchar(50) = NULL
AS
BEGIN
	SELECT tblPlace.IdPlace AS [ID], tblGroup.Name AS [Grupo],
	tblPlace.Name AS [Espaço], tblUser.Name AS [Criado por],
	CASE
		WHEN scdi94.fnDevolverMediaReports(tblPlace.IdPlace) IS NULL THEN 'Não há reports'
		WHEN scdi94.fnDevolverMediaReports(tblPlace.IdPlace) = 1 THEN 'Baixo'
		WHEN scdi94.fnDevolverMediaReports(tblPlace.IdPlace) > 1 AND scdi94.fnDevolverMediaReports(tblPlace.IdPlace) < 2 THEN 'Baixo-Médio'
		WHEN scdi94.fnDevolverMediaReports(tblPlace.IdPlace) = 2 THEN 'Médio'
		WHEN scdi94.fnDevolverMediaReports(tblPlace.IdPlace) > 2 AND scdi94.fnDevolverMediaReports(tblPlace.IdPlace) < 3 THEN 'Médio-Alto'
		ELSE 'Alto'
	END AS  [Nível]
	FROM tblPlace
	INNER JOIN tblGroup ON
	tblPlace.IdGroup = tblGroup.IdGroup
	INNER JOIN tblUser ON
	tblPlace.CreatedBy = tblUser.IdUser
	WHERE tblGroup.IdGroup = 1 AND tblPlace.Name LIKE '%' + @PlaceName + '%'
	GROUP BY tblPlace.IdPlace, tblGroup.Name, tblPlace.Name, tblUser.Name
END
GO

--Procedimento armazenado para adicionar um espaço
IF OBJECT_ID('spAdicionarEspaco') IS NOT NULL
	DROP PROC spAdicionarEspaco
GO
CREATE PROC spAdicionarEspaco
	@paramNomeEspaco varchar(50)
AS
BEGIN
	INSERT INTO tblPlace (IdGroup, Name, CreatedBy)
	VALUES (1, @paramNomeEspaco, 1)
END
GO

--Procedimento armazenado para editar um espaço
--Vai fazer disparar o trigger 'trUpdatePlace'
IF OBJECT_ID('spEditarEspaco') IS NOT NULL
	DROP PROC spEditarEspaco
GO
CREATE PROC spEditarEspaco
	@paramIdEspaco int,
	@paramNomeEspaco varchar(50)
AS
BEGIN
	UPDATE tblPlace
	SET Name = @paramNomeEspaco
	WHERE IdPlace = @paramIdEspaco
END
GO

--Procedimento armazenado para remover um espaço
IF OBJECT_ID('spRemoverEspaco') IS NOT NULL
	DROP PROC spRemoverEspaco
GO
CREATE PROC spRemoverEspaco
	@paramIdEspaco int
AS
BEGIN
	DELETE FROM tblPlace
	WHERE IdPlace = @paramIdEspaco
END
GO

--Procedimento armazenado para listar os dez últimos reports de um espaço
IF OBJECT_ID('spListarDezUltReports') IS NOT NULL
	DROP PROC spListarDezUltReports
GO
CREATE PROC spListarDezUltReports
	@paramIdEspaco int
AS
BEGIN
	SELECT TOP 10 tblPlaceReport.IdPlaceReport AS [ID],
	CASE
		WHEN tblPlaceReport.Level = 1 THEN 'Baixo'
		WHEN tblPlaceReport.Level = 2 THEN 'Médio'
		ELSE 'Alto'
	END AS  [Nível],
	tblUser.Name AS [Criado por],
	tblPlaceReport.CreatedIn AS [Data&Hora]
	FROM tblPlaceReport
	INNER JOIN tblUser ON
	tblPlaceReport.CreatedBy = tblUser.IdUser
	WHERE tblPlaceReport.IdPlace = @paramIdEspaco
	GROUP BY tblPlaceReport.IdPlaceReport, tblPlaceReport.Level, tblUser.Name, tblPlaceReport.CreatedIn, tblPlaceReport.IdPlace	
	ORDER BY [Data&Hora] DESC
END
GO

--Procedimento armazenado para listar os reports de um espaço, entre duas datas
IF OBJECT_ID('spListarReportsEntreDatas') IS NOT NULL
	DROP PROC spListarReportsEntreDatas
GO
CREATE PROC spListarReportsEntreDatas
	@paramIdEspaco int,
	@paramDataInicio DateTime,
	@paramDataFim DateTime
AS
BEGIN
	SELECT tblPlaceReport.IdPlaceReport AS [ID],
	CASE
		WHEN tblPlaceReport.Level = 1 THEN 'Baixo'
		WHEN tblPlaceReport.Level = 2 THEN 'Médio'
		ELSE 'Alto'
	END AS  [Nível],
	tblUser.Name AS [Criado por], tblPlaceReport.CreatedIn AS [Data&Hora]
	FROM tblPlaceReport
	INNER JOIN tblUser ON
	tblPlaceReport.CreatedBy = tblUser.IdUser
	GROUP BY tblPlaceReport.IdPlaceReport, tblPlaceReport.Level, tblUser.Name, tblPlaceReport.CreatedIn, tblPlaceReport.IdPlace
	HAVING tblPlaceReport.CreatedIn BETWEEN @paramDataInicio AND @paramDataFim AND tblPlaceReport.IdPlace = @paramIdEspaco
	ORDER BY [Data&Hora] ASC
END
GO

--Procedimento armazenado para inserir report de nível alto para teste
--Vai fazer disparar o trigger 'trInsertReport'
IF OBJECT_ID('spInserirReportParaTeste') IS NOT NULL
	DROP PROC spInserirReportParaTeste
GO
CREATE PROC spInserirReportParaTeste
AS
BEGIN
	INSERT INTO tblPlaceReport (IdPlace, Level, CreatedIn, CreatedBy)
	VALUES (
		2, /*Espaço com o ID=2*/
		3, /*Nível 3*/
		GETDATE(), /*Data atual*/
		(SELECT TOP 1 idUser FROM tblUser ORDER BY NEWID()) /*Selecionar registo random da tabela 'tblUser'*/
	)
END
GO

--Procedimento armazenado para as várias consultas
IF OBJECT_ID('spConsultas') IS NOT NULL
	DROP PROC spConsultas
GO
CREATE PROC spConsultas
	@paramIdConsulta int
AS
BEGIN
	DECLARE @cnt INT = 0;
	--Nº de reports de cada utilizador, mesmo que não tenha feito nenhum
	IF @paramIdConsulta = 1
	BEGIN
		SELECT tblUser.IdUser AS [ID], tblUser.Name [Nome], COUNT(tblPlaceReport.IdPlaceReport) AS [Nº de Reports]
		FROM tblUser
		LEFT OUTER JOIN tblPlaceReport
		ON tblUser.IdUser = tblPlaceReport.CreatedBy
		GROUP BY tblUser.IdUser, tblUser.Name
	END

	--Utilizadores que ainda não fizeram nenhum report
	ELSE IF @paramIdConsulta = 2
	BEGIN
		SELECT tblUser.IdUser AS [ID], tblUser.Name [Nome]
		FROM tblUser
		WHERE NOT EXISTS
		(SELECT * FROM tblPlaceReport
		WHERE CreatedBy = tblUser.IdUser)
	END

	--Alertas de alta concentração
	ELSE IF @paramIdConsulta = 3
	BEGIN
		SELECT tblWarning.IdWarning AS [ID], tblWarning.Description AS [Descrição], tblPlace.Name AS [Espaço], tblWarning.CreatedIn AS [Data&Hora]
		FROM tblWarning
		INNER JOIN tblPlace ON
		tblWarning.IdPlace = tblPlace.IdPlace
	END
END
GO

--Quando um report é inserido, gerar um alerta, caso se verifique que nos últimos 5 minutos houve mais de 3 reports com nível 3
IF OBJECT_ID('trInsertReport') IS NOT NULL
	DROP TRIGGER trInsertReport
GO
CREATE TRIGGER trInsertReport
ON tblPlaceReport
	FOR INSERT
AS
BEGIN
	DECLARE @numReports int

	SELECT @numReports = COUNT(tblPlaceReport.Level)
	FROM tblPlaceReport
	WHERE tblPlaceReport.CreatedIn BETWEEN DATEADD(MINUTE, -5, GETDATE()) AND GETDATE() AND tblPlaceReport.Level = 3
	GROUP BY tblPlaceReport.IdPlace

	IF
	(
		SELECT COUNT(*)
		FROM tblWarning
		WHERE tblWarning.IdPlace = (SELECT inserted.IdPlace FROM inserted) AND
		tblWarning.CreatedIn BETWEEN DATEADD(MINUTE, -5, GETDATE()) AND GETDATE()
	) < 1 AND @numReports > 3
	BEGIN
		INSERT INTO tblWarning (IdPlace, Description, CreatedIn) VALUES((SELECT inserted.IdPlace FROM inserted), 'Alerta nível de concentração muito alto.', GETDATE())
	END
END
GO

--Quando um espaço é editado, nomeadamente o seu nome, se o novo nome for diferente do anterior todos os reports desse espaço são removidos.
IF OBJECT_ID('trUpdatePlace') IS NOT NULL
	DROP TRIGGER trUpdatePlace
GO
CREATE TRIGGER trUpdatePlace
ON tblPlace
	FOR UPDATE
AS
BEGIN
	IF (SELECT inserted.Name FROM inserted) NOT LIKE
	(SELECT deleted.Name FROM deleted)
	BEGIN
		DELETE FROM tblPlaceReport
		WHERE IdPlace = (SELECT inserted.IdPlace FROM inserted)
	END
END
GO

----Cursor que remove os utilizadores que não fazem reports há 3 meses
--DECLARE @VarIdUser int, @VarUserName varchar(100)

--DECLARE Cursor_RemoveUsers CURSOR
--DYNAMIC
--FOR
--	SELECT IdUser, Name
--	FROM tblUser

--OPEN Cursor_RemoveUsers

--FETCH FIRST FROM Cursor_RemoveUsers
--INTO @VarIdUser, @VarUserName

--WHILE @@FETCH_STATUS = 0
--BEGIN
--	IF (SELECT COUNT(*) FROM tblPlaceReport WHERE CreatedBy = @VarIdUser AND CreatedIn
--	BETWEEN DATEADD(MONTH, -3, GETDATE()) AND GETDATE()) = 0
--	BEGIN
--		DELETE tblUser
--		WHERE CURRENT OF Cursor_RemoveUsers
--		PRINT 'O utilizador ' + @VarUserName + ' com o ID=' + CONVERT(varchar, @VarIdUser) +
--		' foi removido por inatividade!'
--	END
--	FETCH NEXT FROM Cursor_RemoveUsers
--	INTO @VarIdUser, @VarUserName
--END
--CLOSE Cursor_RemoveUsers
--DEALLOCATE Cursor_RemoveUsers

----Utilizadores que ainda não fizeram nenhum report
--SELECT tblUser.IdUser AS [ID], tblUser.Name [Nome]
--FROM tblUser
--WHERE NOT EXISTS
--(SELECT * FROM tblPlaceReport
--WHERE CreatedBy = tblUser.IdUser AND CreatedIn BETWEEN DATEADD(MONTH, -3, GETDATE()) AND GETDATE())
