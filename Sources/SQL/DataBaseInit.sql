USE [master];
GO

-- ========================================================================== --
--   On casse tout avant de commencer                                         --
-- ========================================================================== --
IF EXISTS(SELECT * FROM sys.databases WHERE name='ProjetWEB') BEGIN
  DROP DATABASE ProjetWEB;
END
GO
CREATE DATABASE ProjetWEB;
GO
USE ProjetWEB;
GO

-- ========================================================================== --
--   Administrateur principal (on ne sait jamais, ça peut servir)             --
-- ========================================================================== --
IF EXISTS(SELECT name FROM sys.server_principals WHERE name = 'ProjetWEB_RootAdmin') BEGIN
  DROP LOGIN ProjetWEB_RootAdmin;
END
CREATE LOGIN ProjetWEB_RootAdmin WITH PASSWORD = 'RootAdmin', CHECK_POLICY = OFF;
GO
CREATE USER RootAdmn FOR LOGIN ProjetWEB_RootAdmin;
GO
ALTER ROLE db_accessadmin ADD MEMBER RootAdmn;
ALTER ROLE db_backupoperator ADD MEMBER RootAdmn;
ALTER ROLE db_datareader ADD MEMBER RootAdmn;
ALTER ROLE db_datawriter ADD MEMBER RootAdmn;
ALTER ROLE db_ddladmin ADD MEMBER RootAdmn;
ALTER ROLE db_owner ADD MEMBER RootAdmn;
ALTER ROLE db_securityadmin ADD MEMBER RootAdmn;
GO

-- ========================================================================== --
--   Tables                                                                   --
-- ========================================================================== --
CREATE TABLE _BOOK (
  BOO_REC_ID int NOT NULL,
  BOO_CLI_ID int NOT NULL,
  BOO_VALID bit NOT NULL DEFAULT(0), -- BR010 (partial)
  BOO_UPDATE_AT datetime2,
  BOO_UPDATE_BY char(8) NOT NULL DEFAULT(CURRENT_USER),
  CONSTRAINT PK_BOOK PRIMARY KEY (BOO_REC_ID,BOO_CLI_ID) -- BR008
);
--------------------------------------------------------------------------------
CREATE TABLE _CHOOSE (
  CHO_CLI_ID int NOT NULL,
  CHO_DIS_ID int NOT NULL,
  CHO_REC_ID int NOT NULL,
  CHO_UPDATE_AT datetime2,
  CHO_UPDATE_BY char(8) NOT NULL DEFAULT(CURRENT_USER),
  CONSTRAINT PK_CHOOSE PRIMARY KEY (CHO_CLI_ID,CHO_DIS_ID, CHO_REC_ID) -- BR013
);
--------------------------------------------------------------------------------
CREATE TABLE _CLIENT(
  CLI_ID int IDENTITY(1,1) NOT NULL,
  CLI_ACRONYM char(8) NOT NULL,
  CLI_EMAIL varchar(255) NOT NULL,
  CLI_PASSWORD varchar(64) NOT NULL,
  CLI_GROUP varchar(64) NOT NULL,
  CLI_FNAME varchar(64) NOT NULL,
  CLI_LNAME varchar(64) NOT NULL,
  CLI_SEX char(1) NOT NULL,
  CLI_BDAY date NOT NULL,
  CLI_JOB varchar(64) NOT NULL,
  CLI_UPDATE_AT datetime2,
  CLI_UPDATE_BY char(8) NOT NULL DEFAULT(CURRENT_USER),
  CONSTRAINT PK_CLIENT PRIMARY KEY (CLI_ID),
  CONSTRAINT UK_CLIENT_ACRONYM UNIQUE (CLI_ACRONYM),
  CONSTRAINT UK_CLIENT_FIRST_LAST_NAME UNIQUE (CLI_FNAME, CLI_LNAME) -- BR003
);
--------------------------------------------------------------------------------
CREATE TABLE _DISH (
  DIS_ID int IDENTITY(1,1) NOT NULL,
  DIS_NAME varchar(64) NOT NULL,
  DIS_TYPE int NOT NULL,
  DIS_UPDATE_AT datetime2,
  DIS_UPDATE_BY char(8) NOT NULL DEFAULT(CURRENT_USER),
  CONSTRAINT PK_DISH PRIMARY KEY (DIS_ID),
  CONSTRAINT UK_DISH_NAME_TYPE UNIQUE (DIS_NAME, DIS_TYPE) -- BR004
);
--------------------------------------------------------------------------------
CREATE TABLE _DISHTYPE (
  DTY_ID int NOT NULL,
  DTY_NAME varchar(64) NOT NULL,
  CONSTRAINT PK_DISHTYPE PRIMARY KEY (DTY_ID)
);
--------------------------------------------------------------------------------
CREATE TABLE _FEEL_CLI_CLI (
  FCC_CLI_FROM_ID int NOT NULL,
  FCC_CLI_TO_ID int NOT NULL,
  FCC_FTY_ID int NOT NULL,
  FCC_UPDATE_AT datetime2,
  FCC_UPDATE_BY char(8) NOT NULL DEFAULT(CURRENT_USER),
  CONSTRAINT PK_FEEL_CLI_CLI PRIMARY KEY (FCC_CLI_FROM_ID,FCC_CLI_TO_ID) -- BR015
);
--------------------------------------------------------------------------------
CREATE TABLE _FEEL_CLI_DIS (
  FCD_CLI_ID int NOT NULL,
  FCD_DIS_ID int NOT NULL,
  FCD_FTY_ID int NOT NULL,
  FCD_UPDATE_AT datetime2,
  FCD_UPDATE_BY char(8) NOT NULL DEFAULT(CURRENT_USER),
  CONSTRAINT PK_FEEL_CLI_DIS PRIMARY KEY (FCD_CLI_ID,FCD_DIS_ID) -- BR017
);
--------------------------------------------------------------------------------
CREATE TABLE _FEELINGTYPE (
  FTY_ID int NOT NULL,
  FTY_NAME varchar(64) NOT NULL,
  CONSTRAINT PK_FEELINGTYPE PRIMARY KEY (FTY_ID)
);
--------------------------------------------------------------------------------
CREATE TABLE _OFFER (
  OFF_REC_ID int NOT NULL,
  OFF_DIS_ID int NOT NULL,
  OFF_UPDATE_AT datetime2,
  OFF_UPDATE_BY char(8) NOT NULL DEFAULT(CURRENT_USER),
  CONSTRAINT PK_OFFER PRIMARY KEY (OFF_REC_ID,OFF_DIS_ID) -- BR005
);
--------------------------------------------------------------------------------
CREATE TABLE _RECEPTION (
  REC_ID int IDENTITY(1,1) NOT NULL,
  REC_NAME varchar(64) NOT NULL,
  REC_DATE datetime2 NOT NULL,
  REC_DATE_CLOSING_REG datetime2 NOT NULL,
  REC_CAPACITY int NOT NULL,
  REC_SEAT_TABLE int NOT NULL,
  REC_VALID bit NOT NULL DEFAULT(0), -- BR004 (partial)
  REC_UPDATE_AT datetime2,
  REC_UPDATE_BY char(8) NOT NULL DEFAULT(CURRENT_USER),
  CONSTRAINT PK_RECEPTION PRIMARY KEY (REC_ID),
  CONSTRAINT UK_RECEPTION_NAME_DATE UNIQUE (REC_NAME, REC_DATE)
);
--------------------------------------------------------------------------------
CREATE TABLE _SIT (
  SIT_TAB_ID int NOT NULL,
  SIT_CLI_ID int NOT NULL,
  SIT_UPDATE_AT datetime2,
  SIT_UPDATE_BY char(8) NOT NULL DEFAULT(CURRENT_USER),
  CONSTRAINT PK_SIT PRIMARY KEY (SIT_TAB_ID,SIT_CLI_ID) -- BRX008
);
--------------------------------------------------------------------------------
CREATE TABLE _TABLE (
  TAB_ID int IDENTITY(1,1) NOT NULL,
  TAB_NUMBER int NOT NULL,
  TAB_SEATING int NOT NULL,
  TAB_REC_ID int NOT NULL,
  TAB_VALID  bit NOT NULL DEFAULT(0), -- BR019 (partial)
  TAB_UPDATE_AT datetime2,
  TAB_UPDATE_BY char(8) NOT NULL DEFAULT(CURRENT_USER),
  CONSTRAINT PK_TABLE PRIMARY KEY (TAB_ID),
  CONSTRAINT UK_TABLE_NUMBER_REC UNIQUE (TAB_NUMBER, TAB_REC_ID)
);
--------------------------------------------------------------------------------
ALTER TABLE _BOOK ADD CONSTRAINT FK_BOOK_CLI FOREIGN KEY (BOO_CLI_ID) REFERENCES _CLIENT (CLI_ID);
ALTER TABLE _BOOK ADD CONSTRAINT FK_BOOK_REC FOREIGN KEY (BOO_REC_ID) REFERENCES _RECEPTION (REC_ID);
ALTER TABLE _CHOOSE ADD CONSTRAINT FK_CHOOSE_CLI FOREIGN KEY (CHO_CLI_ID) REFERENCES _CLIENT (CLI_ID);
ALTER TABLE _CHOOSE ADD CONSTRAINT FK_CHOOSE_DIS FOREIGN KEY (CHO_DIS_ID) REFERENCES _DISH (DIS_ID);
ALTER TABLE _CHOOSE ADD CONSTRAINT FK_CHOOSE_REC FOREIGN KEY (CHO_REC_ID) REFERENCES _RECEPTION (REC_ID);
ALTER TABLE _DISH ADD CONSTRAINT FK_DISH_TYPE FOREIGN KEY (DIS_TYPE) REFERENCES _DISHTYPE (DTY_ID);
ALTER TABLE _FEEL_CLI_CLI ADD CONSTRAINT FK_FEEL_CLI_CLI_CLI1 FOREIGN KEY (FCC_CLI_FROM_ID) REFERENCES _CLIENT (CLI_ID);
ALTER TABLE _FEEL_CLI_CLI ADD CONSTRAINT FK_FEEL_CLI_CLI_CLI2 FOREIGN KEY (FCC_CLI_TO_ID) REFERENCES _CLIENT (CLI_ID);
ALTER TABLE _FEEL_CLI_CLI ADD CONSTRAINT FK_FEEL_CLI_CLI_FEELINGTYPE FOREIGN KEY (FCC_FTY_ID) REFERENCES _FEELINGTYPE (FTY_ID);
ALTER TABLE _FEEL_CLI_DIS ADD CONSTRAINT FK_FEEL_CLI_DIS_CLI FOREIGN KEY (FCD_CLI_ID) REFERENCES _CLIENT (CLI_ID);
ALTER TABLE _FEEL_CLI_DIS ADD CONSTRAINT FK_FEEL_CLI_DIS_DISH FOREIGN KEY (FCD_DIS_ID) REFERENCES _DISH (DIS_ID);
ALTER TABLE _FEEL_CLI_DIS ADD CONSTRAINT FK_FEEL_CLI_DIS_FEELINGTYPE FOREIGN KEY (FCD_FTY_ID) REFERENCES _FEELINGTYPE (FTY_ID);
ALTER TABLE _OFFER ADD CONSTRAINT FK_OFFER_DIS FOREIGN KEY (OFF_DIS_ID) REFERENCES _DISH (DIS_ID);
ALTER TABLE _OFFER ADD CONSTRAINT FK_OFFER_REC FOREIGN KEY (OFF_REC_ID) REFERENCES _RECEPTION (REC_ID);
ALTER TABLE _SIT ADD CONSTRAINT FK_SIT_CLI FOREIGN KEY (SIT_CLI_ID) REFERENCES _CLIENT (CLI_ID);
ALTER TABLE _SIT ADD CONSTRAINT FK_SIT_TAB FOREIGN KEY (SIT_TAB_ID) REFERENCES _TABLE (TAB_ID);
ALTER TABLE _TABLE ADD CONSTRAINT FK_TABLE_RECEPTION FOREIGN KEY (TAB_REC_ID) REFERENCES _RECEPTION (REC_ID);

