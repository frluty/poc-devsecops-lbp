# Stage 1 — Build
FROM python:3.12-alpine AS builder
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Stage 2 — Runtime minimal
FROM python:3.12-alpine

WORKDIR /app

# Copier uniquement le nécessaire
COPY --from=builder /usr/local/lib/python3.12 \
     /usr/local/lib/python3.12
COPY src/ .

# Recommandation ANSSI — utilisateur non root
RUN addgroup -S appgroup && \
    adduser -S appuser -G appgroup && \
    chown -R appuser:appgroup /app
USER appuser

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=3s \
  CMD wget -q --spider http://localhost:8080/health || exit 1

ENTRYPOINT ["python", "app.py"]