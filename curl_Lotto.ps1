# curl_lotto.ps1
# PowerShell-Version des Shell-Skripts
# URLs
$LOTTO_ZIEHUNG   = "https://services.lotto-hessen.de/spielinformationen/gewinnzahlen/lotto"
$EURO_ZIEHUNG    = "https://services.lotto-hessen.de/spielinformationen/gewinnzahlen/eurojackpot"
$LOTTO_JACKPOT   = "https://services.lotto-hessen.de/spielinformationen/jackpots/lotto"
$EURO_JACKPOT    = "https://services.lotto-hessen.de/spielinformationen/jackpots/eurojackpot"

# Dateiname mit heutigem Datum
$DATEI = "$(Get-Date -Format 'yyyy-MM-dd')_lotto-Euro.json"

# Daten abrufen
Write-Host "Abrufen der Lotto- und Eurojackpot-Daten..."

try {
    $lottoZiehung      = Invoke-RestMethod -Uri $LOTTO_ZIEHUNG -Headers @{ "Accept" = "application/json" }
    $euroZiehung       = Invoke-RestMethod -Uri $EURO_ZIEHUNG  -Headers @{ "Accept" = "application/json" }
    $lottoJackpot      = Invoke-RestMethod -Uri $LOTTO_JACKPOT -Headers @{ "Accept" = "application/json" }
    $euroJackpot       = Invoke-RestMethod -Uri $EURO_JACKPOT  -Headers @{ "Accept" = "application/json" }

    # JSON zusammenbauen
    $gesamt = [PSCustomObject]@{
        lotto_ziehung       = $lottoZiehung
        eurojackpot_ziehung = $euroZiehung
        lotto_jackpot       = $lottoJackpot
        eurojackpot_jackpot = $euroJackpot
    }

    # JSON-Datei schreiben (UTF-8, eingerückt)
    $gesamt | ConvertTo-Json -Depth 5 | Out-File -FilePath $DATEI -Encoding utf8

    Write-Host "✅ Daten gespeichert in: $DATEI"
}
catch {
    Write-Host "❌ Fehler beim Abrufen der Daten: $($_.Exception.Message)"
}
