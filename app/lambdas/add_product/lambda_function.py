import os
import json
import psycopg2

def handler(event, context):
    print("📦 Añadiendo producto...")

    try:
        body = json.loads(event.get("body", "{}"))
        nombre = body.get("nombre")
        precio = body.get("precio")

        if not nombre or precio is None:
            return {
                "statusCode": 400,
                "body": json.dumps({"error": "Faltan campos 'nombre' o 'precio'"})
            }

        conn = psycopg2.connect(
            host=os.environ['DB_HOST'],
            dbname=os.environ['DB_NAME'],
            user=os.environ['DB_USER'],
            password=os.environ['DB_PASSWORD'],
            port=os.environ.get('DB_PORT', 5432)
        )
        print("✅ Conexión a la BBDD exitosa")

        cursor = conn.cursor()
        cursor.execute("INSERT INTO productos (nombre, precio) VALUES (%s, %s);", (nombre, precio))
        conn.commit()
        cursor.close()
        conn.close()

        return {
            "statusCode": 200,
            "body": json.dumps({"mensaje": "Producto añadido correctamente"})
        }

    except Exception as e:
        print("❌ Error:", e)
        return {
            "statusCode": 500,
            "body": json.dumps({"error": str(e)})
        }
