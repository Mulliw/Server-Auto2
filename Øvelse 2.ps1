$csvFilePath = "C:\Users\Rune_\OneDrive\Dokumenter\Server Auto2\Server deployment.csv"
$csvData = Import-Csv -Path $csvFilepath

$AnonymiseredeData = @()

function Get-MD5Hash {
    param ($inputString)
    $md5 = [System.Security.Cryptography.MD5]::Create()
    $inputBytes = [System.Text.Encoding]::UTF8.GetBytes($inputString)
    $hashBytes = $md5.ComputeHash($inputBytes)
    $hashString = [BitConverter]::ToString($hashBytes) -replace "-", ""
    return $hashString
}

foreach ($row in $csvData) {
    $newRow = [PSCustomObject]@{
        Name = $row.Name
        Hobby = $row.Hobby
        Level = $row.Level
        Sensitive_data = Get-MD5Hash($row.Sensitive_data)
    }
    $AnonymiseredeData += $newRow
}


$AnonymiseredeData | Export-Csv -Path  "C:\Users\Rune_\OneDrive\Dokumenter\Server Auto2\Server deployment.csv" -NoTypeInformation

$csvData
