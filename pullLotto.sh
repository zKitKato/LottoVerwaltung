#!/bin/bash

set -e

fetch_json() {
  URL=$1
  DATA=$(curl -sf -H "Accept: application/json" "$URL") || {
    echo "Fehler beim Laden von $URL"
    exit 1
  }

  echo "$DATA" | jq empty 2>/dev/null || {
    echo "Ungültiges JSON von $URL"
    echo "$DATA"
    exit 1
  }

  echo "$DATA"
}

LOTTO_GEWINNZAHLEN=$(fetch_json "https://services.lotto-hessen.de/spielinformationen/gewinnzahlen/lotto")
EURO_GEWINNZAHLEN=$(fetch_json "https://services.lotto-hessen.de/spielinformationen/gewinnzahlen/eurojackpot")
LOTTO_JACKPOT=$(fetch_json "https://services.lotto-hessen.de/spielinformationen/jackpots/lotto")
EURO_JACKPOT=$(fetch_json "https://services.lotto-hessen.de/spielinformationen/jackpots/eurojackpot")
LOTTO_ZIEHUNG=$(fetch_json "https://services.lotto-hessen.de/spielinformationen/ziehungen/lotto")
EUROJACKPOT_ZIEHUNG=$(fetch_json "https://services.lotto-hessen.de/spielinformationen/ziehungen/eurojackpot")

DATEI="lotto-Euro-liste.json"

jq -n \
  --argjson lotto_gewinnzahlen "$LOTTO_GEWINNZAHLEN" \
  --argjson eurojackpot_gewinnzahlen "$EURO_GEWINNZAHLEN" \
  --argjson lotto_jackpot "$LOTTO_JACKPOT" \
  --argjson eurojackpot_jackpot "$EURO_JACKPOT" \
  --argjson lotto_ziehung "$LOTTO_ZIEHUNG" \
  --argjson eurojackpot_ziehung "$EUROJACKPOT_ZIEHUNG" \
  '{
    lotto_gewinnzahlen: $lotto_gewinnzahlen,
    eurojackpot_gewinnzahlen: $eurojackpot_gewinnzahlen,
    lotto_jackpot: $lotto_jackpot,
    eurojackpot_jackpot: $eurojackpot_jackpot,
    lotto_ziehung: $lotto_ziehung,
    eurojackpot_ziehung: $eurojackpot_ziehung
  }' > "$DATEI"

echo "Daten gespeichert in $DATEI"

curl -X POST http://localhost:8080/api/import \
  -H "Content-Type: application/json" \
  -d @"$DATEI"