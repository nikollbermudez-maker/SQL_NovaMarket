# Sesión 6 | El Contrato con los Datos
## Guía del Estudiante
**Cuando los datos tienen que respetar reglas — el modelo relacional como diseño preventivo**

> Énfasis II – Análisis de Datos | Semana 6 | Unidad 2: El Interrogatorio | NovaMarket Tech

---

## Ficha de la sesión

| Dato | Información |
|---|---|
| Sesión | 6 — El Contrato con los Datos |
| Proceso analítico | **MODELAR** — el modelo relacional como sistema de reglas que los datos deben cumplir |
| Herramienta | DB Fiddle: dbfiddle.uk → seleccionar **MySQL 8.0** |
| Archivo de referencia | `S06_Practica_DB_Fiddle.sql` — úsalo solo si te bloqueas completamente; intenta primero por tu cuenta |
| Entregable | URL de tu sesión en DB Fiddle con los 4 bloques ejecutados y los errores capturados como comentarios |

> **Tu misión hoy:** ¿Qué habría pasado si los datos de NovaMarket hubieran vivido en una base de datos relacional desde el principio?
>
> Hoy construirás ese sistema de contratos desde cero en SQL. Cada línea de código que escribas corresponde a una regla que en S3 tuviste que hacer cumplir a mano. Al final, el motor SQL rechazará automáticamente datos que habrían pasado desapercibidos en Excel.

---

## Referencia rápida — Tipos de dato

| Tipo | Para qué | Regla de comillas |
|---|---|---|
| `INT` | Números enteros (IDs, cantidades) | Sin comillas: `1`, `42` |
| `DECIMAL(10,2)` | Números con 2 decimales (precios, costos) | Sin comillas: `2500.00`, `1.50` |
| `VARCHAR(n)` | Texto de hasta n caracteres | Con comillas simples: `'Bogotá'`, `'Laptops'` |
| `DATE` | Fechas en formato YYYY-MM-DD | Con comillas simples: `'2023-11-24'` |
| `TINYINT(1)` | Booleano: 0 = no, 1 = sí | Sin comillas: `0`, `1` |

> ⚠️ **Regla de oro:** Números sin comillas. Texto y fechas con comillas simples. Violar esta regla = cláusula rota.

---

## Referencia rápida — Las cláusulas del contrato

| Cláusula | Lo que dice | Problema de S3 que habría prevenido |
|---|---|---|
| `PRIMARY KEY` | Ninguna fila puede ser anónima ni repetirse | Duplicados (Problema 1) |
| `NOT NULL` | Este campo no puede quedar vacío | Nulos en Cantidad (Problema 5) |
| `DECIMAL(10,2)` | Solo números con 2 decimales | Precios como texto (Problema 6) |
| `FOREIGN KEY ... REFERENCES` | Este valor debe existir en la tabla referenciada | Ciudades inconsistentes (Problema 2) |
| `CHECK (condición)` | Este valor debe cumplir esta regla de negocio | Cualquier valor sin sentido de negocio |

---

## Verificación inicial — Antes de empezar

1. Abre el navegador y ve a: **dbfiddle.uk**
2. En el menú desplegable selecciona **MySQL 8.0** (no 8.4 — tiene un bug visual)
3. Borra cualquier texto de ejemplo del panel izquierdo

---

## Bloque A — Configurar el entorno (15 min)

### Paso 1 — El primer comando del contrato

Escríbelo tú (no lo pegues):

```sql
-- SQL ignora los comentarios — los dos guiones (--) al inicio son comentario

CREATE DATABASE novamarket;
USE novamarket;

-- CREATE DATABASE = crea el archivo que guardará todas las tablas
-- USE = activa esa base de datos para que los siguientes comandos vivan ahí
```

Presiona **Ctrl+Enter** (o el botón Run) para ejecutar.

| Pregunta | Tu respuesta |
|---|---|
| ¿El comando se ejecutó sin error? | SÍ / NO |
| Si hubo error: ¿qué decía? | |

> ✅ **Checkpoint A:** CREATE DATABASE ejecutado sin error rojo. Si aparece error: ¿tiene el punto y coma (`;`) al final? ¿Seleccionaste MySQL 8.0 y no 8.4?