-- ========================================================================== --
--   Données statiques                                                        --
-- ========================================================================== --
INSERT INTO _FEELINGTYPE (FTY_ID ,FTY_NAME)
VALUES (1, 'aime'),
       (2, 'n''aime pas');
INSERT INTO _DISHTYPE (DTY_ID, DTY_NAME)
VALUES (1, 'entrée'),
       (2, 'plat principal'),
       (3, 'dessert');
GO

-- =============================================================================
-- Author:      Sébastien ADAM
-- Create date: Jan2016
-- Description: Count the dishes that were chosen.
-- =============================================================================
CREATE FUNCTION CountChosenDish
(
  @DishId int
)
RETURNS int
AS
BEGIN
  DECLARE @Result int;
  SELECT @Result = count(*)
  FROM _CHOOSE
  WHERE CHO_DIS_ID = @DishId;
  RETURN @Result;
END
GO
-- =============================================================================
-- Author:      Sébastien ADAM
-- Create date: Jan2016
-- Description: Count the dishes that were disliked.
-- =============================================================================
CREATE FUNCTION CountDislikedDish
(
  @DishId int
)
RETURNS int
AS
BEGIN
  DECLARE @Result int;
  SELECT @Result = count(*)
  FROM _FEEL_CLI_DIS
  WHERE FCD_FTY_ID = 2
    AND FCD_DIS_ID = @DishId;
  RETURN @Result;
END
GO
-- =============================================================================
-- Author:      Sébastien ADAM
-- Create date: Jan2016
-- Description: Count the dishes that were liked.
-- =============================================================================
CREATE FUNCTION CountLikedDish
(
  @DishId int
)
RETURNS int
AS
BEGIN
  DECLARE @Result int;
  SELECT @Result = count(*)
  FROM _FEEL_CLI_DIS
  WHERE FCD_FTY_ID = 1
    AND FCD_DIS_ID = @DishId;
  RETURN @Result;
END
GO
-- =============================================================================
-- Author:      Sébastien ADAM
-- Create date: Jan2016
-- Description: Count the dishes that were offered.
-- =============================================================================
CREATE FUNCTION CountOfferedDish
(
  @DishId int
)
RETURNS int
AS
BEGIN
  DECLARE @Result int;
  SELECT @Result = count(*)
  FROM _OFFER
  WHERE OFF_DIS_ID = @DishId;
  RETURN @Result;
END
GO

-- ========================================================================== --
--   Vues                                                                     --
-- ========================================================================== --
CREATE VIEW Client AS
SELECT CLI_ACRONYM AS Acronym,
       CLI_FNAME AS FirstName,
       CLI_LNAME AS LastName,
       CLI_SEX AS Sex,
       CLI_BDAY AS BirthDay,
       CLI_JOB AS Job,
       CLI_ID AS ClientId,
       CLI_UPDATE_AT AS ModifiedAt,
       CLI_UPDATE_BY AS ModifiedBy
FROM _CLIENT;
GO
--------------------------------------------------------------------------------
CREATE VIEW Dish AS
SELECT DTY_NAME AS [Type],
       DIS_NAME AS Name,
       DIS_ID AS DishId,
       DTY_ID AS DishTypeId,
       DIS_UPDATE_AT AS ModifiedAt,
       DIS_UPDATE_BY AS ModifiedBy
FROM _DISH, _DISHTYPE
WHERE DIS_TYPE = DTY_ID;
GO
--------------------------------------------------------------------------------
CREATE VIEW DishStatistic AS
SELECT DTY_NAME AS [Type],
       DIS_NAME AS Name,
       dbo.CountOfferedDish(DIS_ID) as Offered,
       dbo.CountChosenDish(DIS_ID) as Chosen,
       dbo.CountLikedDish(DIS_ID) as Liked,
       dbo.CountDislikedDish(DIS_ID) as Disliked,
       DIS_ID AS DishId,
       DTY_ID DishTypeId
FROM _DISH, _DISHTYPE
WHERE DIS_TYPE = DTY_ID;
GO
--------------------------------------------------------------------------------
CREATE VIEW DishType AS
SELECT DTY_NAME AS Label,
       DTY_ID AS Id
FROM _DISHTYPE;
GO
--------------------------------------------------------------------------------
CREATE VIEW DishWish AS
SELECT CLI_FNAME AS ClientFirstName,
       CLI_LNAME AS ClientLastName,
       FTY_NAME AS Feeling,
       DTY_NAME AS DishType,
       DIS_NAME AS DishName,
       CLI_ID AS ClientId,
       DIS_ID AS DishId,
       DTY_ID AS DishTypeId,
       FTY_ID AS FeelingTypeId,
       FCD_UPDATE_AT AS ModifiedAt,
       FCD_UPDATE_BY AS ModifiedBy
FROM _FEEL_CLI_DIS,
     _CLIENT,
     _DISH,
     _DISHTYPE,
     _FEELINGTYPE
WHERE FCD_CLI_ID = CLI_ID
  AND FCD_DIS_ID = DIS_ID
  AND DIS_TYPE = DTY_ID
  AND FCD_FTY_ID = FTY_ID;
GO
--------------------------------------------------------------------------------
CREATE VIEW Feeling AS
SELECT _CLIENT_FROM.CLI_FNAME AS ClientFromFirstName,
       _CLIENT_FROM.CLI_LNAME AS ClientFromLastName,
       FTY_NAME AS Feeling,
       _CLIENT_TO.CLI_FNAME AS ClientToFirstName,
       _CLIENT_TO.CLI_LNAME AS ClientToLastName,
       _CLIENT_FROM.CLI_ID AS ClientFromId,
       _CLIENT_TO.CLI_ID AS ClientToId,
       FTY_ID AS FeelingTypeId,
       FCC_UPDATE_AT AS ModifiedAt,
       FCC_UPDATE_BY AS ModifiedBy
FROM _FEEL_CLI_CLI,
     _CLIENT AS _CLIENT_FROM,
     _CLIENT AS _CLIENT_TO,
     _FEELINGTYPE
WHERE FCC_CLI_FROM_ID = _CLIENT_FROM.CLI_ID
  AND FCC_CLI_TO_ID = _CLIENT_TO.CLI_ID
  AND FCC_FTY_ID = FTY_ID;
GO
--------------------------------------------------------------------------------
CREATE VIEW FeelingType AS
SELECT FTY_NAME AS Label,
       FTY_ID AS Id
FROM _FEELINGTYPE;
GO
--------------------------------------------------------------------------------
CREATE VIEW Menu AS
SELECT REC_NAME AS ReceptionName,
       REC_DATE AS ReceptionDate,
       DTY_NAME AS DishType,
       DIS_NAME AS DishName,
       REC_ID AS ReceptionId,
       DIS_ID AS DishId,
       DTY_ID AS DishTypeId,
       OFF_UPDATE_AT AS ModifiedAt,
       OFF_UPDATE_BY AS ModifiedBy
FROM _RECEPTION,
     _OFFER,
     _DISH,
     _DISHTYPE
WHERE REC_ID = OFF_REC_ID
  AND OFF_DIS_ID = DIS_ID
  AND DIS_TYPE = DTY_ID;
GO
--------------------------------------------------------------------------------
CREATE VIEW Reception AS
SELECT REC_NAME AS Name,
       REC_DATE AS [Date],
       REC_DATE_CLOSING_REG AS BookingClosingDate,
       REC_CAPACITY AS Capacity,
       REC_SEAT_TABLE AS SeatsPerTable,
       REC_VALID AS IsValid,
       REC_ID AS ReceptionId,
       REC_UPDATE_AT AS ModifiedAt,
       REC_UPDATE_BY AS ModifiedBy
FROM _RECEPTION;
GO
--------------------------------------------------------------------------------
CREATE VIEW Reservation AS
SELECT REC_NAME AS ReceptionName,
       REC_DATE AS ReceptionDate,
       CLI_FNAME AS ClientFirstName,
       CLI_LNAME AS ClientLastName,
       BOO_VALID AS IsValid,
       REC_ID AS ReceptionId,
       CLI_ID AS ClientId,
       BOO_UPDATE_AT AS ModifiedAt,
       BOO_UPDATE_BY AS ModifiedBy
