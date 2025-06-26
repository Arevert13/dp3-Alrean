FROM public.ecr.aws/lambda/python:3.9

# Instala las dependencias
COPY requirements.txt ./
RUN pip install -r requirements.txt -t .

# Copia el código de la lambda
COPY lambda_function.py ./

# Define el handler
CMD ["lambda_function.lambda_handler"]
