import os
import json
import psycopg2

def handler(event, context):
    print("🛒 Realizando compra...")

    try:
        body = json.loads(event.get("body", "{}"))
        product_id = body.get("product_id")
        quantity = body.get("quantity")

        if not product_id or not quantity:
            return {
                "statusCode": 400,
                "body": json.dumps({"error": "Faltan campos 'product_id' o 'quantity'"})
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
        cursor.execute("INSERT INTO pedidos (producto_id, cantidad) VALUES (%s, %s);", (product_id, quantity))
        conn.commit()
        cursor.close()
        conn.close()

        return {
            "statusCode": 200,
            "body": json.dumps({"mensaje": "Compra registrada correctamente"})
        }

    except Exception as e:
        print("❌ Error:", e)
        return {
            "statusCode": 500,
            "body": json.dumps({"error": str(e)})
        }