FROM _RECEPTION,
     _BOOK,
     _CLIENT
WHERE REC_ID = BOO_REC_ID
  AND BOO_CLI_ID = CLI_ID;
GO
--------------------------------------------------------------------------------
CREATE VIEW ReservedDish AS
SELECT REC_NAME AS ReceptionName,
       REC_DATE AS ReceptionDate,
       CLI_FNAME AS ClientFirstName,
       CLI_LNAME AS ClientLastName,
       DTY_NAME AS DishType,
       DIS_NAME AS DishName,
       REC_ID AS ReceptionId,
       CLI_ID AS ClientId,
       DIS_ID AS DishId,
       DTY_ID AS DishTypeId,
       CHO_UPDATE_AT AS ModifiedAt,
       CHO_UPDATE_BY AS ModifiedBy
FROM _RECEPTION,
     _CHOOSE,
     _DISH,
     _DISHTYPE,
     _CLIENT
WHERE REC_ID = CHO_REC_ID
  AND CHO_CLI_ID = CLI_ID
  AND CHO_DIS_ID = DIS_ID
  AND DIS_TYPE = DTY_ID;
GO
--------------------------------------------------------------------------------
CREATE VIEW TablesMap AS
SELECT REC_NAME AS ReceptionName,
       REC_DATE AS ReceptionDate,
       TAB_NUMBER AS TableNumber,
       CLI_FNAME AS ClientFirstName,
       CLI_LNAME AS ClientLastName,
       TAB_VALID AS IsValid,
       REC_ID AS ReceptionId,
       TAB_ID AS TableId,
       CLI_ID AS ClientId,
       SIT_UPDATE_AT AS ModifiedAt,
       SIT_UPDATE_BY AS ModifiedBy
FROM _RECEPTION,
     _TABLE,
     _SIT,
     _CLIENT
WHERE REC_ID = TAB_REC_ID
  AND TAB_ID = SIT_TAB_ID
  AND SIT_CLI_ID = CLI_ID;
GO

-- ========================================================================== --
--   Fonctions                                                                --
-- ========================================================================== --
-- =============================================================================
-- Author:      Sébastien ADAM
-- Create date: Dec2015
-- Description: Checks if the username and password match.
-- =============================================================================
CREATE FUNCTION DoLogin
(
  @Acronym varchar(64),
  @Password varchar(64)
)
RETURNS bit
AS
BEGIN
  DECLARE @Count int,
          @Result bit;
  SELECT @Count = COUNT(*)
  FROM _CLIENT
  WHERE CLI_ACRONYM = @Acronym
    AND CLI_PASSWORD = @Password;
  IF @Count = 1 BEGIN
    SET @Result = 1;
  END ELSE BEGIN
    SET @Result = 0;
  END
  RETURN @Result;
END
GO
-- =============================================================================
-- Author:      Sébastien ADAM
-- Create date: Dec2015
-- Description: Gets the group of a user.
-- =============================================================================
CREATE FUNCTION GetGroup 
(
  @Acronym varchar(64)
)
RETURNS varchar(64)
AS
BEGIN
  DECLARE @Group varchar(64);
  SELECT TOP 1 @Group = CLI_GROUP
  FROM _CLIENT
  WHERE CLI_ACRONYM = @Acronym;
  RETURN @Group;
END
GO
-- =============================================================================
-- Author:      Sébastien Adam
-- Create date: Dec2015
-- Description: Tests if the reservation is valid for a reception. For a
--              reservation to be valid, it is necessary that the customer has
--              reserved its menu. If the reservation is valid, returns 1.
--              Otherwise return 0. (BR010)
-- =============================================================================
CREATE FUNCTION IS_VALID_BOOK
(
  @RecId int,
  @CliId int
)
RETURNS bit
AS
BEGIN
  DECLARE @Result bit;
  IF (@RecId IS NULL) OR (@CliId IS NULL) BEGIN
    SET @Result = 0;
  END ELSE IF EXISTS(SELECT *
                     FROM _DISHTYPE
                     WHERE DTY_ID NOT IN (SELECT DISTINCT DIS_TYPE
                                          FROM _CHOOSE, _DISH
                                          WHERE CHO_DIS_ID = DIS_ID
                                            AND CHO_CLI_ID = @CliId
                                            AND CHO_REC_ID = @RecId)) BEGIN
    SET @Result = 0;
  END ELSE BEGIN
    SET @Result = 1;
  END
  RETURN @Result;
END
GO
-- =============================================================================
-- Author:      Sébastien Adam
-- Create date: Dec2015
-- Description: Tests whether a reception is valid. To be valid, a reception
--              must offer at least one dish of each type. If the reception is
--              valid, returns 1. Otherwise return 0. (BR004)
-- =============================================================================
CREATE FUNCTION IS_VALID_RECEPTION
(
  @RecId int
)
RETURNS BIT
AS
BEGIN
  DECLARE @Result bit;
  IF @RecId IS NULL BEGIN
    SET @Result = 0;
  END ELSE IF EXISTS(SELECT *
                     FROM _DISHTYPE
                     WHERE DTY_ID NOT IN (SELECT DISTINCT DIS_TYPE
                                          FROM _OFFER, _DISH
                                          WHERE OFF_DIS_ID = DIS_ID
                                            AND OFF_REC_ID = @RecId)) BEGIN
    SET @Result = 0;
  END ELSE BEGIN
    SET @Result = 1;
  END
  RETURN @Result;
END
GO
-- =============================================================================
-- Author:      Sébastien Adam
-- Create date: Dec2015
-- Description: Tests whether a table is valid. To be valid, a table must have
--              at least two clients who are seated. If the table is valid,
--              returns 1. Otherwise return 0. (BR019)
-- =============================================================================
CREATE FUNCTION IS_VALID_TABLE
(
  @TabId int
)
RETURNS bit
AS
BEGIN
  DECLARE @Result bit;
  IF @TabId IS NULL BEGIN
    SET @Result = 0;
  END ELSE IF EXISTS(SELECT *
                     FROM _SIT
                     WHERE SIT_TAB_ID = @TabId
                     HAVING COUNT(*) < 2) BEGIN
    SET @Result = 0;
  END ELSE BEGIN
    SET @Result = 1;
  END
  RETURN @Result;
END
GO
-- =============================================================================
-- Author:      Sébastien Adam
-- Create date: Dec2015
-- Description: Returns the modified time of a record from _BOOK table
-- =============================================================================
CREATE FUNCTION UPDATE_AT_BOOK
(
  @RecId int,
  @CliId int
)
RETURNS datetime2
AS
BEGIN
  DECLARE @Result datetime2;
  SELECT @Result = BOO_UPDATE_AT
  FROM _BOOK
  WHERE BOO_CLI_ID = @CliId
    AND BOO_REC_ID = @RecId;
  RETURN @Result
END
GO
-- =============================================================================
-- Author:      Sébastien Adam
-- Create date: Dec2015
-- Description: Returns the modified time of a record from _CHOOSE table
-- =============================================================================
CREATE FUNCTION UPDATE_AT_CHOOSE
(
  @CliId int,
  @DisId int,
  @RecId int
)
RETURNS datetime2
AS
BEGIN
  DECLARE @Result datetime2;
  SELECT @Result = CHO_UPDATE_AT
  FROM _CHOOSE
  WHERE CHO_CLI_ID = @CliId
    AND CHO_DIS_ID = @DisId
    AND CHO_REC_ID = @RecId;
  RETURN @Result
END
GO
-- =============================================================================
-- Author:      Sébastien Adam
-- Create date: Dec2015
-- Description: Returns the modified time of a record from _CLIENT table
-- =============================================================================
CREATE FUNCTION UPDATE_AT_CLIENT
(
  @CliId int
)
RETURNS datetime2
AS
BEGIN
  DECLARE @Result datetime2;
  SELECT @Result = CLI_UPDATE_AT
  FROM _CLIENT
  WHERE CLI_ID = @CliId;
  RETURN @Result
END
GO
-- =============================================================================
-- Author:      Sébastien Adam
-- Create date: Dec2015
-- Description: Returns the modified time of a record from _DISH table
-- =============================================================================
CREATE FUNCTION UPDATE_AT_DISH
(
  @DisId int
)
RETURNS datetime2
AS
BEGIN
  DECLARE @Result datetime2;
  SELECT @Result = DIS_UPDATE_AT
  FROM _DISH
  WHERE DIS_ID = @DisId;
  RETURN @Result
END
GO
-- =============================================================================
-- Author:      Sébastien Adam
-- Create date: Dec2015
-- Description: Returns the modified time of a record from _FEEL_CLI_CLI table
-- =============================================================================
CREATE FUNCTION UPDATE_AT_FEEL_CLI_CLI
(
  @CliFromId int,
  @CliToId int
)
RETURNS datetime2
AS
BEGIN
  DECLARE @Result datetime2;
  SELECT @Result = FCC_UPDATE_AT
  FROM _FEEL_CLI_CLI
  WHERE FCC_CLI_FROM_ID = @CliFromId
    AND FCC_CLI_TO_ID = @CliToId;
  RETURN @Result
END
GO
-- =============================================================================
-- Author:      Sébastien Adam
-- Create date: Dec2015
-- Description: Returns the modified time of a record from _FEEL_CLI_DIS table
-- =============================================================================
CREATE FUNCTION UPDATE_AT_FEEL_CLI_DIS
(
  @CliId int,
  @DisId int
)
RETURNS datetime2
AS
BEGIN
  DECLARE @Result datetime2;
  SELECT @Result = FCD_UPDATE_AT
  FROM _FEEL_CLI_DIS
  WHERE FCD_CLI_ID = @CliId
    AND FCD_DIS_ID = @DisId;
  RETURN @Result
END
GO
-- =============================================================================
-- Author:      Sébastien Adam
-- Create date: Dec2015
-- Description: Returns the modified time of a record from _OFFER table
-- =============================================================================
CREATE FUNCTION UPDATE_AT_OFFER
(
  @RecId int,
  @DisId int
)
RETURNS datetime2
AS
BEGIN
  DECLARE @Result datetime2;
  SELECT @Result = OFF_UPDATE_AT
  FROM _OFFER
  WHERE OFF_REC_ID = @RecId
    AND OFF_DIS_ID = @DisId;
  RETURN @Result
