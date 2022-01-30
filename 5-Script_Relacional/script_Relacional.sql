-- -----------------------------------------------------
-- DISEÑO DEL SISTEMA DE INFORMACIÓN (DSI).
-- BASES DE DATOS.
--
-- PROYECTO: Servicio de subscripción de Indev.
-- Ref: SCRIPT
--
-- Autores:
--      Jaime Simeón Palomar Blumenthal   alu0101228587
--      Alberto Cruz Luis                 alu0101217734
--      Cristo García González            alu0101204512
--      Antonella Sofía García Álvarez    alu0101227610
-- -----------------------------------------------------


-- -----------------------------------------------------
-- Tabla Usuario
-- -----------------------------------------------------
DROP TABLE IF EXISTS Usuario CASCADE;

CREATE TABLE IF NOT EXISTS Usuario (
    Email VARCHAR(45) NOT NULL,
    Contraseña VARCHAR(45) NOT NULL,
    Nombre VARCHAR(45) NOT NULL UNIQUE,
    Imagen BYTEA NULL,

    PRIMARY KEY (Email)
);


-- -----------------------------------------------------
-- Tabla Basico
-- -----------------------------------------------------
DROP TABLE IF EXISTS Basico CASCADE;

CREATE TABLE IF NOT EXISTS Basico (
    Email VARCHAR(45) NOT NULL,
    Contraseña VARCHAR(45) NOT NULL,
    Nombre VARCHAR(45) NOT NULL UNIQUE,
    Imagen BYTEA NULL,

    PRIMARY KEY (Email)
);


-- -----------------------------------------------------
-- Tabla No_Basico
-- -----------------------------------------------------
DROP TABLE IF EXISTS No_Basico CASCADE;

CREATE TABLE IF NOT EXISTS No_Basico (
    Email VARCHAR(45) NOT NULL,
    Contraseña VARCHAR(45) NOT NULL,
    Nombre VARCHAR(45) NOT NULL UNIQUE,
    Imagen BYTEA NULL,
    Tipo VARCHAR(7) NULL CHECK (Tipo = 'Premium' OR Tipo = 'Deluxe'),

    PRIMARY KEY (Email)
);


-- -----------------------------------------------------
-- Tabla Categoria
-- -----------------------------------------------------
DROP TABLE IF EXISTS Categoria CASCADE;

CREATE TABLE IF NOT EXISTS Categoria (
    Nombre VARCHAR(50) NOT NULL,
    Num_Titulos INT NULL,

    PRIMARY KEY (Nombre)
);


-- -----------------------------------------------------
-- Tabla Videojuego
-- -----------------------------------------------------
DROP TABLE IF EXISTS Videojuego CASCADE;

CREATE TABLE IF NOT EXISTS Videojuego (
    Distribuidora VARCHAR(45) NOT NULL,
    Nombre VARCHAR(45) NOT NULL,
    Año DATE NOT NULL CHECK (Año > 'Jan-01-1950' AND Año < CURRENT_DATE),
    PEGI INT NULL CHECK (PEGI IN (3, 7, 12, 16, 18)),

    PRIMARY KEY (Distribuidora, Nombre, Año)
);

-- -----------------------------------------------------
-- Tabla Externo
-- -----------------------------------------------------
DROP TABLE IF EXISTS Externo CASCADE;

CREATE TABLE IF NOT EXISTS Externo (
    Distribuidora VARCHAR(45) NOT NULL,
    Nombre VARCHAR(45) NOT NULL,
    Año DATE NOT NULL CHECK (Año > 'Jan-01-1950' AND Año < CURRENT_DATE),
    PEGI INT NULL CHECK (PEGI IN (3, 7, 12, 16, 18)),
    Desarrolladora VARCHAR(45) NULL,

    PRIMARY KEY (Distribuidora, Nombre, Año)
);


-- -----------------------------------------------------
-- Tabla De_Indev
-- -----------------------------------------------------
DROP TABLE IF EXISTS De_Indev CASCADE;

CREATE TABLE IF NOT EXISTS De_Indev (
    Distribuidora VARCHAR(45) NOT NULL,
    Nombre VARCHAR(45) NOT NULL,
    Año DATE NOT NULL CHECK (Año > 'Jan-01-1950' AND Año < CURRENT_DATE),
    PEGI INT NULL CHECK (PEGI IN (3, 7, 12, 16, 18)),
    Tipo VARCHAR(11) NULL CHECK (Tipo = 'Reciente' OR Tipo = 'No Reciente'),

    PRIMARY KEY (Distribuidora, Nombre, Año)
);


-- -----------------------------------------------------
-- Tabla Copia_Fisica
-- -----------------------------------------------------
DROP TABLE IF EXISTS Copia_Fisica CASCADE;

CREATE TABLE IF NOT EXISTS Copia_Fisica (
    Serial SERIAL UNIQUE NOT NULL,
    Distribuidora VARCHAR(45) NOT NULL,
    Nombre_Videojuego VARCHAR(45) NOT NULL,
    Año DATE NOT NULL CHECK (Año > 'Jan-01-1950' AND Año < CURRENT_DATE),

    PRIMARY KEY (Serial, Distribuidora, Nombre_Videojuego, Año),

    CONSTRAINT fk_Videojuego_CopiaFisica 
        FOREIGN KEY (Distribuidora, Nombre_Videojuego, Año)
        REFERENCES Videojuego (Distribuidora, Nombre, Año) 
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
);


-- -----------------------------------------------------
-- Tabla Filtra
-- -----------------------------------------------------
DROP TABLE IF EXISTS Filtra CASCADE;

