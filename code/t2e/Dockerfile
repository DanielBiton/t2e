# syntax=docker/dockerfile:1.7

############################
# 1) Builder (build wheels)
############################
FROM python:3.12-slim AS builder

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_NO_CACHE_DIR=1

WORKDIR /app

# OS packages needed only to build some Python deps
RUN apt-get update && apt-get install -y --no-install-recommends \
      build-essential gcc \
    && rm -rf /var/lib/apt/lists/*

# Copy only requirements first (cache-friendly)
COPY requirements.txt .

# Build wheels (fast install in runtime)
# NOTE: This bypasses TLS verification for PyPI hosts (temporary workaround)
RUN pip install --upgrade pip setuptools wheel \
      --trusted-host pypi.org \
      --trusted-host files.pythonhosted.org \
      --trusted-host pypi.python.org \
 && pip wheel --no-cache-dir --wheel-dir /wheels -r requirements.txt \
      --trusted-host pypi.org \
      --trusted-host files.pythonhosted.org \
      --trusted-host pypi.python.org


############################
# 2) Runtime (small, clean)
############################
FROM python:3.12-slim AS runtime

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_NO_CACHE_DIR=1

WORKDIR /app

# non-root user
RUN useradd --create-home --shell /usr/sbin/nologin appuser

# install deps from wheels (no network needed here)
COPY --from=builder /wheels /wheels
COPY requirements.txt .
RUN pip install --no-cache-dir /wheels/*

# copy app code
COPY . .

RUN chown -R appuser:appuser /app
USER appuser

EXPOSE 8000

# Production default:
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]