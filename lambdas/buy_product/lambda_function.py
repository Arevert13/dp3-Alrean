# --- LAMBDA buy_product/lambda_function.py ---
import json
import psycopg2

def lambda_handler(event, context):
    try:
        producto_id = int(event['pathParameters']['producto_id'])

        conn = psycopg2.connect(
            host="<RDS_HOST>",
            database="postgres",
            user="postgres",
            password="<RDS_PASSWORD>",
            port="5432"
        )
        cur = conn.cursor()

        cur.execute("SELECT stock FROM products WHERE id = %s", (producto_id,))
        result = cur.fetchone()

        if not result:
            return {
                'statusCode': 404,
                'body': json.dumps({'error': 'Producto no encontrado'})
            }

        stock = result[0]
        if stock <= 0:
            return {
                'statusCode': 400,
                'body': json.dumps({'error': 'Sin stock disponible'})
            }

        cur.execute("UPDATE products SET stock = stock - 1 WHERE id = %s", (producto_id,))
        conn.commit()

        return {
            'statusCode': 200,
            'body': json.dumps({'message': 'Compra realizada correctamente'})
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
