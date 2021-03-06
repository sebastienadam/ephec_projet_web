USE ProjetWEB;
GO
DECLARE @i int,
        @Id int,
        @Id2 int,
        @RandInt int,
        @Group varchar(64);
-- Réceptions ------------------------------------------------------------------
SET @i = 1;
SET @RandInt = -ROUND(RAND()*4,0)-4;
WHILE @i < 25 BEGIN
    INSERT INTO _RECEPTION (REC_NAME, REC_DATE, REC_DATE_CLOSING_REG, REC_CAPACITY, REC_SEAT_TABLE)
    VALUES ('Réception '+CONVERT(varchar,@i),
            GETDATE()+@RandInt,
            GETDATE()+@RandInt-1,
            ROUND(RAND()*4,0)*25+150,
            ROUND(RAND()*4,0)*2+4);
    SET @RandInt = @RandInt + ROUND(RAND()*4,0);
    SET @i = @i + 1;
END
-- Plats -----------------------------------------------------------------------
SET @i = 1;
WHILE @i < 13 BEGIN
    INSERT INTO _DISH (DIS_NAME, DIS_TYPE)
    VALUES ('Entrée '+CONVERT(varchar,@i), 1),
           ('Plat principal '+CONVERT(varchar,@i), 2),
           ('Dessert '+CONVERT(varchar,@i), 3);
    SET @i = @i + 1;
END
-- Clients ---------------------------------------------------------------------
SET @i = 1;
SET @Group = 'Manager'
WHILE @i < 1025 BEGIN
  IF @i = 4 BEGIN
    SET @Group = 'Client'
  END
  INSERT INTO _CLIENT (CLI_ACRONYM, CLI_EMAIL, CLI_PASSWORD, CLI_GROUP, CLI_FNAME, CLI_LNAME, CLI_SEX, CLI_BDAY, CLI_JOB)
  VALUES('nopr'+REPLICATE('0',4-LEN(RTRIM(@i))) + RTRIM(@i),
         'nopr'+REPLICATE('0',4-LEN(RTRIM(@i))) + RTRIM(@i)+'@nowhere.com',
         'password',
         @Group,
         'Prénom '++CONVERT(varchar,@i),
         'Nom '+CONVERT(varchar,@i),
         (SELECT TOP 1 sex FROM (VALUES ('M'),('m'),('F'),('f')) sexs(sex) ORDER BY NEWID()),
         GETDATE()-8196+ROUND(RAND()*2048,0),
         (SELECT TOP 1 job FROM (VALUES ('agronome'),
                                        ('bibliothécaire'),
                                        ('comptable'),
                                        ('diplomate'),
                                        ('ethnologue'),
                                        ('fiscaliste'),
                                        ('garagiste'),
                                        ('homéopathe'),
                                        ('infographiste'),
                                        ('juge'),
                                        ('kinésithérapeute'),
                                        ('libraire'),
                                        ('maître chien'),
                                        ('nutritionniste'),
                                        ('orthopédiste'),
                                        ('peintre'),
                                        ('réceptionniste'),
                                        ('secrétaire'),
                                        ('tabacologue'),
                                        ('urbaniste'),
                                        ('vétérinaire'),
                                        ('webmaster'),
                                        ('zoologiste')) jobs(job) ORDER BY NEWID()));
  SET @i = @i + 1;
END
-- Menus -----------------------------------------------------------------------
DECLARE InsertCursor CURSOR
FOR SELECT REC_ID
    FROM _RECEPTION;
OPEN InsertCursor;
FETCH InsertCursor INTO @Id;
WHILE @@FETCH_STATUS = 0 BEGIN
  SET @RandInt = ROUND(RAND()*9,0)
  SET @i = 0;
  WHILE @i < @RandInt BEGIN
    INSERT INTO _OFFER (OFF_DIS_ID, OFF_REC_ID)
    VALUES ((SELECT TOP 1 DIS_ID FROM _DISH WHERE DIS_ID NOT IN (SELECT OFF_DIS_ID FROM _OFFER WHERE OFF_REC_ID = @Id) ORDER BY NEWID()),
            @Id);
    SET @i = @i + 1;
  END
  FETCH InsertCursor INTO @Id;
END
CLOSE InsertCursor;
DEALLOCATE InsertCursor;
-- Relations entre les clients -------------------------------------------------
DECLARE InsertCursor CURSOR
FOR SELECT CLI_ID
    FROM _CLIENT;
OPEN InsertCursor;
FETCH InsertCursor INTO @Id;
WHILE @@FETCH_STATUS = 0 BEGIN
  SET @RandInt = ROUND(RAND()*32,0)
  SET @i = 0;
  WHILE @i < @RandInt BEGIN
    INSERT INTO _FEEL_CLI_CLI (FCC_CLI_FROM_ID, FCC_CLI_TO_ID,FCC_FTY_ID)
    VALUES (@Id,
            (SELECT TOP 1 CLI_ID FROM _CLIENT WHERE CLI_ID <> @Id AND CLI_ID NOT IN (SELECT FCC_CLI_TO_ID FROM _FEEL_CLI_CLI WHERE FCC_CLI_FROM_ID = @Id) ORDER BY NEWID()),
            (SELECT TOP 1 FTY_ID FROM _FEELINGTYPE ORDER BY NEWID()));
    SET @i = @i +1;
  END
  FETCH InsertCursor INTO @Id;
