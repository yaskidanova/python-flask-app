ARG PYTHON_VERSION=3.12
ARG APLINE_VERSION=3.22

# python:3.12-alpine3.22 is used as base image for the application 
FROM python:${PYTHON_VERSION}-alpine${APLINE_VERSION}

# disable pyc fules 
ENV PYTHONDONTWRITEBYTECODE=1

# disable buffering 
ENV PYTHONUNBUFFERED=1

WORKDIR /app

# copy everything into your workdir (source - destination)
COPY . .

RUN python -m pip install -r requirements.txt

# How we can prevent from running as a root user ?
# USER nobody or
RUN adduser \
    --disabled-password \
    --home "/nonexistent" \
    --shell "/sbin/nologin" \
    --no-create-home \
    --uid "10001" \
    pythonuser

USER pythonuser

EXPOSE 8000

CMD [ "python3", "-m", "uvicorn", "app:app", "host=0.0.0.0", "port=8000" ]