END
GO
-- =============================================================================
-- Author:      Sébastien Adam
-- Create date: Dec2015
-- Description: Returns the modified time of a record from _RECEPTION table
-- =============================================================================
CREATE FUNCTION UPDATE_AT_RECEPTION
(
  @RecId int
)
RETURNS datetime2
AS
BEGIN
  DECLARE @Result datetime2;
  SELECT @Result = REC_UPDATE_AT
  FROM _RECEPTION
  WHERE REC_ID = @RecId;
  RETURN @Result
END
GO
-- =============================================================================
-- Author:      Sébastien Adam
-- Create date: Dec2015
-- Description: Returns the modified time of a record from _SIT table
-- =============================================================================
CREATE FUNCTION UPDATE_AT_SIT
(
  @TabId int,
  @CliId int
)
RETURNS datetime2
AS
BEGIN
  DECLARE @Result datetime2;
  SELECT @Result = SIT_UPDATE_AT
  FROM _SIT
  WHERE SIT_TAB_ID = @TabId
    AND SIT_CLI_ID = @CliId;
  RETURN @Result
END
GO
-- =============================================================================
-- Author:      Sébastien Adam
-- Create date: Dec2015
-- Description: Returns the modified time of a record from _TABLE table
-- =============================================================================
CREATE FUNCTION UPDATE_AT_TABLE
(
  @TabId int
)
RETURNS datetime2
AS
BEGIN
  DECLARE @Result datetime2;
  SELECT @Result = TAB_UPDATE_AT
  FROM _TABLE
  WHERE TAB_ID = @TabId;
  RETURN @Result
END
GO
-- =============================================================================
-- Author:      Sébastien Adam
-- Create date: Dec2015
-- Description: Returns the list of the clients that are (un)liked by a client.
-- =============================================================================
CREATE FUNCTION GetFeeling
(
  @CliId int,
  @FtyId int = NULL
)
RETURNS @Feeling TABLE
(
  Feeling varchar(64),
  FirstName varchar(64),
  LastName varchar(64),
  ClientId int,
  FeelingTypeId int,
  ModifiedAt datetime2,
  ModifiedBy char(8)
)
AS
BEGIN
  IF @FtyId IS NULL BEGIN
    INSERT INTO @Feeling
    SELECT Feeling,
           ClientToFirstName,
           ClientToLastName,
           ClientToId,
           FeelingTypeId,
           ModifiedAt,
           ModifiedBy
    FROM Feeling
    WHERE ClientFromId = @CliId;
  END ELSE BEGIN
    INSERT INTO @Feeling
    SELECT Feeling,
           ClientToFirstName,
           ClientToLastName,
           ClientToId,
           FeelingTypeId,
           ModifiedAt,
           ModifiedBy
    FROM Feeling
    WHERE ClientFromId = @CliId
      AND FeelingTypeId = @FtyId;
  END
  RETURN
END
GO
-- =============================================================================
-- Author:      Sébastien Adam
-- Create date: Dec2015
-- Description: Returns the menu for a given reception.
-- =============================================================================
CREATE FUNCTION GetMenu
(
  @RecId int,
  @DtyId int = NULL
)
RETURNS @Menu TABLE
(
  DishType varchar(64),
  DishName varchar(64),
  DishId int,
  DishTypeId int,
  ModifiedAt datetime2,
  ModifiedBy char(8)
)
AS
BEGIN
  IF @DtyId IS NULL BEGIN
    INSERT INTO @Menu
    SELECT DishType,
           DishName,
           DishId,
           DishTypeId,
           ModifiedAt,
           ModifiedBy
    FROM Menu
    WHERE ReceptionID = @RecId;
  END ELSE BEGIN
    INSERT INTO @Menu
    SELECT DishType,
           DishName,
           DishId,
           DishTypeId,
           ModifiedAt,
           ModifiedBy
    FROM Menu
    WHERE ReceptionID = @RecId
      AND DishTypeId = @DtyId;
  END
  RETURN
END
GO
-- =============================================================================
-- Author:      Sébastien Adam
-- Create date: Dec2015
-- Description: Returns list of receptions that a customer can book.
-- =============================================================================
CREATE FUNCTION GetReservableReception
(
  @CliId int
)
RETURNS TABLE
AS
RETURN
(
  SELECT *
  FROM Reception
  WHERE CONVERT(date,[Date]) NOT IN (SELECT CONVERT(DATE,REC_DATE)
                                     FROM _RECEPTION
                                     WHERE REC_ID IN (SELECT BOO_REC_ID
                                                      FROM _BOOK
                                                      WHERE BOO_CLI_ID = @CLIID))
  AND BookingClosingDate > GETDATE()
  AND IsValid = 1
)
GO
-- =============================================================================
-- Author:      Sébastien Adam
-- Create date: Dec2015
-- Description: Returns the list of the clients who have booked for a reception.
-- =============================================================================
CREATE FUNCTION GetReservation
(
  @RecId int
)
RETURNS TABLE
AS
RETURN
(
  SELECT ClientFirstName,
         ClientLastName,
         IsValid,
         ClientId,
         ModifiedAt,
         ModifiedBy
  FROM Reservation
  WHERE ReceptionId = @RecId
)
GO
-- =============================================================================
-- Author:      Sébastien Adam
-- Create date: Dec2015
-- Description: Returns the list of the clients with the dishes they ordered for
--              a reception.
-- =============================================================================
CREATE FUNCTION GetReservedDish
(
  @RecId int,
  @CliId int = NULL
)
RETURNS @ReservedDish TABLE
(
  ClientFirstName varchar(64),
  ClientLastName varchar(64),
  DishType varchar(64),
  DishName varchar(64),
  ClientId int,
  DishId int,
  DishTypeId int,
  ModifiedAt datetime2,
  ModifiedBy char(8)
)
AS
BEGIN
  IF @CliId IS NULL BEGIN
    INSERT INTO @ReservedDish
    SELECT ClientFirstName,
           ClientLastName,
           DishType,
           DishName,
           ClientId,
           DishId,
           DishTypeId,
           ModifiedAt,
           ModifiedBy
    FROM ReservedDish
    WHERE ReceptionId = @RecId
  END ELSE BEGIN
    INSERT INTO @ReservedDish
    SELECT ClientFirstName,
           ClientLastName,
           DishType,
           DishName,
           ClientId,
           DishId,
           DishTypeId,
           ModifiedAt,
           ModifiedBy
    FROM ReservedDish
    WHERE ReceptionId = @RecId
      AND ClientId = @CliId
  END
  RETURN
END
GO
-- =============================================================================
-- Author:      Sébastien Adam
-- Create date: Dec2015
-- Description: Returns the list of the receptions booked by a client.
-- =============================================================================
CREATE FUNCTION GetReservedReception
(
  @CliId int
)
RETURNS TABLE
AS
RETURN
(
  SELECT ReceptionName,
         ReceptionDate,
         IsValid,
         ReceptionId,
         ModifiedAt,
         ModifiedBy
  FROM Reservation
  WHERE ClientId = @CliId
)
GO
-- =============================================================================
-- Author:      Sébastien Adam
-- Create date: Dec2015
-- Description: Returns the tables map for a reception.
-- =============================================================================
CREATE FUNCTION GetTablesMap
(
  @RecId int,
  @TabId int = NULL
)
RETURNS @TablesMap TABLE
(
  TableNumber int,
  ClientFirstName varchar(64),
  ClientLastName varchar(64),
  IsValid bit,
  ReceptionId int,
  TableId int,
  ClientId int,
  ModifiedAt datetime2,
  ModifiedBy char(8)
)
AS
BEGIN
  IF @TabId IS NULL BEGIN
    INSERT INTO @TablesMap
    SELECT TableNumber,
           ClientFirstName,
           ClientLastName,
           IsValid,
           ReceptionId,
           TableId,
           ClientId,
           ModifiedAt,
           ModifiedBy
    FROM TablesMap
    WHERE ReceptionId = @RecId;
  END ELSE BEGIN
    INSERT INTO @TablesMap
    SELECT TableNumber,
           ClientFirstName,
           ClientLastName,
           IsValid,
           ReceptionId,
           TableId,
           ClientId,
           ModifiedAt,
           ModifiedBy
    FROM TablesMap
    WHERE ReceptionId = @RecId
      AND TableId = @TabId;
  END
  RETURN
END
GO
-- =============================================================================
-- Author:      Sébastien Adam
-- Create date: Dec2015
-- Description: Returns the list of the clients that are NOT (un)liked by a
--              client.
-- =============================================================================
CREATE FUNCTION GetUnfeeling
(
  @CliId int
)
RETURNS TABLE
AS
RETURN
(
  SELECT FirstName, LastName, ClientId
  FROM Client
  WHERE ClientId NOT IN (SELECT ClientToId
                         FROM Feeling
                         WHERE ClientFromId = @CliId)
    AND ClientId <> @CliId
)
GO
-- =============================================================================
-- Author:      Sébastien Adam
-- Create date: Dec2015
-- Description: Returns the list of clients who have not reserved for a
--              reception.
-- =============================================================================
CREATE FUNCTION GetUnreservation
(
  @RecId int
)
RETURNS TABLE
AS
RETURN
(
  SELECT *
  FROM Client
  WHERE ClientId NOT IN (SELECT ClientId
                         FROM Reservation
                         WHERE ReceptionId = @RecId)
)
GO
-- =============================================================================
-- Author:      Sébastien Adam
-- Create date: Dec2015
-- Description: Returns the list of receptions that a customer has not reserved.
-- =============================================================================
CREATE FUNCTION GetUnreservedReception
(
  @CliId int
)
RETURNS TABLE
AS
RETURN
(
  SELECT *
  FROM Reception
  WHERE ReceptionId NOT IN (SELECT ReceptionId
                            FROM Reservation
                            WHERE ClientId = @CliId)
)
GO
-- =============================================================================
-- Author:      Sébastien Adam
-- Create date: Dec2015
-- Description: Returns the list of the dishes that are NOT (un)liked by a
--              client.
-- =============================================================================
CREATE FUNCTION GetUnwishedDish
(
  @CliId int
)
RETURNS TABLE
AS
RETURN
(
  SELECT [Type], Name, DishId, DishTypeId
  FROM Dish
  WHERE DishId NOT IN (SELECT DishId
                       FROM DishWish
                       WHERE ClientId = @CliId)
)
GO
-- =============================================================================
-- Author:      Sébastien Adam
-- Create date: Dec2015
-- Description: Returns the list of the dishes that are (un)liked by a client.
-- =============================================================================
CREATE FUNCTION GetWishedDish
(
  @CliId int,
  @FtyId int = NULL
)
RETURNS @DishWish TABLE (
  Feeling varchar(64) not null,
  DishType varchar(64) not null,
  DishName varchar(64) not null,
  DishId int not null,
  DishTypeId int not null,
  FeelingTypeId int not null,
  ModifiedAt datetime2,
  ModifiedBy char(8) not null
)
AS
BEGIN
  IF @FtyId IS NULL BEGIN
    INSERT INTO @DishWish
    SELECT Feeling,
           DishType,
           DishName,
           DishId,
           DishTypeId,
           FeelingTypeId,
           ModifiedAt,
           ModifiedBy
    FROM DishWish
    WHERE ClientId = @CliId;
  END ELSE BEGIN
    INSERT INTO @DishWish
    SELECT Feeling,
           DishType,
           DishName,
           DishId,
           DishTypeId,
           FeelingTypeId,
           ModifiedAt,
           ModifiedBy
    FROM DishWish
    WHERE ClientId = @CliId
      AND FeelingTypeId = @FtyId;
  END
  RETURN
