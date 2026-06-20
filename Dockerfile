# Stage 1 — Build
# Digest épinglé : immuable, plus sécurisé qu'un tag de version (zero trust)
FROM cgr.dev/chainguard/python:latest-dev@sha256:fef18ae0928aa00a0e0f39481cf7aa234b4304962b803bb8ecdd9519eaf5027e AS builder
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir --target /app/deps -r requirements.txt

# Stage 2 — Runtime Chainguard (zéro CVE, zéro shell, non-root par défaut)
FROM cgr.dev/chainguard/python:latest@sha256:c6edbd621ec53f2c6dc7d0d9f3faf930e19af1a76241c0868b8b5da7cd4c9bdc

WORKDIR /app

COPY --from=builder /app/deps ./deps
COPY src/ .

ENV PYTHONPATH=/app/deps

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=3s \
  CMD ["python", "-c", "import urllib.request; urllib.request.urlopen('http://localhost:8080/health')"]

ENTRYPOINT ["python", "app.py"]