CREATE TABLE IF NOT EXISTS Filtra (
    Email_Usuario VARCHAR(45) NOT NULL,
    Nombre_Categoria VARCHAR(50) NOT NULL,
    Fecha DATE NOT NULL,

    PRIMARY KEY (Email_Usuario, Nombre_Categoria, Fecha),

    CONSTRAINT fk_Usuario_Filtra
        FOREIGN KEY (Email_Usuario)
        REFERENCES Usuario (Email)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fk_Categoria_Filtra
        FOREIGN KEY (Nombre_Categoria)
        REFERENCES Categoria (Nombre) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE
);


-- -----------------------------------------------------
-- Tabla Pertenece
-- -----------------------------------------------------
DROP TABLE IF EXISTS Pertenece CASCADE;

CREATE TABLE IF NOT EXISTS Pertenece (
    Distribuidora VARCHAR(45) NOT NULL,
    Nombre_Videojuego VARCHAR(45) NOT NULL,
    Año DATE NOT NULL CHECK (Año > 'Jan-01-1950' AND Año < CURRENT_DATE),
    Nombre_Categoria VARCHAR(50) NOT NULL,

    PRIMARY KEY (Distribuidora, Nombre_Videojuego, Año, Nombre_Categoria),

    CONSTRAINT fk_Videojuego_Pertenece
        FOREIGN KEY (Distribuidora, Nombre_Videojuego, Año) 
        REFERENCES Videojuego (Distribuidora, Nombre, Año)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fk_Categoria_Pertenece
        FOREIGN KEY (Nombre_Categoria)
        REFERENCES Categoria (Nombre)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);


-- -----------------------------------------------------
-- Tabla Recibe
-- -----------------------------------------------------
DROP TABLE IF EXISTS Recibe CASCADE;

CREATE TABLE IF NOT EXISTS Recibe (
    Serial_CpFisica INT NOT NULL,
    Email_NoBasico VARCHAR(45) NOT NULL,

    PRIMARY KEY (Serial_CpFisica, Email_NoBasico),

    CONSTRAINT fk_CpFisica_Recibe
        FOREIGN KEY (Serial_CpFisica)
        REFERENCES Copia_Fisica (Serial)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fk_NoBasico_Recibe
        FOREIGN KEY (Email_NoBasico)
        REFERENCES No_Basico (Email)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);


-- -----------------------------------------------------
-- Tabla Juega1
-- -----------------------------------------------------
DROP TABLE IF EXISTS Juega1 CASCADE;

CREATE TABLE IF NOT EXISTS Juega1 (
    Email_Basico VARCHAR(45) NOT NULL,
    Distribuidora VARCHAR(45) NOT NULL,
    Nombre_Externo VARCHAR(45) NOT NULL,
    Año DATE NOT NULL CHECK (Año > 'Jan-01-1950' AND Año < CURRENT_DATE),

    PRIMARY KEY (Email_Basico, Distribuidora, Nombre_Externo, Año),

    CONSTRAINT fk_Basico_Juega1
        FOREIGN KEY (Email_Basico)
        REFERENCES Basico (Email)
        ON DELETE CASCADE 
        ON UPDATE CASCADE,

    CONSTRAINT fk_Externo_Juega1
        FOREIGN KEY (Distribuidora, Nombre_Externo, Año)
        REFERENCES Externo (Distribuidora, Nombre, Año)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);


-- -----------------------------------------------------
-- Tabla Juega2
-- -----------------------------------------------------
DROP TABLE IF EXISTS Juega2 CASCADE;

CREATE TABLE IF NOT EXISTS Juega2 (
    Email_Basico VARCHAR(45) NOT NULL,
    Distribuidora VARCHAR(45) NOT NULL,
    Nombre_DeIndev VARCHAR(45) NOT NULL,
    Año DATE NOT NULL CHECK (Año > 'Jan-01-1950' AND Año < CURRENT_DATE),

    PRIMARY KEY (Email_Basico, Distribuidora, Nombre_DeIndev, Año),

    CONSTRAINT fk_Basico_Juega2
        FOREIGN KEY (Email_Basico)
        REFERENCES Basico (Email)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fk_DeIndev_Juega1
        FOREIGN KEY (Distribuidora , Nombre_DeIndev , Año)
        REFERENCES De_Indev (Distribuidora , Nombre , Año)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);


-- -----------------------------------------------------
-- Tabla Juega3
-- -----------------------------------------------------
DROP TABLE IF EXISTS Juega3 CASCADE;

CREATE TABLE IF NOT EXISTS Juega3 (
  Email_NoBasico VARCHAR(45) NOT NULL,
  Distribuidora VARCHAR(45) NOT NULL,
  Nombre_Videojuego VARCHAR(45) NOT NULL,
  Año DATE NOT NULL CHECK (Año > 'Jan-01-1950' AND Año < CURRENT_DATE),

  PRIMARY KEY (Email_NoBasico, Distribuidora, Nombre_Videojuego, Año),

  CONSTRAINT fk_No_Basico_Juega3
    FOREIGN KEY (Email_NoBasico)
    REFERENCES No_Basico (Email)
    ON DELETE CASCADE
    ON UPDATE CASCADE,

  CONSTRAINT fk_Videojuego_Juega3
    FOREIGN KEY (Distribuidora , Nombre_Videojuego , Año)
    REFERENCES Videojuego (Distribuidora , Nombre , Año)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);


-- -----------------------------------------------------
-- Tabla Juega_Online
-- -----------------------------------------------------
DROP TABLE IF EXISTS Juega_Online CASCADE;

