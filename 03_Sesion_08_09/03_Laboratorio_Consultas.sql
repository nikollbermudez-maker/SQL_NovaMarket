-- 💻 LABORATORIO SESIÓN 8 Y 9 EXPRESS: EL VEREDICTO EN SQL
-- ═══════════════════════════════════════════════════════════════
-- Guía de Referencia: 01_Guia_S08S09_Conceptual.md
-- Base de Datos: Novamarket_S08S09.db (500 registros, lista para usar)
-- ═══════════════════════════════════════════════════════════════
-- INSTRUCCIONES:
-- 1. Asegúrate de estar conectado a la base de datos `Novamarket_S08S09.db`
-- 2. Selecciona cada bloque de consulta y presiona Cmd + E (Mac) o Ctrl + E (Win).
-- ══ PARTE 1 — GROUP BY (Comprimiendo filas) ════════════════════
-- Paso 1: El problema de las 500 filas
-- Si listamos, vemos 500:
SELECT CiudadID,
    Precio_Venta,
    Costo_Envio
FROM FactVentas
LIMIT 5;
-- Si agrupamos, vemos el total:
SELECT CiudadID,
    COUNT(*) AS Filas
FROM FactVentas
GROUP BY CiudadID;
--Respuesta paso 1:
--Veo dos columnas (ciudad ID y filas) y hay 6 filas una para cada ciudad y se ha agrupado
--el numero de registros por cada ciudad 
-- Paso 2: El veredicto de Leticia con GROUP BY (Usando IDs)
-- Respuesta Paso 2:
-- Ninguna tiene un Margen_Aproximado negativo, pero el ID 2 (Leticia) es el más bajo con 134,920.0
-- Este bajo margen coincide con lo observado en Power BI.
-- Paso 3: SUM vs AVG
-- Respuesta Paso 3:
-- Usaría SUM, porque muestra el impacto real del costo total.
-- AVG oculta el problema de que el alto volumen hace el costo total elevadísimo.
SELECT CiudadID,
    ROUND(SUM(Costo_Envio), 2) AS Costo_TOTAL,
    ROUND(AVG(Costo_Envio), 2) AS Costo_PROMEDIO
FROM FactVentas
WHERE CiudadID = 6
GROUP BY CiudadID;
-- ══ PARTE 2 — JOIN (Nombres Reales) ════════════════════════════
-- Paso 4: El primer JOIN: 'Leticia' en lugar de '6'
-- Respuesta Paso 4:
-- La columna que une las tablas es `CiudadID`.
-- Aparece 'Leticia' porque el JOIN trajo el nombre de la ciudad desde la tabla DimCiudad.
SELECT f.TransaccionID,
    c.Ciudad AS Ciudad,
    -- viene de DimCiudad
    f.Costo_Envio
FROM FactVentas f
    INNER JOIN DimCiudad c ON f.CiudadID = c.CiudadID
WHERE c.Ciudad = 'Leticia'
LIMIT 5;
-- Paso 5: Doble JOIN: ciudad Y producto
SELECT f.TransaccionID,
    c.Ciudad AS Ciudad,
    p.Producto AS Producto,
    f.Cantidad,
    ROUND(
        f.Precio_Venta * f.Cantidad * (1 - f.Descuento_Pct),
        2
    ) AS Venta_Neta
FROM FactVentas f
    INNER JOIN DimCiudad c ON f.CiudadID = c.CiudadID
    INNER JOIN DimProducto p ON f.ProductoID = p.ProductoID
LIMIT 10;
-- Paso 6: Doble Agrupación (Ciudad y Producto)
-- ¿Cuánto vendió cada producto en cada ciudad?
SELECT c.Ciudad AS Ciudad,
    p.Producto AS Producto,
    COUNT(*) AS Transacciones,
    ROUND(
        SUM(
            f.Precio_Venta * f.Cantidad * (1 - f.Descuento_Pct)
        ),
        2
    ) AS Venta_Neta
