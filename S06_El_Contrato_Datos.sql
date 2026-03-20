-- ═══════════════════════════════════════════════════════════════
-- NOVAMARKET TECH — SESIÓN 6: EL CONTRATO CON LOS DATOS
-- Verbo: MODELAR (Integridad y Reglas)
-- ═══════════════════════════════════════════════════════════════
/* 
 CONTEXTO:
 En la Sesión 3 (Excel) vimos que el 19% de los registros estaban "sucios".
 Muchos de esos errores (nombres mal escritos, IDs inexistentes)
 no habrían ocurrido si los datos vivieran en una Base de Datos Relacional.
 */
-- 1. OBSERVAR: ¿Qué tablas tenemos en nuestra base de datos?
-- Ejecuta: .tables (en sqlite3) o:
SELECT name
FROM sqlite_master
WHERE type = 'table';
-- 2. INVESTIGAR: ¿Cómo es la estructura de la tabla FactVentas?
-- PRAGMA table_info('FactVentas');
-- 3. EL CONTRATO (Integridad): 
-- Intenta insertar una venta con un ProductoID que NO existe (ej. 999).
-- ¿Qué sucede? ¿Por qué la base de datos "prohíbe" esto?
/*
 INSERT INTO FactVentas (TransaccionID, FechaID, ProductoID, CiudadID, Cantidad, Precio_Venta, Costo_Envio)
 VALUES (9999, 20231124, 999, 1, 10, 500, 80);
 */
-- 4. DILEMA ÉTICO (S06):
-- Tienes acceso de lectura (SELECT) a la base de datos de producción. 
-- Un amigo que trabaja en la competencia te pide "solo una muestra" de 
-- las ventas para ver los precios. ¿Qué implicaciones tiene esto?
-- Deja tu reflexión aquí como comentario.