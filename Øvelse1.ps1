$csvFilePath = "C:\Users\Rune_\OneDrive\Dokumenter\Server Auto2\Server deployment.csv"
$csvData = Import-Csv -Path $csvFilepath -Delimiter ";"
$NytMedlem = [PSCustomObject]@{
    Name = "Benjamin"
    Hobby = "Ridning"
    Level = "Ekspert"
    Sensitive_data = "160789-4651"
}

$csvData += $NytMedlem

$csvData | Export-Csv -Path $csvFilePath -NoTypeInformation

Write-Host "Udpated CSV with new row:"
$csvData