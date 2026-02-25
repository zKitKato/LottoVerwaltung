#!/bin/bash

LOTTO_ZIEHUNG="https://services.lotto-hessen.de/spielinformationen/gewinnzahlen/lotto"
EURO_ZIEHUNG="https://services.lotto-hessen.de/spielinformationen/gewinnzahlen/eurojackpot"
LOTTO_JACKPOT="https://services.lotto-hessen.de/spielinformationen/jackpots/lotto"
EURO_JACKPOT="https://services.lotto-hessen.de/spielinformationen/jackpots/eurojackpot"

DATEI=$(date +"%Y-%m-%d")_lotto-Euro.json

# Sammle alle Daten in einem JSON-Objekt
jq -n \
  --argjson lotto_ziehung "$(curl -s "$LOTTO_ZIEHUNG" -H "Accept: application/json")" \
  --argjson euro_ziehung "$(curl -s "$EURO_ZIEHUNG" -H "Accept: application/json")" \
  --argjson lotto_jackpot "$(curl -s "$LOTTO_JACKPOT" -H "Accept: application/json")" \
  --argjson euro_jackpot "$(curl -s "$EURO_JACKPOT" -H "Accept: application/json")" \
  '{
    lotto_ziehung: $lotto_ziehung,
    eurojackpot_ziehung: $euro_ziehung,
    lotto_jackpot: $lotto_jackpot,
    eurojackpot_jackpot: $euro_jackpot
  }' > "$DATEI"

echo "Daten gespeichert in $DATEI"