CREATE TABLE IF NOT EXISTS Juega_Online (
    Email_NoBasico1 VARCHAR(45) NOT NULL,
    Email_NoBasico2 VARCHAR(45) NOT NULL,
    Distribuidora VARCHAR(45) NOT NULL,
    Nombre_Videojuego VARCHAR(45) NOT NULL,
    Año DATE NOT NULL CHECK (Año > 'Jan-01-1950' AND Año < CURRENT_DATE),

    PRIMARY KEY (Email_NoBasico1, Distribuidora, Nombre_Videojuego, Año, Email_NoBasico2),

    CONSTRAINT fk_NoBasico1_JuegaOnline
        FOREIGN KEY (Email_NoBasico1)
        REFERENCES No_Basico (Email)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fk_No_Basico2
        FOREIGN KEY (Email_NoBasico2)
        REFERENCES No_Basico (Email)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fk_Videojuego_JuegaOnline
        FOREIGN KEY (Distribuidora, Nombre_Videojuego , Año)
        REFERENCES Videojuego (Distribuidora , Nombre , Año)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);




-- -----------------------------------------------------
-- Carga de datos para Usuario
-- -----------------------------------------------------
INSERT INTO Usuario (Email, Contraseña, Nombre, Imagen)
VALUES ('usuario1@gmail.com', '123456789A', 'Usuario1', NULL);

INSERT INTO Usuario (Email, Contraseña, Nombre, Imagen)
VALUES ('usuario2@gmail.com', '123456789B', 'Usuario2', NULL);

INSERT INTO Usuario (Email, Contraseña, Nombre, Imagen)
VALUES ('usuario3@gmail.com', '123456789C', 'Usuario3', NULL);

INSERT INTO Usuario (Email, Contraseña, Nombre, Imagen)
VALUES ('usuario4@gmail.com', '123456789D', 'Usuario4', NULL);

INSERT INTO Usuario (Email, Contraseña, Nombre, Imagen)
VALUES ('usuario5@gmail.com', '123456789E', 'Usuario5', NULL);

INSERT INTO Usuario (Email, Contraseña, Nombre, Imagen)
VALUES ('usuario6@gmail.com', '123456789F', 'Usuario6', NULL);

INSERT INTO Usuario (Email, Contraseña, Nombre, Imagen)
VALUES ('usuario7@gmail.com', '123456789F', 'Usuario7', NULL);


-- -----------------------------------------------------
-- Carga de datos para Basico
-- -----------------------------------------------------
INSERT INTO Basico (Email, Contraseña, Nombre, Imagen)
VALUES ('usuario1@gmail.com', '123456789A', 'Usuario1', NULL);

INSERT INTO Basico (Email, Contraseña, Nombre, Imagen)
VALUES ('usuario2@gmail.com', '123456789B', 'Usuario2', NULL);

INSERT INTO Basico (Email, Contraseña, Nombre, Imagen)
VALUES ('usuario3@gmail.com', '123456789C', 'Usuario3', NULL);


-- -----------------------------------------------------
-- Carga de datos para No_Basico
-- -----------------------------------------------------
INSERT INTO No_Basico (Email, Contraseña, Nombre, Imagen, Tipo)
VALUES ('usuario4@gmail.com', '123456789D', 'Usuario4', NULL, 'Premium');

INSERT INTO No_Basico (Email, Contraseña, Nombre, Imagen, Tipo)
VALUES ('usuario5@gmail.com', '123456789E', 'Usuario5', NULL, 'Deluxe');

INSERT INTO No_Basico (Email, Contraseña, Nombre, Imagen, Tipo)
VALUES ('usuario6@gmail.com', '123456789F', 'Usuario6', NULL, 'Deluxe');

INSERT INTO No_Basico (Email, Contraseña, Nombre, Imagen, Tipo)
VALUES ('usuario7@gmail.com', '123456789F', 'Usuario7', NULL, 'Deluxe');


-- -----------------------------------------------------
-- Carga de datos para Categoria
-- -----------------------------------------------------
INSERT INTO Categoria (Nombre, Num_Titulos)
VALUES ('Shooter', 2);

INSERT INTO Categoria (Nombre, Num_Titulos)
VALUES ('Estrategia', 2);

INSERT INTO Categoria (Nombre, Num_Titulos)
VALUES ('Walking Simulator / Exploración', 2);


-- -----------------------------------------------------
-- Carga de datos para Videojuego
-- -----------------------------------------------------
INSERT INTO Videojuego (Distribuidora, Nombre, Año, PEGI)
VALUES ('Activision-Blizzard', 'Call of Duty: Black Ops II', 'Nov-12-2012', 18);

INSERT INTO Videojuego (Distribuidora, Nombre, Año, PEGI)
VALUES ('Epic Games', 'Battletop', 'Jul-21-2017', 12);

INSERT INTO Videojuego (Distribuidora, Nombre, Año, PEGI)
VALUES ('Xbox Game Studios', 'Age of Empires IV', 'Oct-28-2021', 7);

INSERT INTO Videojuego (Distribuidora, Nombre, Año, PEGI)
VALUES ('505 Games', 'Forge of Governments', 'May-19-2018', 7);

INSERT INTO Videojuego (Distribuidora, Nombre, Año, PEGI)
VALUES ('Annapurna Interactive', 'Outer Wilds', 'May-28-2019', 7);

INSERT INTO Videojuego (Distribuidora, Nombre, Año, PEGI)
VALUES ('ID@Xbox', 'A Knight in the Woods', 'Jul-25-2013', 18);


-- -----------------------------------------------------
-- Carga de datos para Externo
-- -----------------------------------------------------
INSERT INTO Externo (Distribuidora, Nombre, Año, PEGI)
VALUES ('Activision-Blizzard', 'Call of Duty: Black Ops II', 'Nov-12-2012', 18);

INSERT INTO Externo (Distribuidora, Nombre, Año, PEGI)
VALUES ('Xbox Game Studios', 'Age of Empires IV', 'Oct-28-2021', 7);

