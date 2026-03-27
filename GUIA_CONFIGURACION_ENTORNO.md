# 🛠️ Guía de Configuración del Entorno SQL

Esta guía te ayudará a configurar tu entorno de trabajo para las sesiones de SQL utilizando **Antigravity** (VS Code) y **SQLite**.

## 1. Instalación de Herramientas
Asegúrate de tener instaladas las siguientes extensiones en VS Code:
- **SQLTools**: La herramienta principal para ejecutar SQL.
- **SQLTools SQLite Driver**: El controlador para trabajar con archivos `.db`.

## 2. Configuración de la Conexión
1. Abre VS Code y haz clic en el icono de **SQLTools** en la barra lateral.
2. Haz clic en "Add New Connection".
3. Selecciona **SQLite (Local File)**.
4. Asígnale un nombre (ej. `NovaMarket_S07`).
5. En "Database File", busca y selecciona el archivo `.db` de la sesión actual (ej. `Sesion_07/novamarket_s07.db`).
6. Haz clic en "Save Connection" y luego en "Connect".

## 3. Ejecución de Consultas
1. Abre un archivo `.sql` (ej. `Sesion_07/S07_NovaMarket_Consultas.sql`).
2. Haz clic en "Focus on Connection" en la parte superior del archivo.
3. Selecciona la conexión que creaste.
4. Resalta el código SQL que quieras ejecutar y presiona `Cmd + E` (Mac) o `Ctrl + E` (Windows).

## 4. Verificación de Datos
Para confirmar que todo está listo, ejecuta:
```sql
SELECT count(*) FROM FactVentas;
```
Deberías ver un resultado de **500** registros.

---
*Si tienes problemas, consulta con tu docente o pregúntale a Antigravity.*
