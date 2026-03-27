-- ═══════════════════════════════════════════════════════════════
-- NOVAMARKET TECH — SESIÓN 7: EL INTERROGATORIO
-- Haz las preguntas correctas — SELECT, WHERE, ORDER BY, LIMIT
-- Prerequisito: tener cargada la BD de S6 (S06_NovaMarket_DB_Completa.sql)
-- ═══════════════════════════════════════════════════════════════

USE novamarket_tech;


-- ══════════════════════════════════════════════════════════════
-- BLOQUE A — EL PRIMER VISTAZO: ¿qué hay en esta base de datos?
-- ══════════════════════════════════════════════════════════════

-- A1. Las primeras 10 transacciones — exploración inicial
--     Observa: ¿ves nombres de ciudad o números? ¿por qué?
SELECT * FROM FactVentas LIMIT 10;

-- A2. ¿Cuántas transacciones hay en total?
SELECT COUNT(*) AS Total_Transacciones FROM FactVentas;

-- A3. Las dimensiones — el diccionario del contrato
SELECT * FROM DimCiudad ORDER BY CiudadID;
SELECT * FROM DimProducto ORDER BY ProductoID;

-- A4. Pregunta para reflexionar antes de continuar:
--     En FactVentas, CiudadID=6 corresponde a ¿qué ciudad?
--     ¿Cómo lo verificarías con una consulta?
SELECT Nombre FROM DimCiudad WHERE CiudadID = 6;


-- ══════════════════════════════════════════════════════════════
-- BLOQUE B — SELECT con columnas, alias y cálculos
-- ══════════════════════════════════════════════════════════════

-- B1. Solo las columnas que necesito — no siempre SELECT *
SELECT
    TransaccionID,
    FechaID,
    CiudadID,
    Cantidad,
    Precio_Venta,
    Costo_Envio
FROM FactVentas
LIMIT 15;

-- B2. Columnas calculadas con AS — el analista crea nueva información
--     Venta_Bruta = Precio × Cantidad (sin descuento todavía)
SELECT
    TransaccionID,
    CiudadID,
    Cantidad,
    Precio_Venta,
    Descuento_Pct,
    (Precio_Venta * Cantidad)                        AS Venta_Bruta,
    (Precio_Venta * Cantidad * Descuento_Pct)        AS Descuento_Monto,
    (Precio_Venta * Cantidad * (1 - Descuento_Pct))  AS Venta_Neta
FROM FactVentas
LIMIT 20;

-- B3. ROUND() para controlar decimales en resultados calculados
SELECT
    TransaccionID,
    ROUND(Precio_Venta * Cantidad * (1 - Descuento_Pct), 2) AS Venta_Neta,
    ROUND(Costo_Envio, 2)                                   AS Costo_Envio
FROM FactVentas
LIMIT 10;

-- B4. Columnas de las dimensiones — ¿qué productos tenemos?
SELECT
    Nombre                             AS Producto,
    Categoria,
    Precio_Unitario                    AS Precio,
    Costo_Unitario                     AS Costo,
    (Precio_Unitario - Costo_Unitario) AS Margen_Bruto,
    ROUND((Precio_Unitario - Costo_Unitario)
          / Precio_Unitario * 100, 1)  AS Margen_Pct
FROM DimProducto
ORDER BY Margen_Pct DESC;


-- ══════════════════════════════════════════════════════════════
-- BLOQUE C — WHERE: la precisión de la pregunta
-- ══════════════════════════════════════════════════════════════

-- C1. Filtro simple con = (igualdad)
--     Todas las ventas de Leticia — nota: usamos CiudadID, no el nombre
--     ¿Por qué? Porque el contrato separa los hechos de las dimensiones
SELECT
    TransaccionID,
    FechaID,
    CiudadID,   -- esto es 6, no 'Leticia' — eso lo resuelve JOIN en S9
    Cantidad,
    Precio_Venta,
    Costo_Envio
FROM FactVentas
WHERE CiudadID = 6
ORDER BY FechaID;

-- C2. ¿Cuántas transacciones tiene Leticia?
SELECT COUNT(*) AS Transacciones_Leticia
FROM FactVentas
WHERE CiudadID = 6;

-- C3. Filtro numérico con > (mayor que)
--     Ventas con descuento agresivo (más del 15%)
--     Estos son los que destruyen el margen en Black Friday
SELECT
    TransaccionID,
    FechaID,
    CiudadID,
    Descuento_Pct,
    Precio_Venta,
    ROUND(Precio_Venta * Cantidad * (1 - Descuento_Pct), 2) AS Venta_Neta
FROM FactVentas
WHERE Descuento_Pct > 0.15
ORDER BY Descuento_Pct DESC;

-- C4. Combinando condiciones con AND
--     Ventas de Leticia CON descuento — el peor escenario posible
SELECT
    TransaccionID,
    CiudadID,
    Descuento_Pct,
    Costo_Envio,
    ROUND(Precio_Venta * Cantidad * (1 - Descuento_Pct), 2) AS Venta_Neta
FROM FactVentas
WHERE CiudadID = 6
  AND Descuento_Pct > 0
ORDER BY Descuento_Pct DESC;