INSERT INTO Externo (Distribuidora, Nombre, Año, PEGI)
VALUES ('Annapurna Interactive', 'Outer Wilds', 'May-28-2019', 7);


-- -----------------------------------------------------
-- Carga de datos para De_Indev
-- -----------------------------------------------------
INSERT INTO De_Indev (Distribuidora, Nombre, Año, PEGI, Tipo)
VALUES ('Epic Games', 'Battletop', 'Jul-21-2017', 12, 'No Reciente');

INSERT INTO De_Indev (Distribuidora, Nombre, Año, PEGI, Tipo)
VALUES ('505 Games', 'Forge of Governments', 'Jan-19-2022', 7, 'Reciente');

INSERT INTO De_Indev (Distribuidora, Nombre, Año, PEGI, Tipo)
VALUES ('ID@Xbox', 'A Knight in the Woods', 'Jul-25-2013', 18, 'No Reciente');


-- -----------------------------------------------------
-- Carga de datos para Copia_Fisica
-- -----------------------------------------------------
INSERT INTO Copia_Fisica (Serial, Distribuidora, Nombre_Videojuego, Año)
VALUES (1, 'Activision-Blizzard', 'Call of Duty: Black Ops II', 'Nov-12-2012');

INSERT INTO Copia_Fisica (Serial, Distribuidora, Nombre_Videojuego, Año)
VALUES (2, 'Epic Games', 'Battletop', 'Jul-21-2017');

INSERT INTO Copia_Fisica (Serial, Distribuidora, Nombre_Videojuego, Año)
VALUES (3, 'Epic Games', 'Battletop', 'Jul-21-2017');

INSERT INTO Copia_Fisica (Serial, Distribuidora, Nombre_Videojuego, Año)
VALUES (4, 'Xbox Game Studios', 'Age of Empires IV', 'Oct-28-2021');

INSERT INTO Copia_Fisica (Serial, Distribuidora, Nombre_Videojuego, Año)
VALUES (5, 'Xbox Game Studios', 'Age of Empires IV', 'Oct-28-2021');


-- -----------------------------------------------------
-- Carga de datos para Filtra
-- -----------------------------------------------------
INSERT INTO Filtra (Email_Usuario, Nombre_Categoria, Fecha)
VALUES ('usuario1@gmail.com', 'Shooter', 'Dec-24-2021');

INSERT INTO Filtra (Email_Usuario, Nombre_Categoria, Fecha)
VALUES ('usuario2@gmail.com', 'Shooter', 'Dec-25-2021');

INSERT INTO Filtra (Email_Usuario, Nombre_Categoria, Fecha)
VALUES ('usuario1@gmail.com', 'Estrategia', 'Jan-01-2022');

INSERT INTO Filtra (Email_Usuario, Nombre_Categoria, Fecha)
VALUES ('usuario4@gmail.com', 'Walking Simulator / Exploración', 'Jan-01-2022');

INSERT INTO Filtra (Email_Usuario, Nombre_Categoria, Fecha)
VALUES ('usuario5@gmail.com', 'Walking Simulator / Exploración', 'Jan-05-2022');


-- -----------------------------------------------------
-- Carga de datos para Pertenece
-- -----------------------------------------------------
INSERT INTO Pertenece (Distribuidora, Nombre_Videojuego, Año, Nombre_Categoria)
VALUES ('Activision-Blizzard', 'Call of Duty: Black Ops II', 'Nov-12-2012', 'Shooter');

INSERT INTO Pertenece (Distribuidora, Nombre_Videojuego, Año, Nombre_Categoria)
VALUES ('Epic Games', 'Battletop', 'Jul-21-2017', 'Shooter');

INSERT INTO Pertenece (Distribuidora, Nombre_Videojuego, Año, Nombre_Categoria)
VALUES ('Xbox Game Studios', 'Age of Empires IV', 'Oct-28-2021', 'Estrategia');

INSERT INTO Pertenece (Distribuidora, Nombre_Videojuego, Año, Nombre_Categoria)
VALUES ('505 Games', 'Forge of Governments', 'May-19-2018', 'Estrategia');

INSERT INTO Pertenece (Distribuidora, Nombre_Videojuego, Año, Nombre_Categoria)
VALUES ('Annapurna Interactive', 'Outer Wilds', 'May-28-2019', 'Walking Simulator / Exploración');

INSERT INTO Pertenece (Distribuidora, Nombre_Videojuego, Año, Nombre_Categoria)
VALUES ('ID@Xbox', 'A Knight in the Woods', 'Jul-25-2013', 'Walking Simulator / Exploración');


-- -----------------------------------------------------
-- Carga de datos para Recibe
-- -----------------------------------------------------
INSERT INTO Recibe (Serial_CpFisica, Email_NoBasico)
VALUES (1, 'usuario5@gmail.com');

INSERT INTO Recibe (Serial_CpFisica, Email_NoBasico)
VALUES (2, 'usuario5@gmail.com');

INSERT INTO Recibe (Serial_CpFisica, Email_NoBasico)
VALUES (3, 'usuario6@gmail.com');

INSERT INTO Recibe (Serial_CpFisica, Email_NoBasico)
VALUES (4, 'usuario6@gmail.com');

INSERT INTO Recibe (Serial_CpFisica, Email_NoBasico)
VALUES (5, 'usuario7@gmail.com');


-- -----------------------------------------------------
-- Carga de datos para Juega1
-- -----------------------------------------------------
INSERT INTO Juega1 (Email_Basico, Distribuidora, Nombre_Externo, Año)
VALUES ('usuario1@gmail.com', 'Activision-Blizzard', 'Call of Duty: Black Ops II', 'Nov-12-2012');

