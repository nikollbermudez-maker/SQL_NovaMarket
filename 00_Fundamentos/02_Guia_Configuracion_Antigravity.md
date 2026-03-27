# 🛠️ Guía de Configuración: Entorno de Datos SQL

Esta guía te llevará de **cero a funcional** para que puedas trabajar en todas las sesiones de SQL de NovaMarket Tech utilizando VS Code y tu asistente de IA, **Antigravity**.

---

## Paso 1: Instalación de Extensiones 🧩
Abre VS Code, ve al mercado de extensiones (`Cmd + Shift + X`) e instala las siguientes:

1.  **SQLTools**: (Autor: Matheus Teixeira). Es el motor para ejecutar SQL.
2.  **SQLTools SQLite/Bun/DuckDB Driver**: (Autor: Matheus Teixeira). Permite que SQLTools entienda archivos `.db`.
3.  **SQLite Viewer**: (Autor: florianpircher). Para ver tus bases de datos como si fueran un archivo de Excel.

---

## Paso 2: Abrir tu Espacio de Trabajo 📂
1.  Descarga o clona la carpeta del proyecto `SQL`.
2.  En VS Code, ve a **File > Open Folder...** y selecciona la carpeta raíz `SQL`.
3.  Deberías ver archivos como `README.md`, `GLOSARIO_ESTUDIANTE.md` y las carpetas de las sesiones.

---

## Paso 3: Configurar la Conexión SQL (Visual) ⚡
Para ejecutar código SQL con un clic:

1.  Haz clic en el icono de **SQLTools** en la barra lateral izquierda (parece un cilindro).
2.  Haz clic en el botón **"+" (Add New Connection)**.
3.  Selecciona **SQLite**.
4.  **Connection Name:** Escribe `NovaMarket`.
5.  **Database File:** Haz clic en "Select from computer" y busca el archivo `novamarket_v3.db` (o el de la sesión actual, como `novamarket_s07.db`).
6.  Haz clic en **SAVE CONNECTION** y luego en **CONNECT**.

> **Pro Tip:** Ahora, en cualquier archivo `.sql`, selecciona una línea de código y presiona `Cmd + E` para ejecutarla.

---

## Paso 4: Uso de la Terminal (El Motor) 💻
A veces es más rápido usar la terminal. 

1.  Abre la terminal en VS Code (`Ctrl + ñ` o `Terminal > New Terminal`).
2.  Escribe el comando para entrar a la base de datos:
    ```bash
    sqlite3 novamarket_s07.db
    ```
3.  **Comandos útiles dentro de SQLite:**
    *   `.tables` → Ver qué tablas hay.
    *   `.schema NombreTabla` → Ver las columnas de una tabla.
    *   `.exit` → Salir.

---

## Paso 5: Trabajando con Antigravity (Tu Mentor IA) 🤖
Antigravity no solo escribe código por ti, te ayuda a entenderlo.

*   **¿No funciona tu código?** Selecciona el error y abre el chat de Antigravity. Dile: *"Explícame por qué falló esta consulta"*.
*   **¿Necesitas una consulta nueva?** Pídele: *"Crea una consulta que me muestre las 5 ventas más caras de Bogotá"*.
*   **Aprendizaje Ativo:** Siempre pregunta *"¿Por qué usamos esta función?"* para profundizar tu conocimiento.

---

## Resumen de Reglas de Oro ✨
1.  **Punto y Coma:** Todas las sentencias SQL deben terminar en `;`.
2.  **Case Insensitive:** SQL no distingue entre mayúsculas y minúsculas (`select` es igual a `SELECT`), pero es buena práctica usar mayúsculas para los comandos.
3.  **Cuidado con los archivos `.db`:** Son tu base de datos real. No los borres a menos que quieras empezar de cero.

---
*¡Listo! Ya tienes un entorno profesional de análisis de datos. ¡A darle!*