END
GO
-- =============================================================================
-- Author:      Sébastien Adam
-- Create date: Dec2015
-- Description: Returns the list of the dishes to prepare for a reception.
-- =============================================================================
CREATE FUNCTION GetDishToPrepare
(
  @RecId int
)
RETURNS TABLE
AS
RETURN
(
  SELECT DishType,
         DishName,
         DishId,
         DishTypeId,
         COUNT(*) AS Quantity
  FROM ReservedDish
  WHERE ReceptionId = @RecId
  GROUP BY DishType, DishName, DishId, DishTypeId
)
GO

-- ========================================================================== --
--   Procédures stockées                                                      --
-- ========================================================================== --
-- =============================================================================
-- Author:      Sébastien Adam
-- Create date: Dec2015
-- Description: Assignes the validation bit of a reservation for a reception.
-- =============================================================================
CREATE PROCEDURE SP_VALIDATE_BOOK
  @RecId int,
  @CliId int
AS
BEGIN
  SET NOCOUNT ON;
  DECLARE @ValidStatus bit,
          @IsValid bit;
  IF (@RecId IS NOT NULL) AND (@CliId IS NOT NULL) BEGIN
    SET @IsValid = dbo.IS_VALID_BOOK(@RecId, @CliId);
    SELECT @ValidStatus = BOO_VALID
    FROM _BOOK
    WHERE BOO_REC_ID = @RecId AND BOO_CLI_ID = @CliId;
    IF @IsValid <> @ValidStatus BEGIN
      UPDATE _BOOK
      SET BOO_VALID = @IsValid
      WHERE BOO_CLI_ID = @CliId AND BOO_REC_ID = @RecId;
    END
  END
END
GO
-- =============================================================================
-- Author:      Sébastien Adam
-- Create date: Dec2015
-- Description: Assignes the validation bit of a reception. (BR004)
-- =============================================================================
CREATE PROCEDURE SP_VALIDATE_RECEPTION
  @RecId int
AS
BEGIN
  SET NOCOUNT ON;
  DECLARE @ValidStatus bit,
          @IsValid bit;
  IF @RecId IS NOT NULL BEGIN
    SET @IsValid = dbo.IS_VALID_RECEPTION(@RecId);
    SELECT @ValidStatus = REC_VALID
    FROM _RECEPTION
    WHERE REC_ID = @RecId;
    IF @IsValid <> @ValidStatus BEGIN
      UPDATE _RECEPTION
      SET REC_VALID = @IsValid
      WHERE REC_ID = @RecId;
    END
  END
END
GO
-- =============================================================================
-- Author:      Sébastien Adam
-- Create date: Dec2015
-- Description: Assignes the validation bit of a table for a reception.
-- =============================================================================
CREATE PROCEDURE SP_VALIDATE_TABLE
  @TabId int
AS
BEGIN
  SET NOCOUNT ON;
  DECLARE @ValidStatus bit,
          @IsValid bit;
  IF @TabId IS NOT NULL BEGIN
    SET @IsValid = dbo.IS_VALID_TABLE(@TabId);
    SELECT @ValidStatus = TAB_VALID
    FROM _TABLE
    WHERE TAB_ID = @TabId;
    IF @IsValid <> @ValidStatus BEGIN
      UPDATE _TABLE
      SET TAB_VALID = @IsValid
      WHERE TAB_ID = @TabId;
    END
  END
END
GO
-- =============================================================================
-- Author:      Sébastien Adam
-- Create date: Dec2015
-- Description: Delete a "dish wish"
-- =============================================================================
CREATE PROCEDURE DeleteDishWish
  @CliId int,
  @DisId int,
  @ModifiedAt datetime2
AS
BEGIN
  SET NOCOUNT ON;
  IF @ModifiedAt = dbo.UPDATE_AT_FEEL_CLI_DIS(@CliId,@DisId) BEGIN
    DELETE _FEEL_CLI_DIS
    WHERE FCD_CLI_ID = @CliId
      AND FCD_DIS_ID = @DisId;
  END ELSE BEGIN
    ;THROW 50000, 'Your record is not up to date', 1;
  END
END
GO
-- =============================================================================
-- Author:      Sébastien Adam
-- Create date: Dec2015
-- Description: Delete a feeling between clients
-- =============================================================================
CREATE PROCEDURE DeleteFeeling
  @CliFromId int,
  @CliToId int,
  @ModifiedAt datetime2
AS
BEGIN
  SET NOCOUNT ON;
  IF @ModifiedAt = dbo.UPDATE_AT_FEEL_CLI_CLI(@CliFromId,@CliToId) BEGIN
    DELETE _FEEL_CLI_CLI
    WHERE FCC_CLI_FROM_ID = @CliFromId
      AND FCC_CLI_TO_ID = @CliToId;
  END ELSE BEGIN
    ;THROW 50000, 'Your record is not up to date', 1;
  END
END
GO
-- =============================================================================
-- Author:      Sébastien Adam
-- Create date: Dec2015
-- Description: Delete the registration for a reception
-- =============================================================================
CREATE PROCEDURE DeleteReservation
  @RecId int,
  @CliId int,
  @ModifiedAt datetime2
AS
BEGIN
  SET NOCOUNT ON;
  IF @ModifiedAt = dbo.UPDATE_AT_BOOK(@RecId, @CliId) BEGIN
    DELETE _BOOK
    WHERE BOO_CLI_ID = @CliId
      AND BOO_REC_ID = @RecId;
  END ELSE BEGIN
    ;THROW 50000, 'Your record is not up to date', 1;
  END
END
GO
-- =============================================================================
-- Author:      Sébastien Adam
-- Create date: Dec2015
-- Description: Delete the reservation of a dish for a reception
-- =============================================================================
CREATE PROCEDURE DeleteReservedDish
  @CliId int,
  @DisId int,
  @RecId int,
  @ModifiedAt datetime2
AS
BEGIN
  SET NOCOUNT ON;
  IF @ModifiedAt = dbo.UPDATE_AT_CHOOSE(@CliId,@DisId,@RecId) BEGIN
    DELETE _CHOOSE
    WHERE CHO_CLI_ID = @CliId
      AND CHO_DIS_ID = @DisId
      AND CHO_REC_ID = @RecId;
  END ELSE BEGIN
    ;THROW 50000, 'Your record is not up to date', 1;
  END
END
GO
-- =============================================================================
-- Author:      Sébastien Adam
-- Create date: Dec2015
-- Description: Creates new feeling between clients
-- =============================================================================
CREATE PROCEDURE NewFeeling
  @CliFromId int,
  @CliToId int,
  @FtyId int,
  @ModifiedBy char(8)
AS
BEGIN
  SET NOCOUNT ON;
  IF (@CliFromId IS NOT NULL) AND (@CliToId IS NOT NULL) AND (@FtyId IS NOT NULL) AND (@ModifiedBy IS NOT NULL) BEGIN
    INSERT INTO _FEEL_CLI_CLI (FCC_CLI_FROM_ID, FCC_CLI_TO_ID, FCC_FTY_ID, FCC_UPDATE_BY)
    VALUES (@CliFromId, @CliToId, @FtyId, @ModifiedBy);
  END
END
GO
-- =============================================================================
-- Author:      Sébastien Adam
-- Create date: Jan2016
-- Description: Creates a reception.
-- =============================================================================
CREATE PROCEDURE NewReception
  @Name varchar(64),
  @Date datetime2,
  @ClosingReg datetime2,
  @Capacity int,
  @SeatsPerTable int,
  @ModifiedBy char(8),
  @RecId int OUTPUT
AS
BEGIN
  SET NOCOUNT ON;
  IF (@Name IS NOT NULL) AND (@Date IS NOT NULL) AND (@ClosingReg IS NOT NULL) AND (@Capacity IS NOT NULL) AND (@SeatsPerTable IS NOT NULL) AND (@ModifiedBy IS NOT NULL) BEGIN
    INSERT INTO _RECEPTION (REC_NAME, REC_DATE, REC_DATE_CLOSING_REG, REC_CAPACITY, REC_SEAT_TABLE, REC_UPDATE_BY)
    VALUES (@Name, @Date, @ClosingReg, @Capacity, @SeatsPerTable, @ModifiedBy);
    SET @RecId = IDENT_CURRENT('_RECEPTION');
  END
END
GO-- =============================================================================
-- Author:      Sébastien Adam
-- Create date: Dec2015
-- Description: Registers for a reception.
-- =============================================================================
CREATE PROCEDURE NewReservation
  @RecId int,
  @CliId int,
  @ModifiedBy char(8)
