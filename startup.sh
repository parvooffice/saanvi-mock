#!/usr/bin/env bash
set -e

cd "$(dirname "$0")"

if curl -fsS "http://127.0.0.1:8080/" >/dev/null 2>&1; then
  exit 0
fi

npm install --silent
npm run dev -- --host 0.0.0.0 --port 8080 >/tmp/nexus-shadow.log 2>&1 &

for _ in {1..30}; do
  if curl -fsS "http://127.0.0.1:8080/" >/dev/null 2>&1; then
    exit 0
  fi
  sleep 1
done

exit 1
