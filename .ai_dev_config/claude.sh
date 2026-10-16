#!/usr/bin/env bash
# Setup Claude Code + serveurs MCP dans le devcontainer.
# Lancé automatiquement par postCreateCommand (voir devcontainer.json).
set -euo pipefail

WORKSPACE="$(cd "$(dirname "$0")/.." && pwd)"

echo "==> Installation de Claude Code"
npm install -g @anthropic-ai/claude-code

echo "==> Copie de la config MCP vers .mcp.json"
# Claude Code lit .mcp.json à la racine du projet et remplace ${BRAVE_API_KEY}
# par la variable d'environnement : la clé n'est jamais écrite en dur.
cp "$WORKSPACE/.devcontainer/claude_desktop_config.json" "$WORKSPACE/.mcp.json"

if [ -z "${BRAVE_API_KEY:-}" ]; then
  echo "!!  BRAVE_API_KEY n'est pas définie : brave-search ne marchera pas."
  echo "    Exporte-la sur ta machine puis fais 'Rebuild Container'."
fi

echo "==> Préchargement des serveurs MCP"
npx -y @modelcontextprotocol/server-filesystem --help >/dev/null 2>&1 || true

echo "==> Terminé. Lance 'claude' puis '/mcp' pour vérifier les serveurs."