INSERT INTO Juega1 (Email_Basico, Distribuidora, Nombre_Externo, Año)
VALUES ('usuario1@gmail.com', 'Xbox Game Studios', 'Age of Empires IV', 'Oct-28-2021');

INSERT INTO Juega1 (Email_Basico, Distribuidora, Nombre_Externo, Año)
VALUES ('usuario2@gmail.com', 'Annapurna Interactive', 'Outer Wilds', 'May-28-2019');


-- -----------------------------------------------------
-- Carga de datos para Juega2
-- -----------------------------------------------------
INSERT INTO Juega2 (Email_Basico, Distribuidora, Nombre_DeIndev, Año)
VALUES ('usuario3@gmail.com', 'ID@Xbox', 'A Knight in the Woods', 'Jul-25-2013');

INSERT INTO Juega2 (Email_Basico, Distribuidora, Nombre_DeIndev, Año)
VALUES ('usuario3@gmail.com', 'Epic Games', 'Battletop', 'Jul-21-2017');


-- -----------------------------------------------------
-- Carga de datos para Juega3
-- -----------------------------------------------------
INSERT INTO Juega3 (Email_NoBasico, Distribuidora, Nombre_Videojuego, Año)
VALUES ('usuario4@gmail.com', 'ID@Xbox', 'A Knight in the Woods', 'Jul-25-2013');

INSERT INTO Juega3 (Email_NoBasico, Distribuidora, Nombre_Videojuego, Año)
VALUES ('usuario5@gmail.com', 'Epic Games', 'Battletop', 'Jul-21-2017');

INSERT INTO Juega3 (Email_NoBasico, Distribuidora, Nombre_Videojuego, Año)
VALUES ('usuario6@gmail.com', 'Epic Games', 'Battletop', 'Jul-21-2017');

INSERT INTO Juega3 (Email_NoBasico, Distribuidora, Nombre_Videojuego, Año)
VALUES ('usuario6@gmail.com', 'Activision-Blizzard', 'Call of Duty: Black Ops II', 'Nov-12-2012');

INSERT INTO Juega3 (Email_NoBasico, Distribuidora, Nombre_Videojuego, Año)
VALUES ('usuario7@gmail.com', 'Annapurna Interactive', 'Outer Wilds', 'May-28-2019');


-- -----------------------------------------------------
-- Carga de datos para Juega_Online
-- -----------------------------------------------------
INSERT INTO Juega_Online (Email_NoBasico1, Email_NoBasico2, Distribuidora, Nombre_Videojuego, Año)
VALUES ('usuario5@gmail.com', 'usuario4@gmail.com', 'Epic Games', 'Battletop', 'Jul-21-2017');

INSERT INTO Juega_Online (Email_NoBasico1, Email_NoBasico2, Distribuidora, Nombre_Videojuego, Año)
VALUES ('usuario6@gmail.com', 'usuario7@gmail.com', 'Epic Games', 'Battletop', 'Jul-21-2017');

INSERT INTO Juega_Online (Email_NoBasico1, Email_NoBasico2, Distribuidora, Nombre_Videojuego, Año)
VALUES ('usuario6@gmail.com', 'usuario5@gmail.com', 'Activision-Blizzard', 'Call of Duty: Black Ops II', 'Nov-12-2012');




-- -----------------------------------------------------
-- Función y Trigger Basico_Insert
-- Las categorías de usuarios son excluyentes.
-- Es decir, un usuario BASICO no puede ser NO_BASICO.
-- -----------------------------------------------------
DROP FUNCTION IF EXISTS Basico_Insert() CASCADE;

CREATE FUNCTION Basico_Insert() RETURNS TRIGGER AS $$
    BEGIN
        IF (NEW.Email IN (SELECT Email
                          FROM No_Basico))
        THEN
            RAISE 'Usuario % repetido.', NEW.Email
            USING HINT = 'Un usuario no puede ser Básico y No_Básico a la vez.';
        END IF;

        RETURN NEW;
	END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER Check_Basico_Insert 
BEFORE INSERT ON Basico FOR EACH ROW EXECUTE PROCEDURE Basico_Insert();

-- Tests para el trigger --
INSERT INTO Usuario (Email, Contraseña, Nombre, Imagen)
VALUES ('usuarioTest1@gmail.com', 'contraseña', 'UsuarioTest', NULL);

INSERT INTO No_Basico (Email, Contraseña, Nombre, Imagen, Tipo)
VALUES ('usuarioTest1@gmail.com', 'contraseña', 'UsuarioTest', NULL, 'Premium');

INSERT INTO Basico (Email, Contraseña, Nombre, Imagen)
VALUES ('usuarioTest1@gmail.com', 'contraseña', 'UsuarioTest', NULL);

DELETE FROM Usuario
WHERE Email = 'usuarioTest1@gmail.com';

DELETE FROM No_Basico
WHERE Email = 'usuarioTest1@gmail.com';

SELECT *
FROM Basico
WHERE Email = 'usuarioTest1@gmail.com';




-- -----------------------------------------------------
-- Función y Trigger NoBasico_Insert
-- Las categorías de usuarios son excluyentes.
-- Es decir, un usuario BASICO no puede ser NO_BASICO.
-- -----------------------------------------------------
DROP FUNCTION IF EXISTS NoBasico_Insert() CASCADE;

CREATE FUNCTION NoBasico_Insert() RETURNS TRIGGER AS $$
    BEGIN
        IF (NEW.Email IN (SELECT Email
                          FROM Basico))
        THEN
            RAISE 'Usuario % repetido.', NEW.Email
            USING HINT = 'Un usuario no puede ser Básico y No_Básico a la vez.';
        END IF;

        RETURN NEW;
	END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER Check_NoBasico_Insert 
