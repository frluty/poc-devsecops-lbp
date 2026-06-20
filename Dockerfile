# Stage 1 — Build
FROM cgr.dev/chainguard/python:latest-dev AS builder
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir --target /app/deps -r requirements.txt

# Stage 2 — Runtime Chainguard (zéro CVE, zéro shell, non-root par défaut)
FROM cgr.dev/chainguard/python:latest

WORKDIR /app

COPY --from=builder /app/deps ./deps
COPY src/ .

ENV PYTHONPATH=/app/deps

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=3s \
  CMD ["python", "-c", "import urllib.request; urllib.request.urlopen('http://localhost:8080/health')"]

ENTRYPOINT ["python", "app.py"]
