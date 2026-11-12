--  Extrayendo métricas clave con SQL --

USE Ventas_Tech_DB

-- Consulta 1: Resumen ejecutivo mensual --

SELECT SUM(Cantidad*Precio_unitario) AS Total_facturado, COUNT(Id_Venta) AS Cantidad_de_pedidos, AVG(Cantidad*Precio_unitario) AS Ticket_promedio
FROM Ventas
GROUP BY MONTH(Fecha_venta)

-- Consulta 2: Ranking de productos --

SELECT TOP 5 Id_producto, SUM(Cantidad*Precio_unitario) AS Facturacion_producto, SUM(Cantidad) AS Unidades_vendidas
FROM Ventas
GROUP BY Id_Producto 
ORDER BY Facturacion_producto DESC

-- Consulta 3: Clientes recurrentes --

SELECT Id_Cliente, COUNT(Id_Cliente) AS Cantidad_pedidos, SUM(Cantidad*Precio_unitario) AS Total_gastado
FROM Ventas
GROUP BY Id_Cliente
HAVING COUNT(*)>1

-- Productos por encima/por debajo del promedio --

WITH Facturacion_por_productos AS(
    SELECT Id_Producto, SUM(Cantidad*Precio_unitario) AS Total_facturado
    FROM Ventas
    GROUP BY Id_Producto
)
SELECT Id_Producto, Total_facturado
, CASE
    WHEN Total_facturado > (
       SELECT AVG(Total_facturado) 
       FROM Facturacion_por_productos
    )
    THEN 'Por encima'
    ELSE 'Por debajo'
  END AS Promedio_facturacion
FROM Facturacion_por_productos


-- Hallazgos:
-- 1. La cantidad de unidades vendidas no es proporcional a la fcturación total de un producto, debido a que hay productos con mucha diferencia de precio.
-- 2. La cantidad de compras por cliente no es proporcional al total gastado por el mismo, ya que en cada compra los importes pueden variar ampliamente.
-- 3. Los productos que superan el promedio de facturación, son aquellos cuyo precio unitario es más elevado.
-- Observación: Falta información de costos para establecer margenes de ganancia. Con la información proporcionada, se sugiere intentar ventas cruzadas que acerquen más cada venta al ticket promedio.