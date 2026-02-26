#!/bin/bash

# URLs
LOTTO_GEWINNZAHLEN="https://services.lotto-hessen.de/spielinformationen/gewinnzahlen/lotto"
EURO_GEWINNZAHLEN="https://services.lotto-hessen.de/spielinformationen/gewinnzahlen/eurojackpot"
LOTTO_JACKPOT="https://services.lotto-hessen.de/spielinformationen/jackpots/lotto"
EURO_JACKPOT="https://services.lotto-hessen.de/spielinformationen/jackpots/eurojackpot"
LOTTO_ZIEHUNG="https://services.lotto-hessen.de/spielinformationen/ziehungen/lotto"
EUROJACKPOT_ZIEHUNG="https://services.lotto-hessen.de/spielinformationen/ziehungen/eurojackpot"
# Dateiname mit aktuellem Datum
DATEI=lotto-Euro-liste.json

# Abruf und Zusammenfassung der Daten
{
  echo "{"
  echo '  "lotto_gewinnzahlen":'
  curl -s "$LOTTO_GEWINNZAHLEN" -H "Accept: application/json" | jq '.'
  echo ','
  echo '  "eurojackpot_gewinnzahlen":'
  curl -s "$EURO_GEWINNZAHLEN" -H "Accept: application/json" | jq '.'
  echo ','
  echo '  "lotto_jackpot":'
  curl -s "$LOTTO_JACKPOT" -H "Accept: application/json" | jq '.'
  echo ','
  echo '  "eurojackpot_jackpot":'
  curl -s "$EURO_JACKPOT" -H "Accept: application/json" | jq '.'
  echo ','
  echo ' "lotto_ziehung":'
  curl -s "$LOTTO_ZIEHUNG" -H "Accept: application/json" | jq '.'
  echo ','
  echo '"eurojackpot_ziehung":'
  curl -s "$EUROJACKPOT_ZIEHUNG" -H "Accept: application/json" | jq '.'
  echo "}"
} | jq '.' > "$DATEI"

echo "Daten gespeichert in $DATEI"


curl -X POST "http://localhost:8080/api/import?filePath=$(pwd)/$DATEI" -H "Content-Type: application/json"