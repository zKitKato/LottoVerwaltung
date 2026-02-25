#!/bin/bash

# URLs
LOTTO_ZIEHUNG="https://services.lotto-hessen.de/spielinformationen/gewinnzahlen/lotto"
EURO_ZIEHUNG="https://services.lotto-hessen.de/spielinformationen/gewinnzahlen/eurojackpot"
LOTTO_JACKPOT="https://services.lotto-hessen.de/spielinformationen/jackpots/lotto"
EURO_JACKPOT="https://services.lotto-hessen.de/spielinformationen/jackpots/eurojackpot"

# Dateiname mit aktuellem Datum
DATEI=$(date +"%Y-%m-%d")_lotto-Euro.json

# Abruf und Zusammenfassung der Daten
{
  echo "{"
  echo '  "lotto_ziehung":'
  curl -s "$LOTTO_ZIEHUNG" -H "Accept: application/json" | jq '.'
  echo ','
  echo '  "eurojackpot_ziehung":'
  curl -s "$EURO_ZIEHUNG" -H "Accept: application/json" | jq '.'
  echo ','
  echo '  "lotto_jackpot":'
  curl -s "$LOTTO_JACKPOT" -H "Accept: application/json" | jq '.'
  echo ','
  echo '  "eurojackpot_jackpot":'
  curl -s "$EURO_JACKPOT" -H "Accept: application/json" | jq '.'
  echo "}"
} | jq '.' > "$DATEI"

echo "Daten gespeichert in $DATEI"