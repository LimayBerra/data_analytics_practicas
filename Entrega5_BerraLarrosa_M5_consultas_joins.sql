-- Cruzando tablas para enriquecer el análisis

USE Ventas_Tech_DB
GO

-- Aclaración: Algunas palabras mantienen tildes, ya que la Base creada para el M3, fue así dispuesta. De crearla de cero, sería preferible quitar las tildes de Entidades y Atributos.

-- Consulta 1: Vista base del proyecto (INNER JOIN)
-- Propósito: Integrar la información que tiene correspondencia en todas las tablas de ventas, clientes, productos y categorías en una única vista para facilitar los análisis posteriores.

SELECT 
  V.Id_Venta,
  Cl.Id_Cliente,
  Cl.Nombre,
  Cl.Ciudad,
  V.Fecha_venta,
  P.Nombre_producto,
  C.Descripción,
  V.Cantidad,
  V.Precio_unitario,
  V.Cantidad*V.Precio_unitario AS Total_Venta 
FROM Ventas V
INNER JOIN Productos P
  ON V.Id_Producto=P.Id_Producto
INNER JOIN Clientes Cl
  ON V.Id_cliente=Cl.Id_Cliente
INNER JOIN Categorías C
  ON P.Id_Categoría=C.Id_Categoría

-- Hallazgo: Se obtuvo una base de datos consolidada, de la que solo ha quedado fuera un producto.

-- Consulta 2: Clientes sin ventas (LEFT JOIN)
-- Propósito: detectar clientes registrados que nunca compraron, para que CRM los contacte.

SELECT 
  Cl.Id_Cliente,
  Cl.Nombre,
  Cl.Email,
  Cl.Fecha_registro
FROM Clientes Cl
LEFT JOIN Ventas V
  ON Cl.Id_Cliente=V.Id_Cliente
WHERE Id_Venta IS NULL

-- Hallazgo: No hay clientes sin ventas.

-- Consulta 3: Productos sin ventas (LEFT JOIN)
-- Propósito: Detectar qué productos no se han vendido nunca, para que A. Producto evalúe su continuidad o marketing.

SELECT 
  P.Id_Producto,
  P.Nombre_producto,
  P.Precio,
  C.Nombre_categoría
FROM Productos P
LEFT JOIN Categorías C
  ON P.Id_Categoría=C.Id_Categoría
LEFT JOIN Ventas V
  ON P.Id_Producto=V.Id_Cliente
WHERE Id_Venta IS NULL

-- Hallazgo: Un producto sin ninguna venta asociada: Tecládo Mecánico (Id_Producto: 6).

-- Consulta 4: Consolidado por periodo -canal- (UNION ALL)
-- Aclaración: Se mantuvo la columna "Canal", ya que es solicitado así en el ejercicio, sin embargo, al no diponer de esos datos, se creo otra columna con mayor sentido de análisis para la Base de Datos que utilizamos.
-- Propósito: Generar una tabla comparativa de ventas totales entre la primera y la segunda decena del mes para orientar las decisiones del área de ventas.
-- En el caso de tomar en cuenta la columna Canal, diríamos que la comparativa sería para establecer de qué forma se realizan más ventas e incentivar el otro canal.

SELECT Periodo, Canal, SUM(Total) AS Total_Periodo
FROM (
    SELECT
      Fecha_venta,
      Cantidad * Precio_unitario AS Total,
      'Online' AS Canal,
      'Primera decena de marzo' AS Periodo
    FROM Ventas 
    WHERE 
      Fecha_venta>'2024-03-01'
      AND Fecha_venta<='2024-03-10'
    UNION ALL
    SELECT
      Fecha_venta,
      Cantidad * Precio_unitario AS Total,
      'Presencial' AS Canal,
      'Segunda decena de marzo' AS Periodo
    FROM Ventas 
    WHERE 
      Fecha_venta>'2024-03-10'
      AND Fecha_venta<='2024-03-20'
) AS Consolidado
GROUP BY Canal, Periodo

-- Hallazgo: Caída de casi un 22% de las ventas durante el segundo período (del 11 al 20 de marzo).
-- En el caso de considerar la columna de Canal (por tanto sería: Total_Canal y no Total_Periodo), diríamos que online se realizan casi un 22% más de ventas que presencialmente.