---

## Bloque B — Redactar el contrato: CREATE TABLE DimProducto (25 min)

### Paso 2 — Leer el contrato antes de firmarlo

Antes de escribir el código, lee esta tabla. Cada cláusula que escribirás tiene un significado y previene un problema:

| Cláusula | Lo que dice el contrato | Problema de S3 que habría prevenido |
|---|---|---|
| `INT PRIMARY KEY` | Ningún producto puede tener el mismo ID | Duplicados (Problema 1) |
| `VARCHAR(100) NOT NULL` | Texto de hasta 100 caracteres, no puede quedar vacío | Nombre vacío: imposible |
| `DECIMAL(10,2) NOT NULL` | Número con exactamente 2 decimales, no puede quedar vacío | Precios como texto (Problema 6) |

### Paso 3 — Escribir el contrato línea a línea

Agrega esto **debajo** del código anterior. Escríbelo línea a línea:

```sql
CREATE TABLE DimProducto (
    ProductoID   INT           PRIMARY KEY,   -- ningún producto puede ser anónimo
    Nombre       VARCHAR(100)  NOT NULL,       -- un producto sin nombre no entra
    Categoria    VARCHAR(50)   NOT NULL,       -- categoría vacía: imposible
    Precio       DECIMAL(10,2) NOT NULL,       -- precio como texto '$2500': imposible
    Costo        DECIMAL(10,2) NOT NULL        -- costo vacío: imposible
);
```

Luego verifica:

```sql
SHOW TABLES;          -- ¿qué tablas tiene la base de datos?
DESCRIBE DimProducto; -- ¿cuáles son las cláusulas del contrato?
```

| Pregunta | Tu respuesta |
|---|---|
| ¿Cuántas tablas muestra SHOW TABLES? | |
| ¿Cuál columna tiene 'PRI' en la columna Key? | |
| ¿Cuántas columnas tienen 'NO' en la columna Null? | |

> ✅ **Checkpoint B:** SHOW TABLES muestra 1 tabla. DESCRIBE DimProducto muestra 5 columnas. ProductoID tiene 'PRI' en Key. Todas las columnas tienen 'NO' en Null.

---

## Bloque C — Firmar el contrato con datos + probarlo (25 min)

### Paso 4 — Insertar los 4 productos

```sql
INSERT INTO DimProducto (ProductoID, Nombre, Categoria, Precio, Costo) VALUES
    (1, 'Laptop Gamer Z',      'Laptops',     2500.00, 1800.00),
    (2, 'Smartphone Pro',      'Smartphones', 1200.00,  800.00),
    (3, 'Smartwatch Q',        'Wearables',    300.00,  180.00),
    (4, 'Audifonos Bluetooth', 'Audio',        150.00,   90.00);
-- Texto con comillas simples. Números sin comillas.
```

| Pregunta | Tu respuesta |
|---|---|
| ¿Cuántas filas afectadas? | |

### Paso 5 — Consultar el contrato

```sql
-- Ver todos los productos
SELECT * FROM DimProducto;

-- Ver nombre y margen calculado
SELECT
    Nombre                                     AS Producto,
    Precio,
    Costo,
    (Precio - Costo)                           AS Margen_Bruto,
    ROUND((Precio - Costo) / Precio * 100, 1)  AS Margen_Pct
FROM DimProducto
ORDER BY Margen_Pct DESC;
```

| Producto | Margen_Bruto ($) | Margen_Pct (%) |
|---|---|---|
| Laptop Gamer Z | | |
| Smartphone Pro | | |
| Smartwatch Q | | |
| Audifonos Bluetooth | | |

### Paso 6 — Probar que PRIMARY KEY funciona

Ejecuta este INSERT que intenta violar la cláusula PRIMARY KEY:

```sql
INSERT INTO DimProducto (ProductoID, Nombre, Categoria, Precio, Costo)
VALUES (1, 'Laptop Duplicada', 'Laptops', 2500.00, 1800.00);
-- ProductoID=1 ya existe — el contrato dice que no puede repetirse
```

| Pregunta | Tu respuesta |
|---|---|
| ¿Aceptó o rechazó el INSERT? | |
| ¿Qué problema de S3 acaba de ser rechazado automáticamente? | |