END
CLOSE InsertCursor;
DEALLOCATE InsertCursor;
-- Appréciation des plats par les clients --------------------------------------
DECLARE InsertCursor CURSOR
FOR SELECT CLI_ID
    FROM _CLIENT;
OPEN InsertCursor;
FETCH InsertCursor INTO @Id;
WHILE @@FETCH_STATUS = 0 BEGIN
  SET @RandInt = ROUND(RAND()*16,0)
  SET @i = 0;
  WHILE @i < @RandInt BEGIN
    INSERT INTO _FEEL_CLI_DIS (FCD_CLI_ID, FCD_DIS_ID,FCD_FTY_ID)
    VALUES (@Id,
            (SELECT TOP 1 DIS_ID FROM _DISH WHERE DIS_ID NOT IN (SELECT FCD_DIS_ID FROM _FEEL_CLI_DIS WHERE FCD_CLI_ID = @Id) ORDER BY NEWID()),
            (SELECT TOP 1 FTY_ID FROM _FEELINGTYPE ORDER BY NEWID()));
    SET @i = @i +1;
  END
  FETCH InsertCursor INTO @Id;
END
CLOSE InsertCursor;
DEALLOCATE InsertCursor;
-- Inscsription aux réceptions -------------------------------------------------
DECLARE InsertCursor CURSOR
FOR SELECT CLI_ID
    FROM _CLIENT;
OPEN InsertCursor;
FETCH InsertCursor INTO @Id;
WHILE @@FETCH_STATUS = 0 BEGIN
  IF ROUND(RAND()*2,0) = 0 BEGIN
    SET @RandInt = ROUND(RAND()*8,0)
    SET @i = 0;
    WHILE @i < @RandInt BEGIN
      SELECT TOP 1 @Id2 = REC_ID
      FROM _RECEPTION
      WHERE CONVERT(DATE,REC_DATE) NOT IN (SELECT CONVERT(DATE,REC_DATE)
                                           FROM _RECEPTION
                                           WHERE REC_ID IN (SELECT BOO_REC_ID
                                                            FROM _BOOK
                                                            WHERE BOO_CLI_ID = @Id))
        AND REC_VALID = 1
        AND REC_DATE_CLOSING_REG > GETDATE()
        AND REC_CAPACITY > (SELECT COUNT(*)
                            FROM _BOOK
                            WHERE BOO_CLI_ID = @Id)
      ORDER BY NEWID();
      IF @Id2 IS NOT NULL BEGIN
        INSERT INTO _BOOK (BOO_CLI_ID, BOO_REC_ID)
        VALUES (@Id,@Id2);
        IF ROUND(RAND()*3,0) <> 0 BEGIN
          INSERT INTO _CHOOSE (CHO_CLI_ID, CHO_DIS_ID, CHO_REC_ID)
          VALUES (@Id,
                  (SELECT TOP 1 DIS_ID
                   FROM _DISH
                   WHERE DIS_ID IN (SELECT OFF_DIS_ID FROM _OFFER WHERE OFF_REC_ID = @Id2)
                     AND DIS_TYPE = 1
                   ORDER BY NEWID()),
                  @Id2);
        END
        IF ROUND(RAND()*3,0) <> 0 BEGIN
          INSERT INTO _CHOOSE (CHO_CLI_ID, CHO_DIS_ID, CHO_REC_ID)
          VALUES (@Id,
                  (SELECT TOP 1 DIS_ID
                   FROM _DISH
                   WHERE DIS_ID IN (SELECT OFF_DIS_ID FROM _OFFER WHERE OFF_REC_ID = @Id2)
                     AND DIS_TYPE = 2
                   ORDER BY NEWID()),
                  @Id2);
        END
        IF ROUND(RAND()*3,0) <> 0 BEGIN
          INSERT INTO _CHOOSE (CHO_CLI_ID, CHO_DIS_ID, CHO_REC_ID)
          VALUES (@Id,
                  (SELECT TOP 1 DIS_ID
                   FROM _DISH
                   WHERE DIS_ID IN (SELECT OFF_DIS_ID FROM _OFFER WHERE OFF_REC_ID = @Id2)
                     AND DIS_TYPE = 3
                   ORDER BY NEWID()),
                  @Id2);
        END
      END ELSE BEGIN
        BREAK;
      END
      SET @i = @i +1;
    END
  END
  FETCH InsertCursor INTO @Id;
END
CLOSE InsertCursor;
DEALLOCATE InsertCursor;

SELECT * FROM Client;
SELECT * FROM Dish;
SELECT * FROM DishWish;
SELECT * FROM Feeling;
SELECT * FROM Menu;
SELECT * FROM Reception;
SELECT * FROM Reservation;
SELECT * FROM ReservedDish;
