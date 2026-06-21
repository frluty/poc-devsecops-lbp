#!/bin/sh
set -euo pipefail

IMAGE="ghcr.io/frluty/poc-devsecops-lbp:latest"
COSIGN_PUB="${COSIGN_PUB_PATH:-./cosign.pub}"

if [ ! -f "$COSIGN_PUB" ]; then
  echo "ERREUR : clé publique introuvable ($COSIGN_PUB)"
  echo "Copier cosign.pub sur cette machine et relancer."
  exit 1
fi

echo "==> Vérification de la signature Cosign (offline)..."
cosign verify \
  --key "$COSIGN_PUB" \
  --offline \
  "$IMAGE"

echo "==> Signature valide. Démarrage du conteneur..."
docker compose up -d

echo "==> Conteneur démarré."
docker compose ps
