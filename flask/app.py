from flask import Flask, request, jsonify
import requests

app = Flask(__name__)

# Sustituye estas URLs por las de API Gateway cuando las tengas
ADD_PRODUCT_URL = "https://<API_GATEWAY>/add"
GET_PRODUCTS_URL = "https://<API_GATEWAY>/products"
BUY_PRODUCT_URL = "https://<API_GATEWAY>/buy/{id}"

@app.route('/')
def home():
    return "API Frontend funcionando correctamente"

@app.route('/productos', methods=['GET'])
def get_products():
    response = requests.get(GET_PRODUCTS_URL)
    return jsonify(response.json()), response.status_code

@app.route('/productos/add', methods=['POST'])
def add_product():
    data = request.json
    response = requests.post(ADD_PRODUCT_URL, json=data)
    return jsonify(response.json()), response.status_code

@app.route('/comprar/<int:producto_id>', methods=['POST'])
def comprar_product(producto_id):
    url = BUY_PRODUCT_URL.format(id=producto_id)
    response = requests.post(url)
    return jsonify(response.json()), response.status_code