AS
BEGIN
  SET NOCOUNT ON;
  IF (@RecId IS NOT NULL) AND (@CliId IS NOT NULL) AND (@ModifiedBy IS NOT NULL) BEGIN
    INSERT INTO _BOOK (BOO_CLI_ID, BOO_REC_ID, BOO_UPDATE_BY)
    VALUES (@CliId, @RecId, @ModifiedBy);
  END
END
GO
-- =============================================================================
-- Author:      Sébastien Adam
-- Create date: Dec2015
-- Description: Chooses a dish for a reception.
-- =============================================================================
CREATE PROCEDURE NewReservedDish
  @CliId int,
  @DisId int,
  @RecId int,
  @ModifiedBy char(8)
AS
BEGIN
  SET NOCOUNT ON;
  IF (@CliId IS NOT NULL) AND (@DisId IS NOT NULL) AND (@RecId IS NOT NULL) AND (@ModifiedBy IS NOT NULL) BEGIN
    INSERT INTO _CHOOSE (CHO_CLI_ID, CHO_DIS_ID, CHO_REC_ID, CHO_UPDATE_BY)
    VALUES (@CliId, @DisId, @RecId, @ModifiedBy);
  END
END
GO
-- =============================================================================
-- Author:      Sébastien Adam
-- Create date: Dec2015
-- Description: Creates new "dish wish"
-- =============================================================================
CREATE PROCEDURE NewWishedDish
  @CliId int,
  @DisId int,
  @FtyId int,
  @ModifiedBy char(8)
AS
BEGIN
  SET NOCOUNT ON;
  IF (@CliId IS NOT NULL) AND (@DisId IS NOT NULL) AND (@FtyId IS NOT NULL) AND (@ModifiedBy IS NOT NULL) BEGIN
    INSERT INTO _FEEL_CLI_DIS (FCD_CLI_ID, FCD_DIS_ID, FCD_FTY_ID, FCD_UPDATE_BY)
    VALUES (@CliId, @DisId, @FtyId, @ModifiedBy);
  END
END
GO
-- =============================================================================
-- Author:      Sébastien Adam
-- Create date: Dec2015
-- Description: Update a feeling between clients
-- =============================================================================
CREATE PROCEDURE UpdateFeeling
  @CliFromId int,
  @CliToId int,
  @FtyId int,
  @ModifiedAt datetime2,
  @ModifiedBy char(8)
AS
BEGIN
  SET NOCOUNT ON;
  IF (@CliFromId IS NOT NULL) AND (@CliToId IS NOT NULL) AND (@FtyId IS NOT NULL) AND (@ModifiedAt IS NOT NULL) AND (@ModifiedBy IS NOT NULL) BEGIN
    IF @ModifiedAt = dbo.UPDATE_AT_FEEL_CLI_CLI(@CliFromId,@CliToId) BEGIN
      UPDATE _FEEL_CLI_CLI
      SET FCC_FTY_ID = @FtyId,
          FCC_UPDATE_BY = @ModifiedBy
      WHERE FCC_CLI_FROM_ID = @CliFromId
        AND FCC_CLI_TO_ID = @CliToId;
    END ELSE BEGIN
      ;THROW 50000, 'Your record is not up to date', 1;
    END
  END
END
GO
-- =============================================================================
-- Author:      Sébastien Adam
-- Create date: Dec2015
-- Description: Update a "dish wish"
-- =============================================================================
CREATE PROCEDURE UpdateWishedDish
  @CliId int,
  @DisId int,
  @DtyId int,
  @ModifiedAt datetime2,
  @ModifiedBy char(8)
AS
BEGIN
  SET NOCOUNT ON;
  IF (@CliId IS NOT NULL) AND (@DisId IS NOT NULL) AND (@DtyId IS NOT NULL) AND (@ModifiedAt IS NOT NULL) AND (@ModifiedBy IS NOT NULL) BEGIN
    IF @ModifiedAt = dbo.UPDATE_AT_FEEL_CLI_DIS(@CliId,@DisId) BEGIN
      UPDATE _FEEL_CLI_DIS
      SET FCD_FTY_ID = @DtyId,
          FCD_UPDATE_BY = @ModifiedBy
      WHERE FCD_CLI_ID = @CliId
        AND FCD_DIS_ID = @DisId;
    END ELSE BEGIN
      ;THROW 50000, 'Your record is not up to date', 1;
    END
  END
END
GO
-- =============================================================================
-- Author:      Sébastien Adam
-- Create date: Dec2015
-- Description: Removes a dish of a reception menu.
-- =============================================================================
CREATE PROCEDURE DeleteMenu
  @RecId int,
  @DisId int,
  @ModifiedAt datetime2
AS
BEGIN
  SET NOCOUNT ON;
  IF (@RecId IS NOT NULL) AND (@DisId IS NOT NULL) AND (@ModifiedAt IS NOT NULL) BEGIN
    IF @ModifiedAt = dbo.UPDATE_AT_OFFER(@RecId, @DisId) BEGIN
      DELETE FROM _OFFER
      WHERE OFF_REC_ID = @RecId
        AND OFF_DIS_ID = @DisId;
    END ELSE BEGIN
      ;THROW 50000, 'Your record is not up to date', 1;
    END
  END
END
GO
-- =============================================================================
-- Author:      Sébastien Adam
-- Create date: Dec2015
-- Description: Removes a client form a table.
-- =============================================================================
CREATE PROCEDURE DeleteSit
  @TabId int,
  @CliId int,
  @ModifiedAt datetime2
AS
BEGIN
  SET NOCOUNT ON;
  IF (@TabId IS NOT NULL) AND (@CliId IS NOT NULL) AND (@ModifiedAt IS NOT NULL) BEGIN
    IF @ModifiedAt = dbo.UPDATE_AT_SIT(@TabId,@CliId) BEGIN
      DELETE _SIT
      WHERE SIT_TAB_ID = @TabId
        AND SIT_CLI_ID = @CliId;
    END ELSE BEGIN
      ;THROW 50000, 'Your record is not up to date', 1;
    END
  END
END
GO
-- =============================================================================
-- Author:      Sébastien Adam
-- Create date: Dec2015
-- Description: Delete a table for a reception
-- =============================================================================
CREATE PROCEDURE DeleteTable
  @TabId int,
  @ModifiedAt datetime2
AS
BEGIN
  SET NOCOUNT ON;
  IF (@TabId IS NOT NULL) AND (@ModifiedAt IS NOT NULL) BEGIN
    IF @ModifiedAt = dbo.UPDATE_AT_TABLE(@TabId) BEGIN
      DELETE _TABLE
      WHERE TAB_ID = @TabId;
    END ELSE BEGIN
      ;THROW 50000, 'Your record is not up to date', 1;
    END
  END
END
GO
-- =============================================================================
-- Author:      Sébastien Adam
-- Create date: Dec2015
-- Description: Adds a dish on a reception menu.
-- =============================================================================
CREATE PROCEDURE NewMenu
  @RecId int,
  @DisId int,
  @ModifiedBy char(8)
AS
BEGIN
  SET NOCOUNT ON;
  IF (@RecId IS NOT NULL) AND (@DisId IS NOT NULL) AND (@ModifiedBy IS NOT NULL) BEGIN
    INSERT INTO _OFFER (OFF_DIS_ID, OFF_REC_ID, OFF_UPDATE_BY)
    VALUES (@DisId, @RecId, @ModifiedBy);
  END
END
GO
-- =============================================================================
-- Author:      Sébastien Adam
-- Create date: Dec2015
-- Description: Sit a client at a table.
-- =============================================================================
CREATE PROCEDURE NewSit
  @TabId int,
  @CliId int,
  @ModifiedBy char(8)
AS
BEGIN
  SET NOCOUNT ON;
  IF (@TabId IS NOT NULL) AND (@CliId IS NOT NULL) AND (@ModifiedBy IS NOT NULL) BEGIN
    INSERT INTO _SIT (SIT_TAB_ID, SIT_CLI_ID, SIT_UPDATE_BY)
    VALUES (@TabId, @CliId, @ModifiedBy);
  END
END
GO
-- =============================================================================
-- Author:      Sébastien Adam
-- Create date: Dec2015
-- Description: Creates a table for a reception.
-- =============================================================================
CREATE PROCEDURE NewTable
  @RecId int,
  @TableNumber int,
  @ModifiedBy char(8),
  @TabId int OUTPUT
AS
BEGIN
  SET NOCOUNT ON;
  DECLARE @NbSeats int;
  IF (@RecId IS NOT NULL) AND (@TableNumber IS NOT NULL) AND (@ModifiedBy IS NOT NULL) BEGIN
    SELECT @NbSeats = REC_SEAT_TABLE
    FROM _RECEPTION
    WHERE REC_ID = @RecId;
    IF @NbSeats IS NOT NULL BEGIN
      INSERT INTO _TABLE (TAB_REC_ID, TAB_NUMBER, TAB_SEATING, TAB_UPDATE_BY)
      VALUES (@RecId, @TableNumber, @NbSeats, @ModifiedBy);
      SELECT @TabId = TAB_ID
      FROM _TABLE
      WHERE TAB_NUMBER = @TableNumber
        AND TAB_REC_ID = @RecId;
    END
  END
END
GO

-- ========================================================================== --
--   Triggers                                                                 --
-- ========================================================================== --
-- =============================================================================
-- Author:      Sébastien Adam
-- Create date: Dec2015
-- Description: When delete a reservation, delete all dependenties
-- =============================================================================
CREATE TRIGGER TR_BOOK_DELETE
   ON _BOOK
   AFTER DELETE
AS
BEGIN
  SET NOCOUNT ON;
  DECLARE @CliId int,
          @RecId int;
  DECLARE DeleteCursorBook CURSOR
  FOR SELECT BOO_REC_ID, BOO_CLI_ID
      FROM deleted;
  OPEN DeleteCursorBook;
  FETCH DeleteCursorBook INTO @RecId, @CliId;
  WHILE @@FETCH_STATUS = 0 BEGIN
    DELETE FROM _CHOOSE
    WHERE CHO_CLI_ID = @CliId AND CHO_REC_ID = @RecId;
    DELETE FROM _SIT
    WHERE SIT_CLI_ID = @CliId AND SIT_TAB_ID IN (SELECT TAB_ID
                                                 FROM _TABLE
                                                 WHERE TAB_REC_ID = @RecId);
    FETCH DeleteCursorBook INTO @RecId, @CliId;
  END;
  CLOSE DeleteCursorBook;
  DEALLOCATE DeleteCursorBook;