BEFORE INSERT ON No_Basico FOR EACH ROW EXECUTE PROCEDURE NoBasico_Insert();

-- Tests para el trigger --
INSERT INTO Usuario (Email, Contraseña, Nombre, Imagen)
VALUES ('usuarioTest2@gmail.com', 'contraseña', 'UsuarioTest2', NULL);

INSERT INTO Basico (Email, Contraseña, Nombre, Imagen)
VALUES ('usuarioTest2@gmail.com', 'contraseña', 'UsuarioTest2', NULL);

INSERT INTO No_Basico (Email, Contraseña, Nombre, Imagen, Tipo)
VALUES ('usuarioTest2@gmail.com', 'contraseña', 'UsuarioTest2', NULL, 'Premium');

DELETE FROM Usuario
WHERE Email = 'usuarioTest2@gmail.com';

DELETE FROM Basico
WHERE Email = 'usuarioTest2@gmail.com';

SELECT *
FROM No_Basico
WHERE Email = 'usuarioTest2@gmail.com';


-- -----------------------------------------------------
-- Función y Trigger EstaEn_Usuario
-- Todos los usuarios de las relaciones BASICO y
-- NO_BASICO tienen que estar en USUARIO.
-- -----------------------------------------------------
DROP FUNCTION IF EXISTS EstaEn_Usuario() CASCADE;

CREATE FUNCTION EstaEn_Usuario() RETURNS TRIGGER AS $$
    BEGIN
        IF (NEW.Email NOT IN (SELECT Email
                              FROM Usuario)) THEN
            RAISE 'Usuario no admitido.'
            USING HINT = 'Todos los usuarios tienen que estar en la tabla Usuarios antes que en cualquier otra.';
        END IF;

        RETURN NEW;
	END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER Basico_EstaEn_Usuario_Trigger 
BEFORE INSERT ON Basico FOR EACH ROW EXECUTE PROCEDURE EstaEn_Usuario();

CREATE TRIGGER NoBasico_EstaEn_Usuario_Trigger 
BEFORE INSERT ON No_Basico FOR EACH ROW EXECUTE PROCEDURE EstaEn_Usuario();

-- Tests para el trigger --
INSERT INTO Basico (Email, Contraseña, Nombre, Imagen)
VALUES ('usuarioTest3@gmail.com', 'contraseña', 'UsuarioTest3', NULL);

INSERT INTO No_Basico (Email, Contraseña, Nombre, Imagen, Tipo)
VALUES ('usuarioTest3@gmail.com', 'contraseña', 'UsuarioTest3', NULL, 'Premium');

SELECT *
FROM Basico
WHERE Email = 'usuarioTest3@gmail.com';

SELECT *
FROM No_Basico
WHERE Email = 'usuarioTest3@gmail.com';


-- -----------------------------------------------------
-- Función y Trigger Recibe_Insert
-- Sólo los usuarios de la tabla NO_BASICO con Tipo
-- 'Deluxe' pueden estar en la tabla RECIBE.
-- -----------------------------------------------------
DROP FUNCTION IF EXISTS Recibe_Insert() CASCADE;

CREATE FUNCTION Recibe_Insert() RETURNS TRIGGER AS $$
    BEGIN
        IF ((SELECT Tipo
             FROM No_Basico
             WHERE Email = NEW.Email_NoBasico AND
                   Tipo = 'Deluxe') IS NULL) THEN
            RAISE 'Usuario no admitido.'
            USING HINT = 'Sólo los usuarios Deluxe pueden recibir copias físicas.';
        END IF;

        RETURN NULL;
	END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER Check_Recibe_Insert 
BEFORE INSERT ON Recibe EXECUTE PROCEDURE Recibe_Insert();

-- Tests para el trigger --
INSERT INTO Usuario (Email, Contraseña, Nombre, Imagen)
VALUES ('usuarioTest4@gmail.com', 'contraseña', 'UsuarioTest4', NULL);

INSERT INTO No_Basico (Email, Contraseña, Nombre, Imagen, Tipo)
VALUES ('usuarioTest4@gmail.com', 'contraseña', 'UsuarioTest4', NULL, 'Premium');

INSERT INTO Copia_Fisica (Serial, Distribuidora, Nombre_Videojuego, Año)
VALUES (6, 'Xbox Game Studios', 'Age of Empires IV', 'Oct-28-2021');

INSERT INTO Recibe (Serial_CpFisica, Email_NoBasico)
VALUES (6, 'usuarioTest4@gmail.com');

SELECT *
FROM Recibe
WHERE Email_NoBasico = 'usuarioTest4@gmail.com' AND
      Serial_CpFisica = 6;

DELETE FROM Usuario
WHERE Email = 'usuarioTest4@gmail.com';

DELETE FROM No_Basico
WHERE Email = 'usuarioTest4@gmail.com';

DELETE FROM Copia_Fisica
WHERE Serial = 6;


-- -----------------------------------------------------
-- Función y Trigger Externo_Insert
-- Las categorías de videojuegos son excluyentes.
-- Es decir, un videojuego EXTERNO no puede ser DE_INDEV.
-- -----------------------------------------------------
DROP FUNCTION IF EXISTS Externo_Insert() CASCADE;

CREATE FUNCTION Externo_Insert() RETURNS TRIGGER AS $$
    BEGIN
        IF ((SELECT Nombre
             FROM De_Indev
             WHERE (Distribuidora = NEW.Distribuidora AND
                    Nombre = NEW.Nombre AND
                    Año = NEW.Año)) IS NOT NULL) THEN
            RAISE 'Videojuego repetido.'
            USING HINT = 'Un videojuego no puede ser Externo y De_Indev a la vez.';
        END IF;

        RETURN NEW;
	END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER Check_Externo_Insert 
