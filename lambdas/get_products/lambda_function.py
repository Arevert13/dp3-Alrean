import json
import psycopg2

def lambda_handler(event, context):
    try:
        conn = psycopg2.connect(
            host="<RDS_HOST>",          # ← Sustituye con el endpoint real de tu RDS
            database="postgres",
            user="postgres",
            password="<RDS_PASSWORD>",  # ← Sustituye con tu contraseña
            port="5432"
        )
        cur = conn.cursor()

        cur.execute("SELECT id, nombre, descripcion, precio, stock, imagen FROM products")
        rows = cur.fetchall()

        productos = [
            {
                "id": r[0],
                "nombre": r[1],
                "descripcion": r[2],
                "precio": float(r[3]),
                "stock": r[4],
                "imagen": r[5]
            } for r in rows
        ]

        return {
            'statusCode': 200,
            'body': json.dumps(productos)
        }

    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }
    finally:
        try:
            cur.close()
            conn.close()
        except:
            pass
