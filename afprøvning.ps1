# Sti til CSV-filen med brugerliste
$csvFile = "C:\Users\Rune_\OneDrive\Dokumenter\Server Auto2\Users.csv"

# Sti til logfil
$logFile = "C:\Users\Rune_\OneDrive\Dokumenter\Server Auto2\Logsoutput\logfile.txt"
$logDirectory = [System.IO.Path]::GetDirectoryName($logFile)

# Opret log-mappen, hvis den ikke allerede eksisterer
if (-not (Test-Path $logDirectory)) {
    New-Item -ItemType Directory -Path $logDirectory
}

# Start logging
Start-Transcript -Path $logFile

# Indlæs brugere fra CSV-fil
$users = Import-Csv -Path $csvFile

foreach ($user in $users) {
    try {
        # Her oprettes brugeren (dette er bare et eksempel på kommando)
        # Udskift denne del med din brugeroprettelseslogik
        New-ADUser -SamAccountName $user.Username -GivenName $user.FirstName -Surname $user.LastName -EmailAddress $user.Email -AccountPassword (ConvertTo-SecureString $user.Password -AsPlainText -Force) -Enabled $true

        # Hvis brugeroprettelsen er succesfuld, log det
        $message = "Bruger oprettet: $($user.FirstName) $($user.LastName) ($($user.Username)) med email $($user.Email)"
        $message | Out-File -FilePath $logFile -Append
    }
    catch {
        # Hvis der opstår en fejl, log den
        $errorMessage = "Fejl ved oprettelse af bruger: $($user.FirstName) $($user.LastName) ($($user.Username)). Fejl: $($_.Exception.Message)"
        $errorMessage | Out-File -FilePath $logFile -Append
    }
}

# Stop logging
Stop-Transcript
