# Stage 1 — Build
FROM python:3.12-slim AS builder
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Stage 2 — Runtime minimal 
FROM python:3.12-slim

# Mise à jour des packages système
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copier uniquement le nécessaire
COPY --from=builder /usr/local/lib/python3.12 \
     /usr/local/lib/python3.12
COPY src/ .

# Recommandation ANSSI — utilisateur non root 
RUN groupadd -r appuser && \
    useradd -r -g appuser appuser && \
    chown -R appuser:appuser /app
USER appuser

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=3s \
  CMD curl -f http://localhost:8080/health || exit 1

ENTRYPOINT ["python", "app.py"]