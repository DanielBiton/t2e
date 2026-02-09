# syntax=docker/dockerfile:1.7

############################
# 1) Builder (wheels)
############################
FROM python:3.12-slim AS builder

# Prevents Python from writing .pyc files and enables unbuffered logs
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# System deps only needed to build some Python packages

COPY requirements.txt /app

RUN apt-get update && apt-get install -y --no-install-recommends \
      build-essential \
      gcc \
      && pip install -r requirements.txt \
      && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# If your app listens on 8000 (adjust as needed)
EXPOSE 8000

# 3) Simple script:
# CMD ["python", "-m", "myapp"]
CMD ["uvicorn app:app --reload"]