END
GO
-- =============================================================================
-- Author:      Sébastien Adam
-- Create date: Dec2015
-- Description: Automatically assigns the modification date and the user who
--              made it. Verifies that:
--              - the reception is valid (BR006)
--              - the reception is not full (BR007)
--              - the registration for the reception is not closed (BR001)
--              - the client does not register many receptions that go together
--                (BR009)
--              Also assigns the validation bit for the resrvation.
-- =============================================================================
CREATE TRIGGER TR_BOOK_INSERTUPDATE
   ON _BOOK
   AFTER INSERT, UPDATE
AS
BEGIN
  SET NOCOUNT ON;
  DECLARE @RecId int,
          @CliId int,
          @Error int,
          @RecDate datetime2,
          @RecCloseDate datetime2,
          @Now datetime2,
          @RecCapacity int;
  SET @Error = 0;
  DECLARE InsertCursorBook CURSOR
  FOR SELECT BOO_REC_ID, BOO_CLI_ID
      FROM inserted;
  OPEN InsertCursorBook;
  FETCH InsertCursorBook INTO @RecId, @CliId;
  WHILE @@FETCH_STATUS = 0 BEGIN
    IF dbo.IS_VALID_RECEPTION(@RecId) <> 1 BEGIN -- BR006
      SET @Error = 50006;
      BREAK;
    END
    SELECT @RecDate = REC_DATE, @RecCloseDate = REC_DATE_CLOSING_REG, @RecCapacity = REC_CAPACITY
    FROM _RECEPTION
    WHERE REC_ID = @RecId;
    SET @Now = GETDATE();
    IF EXISTS(SELECT *
              FROM _BOOK
              WHERE BOO_REC_ID = @RecId
              HAVING COUNT(*) > @RecCapacity) BEGIN -- BR007
      SET @Error = 50007;
      BREAK;
    END
    IF @RecCloseDate < @Now BEGIN -- BR001
      SET @Error = 50001;
      BREAK;
    END
    IF EXISTS(SELECT *
              FROM _RECEPTION
              WHERE REC_ID IN (SELECT BOO_REC_ID
                               FROM _BOOK
                               WHERE BOO_CLI_ID = @CliId)
                AND REC_ID <> @RecId
                AND CONVERT(DATE,REC_DATE) = CONVERT(DATE,@RecDate)) BEGIN -- BR009
      SET @Error = 50009;
      BREAK;
    END
    UPDATE _BOOK
    SET BOO_UPDATE_AT = @Now,
--         BOO_UPDATE_BY = CURRENT_USER,
        BOO_VALID = dbo.IS_VALID_BOOK(@RecId, @CliId) -- BR010 (partial)
    WHERE BOO_REC_ID = @RecId AND BOO_CLI_ID = @CliId;
    FETCH InsertCursorBook INTO @RecId, @CliId;
  END;
  CLOSE InsertCursorBook;
  DEALLOCATE InsertCursorBook;
  IF @Error <> 0 BEGIN
    ROLLBACK;
    THROW @Error, 'Fail to book a reception.', 1;
  END
END
GO
-- =============================================================================
-- Author:      Sébastien Adam
-- Create date: Dec2015
-- Description: Update reservation validation tag.
-- =============================================================================
CREATE TRIGGER TR_CHOOSE_DELETE
  ON _CHOOSE
  AFTER DELETE
AS
BEGIN
  SET NOCOUNT ON;
  DECLARE @CliId int,
          @RecId int;
  DECLARE DeleteCursorChoose CURSOR
  FOR SELECT CHO_REC_ID, CHO_CLI_ID
      FROM deleted;
  OPEN DeleteCursorChoose;
  FETCH DeleteCursorChoose INTO @RecId, @CliId;
  WHILE @@FETCH_STATUS = 0 BEGIN
    EXECUTE SP_VALIDATE_BOOK @RecId, @CliId;
    FETCH DeleteCursorChoose INTO @RecId, @CliId;
  END;
  CLOSE DeleteCursorChoose;
  DEALLOCATE DeleteCursorChoose;
END
GO
-- =============================================================================
-- Author:      Sébastien Adam
-- Create date: Dec2015
-- Description: Automatically assigns the modification date and the user who
--              made it. Also ensures that:
--              - the customer has booked for the reception for which he chooses
--                his dish (BR012)
--              - the chosen dish is proposed at the chosen reception (BR011)
--              - the customer provided only one dish of each type for a given
--                reception (BR014)
--              If the customer chose a dish of each type, validate booking.
-- =============================================================================
CREATE TRIGGER TR_CHOOSE_INSERTUPDATE
  ON  _CHOOSE
  AFTER INSERT,UPDATE
AS
BEGIN
  SET NOCOUNT ON;
  DECLARE @CliId int,
          @DisId int,
          @RecId int,
          @Error int;
  SET @Error = 0;
  DECLARE InsertCursorChoose CURSOR
  FOR SELECT CHO_CLI_ID, CHO_DIS_ID, CHO_REC_ID
      FROM inserted;
  OPEN InsertCursorChoose;
  FETCH InsertCursorChoose INTO @CliId, @DisId, @RecId;
  WHILE @@FETCH_STATUS = 0 BEGIN
    IF NOT EXISTS(SELECT *
                  FROM _BOOK
                  WHERE BOO_CLI_ID = @CliId AND BOO_REC_ID = @RecId) BEGIN -- BR012
      SET @Error = 50012;
      BREAK;
    END
    IF NOT EXISTS(SELECT *
                  FROM _OFFER
                  WHERE OFF_DIS_ID = @DisId AND OFF_REC_ID = @RecId) BEGIN -- BR011
      SET @Error = 50011;
      BREAK;
    END
    IF EXISTS(SELECT *
              FROM _DISH
              WHERE DIS_ID = @DisId
                AND DIS_TYPE IN (SELECT DIS_TYPE
                                 FROM _CHOOSE, _DISH
                                 WHERE CHO_DIS_ID = DIS_ID
                                   AND CHO_CLI_ID = @CliId
                                   AND CHO_REC_ID = @RecId
                                   AND CHO_DIS_ID <> @DisId)) BEGIN -- BR014
      SET @Error = 50014;
      BREAK;
    END
    UPDATE _CHOOSE
    SET CHO_UPDATE_AT = GETDATE()--,
--         CHO_UPDATE_BY = CURRENT_USER
    WHERE CHO_CLI_ID = @CliId AND CHO_DIS_ID = @DisId AND CHO_REC_ID = @RecId;
    EXECUTE SP_VALIDATE_BOOK @RecId, @CliId;
    FETCH InsertCursorChoose INTO @CliId, @DisId, @RecId;
  END;
  CLOSE InsertCursorChoose;
  DEALLOCATE InsertCursorChoose;
  IF @Error <> 0 BEGIN
    ROLLBACK;
    THROW @Error, 'Fail to choose a dish for a reception.', 1;
  END
END
GO
-- =============================================================================
-- Author:      Sébastien Adam
-- Create date: Dec2015
-- Description: Automatically assigns the modification date and the user who
--              made it.
-- =============================================================================
CREATE TRIGGER TR_CLIENT_INSERTUPDATE
   ON _CLIENT
   AFTER INSERT, UPDATE
AS
BEGIN
  SET NOCOUNT ON;
  UPDATE _CLIENT
  SET CLI_UPDATE_AT = GETDATE(),
--       CLI_UPDATE_BY = CURRENT_USER,
      CLI_SEX = UPPER(CLI_SEX)
  WHERE CLI_ID IN (SELECT CLI_ID FROM inserted);
END
GO
-- =============================================================================
-- Author:      Sébastien Adam
-- Create date: Dec2015
-- Description: Automatically assigns the modification date and the user who
--              made it.
-- =============================================================================
CREATE TRIGGER TR_DISH_INSERTUPDATE
   ON _DISH
   AFTER INSERT, UPDATE
AS
BEGIN
  SET NOCOUNT ON;
  UPDATE _DISH
  SET DIS_UPDATE_AT = GETDATE()--,
--       DIS_UPDATE_BY = CURRENT_USER
  WHERE DIS_ID IN (SELECT DIS_ID FROM inserted);
END
GO
-- =============================================================================
-- Author:      Sébastien Adam
-- Create date: Dec2015
-- Description: Automatically assigns the modification date and the user who
--              made it. Also prohibit a client to feel something to himself
--              (BR016)
-- =============================================================================
CREATE TRIGGER TR_FEEL_CLI_CLI_INSERTUPDATE
   ON _FEEL_CLI_CLI
   AFTER INSERT, UPDATE
AS
BEGIN
  SET NOCOUNT ON;
  DECLARE @CliFromId int,
          @CliToId int,
          @Error int;
  SET @Error = 0;
  DECLARE InsertCursorFeelCC CURSOR
  FOR SELECT FCC_CLI_FROM_ID, FCC_CLI_TO_ID
      FROM inserted;
  OPEN InsertCursorFeelCC;
  FETCH InsertCursorFeelCC INTO @CliFromId, @CliToId;
  WHILE @@FETCH_STATUS = 0 BEGIN
    IF @CliFromId = @CliToId BEGIN -- BR016
      SET @Error = 50016;
      BREAK
    END
    UPDATE _FEEL_CLI_CLI
    SET FCC_UPDATE_AT = GETDATE()--,
--         FCC_UPDATE_BY = CURRENT_USER
    WHERE FCC_CLI_FROM_ID = @CliFromId
      AND FCC_CLI_TO_ID = @CliToId;
    FETCH InsertCursorFeelCC INTO @CliFromId, @CliToId;
  END;
  CLOSE InsertCursorFeelCC;
  DEALLOCATE InsertCursorFeelCC;
  IF @Error <> 0 BEGIN
    ROLLBACK;
    THROW @Error, 'Fail to add client feeling for a client.', 1;
  END