BEFORE INSERT ON Externo FOR EACH ROW EXECUTE PROCEDURE Externo_Insert();

-- Tests para el trigger --
INSERT INTO Videojuego (Distribuidora, Nombre, Año, PEGI)
VALUES ('DistTest', 'VideojuegoTest', 'Jan-01-2000', NULL);

INSERT INTO De_Indev (Distribuidora, Nombre, Año, PEGI, Tipo)
VALUES ('DistTest', 'VideojuegoTest', 'Jan-01-2000', NULL, 'No Reciente');

INSERT INTO Externo (Distribuidora, Nombre, Año, PEGI, Desarrolladora)
VALUES ('DistTest', 'VideojuegoTest', 'Jan-01-2000', NULL, 'DesTest');

DELETE FROM Videojuego
WHERE Distribuidora = 'DistTest';

DELETE FROM De_Indev
WHERE Distribuidora = 'DistTest';

SELECT *
FROM Externo
WHERE Distribuidora = 'DistTest';


-- -----------------------------------------------------
-- Función y Trigger DeIndev_Insert
-- Las categorías de videojuegos son excluyentes.
-- Es decir, un videojuego EXTERNO no puede ser DE_INDEV.
-- -----------------------------------------------------
DROP FUNCTION IF EXISTS DeIndev_Insert() CASCADE;

CREATE FUNCTION DeIndev_Insert() RETURNS TRIGGER AS $$
    BEGIN
        IF ((SELECT Nombre
             FROM Externo
             WHERE (Distribuidora = NEW.Distribuidora AND
                    Nombre = NEW.Nombre AND
                    Año = NEW.Año)) IS NOT NULL) THEN
            RAISE 'Videojuego repetido.'
            USING HINT = 'Un videojuego no puede ser Externo y De_Indev a la vez.';
        END IF;

        RETURN NEW;
	END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER Check_DeIndev_Insert 
BEFORE INSERT ON De_Indev FOR EACH ROW EXECUTE PROCEDURE DeIndev_Insert();

-- Tests para el trigger --
INSERT INTO Videojuego (Distribuidora, Nombre, Año, PEGI)
VALUES ('DistTest', 'VideojuegoTest', 'Jan-01-2000', NULL);

INSERT INTO Externo (Distribuidora, Nombre, Año, PEGI, Desarrolladora)
VALUES ('DistTest', 'VideojuegoTest', 'Jan-01-2000', NULL, 'DesTest');

INSERT INTO De_Indev (Distribuidora, Nombre, Año, PEGI, Tipo)
VALUES ('DistTest', 'VideojuegoTest', 'Jan-01-2000', NULL, 'No Reciente');

DELETE FROM Videojuego
WHERE Distribuidora = 'DistTest';

DELETE FROM Externo
WHERE Distribuidora = 'DistTest';

SELECT *
FROM De_Indev
WHERE Distribuidora = 'DistTest';


-- -----------------------------------------------------
-- Función y Trigger Juega1_Insert
-- No puede haber usuarios repetidos entre las
-- relaciones JUEGA1 y JUEGA2.
-- -----------------------------------------------------
DROP FUNCTION IF EXISTS Juega1_Insert() CASCADE;

CREATE FUNCTION Juega1_Insert() RETURNS TRIGGER AS $$
    BEGIN
        IF (NEW.Email_Basico IN (SELECT Email_Basico
                                 FROM Juega2)) 
        THEN
            RAISE 'Usuario no admitido.'
            USING HINT = 'Un usuario sólo puede jugar a videojuegos EXTERNOS o DE_INDEV de tipo "Reciente", eligiendo entre un tipo u otro.';
        END IF;

        RETURN NEW;
	END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER Check_Juega1_Insert 
BEFORE INSERT ON Juega1 FOR EACH ROW EXECUTE PROCEDURE Juega1_Insert();

-- Tests para probar el trigger --
INSERT INTO Usuario (Email, Contraseña, Nombre, Imagen)
VALUES ('usuarioTest4@gmail.com', 'contraseña', 'UsuarioTest4', NULL);

INSERT INTO Basico (Email, Contraseña, Nombre, Imagen)
VALUES ('usuarioTest4@gmail.com', 'contraseña', 'UsuarioTest4', NULL);

INSERT INTO Videojuego (Distribuidora, Nombre, Año, PEGI)
VALUES ('DistTest1', 'VideojuegoTest1', 'Jan-01-2000', NULL);

INSERT INTO Videojuego (Distribuidora, Nombre, Año, PEGI)
VALUES ('DistTest2', 'VideojuegoTest2', 'Feb-01-2000', NULL);

INSERT INTO Externo (Distribuidora, Nombre, Año, PEGI, Desarrolladora)
VALUES ('DistTest1', 'VideojuegoTest1', 'Jan-01-2000', NULL, 'DesTest');

INSERT INTO De_Indev (Distribuidora, Nombre, Año, PEGI, Tipo)
VALUES ('DistTest2', 'VideojuegoTest2', 'Feb-01-2000', NULL, 'No Reciente');

INSERT INTO Juega2 (Email_Basico, Distribuidora, Nombre_DeIndev, Año)
VALUES ('usuarioTest4@gmail.com', 'DistTest2', 'VideojuegoTest2', 'Feb-01-2000');

INSERT INTO Juega1 (Email_Basico, Distribuidora, Nombre_Externo, Año)
VALUES ('usuarioTest4@gmail.com', 'DistTest1', 'VideojuegoTest1', 'Jan-01-2000');

SELECT *
FROM Juega1
WHERE Email_Basico = 'usuarioTest4@gmail.com';