-- C5. OR e IN — ciudades de la región Caribe (IDs 4 y 5)
--     Versión con OR:
SELECT TransaccionID, CiudadID, Costo_Envio
FROM FactVentas
WHERE CiudadID = 4 OR CiudadID = 5
LIMIT 10;

--     Versión equivalente con IN (más limpia cuando hay varios valores):
SELECT TransaccionID, CiudadID, Costo_Envio
FROM FactVentas
WHERE CiudadID IN (4, 5)
LIMIT 10;

-- C6. BETWEEN — rango de fechas (noviembre = mes de Black Friday)
--     FechaID tiene formato AAAAMMDD: noviembre 2023 = 20231101 a 20231130
SELECT
    TransaccionID,
    FechaID,
    CiudadID,
    Descuento_Pct,
    Precio_Venta
FROM FactVentas
WHERE FechaID BETWEEN 20231101 AND 20231130
ORDER BY FechaID
LIMIT 20;

-- C7. LIKE — buscar texto en columnas de texto (en dimensiones)
--     Productos cuya categoría empieza por 'S'
SELECT Nombre, Categoria, Precio_Unitario
FROM DimProducto
WHERE Categoria LIKE 'S%';

-- C8. Negación con <> (diferente de) y NOT IN
--     Todo excepto Leticia
SELECT COUNT(*) AS Transacciones_Sin_Leticia
FROM FactVentas
WHERE CiudadID <> 6;

-- C9. IS NULL — verificar si hay valores nulos
--     ¿Hay transacciones sin fecha de evento especial?
SELECT COUNT(*) AS Dias_Sin_Evento
FROM DimFecha
WHERE Evento_Especial IS NULL;

-- C10. Filtro específico de evento — el Black Friday
SELECT COUNT(*) AS Ventas_BlackFriday
FROM FactVentas
WHERE FechaID = 20231124;


-- ══════════════════════════════════════════════════════════════
-- BLOQUE D — ORDER BY y LIMIT: ordenar y limitar resultados
-- ══════════════════════════════════════════════════════════════

-- D1. Las 10 ventas con mayor costo de envío
--     ¿Adivinas de qué ciudad son casi todas?
SELECT
    TransaccionID,
    CiudadID,
    Costo_Envio,
    Precio_Venta,
    Cantidad
FROM FactVentas
ORDER BY Costo_Envio DESC
LIMIT 10;

-- D2. Las 10 ventas con MENOR venta neta (posible pérdida)
SELECT
    TransaccionID,
    CiudadID,
    Precio_Venta,
    Cantidad,
    Descuento_Pct,
    Costo_Envio,
    ROUND(Precio_Venta * Cantidad * (1 - Descuento_Pct) - Costo_Envio, 2) AS Margen_Aproximado
FROM FactVentas
ORDER BY Margen_Aproximado ASC
LIMIT 10;

-- D3. ORDER BY múltiple — primero por ciudad, luego por fecha
SELECT
    TransaccionID,
    CiudadID,
    FechaID,
    Precio_Venta,
    Costo_Envio
FROM FactVentas
ORDER BY CiudadID ASC, FechaID DESC
LIMIT 20;

-- D4. Combinando todo — la pregunta que el CEO necesita responder:
--     ¿Cuáles son las 5 ventas de Leticia con mayor costo de envío?
SELECT
    TransaccionID,
    FechaID,
    ProductoID,
    Cantidad,
    ROUND(Precio_Venta * Cantidad * (1 - Descuento_Pct), 2) AS Venta_Neta,
    Costo_Envio,
    ROUND(Precio_Venta * Cantidad * (1 - Descuento_Pct) - Costo_Envio, 2) AS Margen_Aproximado
FROM FactVentas
WHERE CiudadID = 6
ORDER BY Costo_Envio DESC
LIMIT 5;


-- ══════════════════════════════════════════════════════════════
-- BLOQUE E — DESAFÍOS AUTÓNOMOS
-- ══════════════════════════════════════════════════════════════

-- DESAFÍO 1 (fácil):
-- ¿Cuántas ventas hubo en septiembre de 2023?
-- (FechaID entre 20230901 y 20230930)
-- Tu consulta:



-- DESAFÍO 2 (medio):
-- Muestra las 10 transacciones con mayor Descuento_Pct
-- que NO sean de Leticia (CiudadID <> 6).
-- Columnas: TransaccionID, CiudadID, Descuento_Pct, Precio_Venta
-- Tu consulta:



-- DESAFÍO 3 (difícil):
-- El CEO quiere saber cuántas ventas del mes de noviembre
-- tuvieron un descuento mayor al 20% Y un Costo_Envio mayor a 500.
-- (Estas son las ventas que más destruyen valor)
-- Tu consulta:



-- REFLEXIÓN:
-- En todos los DESAFÍOS anteriores, los resultados muestran CiudadID=6
-- pero no el nombre 'Leticia'. ¿Cómo se resuelve eso?
-- La respuesta llega en la Sesión 9: JOIN une las tablas.
-- Por ahora: ¿puedes hacer una segunda consulta a DimCiudad
-- para verificar qué ciudad es el CiudadID que aparece con más frecuencia?