CREATE DATABASE UsuariosDB;
GO

USE UsuariosDB;
GO

CREATE TABLE Usuarios (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Nombre NVARCHAR(50),
    Apellido NVARCHAR(50),
    Edad INT,
    Correo NVARCHAR(100),
    Hobbies NVARCHAR(255), 
    Activo BIT,
    FechaCreacion DATETIME DEFAULT GETDATE(), 
    FechaActualizacion DATETIME DEFAULT GETDATE() 
);
GO

CREATE PROCEDURE InsertarUsuario
    @Nombre NVARCHAR(50),
    @Apellido NVARCHAR(50),
    @Edad INT,
    @Correo NVARCHAR(100),
    @Hobbies NVARCHAR(255),
    @Activo BIT
AS
BEGIN
    INSERT INTO Usuarios (Nombre, Apellido, Edad, Correo, Hobbies, Activo, FechaCreacion, FechaActualizacion)
    VALUES (@Nombre, @Apellido, @Edad, @Correo, @Hobbies, @Activo, GETDATE(), GETDATE());
END;
GO

CREATE FUNCTION OrdenarHobbies(@hobbies NVARCHAR(255))
RETURNS NVARCHAR(255)
AS
BEGIN
    DECLARE @result NVARCHAR(255);
    
    DECLARE @HobbiesTable TABLE (Hobby NVARCHAR(255));

    INSERT INTO @HobbiesTable (Hobby)
    SELECT TRIM(value) 
    FROM STRING_SPLIT(@hobbies, '-');

    SELECT @result = STRING_AGG(Hobby, ',') WITHIN GROUP (ORDER BY Hobby)
    FROM @HobbiesTable;

    RETURN @result;
END;
GO

CREATE PROCEDURE ObtenerUsuariosPorEdad
    @Edad INT
AS
BEGIN
    SELECT Id, Nombre, Apellido, Edad, Correo, dbo.OrdenarHobbies(Hobbies) AS Hobbies, Activo, FechaCreacion
    FROM Usuarios
    WHERE Edad >= @Edad;
END;
GO

CREATE PROCEDURE ObtenerUsuariosRecientes
AS
BEGIN
    SELECT * 
    FROM Usuarios
    WHERE FechaCreacion >= DATEADD(HOUR, -2, GETDATE());
END;

GO

EXEC InsertarUsuario
    @Nombre = 'Juan',
    @Apellido = 'Pérez',
    @Edad = 30,
    @Correo = 'juan.perez@example.com',
    @Hobbies = 'fútbol-lectura-viajar',
    @Activo = 1;

EXEC InsertarUsuario
    @Nombre = 'Ana',
    @Apellido = 'Gómez',
    @Edad = 25,
    @Correo = 'ana.gomez@example.com',
    @Hobbies = 'música-danza-cine',
    @Activo = 0;

EXEC InsertarUsuario
    @Nombre = 'Carlos',
    @Apellido = 'Martínez',
    @Edad = 35,
    @Correo = 'carlos.martinez@example.com',
    @Hobbies = 'ajedrez-gimnasio-lectura',
    @Activo = 1;

EXEC InsertarUsuario
    @Nombre = 'Laura',
    @Apellido = 'Sánchez',
    @Edad = 28,
    @Correo = 'laura.sanchez@example.com',
    @Hobbies = 'pintura-fotografía-ciclismo',
    @Activo = 1;