DELETE FROM Usuario
WHERE Email = 'usuarioTest4@gmail.com';

DELETE FROM Basico
WHERE Email = 'usuarioTest4@gmail.com';

DELETE FROM Videojuego
WHERE Distribuidora = 'DistTest1';

DELETE FROM Videojuego
WHERE Distribuidora = 'DistTest2';

DELETE FROM Externo
WHERE Distribuidora = 'DistTest1';

DELETE FROM De_Indev
WHERE Distribuidora = 'DistTest2';


-- -----------------------------------------------------
-- Función y Trigger Juega2_Insert
-- No puede haber usuarios repetidos entre las
-- relaciones JUEGA1 y JUEGA2.
-- En la tabla JUEGA2 sólo puede haber videojuegos de
-- la relación DE_INDEV cuyo Tipo sea 'No Reciente'.
-- -----------------------------------------------------
DROP FUNCTION IF EXISTS Juega2_Insert() CASCADE;

CREATE FUNCTION Juega2_Insert() RETURNS TRIGGER AS $$
    BEGIN
        IF (NEW.Email_Basico IN (SELECT Email_Basico
                                 FROM Juega1)) 
        THEN
            RAISE 'Usuario no admitido.'
            USING HINT = 'Un usuario sólo puede jugar a videojuegos EXTERNOS o DE_INDEV de tipo "Reciente", eligiendo entre un tipo u otro.';
        END IF;

        RETURN NEW;
	END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER Check_Juega2_Insert 
BEFORE INSERT ON Juega2 FOR EACH ROW EXECUTE PROCEDURE Juega2_Insert();

-- Tests para probar el trigger --
INSERT INTO Usuario (Email, Contraseña, Nombre, Imagen)
VALUES ('usuarioTest5@gmail.com', 'contraseña', 'UsuarioTest4', NULL);

INSERT INTO Basico (Email, Contraseña, Nombre, Imagen)
VALUES ('usuarioTest5@gmail.com', 'contraseña', 'UsuarioTest4', NULL);

INSERT INTO Videojuego (Distribuidora, Nombre, Año, PEGI)
VALUES ('DistTest3', 'VideojuegoTest3', 'Jan-01-2000', NULL);

INSERT INTO Videojuego (Distribuidora, Nombre, Año, PEGI)
VALUES ('DistTest4', 'VideojuegoTest4', 'Feb-01-2000', NULL);

INSERT INTO Externo (Distribuidora, Nombre, Año, PEGI, Desarrolladora)
VALUES ('DistTest3', 'VideojuegoTest3', 'Jan-01-2000', NULL, 'DesTest');

INSERT INTO De_Indev (Distribuidora, Nombre, Año, PEGI, Tipo)
VALUES ('DistTest4', 'VideojuegoTest4', 'Feb-01-2000', NULL, 'No Reciente');

INSERT INTO Juega1 (Email_Basico, Distribuidora, Nombre_Externo, Año)
VALUES ('usuarioTest5@gmail.com', 'DistTest3', 'VideojuegoTest3', 'Jan-01-2000');

INSERT INTO Juega2 (Email_Basico, Distribuidora, Nombre_DeIndev, Año)
VALUES ('usuarioTest5@gmail.com', 'DistTest4', 'VideojuegoTest4', 'Feb-01-2000');

SELECT *
FROM Juega2
WHERE Email_Basico = 'usuarioTest5@gmail.com';

DELETE FROM Usuario
WHERE Email = 'usuarioTest5@gmail.com';

DELETE FROM Basico
WHERE Email = 'usuarioTest5@gmail.com';

DELETE FROM Videojuego
WHERE Distribuidora = 'DistTest3';

DELETE FROM Videojuego
WHERE Distribuidora = 'DistTest4';

DELETE FROM Externo
WHERE Distribuidora = 'DistTest3';

DELETE FROM De_Indev
WHERE Distribuidora = 'DistTest4';


-- -----------------------------------------------------
-- Función y Trigger Actualiza_Categoria
-- Cada vez que se asigna un videojuego a una
-- categoría, se actualiza la cuenta de videojuegos
-- por categoría.
-- -----------------------------------------------------
DROP FUNCTION IF EXISTS Cuenta_Titulos() CASCADE;

CREATE FUNCTION Cuenta_Titulos() RETURNS INTEGER AS $count$
    BEGIN
        RETURN (SELECT COUNT(*)::int
                FROM Pertenece
                WHERE Nombre_Categoria = NEW.Nombre_Categoria);
	END;
$count$ LANGUAGE plpgsql;

DROP FUNCTION IF EXISTS Actualiza_Categoria() CASCADE;

CREATE FUNCTION Actualiza_Categoria() RETURNS TRIGGER AS $$
    BEGIN
        UPDATE Categoria
        SET Num_Titulos = (SELECT COUNT(*)::int
                           FROM Pertenece
                           WHERE Nombre_Categoria = NEW.Nombre_Categoria)
        WHERE (Nombre = NEW.Nombre_Categoria);

        RETURN NEW;
	END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER Actualiza_Categoria_Trigger
AFTER INSERT ON Pertenece FOR EACH ROW EXECUTE PROCEDURE Actualiza_Categoria();

-- Tests para probar el trigger --
INSERT INTO Videojuego (Distribuidora, Nombre, Año, PEGI)
VALUES ('DistTest3', 'VideojuegoTest3', 'Jan-01-2000', NULL);

INSERT INTO Categoria (Nombre, Num_Titulos)
VALUES ('CatTest', 0);

INSERT INTO Pertenece (Distribuidora, Nombre_Videojuego, Año, Nombre_Categoria)
VALUES ('DistTest3', 'VideojuegoTest3', 'Jan-01-2000', 'CatTest');