END
GO
-- =============================================================================
-- Author:      Sébastien Adam
-- Create date: Dec2015
-- Description: Automatically assigns the modification date and the user who
--              made it.
-- =============================================================================
CREATE TRIGGER TR_FEEL_CLI_DIS_INSERTUPDATE
   ON _FEEL_CLI_DIS
   AFTER INSERT, UPDATE
AS
BEGIN
  SET NOCOUNT ON;
  DECLARE @CliId int,
          @DisId int;
  DECLARE InsertCursorFeelCD CURSOR
  FOR SELECT FCD_CLI_ID, FCD_DIS_ID
      FROM inserted;
  OPEN InsertCursorFeelCD;
  FETCH InsertCursorFeelCD INTO @CliId, @DisId;
  WHILE @@FETCH_STATUS = 0 BEGIN
    UPDATE _FEEL_CLI_DIS
    SET FCD_UPDATE_AT = GETDATE()--,
--         FCD_UPDATE_BY = CURRENT_USER
    WHERE FCD_CLI_ID = @CliId AND FCD_DIS_ID = @DisId;
    FETCH InsertCursorFeelCD INTO @CliId, @DisId;
  END;
  CLOSE InsertCursorFeelCD;
  DEALLOCATE InsertCursorFeelCD;
END
GO
-- =============================================================================
-- Author:      Sébastien Adam
-- Create date: Dec2015
-- Description: Automatically assigns the modification date and the user who
--              made it. Also validates the correspondig reception when a type
--              of each dish is offered. (BR004)
-- =============================================================================
CREATE TRIGGER TR_OFFER_INSERTUPDATE
   ON _OFFER
   AFTER INSERT, UPDATE
AS
BEGIN
  SET NOCOUNT ON;
  DECLARE @RecId int,
          @DisId int,
          @Valid bit;
  DECLARE InsertCursorOffer CURSOR
  FOR SELECT OFF_REC_ID, OFF_DIS_ID
      FROM inserted;
  OPEN InsertCursorOffer;
  FETCH InsertCursorOffer INTO @RecId, @DisId;
  WHILE @@FETCH_STATUS = 0 BEGIN
    UPDATE _OFFER
    SET OFF_UPDATE_AT = GETDATE()--,
--         OFF_UPDATE_BY = CURRENT_USER
    WHERE OFF_REC_ID = @RecId
      AND OFF_DIS_ID = @DisId;
    EXECUTE SP_VALIDATE_RECEPTION @RecId;
    FETCH InsertCursorOffer INTO @RecId, @DisId;
  END;
  CLOSE InsertCursorOffer;
  DEALLOCATE InsertCursorOffer;
END
GO
-- =============================================================================
-- Author:      Sébastien Adam
-- Create date: Dec2015
-- Description: Automatically assigns the modification date and the user who
--              made it. Also ensures that the closing date for the
--              registrations is after the date of the reception (BR002).  Also
--              assigns the validation bit. (BR004)
-- =============================================================================
CREATE TRIGGER TR_RECEPTION_INSERTUPDATE
   ON _RECEPTION
   AFTER INSERT, UPDATE
AS
BEGIN
  SET NOCOUNT ON;
  DECLARE @RecId int,
          @RecDate datetime2,
          @RecEndBook datetime2,
          @Error int;
  SET @Error = 0;
  DECLARE InsertCursorReception CURSOR
  FOR SELECT REC_ID, REC_DATE, REC_DATE_CLOSING_REG
      FROM inserted;
  OPEN InsertCursorReception;
  FETCH InsertCursorReception INTO @RecId, @RecDate, @RecEndBook;
  WHILE @@FETCH_STATUS = 0 BEGIN
    IF @RecEndBook > @RecDate BEGIN -- BR002
      SET @Error = 50002;
      BREAK;
    END
    UPDATE _RECEPTION
    SET REC_UPDATE_AT = GETDATE(),
--         REC_UPDATE_BY = CURRENT_USER,
        REC_VALID = dbo.IS_VALID_RECEPTION(@RecId) -- BR004 (partial)
    WHERE REC_ID = @RecId;
    FETCH InsertCursorReception INTO @RecId, @RecDate, @RecEndBook;
  END;
  CLOSE InsertCursorReception;
  DEALLOCATE InsertCursorReception;
  IF @Error <> 0 BEGIN
    ROLLBACK;
    THROW @Error, 'Fail to add reception.', 1;
  END
END
GO
-- =============================================================================
-- Author:      Sébastien Adam
-- Create date: Dec2015
-- Description: Update the validation bit of a table.
-- =============================================================================
CREATE TRIGGER TR_SIT_DELETE
  ON _SIT
  AFTER DELETE
AS
BEGIN
  SET NOCOUNT ON;
  DECLARE @TabId int;
  DECLARE DeleteCursorTable CURSOR
  FOR SELECT DISTINCT SIT_TAB_ID
      FROM deleted;
  OPEN DeleteCursorTable;
  FETCH DeleteCursorTable INTO @TabId;
  WHILE @@FETCH_STATUS = 0 BEGIN
    EXECUTE SP_VALIDATE_TABLE @TabId;
    FETCH DeleteCursorTable INTO @TabId;
  END;
  CLOSE DeleteCursorTable;
  DEALLOCATE DeleteCursorTable;
END
GO
-- =============================================================================
-- Author:      Sébastien Adam
-- Create date: Dec2015
-- Description: Automatically assigns the modification date and the user who
--              made it. Also ensure that:
--              - there are no more client sitting at a table that seats at the
--                table. (BR020)
--              - a client is registered at the reception to sit down. (BR021)
--              - a client does not sit at several tables in the same reception.
--                (BR022)
--              Also assign the validation bit of the table. (BR019)
-- =============================================================================
CREATE TRIGGER TR_SIT_INSERTUPDATE
   ON _SIT
   AFTER INSERT, UPDATE
AS
BEGIN
  SET NOCOUNT ON;
  DECLARE @TabId int,
          @CliId int,
          @RecId int,
          @Error int;
  SET @Error = 0;
  DECLARE InsertCursorSit CURSOR
  FOR SELECT DISTINCT SIT_TAB_ID
      FROM inserted;
  OPEN InsertCursorSit;
  FETCH InsertCursorSit INTO @TabId;
  WHILE @@FETCH_STATUS = 0 BEGIN
    IF EXISTS(SELECT COUNT(*)
              FROM _SIT
              WHERE SIT_TAB_ID = @TabId
              GROUP BY SIT_TAB_ID
              HAVING COUNT(*) > (SELECT TAB_SEATING
                                 FROM _TABLE
                                 WHERE TAB_ID = @TabId)) BEGIN -- BR020
      SET @Error = 50020;
      BREAK;
    END
    FETCH InsertCursorSit INTO @TabId;
  END
  CLOSE InsertCursorSit;
  DEALLOCATE InsertCursorSit;
  IF @Error = 0 BEGIN
    DECLARE InsertCursorSit CURSOR
    FOR SELECT SIT_TAB_ID, SIT_CLI_ID
        FROM inserted;
    OPEN InsertCursorSit;
    FETCH InsertCursorSit INTO @TabId, @CliId;
    WHILE @@FETCH_STATUS = 0 BEGIN
      SELECT @RecId = TAB_REC_ID
      FROM _TABLE
      WHERE TAB_ID = @TabId;
      IF NOT EXISTS(SELECT *
                    FROM _BOOK
                    WHERE BOO_CLI_ID = @CliId AND BOO_REC_ID = @RecId) BEGIN -- BR021
        SET @Error = 50021;
        BREAK;
      END
      IF EXISTS(SELECT *
                FROM _SIT
                WHERE SIT_CLI_ID = @CliId
                  AND SIT_TAB_ID <> @TabId
                  AND SIT_TAB_ID IN (SELECT TAB_ID
                                     FROM _TABLE
                                     WHERE TAB_REC_ID = @RecId)) BEGIN -- BR022
        SET @Error = 50022;
        BREAK;
      END
      UPDATE _SIT
      SET SIT_UPDATE_AT = GETDATE()--,
--           SIT_UPDATE_BY = CURRENT_USER
      WHERE SIT_TAB_ID = @TabId AND SIT_CLI_ID = @CliId;
      FETCH InsertCursorSit INTO @TabId, @CliId;
    END;
    CLOSE InsertCursorSit;
    DEALLOCATE InsertCursorSit;
  END
  IF @Error = 0 BEGIN
    DECLARE InsertCursorSit CURSOR
    FOR SELECT DISTINCT SIT_TAB_ID
        FROM inserted;
    OPEN InsertCursorSit;
    FETCH InsertCursorSit INTO @TabId;
    WHILE @@FETCH_STATUS = 0 BEGIN
      EXECUTE SP_VALIDATE_TABLE @TabId; -- BR019 (partial)
      FETCH InsertCursorSit INTO @TabId;
    END
    CLOSE InsertCursorSit;
  END
  DEALLOCATE InsertCursorSit;
  IF @Error <> 0 BEGIN
    ROLLBACK;
    THROW @Error, 'Fail to sit a client.', 1;
  END
END
GO
-- =============================================================================
-- Author:      Sébastien Adam
-- Create date: Dec2015
-- Description: Automatically assigns the modification date and the user who
--              made it.
-- =============================================================================
CREATE TRIGGER TR_TABLE_INSERTUPDATE
   ON _TABLE
   AFTER INSERT, UPDATE
AS
BEGIN
  SET NOCOUNT ON;
  DECLARE @TabId int;
  DECLARE InsertCursorTable CURSOR
  FOR SELECT DISTINCT TAB_ID
      FROM inserted;
  OPEN InsertCursorTable;
  FETCH InsertCursorTable INTO @TabId;
  WHILE @@FETCH_STATUS = 0 BEGIN
    UPDATE _TABLE
    SET TAB_UPDATE_AT = GETDATE(),
--         TAB_UPDATE_BY = CURRENT_USER,
        TAB_VALID = dbo.IS_VALID_TABLE(@TabId) -- BR019 (partial)
    WHERE TAB_ID = @TabId;
    FETCH InsertCursorTable INTO @TabId;
  END;
  CLOSE InsertCursorTable;
  DEALLOCATE InsertCursorTable;
END
GO
