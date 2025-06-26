FROM public.ecr.aws/lambda/python:3.9

# Instalación de dependencias
COPY requirements.txt ./
RUN pip install -r requirements.txt -t .

# Copiar código de la función
COPY lambda_function.py ./

# Definir el handler
CMD ["lambda_function.lambda_handler"]
