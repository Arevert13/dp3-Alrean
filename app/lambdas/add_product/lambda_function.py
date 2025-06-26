# --- LAMBDA add_product/lambda_function.py ---
import json
import psycopg2

def lambda_handler(event, context):
    try:
        data = json.loads(event['body'])

        conn = psycopg2.connect(
            host="<RDS_HOST>",
            database="postgres",
            user="postgres",
            password="<RDS_PASSWORD>",
            port="5432"
        )
        cur = conn.cursor()

        cur.execute(
            "INSERT INTO products (id, nombre, descripcion, precio, stock, imagen) VALUES (%s, %s, %s, %s, %s, %s)",
            (data['id'], data['nombre'], data['descripcion'], data['precio'], data['stock'], data['imagen'])
        )

        conn.commit()
        cur.close()
        conn.close()

        return {
            'statusCode': 201,
            'body': json.dumps({'message': 'Producto añadido correctamente'})
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