FROM FactVentas f
    INNER JOIN DimCiudad c ON f.CiudadID = c.CiudadID
    INNER JOIN DimProducto p ON f.ProductoID = p.ProductoID
GROUP BY c.Ciudad,
    p.Producto
ORDER BY c.Ciudad ASC,
    Venta_Neta DESC;
-- ══ LA CONSULTA MAESTRA (JOIN + GROUP BY) ══════════════════════
-- Reproduciendo el dashboard de S4
-- Respuesta Consulta Maestra:
-- Leticia no tiene pérdida (negativo) sino el margen más bajo: 134,920.0.
-- Esto coincide exactamente con el dashboard de S4.
SELECT c.Ciudad AS Ciudad,
    COUNT(*) AS Transacciones,
    ROUND(
        SUM(
            f.Precio_Venta * f.Cantidad * (1 - f.Descuento_Pct)
        ),
        2
    ) AS Venta_Neta,
    ROUND(SUM(f.Costo_Envio), 2) AS Costo_Envio_Total,
    ROUND(
        SUM(
            f.Precio_Venta * f.Cantidad * (1 - f.Descuento_Pct) - f.Costo_Envio
        ),
        2
    ) AS Margen_Aproximado
FROM FactVentas f
    INNER JOIN DimCiudad c ON f.CiudadID = c.CiudadID
GROUP BY c.Ciudad
ORDER BY Margen_Aproximado ASC;
-- ═══════════════════════════════════════════════════════════════
-- 🚀 PRÁCTICA AUTÓNOMA (ENTREGABLES)
-- Escribe tus consultas debajo de cada enunciado.
-- ═══════════════════════════════════════════════════════════════
-- E1: (Fácil) Muestra nombre del producto, categoría y venta neta total de cada producto. Ordena de mayor a menor.
SELECT 
    p.Producto, 
    p.Categoria, 
    ROUND(SUM(f.Precio_Venta * f.Cantidad * (1-f.Descuento_Pct)), 2) AS Venta_Neta
FROM FactVentas f
INNER JOIN DimProducto p ON f.ProductoID = p.ProductoID
GROUP BY p.Producto, p.Categoria
ORDER BY Venta_Neta DESC;

-- E2: (Medio) ¿Cuál producto vendió más en Leticia? Usa JOIN + WHERE + GROUP BY.
SELECT 
    p.Producto,
    COUNT(*) AS Transacciones,
    ROUND(SUM(f.Precio_Venta * f.Cantidad * (1-f.Descuento_Pct)), 2) AS Venta_Neta
FROM FactVentas f
INNER JOIN DimCiudad c ON f.CiudadID = c.CiudadID
INNER JOIN DimProducto p ON f.ProductoID = p.ProductoID
WHERE c.Ciudad = 'Leticia'
GROUP BY p.Producto
ORDER BY Venta_Neta DESC
LIMIT 1;

-- E3: (Difícil) Reproduce la tabla del dashboard de S4 completa: Ciudad, Ventas, Utilidad, Margen%. Con nombres reales.
SELECT
    c.Ciudad AS Ciudad,
    ROUND(SUM(f.Precio_Venta * f.Cantidad * (1-f.Descuento_Pct)), 2) AS Ventas,
    ROUND(SUM(
        f.Precio_Venta * f.Cantidad * (1-f.Descuento_Pct)
        - f.Costo_Envio
    ), 2) AS Utilidad,
    ROUND(
        SUM(f.Precio_Venta * f.Cantidad * (1-f.Descuento_Pct) - f.Costo_Envio) / 
        SUM(f.Precio_Venta * f.Cantidad * (1-f.Descuento_Pct)) * 100
    , 2) AS Margen_Porcentaje
FROM FactVentas f
INNER JOIN DimCiudad c ON f.CiudadID = c.CiudadID
GROUP BY c.Ciudad
ORDER BY Margen_Porcentaje ASC;
-- ═══════════════════════════════════════════════════════════════
-- ¡Fin de la Unidad 2! Prepárate para Python en la Unidad 3.
-- ═══════════════════════════════════════════════════════════════