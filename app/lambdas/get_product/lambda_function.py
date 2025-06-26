import os
import json
import psycopg2

def handler(event, context):
    print("🔍 Obteniendo todos los productos...")

    try:
        conn = psycopg2.connect(
            host=os.environ['DB_HOST'],
            dbname=os.environ['DB_NAME'],
            user=os.environ['DB_USER'],
            password=os.environ['DB_PASSWORD'],
            port=os.environ.get('DB_PORT', 5432)
        )
        print("✅ Conexión establecida")

        cursor = conn.cursor()
        cursor.execute("SELECT id, nombre, precio FROM productos;")
        rows = cursor.fetchall()
        cursor.close()
        conn.close()

        productos = [{"id": r[0], "nombre": r[1], "precio": r[2]} for r in rows]

        return {
            "statusCode": 200,
            "body": json.dumps(productos)
        }

    except Exception as e:
        print("❌ Error:", e)
        return {
            "statusCode": 500,
            "body": json.dumps({"error": str(e)})
        }
