CREATE DATABASE Ventas_Tech_DB;

USE Ventas_Tech_DB;

___ SECCIÓN 1: ELIMINAR EXISTENCIAS PREVIAS ___
DROP TABLE IF EXISTS Ventas;
DROP TABLE IF EXISTS Productos;
DROP TABLE IF EXISTS Clientes;
DROP TABLE IF EXISTS Categorías;

___ SECCIÓN 1: CREAR TABLAS ___
CREATE TABLE Categorías(
Id_Categoría INT IDENTITY(1,1) PRIMARY KEY,
Nombre_categoría VARCHAR(50) NOT NULL,
Descripción VARCHAR(200)
);

CREATE TABLE Clientes(
Id_Cliente INT IDENTITY(1,1) PRIMARY KEY,
Nombre VARCHAR(100) NOT NULL,
Email VARCHAR(100) UNIQUE,
Ciudad VARCHAR(50),
Fecha_registro DATE NOT NULL
);

CREATE TABLE Productos(
Id_Producto INT IDENTITY(1,1) PRIMARY KEY,
Nombre_producto VARCHAR(100) NOT NULL,
Id_Categoría INT NOT NULL,
Precio DECIMAL(10,2) NOT NULL,
Stock INT DEFAULT 0,
Activo BIT DEFAULT 1,

CONSTRAINT FK_Productos_Categoría FOREIGN KEY(Id_Categoría) REFERENCES Categorías(Id_Categoría)
);

CREATE TABLE Ventas(
Id_Venta INT IDENTITY(1,1) PRIMARY KEY,
Id_Cliente INT NOT NULL,
Id_Producto INT NOT NULL,
Cantidad INT NOT NULL,
Precio_unitario DECIMAL(10,2) NOT NULL,
Fecha_venta DATE NOT NULL,

CONSTRAINT FK_Ventas_Cliente FOREIGN KEY(Id_Cliente) REFERENCES Clientes(Id_Cliente),
CONSTRAINT FK_Ventas_Producto FOREIGN KEY(Id_Producto) REFERENCES Productos(Id_Producto)
);

___ SECCIÓN 1: INSERTAR DATOS ___
INSERT INTO Categorías (Nombre_categoría, Descripción) VALUES
  ('Computación',    'Laptops, PCs y monitores'),
  ('Accesorios',     'Periféricos y complementos'),
  ('Audio',          'Auriculares y parlantes'),
  ('Almacenamiento', 'Discos y memorias');

INSERT INTO Clientes (Nombre, Email, Ciudad, Fecha_registro) VALUES
  ('María López',  'maria@mail.com',  'Buenos Aires', '2024-01-05'),
  ('Carlos Ruiz',  'carlos@mail.com', 'Córdoba',      '2024-01-10'),
  ('Ana Gómez',    'ana@mail.com',    'Rosario',      '2024-02-01'),
  ('Pedro Sanz',   'pedro@mail.com',  'Mendoza',      '2024-02-15'),
  ('Laura Torres', 'laura@mail.com',  'Tucumán',      '2024-03-01');

INSERT INTO Productos (Nombre_producto, Id_Categoría, Precio, Stock, Activo) VALUES
  ('Laptop Pro 15',      1, 1200.00, 15, 1),
  ('Mouse Inalámbrico',  2,   28.00, 80, 1),
  ('Monitor 4K 27',      1,  450.00, 12, 1),
  ('Auriculares BT Pro', 3,  120.00, 35, 1),
  ('SSD Externo 1TB',    4,  130.00, 18, 1),
  ('Teclado Mecánico',   2,   95.00, 40, 1);

INSERT INTO Ventas (Id_Cliente, Id_Producto, Cantidad, Precio_unitario, Fecha_venta) VALUES
  (1, 1, 2, 1200.00, '2024-03-05'),
  (2, 2, 5,   28.00, '2024-03-06'),
  (3, 3, 1,  450.00, '2024-03-07'),
  (1, 4, 2,  120.00, '2024-03-08'),
  (4, 5, 3,  130.00, '2024-03-10'),
  (2, 6, 4,   95.00, '2024-03-11'),
  (5, 1, 1, 1200.00, '2024-03-12'),
  (3, 2, 8,   28.00, '2024-03-13'),
  (4, 4, 1,  120.00, '2024-03-14'),
  (5, 3, 2,  450.00, '2024-03-15');

___ SECCIÓN 1: VALIDACIÓN ___
SELECT * FROM Categorías;
SELECT * FROM Clientes;
SELECT * FROM Productos;
SELECT * FROM Ventas;