# Logfil placering
$logoutput = "C:\Users\Rune_\OneDrive\Dokumenter\Server Auto2\Logsoutput"

# Funktionen der logger beskeder
function Write-Log {
    param (
        [string]$message,
        [string]$level = "INFO"
    )
    
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "$timestamp - $level - $message"
    $logMessage | Out-File -Append -FilePath $logoutput
}

# Funktionen der opretter brugere
function Create-User {
    param (
        [PSCustomObject]$userInfo
    )

    try {
        # Her starter try funktionen med at oprette brugere til ad, meningen er den så skal give et logoutput, både hvis det går godt, eller skidt.
        
        $username = $userInfo.Username
        $email = $userInfo.Email
        $firstname = $userInfo.FirstName
        $lastname = $userInfo.LastName
        Write-Log "Opretter bruger: $username med email: $email"

        New-ADUser -Name $username -EmailAddress $email -FirstName $firstname -LastName $lastname
        Write-Log "Bruger $username er oprettet succesfuldt."
    } catch {
        Write-Log "Fejl under oprettelse af bruger: $($userInfo.Username). Fejlbesked: $_" -level "ERROR"
    }
}

# Læser CSV-fil og opretter brugere
function Read-And-Create-Users {
    param (
        [string]$csvPath
    )

    try {
        $users = Import-Csv -Path $csvPath
        Write-Log "CSV-fil $csvPath er læst succesfuldt."

        foreach ($user in $users) {
            Create-User -userInfo $user
        }
    } catch {
        Write-Log "Fejl under læsning af CSV-fil: $_" -level "ERROR"
    }
}

# Kører vores funktion
$csvFile = "C:\Users\Rune_\OneDrive\Dokumenter\Server Auto2\Users.csv"
Read-And-Create-Users -csvPath $csvFile

