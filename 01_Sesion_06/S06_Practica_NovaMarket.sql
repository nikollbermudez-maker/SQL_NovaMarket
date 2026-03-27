-- ═══════════════════════════════════════════════════════════════
-- NOVAMARKET TECH — SESIÓN 6: HOLA, SQL (VERSIÓN ANTIGRAVITY)
-- ═══════════════════════════════════════════════════════════════

-- NOTA: En SQLite no usamos CREATE DATABASE. 
-- El archivo .db ya es tu base de datos.

-- ══ BLOQUE B — Crear DimProducto ═══════════════════════════════

CREATE TABLE DimProducto (
    ProductoID   INTEGER       PRIMARY KEY,      -- llave primaria
    Nombre       VARCHAR(100)  NOT NULL,          
    Categoria    VARCHAR(50)   NOT NULL,          
    Precio       DECIMAL(10,2) NOT NULL,          
    Costo        DECIMAL(10,2) NOT NULL           
);

-- Verificar la estructura (Comando SQLite):
-- PRAGMA table_info('DimProducto');


-- ══ BLOQUE C — Insertar los productos ════════════════════════

INSERT INTO DimProducto (ProductoID, Nombre, Categoria, Precio, Costo) VALUES
    (1, 'Laptop Gamer Z',      'Laptops',     2500.00, 1800.00),
    (2, 'Smartphone Pro',      'Smartphones', 1200.00,  800.00),
    (3, 'Smartwatch Q',        'Wearables',    300.00,  180.00),
    (4, 'Audifonos Bluetooth', 'Audio',        150.00,   90.00);

-- Ver margen:
SELECT
    Nombre                                    AS Producto,
    Precio,
    Costo,
    (Precio - Costo)                          AS Margen_Bruto,
    ROUND((Precio - Costo) / Precio * 100, 1) AS Margen_Pct
FROM DimProducto
ORDER BY Margen_Pct DESC;


-- ══ BLOQUE D — DimCiudad (Tu turno) ═══════════════════════════

CREATE TABLE DimCiudad (
    CiudadID       INTEGER       PRIMARY KEY,
    Nombre         VARCHAR(100)  NOT NULL,
    Region         VARCHAR(50)   NOT NULL,
    Factor_Envio   DECIMAL(4,2)  NOT NULL,
    Es_Zona_Remota INTEGER       DEFAULT 0        -- 0 = no, 1 = sí
);

INSERT INTO DimCiudad (CiudadID, Nombre, Region, Factor_Envio, Es_Zona_Remota) VALUES
    (1, 'Bogotá',       'Centro',    1.00, 0),
    (2, 'Medellín',     'Andina',    1.20, 0),
    (3, 'Cali',         'Pacífico',  1.30, 0),
    (4, 'Barranquilla', 'Caribe',    1.50, 0),
    (5, 'Cartagena',    'Caribe',    1.60, 0),
    (6, 'Leticia',      'Amazonia',  8.00, 1);

-- Consulta final de verificación:
SELECT * FROM DimCiudad ORDER BY Factor_Envio DESC;
