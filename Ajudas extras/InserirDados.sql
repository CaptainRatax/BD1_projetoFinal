--Para garantir que este trigger só é criado dps da inserção dos dados teste
IF OBJECT_ID('trInsertReport') IS NOT NULL
	DROP TRIGGER trInsertReport

DECLARE @cnt INT = 0;

INSERT INTO tblUser (Name, Email, Password, CreatedIn)
VALUES('Admin ESTGV', 'adminestgv@estgv.ipv.pt', 'adminestgv_pass', GETDATE())
WHILE(@cnt < 30)
BEGIN
	INSERT INTO tblUser (Name, Email, Password, CreatedIn)
	VALUES (
	'Aluno ' + CONVERT(varchar, @cnt),
	'aluno'+ CONVERT(varchar, @cnt) + '@alunos.estgv.ipv.pt',
	'aluno'+ CONVERT(varchar, @cnt) + '_pass',
	--Gerar uma data random entre duas datas
	DATEADD(DAY, ROUND(DATEDIFF(DAY, '2021-01-01', GETDATE()) * RAND(CHECKSUM(NEWID())), 0), DATEADD(second,CHECKSUM(NEWID())%48000, '2021-01-01'))
	)
	SET @cnt = @cnt + 1;
END


INSERT INTO tblGroup (Name, CreatedIn)
VALUES('ESTGV', GETDATE())


INSERT INTO tblPlace (IdGroup, Name, CreatedBy)
VALUES(1, 'Bar', 1),
(1, 'Refeitório', 1),
(1, 'Biblioteca', 1),
(1, 'Auditório', 1),
(1, 'Residências', 1)


SET @cnt = 0;
WHILE(@cnt < 200)
BEGIN
	INSERT INTO tblPlaceReport (IdPlace, Level, CreatedIn, CreatedBy)
	VALUES (
	--Selecionar registo random da tabela 'tblPlace'
	(SELECT TOP 1 IdPlace FROM tblPlace ORDER BY NEWID()),
	--Gerar número inteiro entre 1 e 3 (níveis de report)
	(SELECT FLOOR(RAND()*(3-1+1))+1),
	--Gerar uma data random entre duas datas
	DATEADD(DAY, ROUND(DATEDIFF(DAY, '2021-01-01', GETDATE()) * RAND(CHECKSUM(NEWID())), 0), DATEADD(second,CHECKSUM(NEWID())%48000, '2021-01-01')),
	--Selecionar registo random da tabela 'tblUser'
	(SELECT TOP 1 idUser FROM tblUser ORDER BY NEWID())
	)
	SET @cnt = @cnt + 1;
END


SET @cnt = 0;
WHILE(@cnt < 100)
BEGIN
	INSERT INTO tblPlaceReport (IdPlace, Level, CreatedIn, CreatedBy)
	VALUES (
	--Selecionar registo random da tabela 'tblPlace'
	(SELECT TOP 1 IdPlace FROM tblPlace ORDER BY NEWID()),
	--Gerar número inteiro entre 1 e 3 (níveis de report)
	(SELECT FLOOR(RAND()*(3-1+1))+1),
	--Gerar uma data random entre duas datas
	DATEADD(MINUTE, -5, GETDATE()),
	--Selecionar registo random da tabela 'tblUser'
	(SELECT TOP 1 idUser FROM tblUser ORDER BY NEWID())
	)
	SET @cnt = @cnt + 1;
END


SET @cnt = 30;
WHILE(@cnt < 40)
BEGIN
	INSERT INTO tblUser (Name, Email, Password, CreatedIn)
	VALUES (
	'Aluno ' + CONVERT(varchar, @cnt),
	'aluno'+ CONVERT(varchar, @cnt) + '@alunos.estgv.ipv.pt',
	'aluno'+ CONVERT(varchar, @cnt) + '_pass',
	--Data de há 4 meses atrás
	DATEADD(MONTH, -4, GETDATE())
	)
	SET @cnt = @cnt + 1;
END