> ✅ **Checkpoint C:** DimProducto tiene 4 filas. El SELECT con cálculo muestra 4 productos con sus márgenes. El INSERT con ProductoID=1 duplicado fue rechazado con error de PRIMARY KEY.

---

## Bloque D — DimCiudad + la prueba definitiva del contrato (25 min)

> **Ahora con menos guía.** Usarás el patrón del Bloque B para crear DimCiudad. El momento más importante de este bloque es el último paso: el INSERT con una ciudad que no existe.

### Paso 7 — Crear DimCiudad

La tabla DimCiudad debe tener estas columnas:

| Columna | Tipo | Cláusula | ¿Qué previene? |
|---|---|---|---|
| `CiudadID` | `INT` | `PRIMARY KEY` | Dos ciudades con el mismo ID: imposible |
| `Nombre` | `VARCHAR(100)` | `NOT NULL` | Ciudad sin nombre: imposible |
| `Region` | `VARCHAR(50)` | `NOT NULL` | Región vacía: imposible |
| `Factor_Envio` | `DECIMAL(4,2)` | `NOT NULL` | Factor vacío o como texto: imposible |
| `Es_Zona_Remota` | `TINYINT(1)` | `DEFAULT 0` | Si no se especifica, valor por defecto es 0 |

Escribe el `CREATE TABLE DimCiudad` tú mismo (sin mirar el archivo de referencia):

```sql
-- Tu CREATE TABLE DimCiudad aquí:



```

Verifica con `DESCRIBE DimCiudad`.

### Paso 8 — Insertar las 6 ciudades

| CiudadID | Nombre | Region | Factor_Envio | Es_Zona_Remota |
|---|---|---|---|---|
| 1 | Bogotá | Centro | 1.00 | 0 |
| 2 | Medellín | Andina | 1.20 | 0 |
| 3 | Cali | Pacífico | 1.30 | 0 |
| 4 | Barranquilla | Caribe | 1.50 | 0 |
| 5 | Cartagena | Caribe | 1.60 | 0 |
| 6 | **Leticia** | Amazonia | **8.00** | **1** ← zona remota: Factor_Envio 8× mayor que Bogotá |

Escribe el `INSERT INTO DimCiudad` con las 6 ciudades.

Verifica con:
```sql
SELECT * FROM DimCiudad ORDER BY Factor_Envio DESC;
```

| Pregunta | Tu respuesta |
|---|---|
| ¿Cuál ciudad tiene el mayor Factor_Envio? | |
| ¿Cuántas ciudades tienen Es_Zona_Remota=1? | |

### Paso 9 — La prueba definitiva: el INSERT que el contrato debe rechazar ⭐

Este es el momento más importante de la sesión. Ejecuta este INSERT:

```sql
-- Para la demostración necesitamos una tabla con FK
CREATE TABLE FactVentas_Demo (
    TransaccionID INT PRIMARY KEY,
    CiudadID      INT NOT NULL,
    Cantidad      INT NOT NULL CHECK (Cantidad > 0),
    CONSTRAINT fk_ciudad_demo
        FOREIGN KEY (CiudadID) REFERENCES DimCiudad(CiudadID)
);

-- Ahora el INSERT que el contrato debe rechazar:
INSERT INTO FactVentas_Demo VALUES (9001, 99, 2);
-- CiudadID=99 no existe en DimCiudad
-- El contrato dice: no puedes referenciar algo que no existe
```

| Pregunta | Tu respuesta |
|---|---|
| Copia aquí el mensaje de error exacto: | |
| ¿Qué problema de S3 habría detectado este error? | |
| ¿Cuántos minutos pasaste en S3 corrigiendo ese problema manualmente? | |

> ✅ **Checkpoint D:** DimCiudad tiene 6 filas. Leticia tiene Factor_Envio=8.00 y Es_Zona_Remota=1. El INSERT con CiudadID=99 fue rechazado con error de FOREIGN KEY.

---

## Reflexión de cierre

> **La pregunta que abrió la sesión, ahora que tienes la evidencia:**
>
> Al inicio preguntamos: "¿Cuántos de los 6 problemas de S3 habrían sido imposibles si los datos hubieran vivido en una BD relacional?"
>
> Completa la tabla con la cláusula SQL exacta que habría prevenido cada problema:

| Problema de S3 | ¿Habría sido imposible? | Cláusula SQL que lo previene |
|---|---|---|
| 1. Filas duplicadas | | |
| 2. Ciudades inconsistentes | | |
| 3. Categorías inconsistentes | | |
| 4. Fechas como texto | | |
| 5. Nulos en Cantidad | | |
| 6. Precios como texto | | |

---

## Para antes de la Sesión 7 — Instalar el entorno local

> **¿Por qué instalar si DB Fiddle funciona?** En S7 cargarás la BD completa de NovaMarket: 500 transacciones, 91 días, 6 ciudades. Un script de esa envergadura puede dar timeout en DB Fiddle. MySQL Workbench o Antigravity trabajan localmente — más rápido y sin límites.

**Opción A — MySQL Workbench (Windows)**
1. mysql.com/downloads/installer → "MySQL Installer Community" (~500 MB)
2. Instalar → "Developer Default" → seguir el asistente
3. Configurar contraseña de root (anotarla)
4. Verificar: abrir Workbench → conectar a localhost → "Connection successful"

**Opción B — MySQL Workbench (Mac)**
1. mysql.com/downloads/community → `.dmg` para macOS (versión ARM para M1/M2)
2. Instalar MySQL Server primero, luego MySQL Workbench por separado

**Opción C — Antigravity (extensión SQLTools)**
1. Extensions → buscar "SQLTools" → instalar
2. Buscar "SQLTools MySQL/MariaDB Driver" → instalar
3. Ctrl+Shift+P → SQLTools: Add New Connection → configurar con localhost y contraseña de root
4. Alternativa sin servidor: SQLTools SQLite Driver — trabaja con archivo `.db`, sin servidor

> Si hay problemas con la instalación, avisar al docente. Se puede continuar con DB Fiddle para las primeras consultas de S7.

---

## Lo que viene en S7 — El Interrogatorio

En S6 firmaste el contrato con dos tablas pequeñas. En S7 trabajarás con la **BD completa de NovaMarket**: 500 transacciones reales de Sep–Nov 2023. La primera consulta que escribirás responde la pregunta que el CEO necesita: ¿cuánto perdió Leticia?

---
*Sesión 6 | El Contrato con los Datos | NovaMarket Tech | Análisis de Datos para la Toma de Decisiones*
# 🚀 Guía de Ejecución: Sesión 6 (Antigravity)

Esta guía te explica **cómo realizar** la práctica de "El Contrato con los Datos" dentro de VS Code.

## 1. Preparar la Base de Datos
En SQLite, trabajamos sobre archivos. Sigue estos pasos en tu **Terminal**:

1.  Asegúrate de estar en la carpeta del curso.
2.  Crea tu base de datos de trabajo para hoy:
    ```bash
    sqlite3 01_Base_Datos_S06.db
    ```
3.  Sal de la terminal de SQLite con `.exit` para seguir trabajando.

## 2. Redactar el Contrato (Script SQL)
Abre el archivo `01_Practica_SQL_S06.sql`. Aquí es donde escribirás tus comandos.

1.  **Crear la tabla:** Selecciona el bloque de `CREATE TABLE DimProducto` y presiona `Cmd + E`.
2.  **Verificar:** Para ver si la tabla se creó, ejecuta:
    ```sql
    PRAGMA table_info('DimProducto');
    ```

## 3. Probar las Reglas
El objetivo de hoy es que veas cómo el sistema rechaza errores comunes:

-   **Prueba de Duplicados:** Ejecuta dos veces el mismo `INSERT` con el ID 1.
-   **Prueba de Nulos:** Intenta insertar un producto sin nombre.

> **Uso de Antigravity:** Si un error te confunde, selecciona el mensaje de error rojo y pregúntale a Antigravity: *"Explícame esta restricción de PRIMARY KEY"*.

## 4. Próximos Pasos
Una vez que domines las dimensiones (Producto y Ciudad), estarás listo para la Sesión 7, donde uniremos estas reglas con 500 filas de ventas reales.

---
*Sesión 06 | Ejecución | NovaMarket Tech*
