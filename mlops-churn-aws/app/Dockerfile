FROM public.ecr.aws/lambda/python:3.10

WORKDIR ${LAMBDA_TASK_ROOT}

COPY model/requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY app/app.py .

ENV MODEL_BUCKET=mlops-churn-rushi

CMD ["app.handler"]