# Placering af csv filen med brugere
$csvFile = "C:\Users\Rune_\OneDrive\Dokumenter\Server Auto2\Users.csv"

# Placering af logfilen
$logFile = "C:\Users\Rune_\OneDrive\Dokumenter\Server Auto2\Logsoutput\logfile.txt"
$logDirectory = [System.IO.Path]::GetDirectoryName($logFile)

# Her er der lavet en if, til at oprette en logfil hvis ikke der er en i forvejen.
if (-not (Test-Path $logDirectory)) {
    New-Item -ItemType Directory -Path $logDirectory
}

# Her starter vi med at oprette bruger ud fra vores csv-fil
$users = Import-Csv -Path $csvFile

foreach ($user in $users) {
    try {
        # Her oprettes brugeren ud fra de parameter vi har i vores csv-fil    
        New-ADUser -SamAccountName $user.Username -GivenName $user.FirstName -Surname $user.LastName -EmailAddress $user.Email -Name $user.FirstName

        # Hvis brugeroprettelsen er succesfuld, skrives det i loggen
        $message = "Bruger oprettet: $($user.FirstName) $($user.LastName) ($($user.Username)) med email $($user.Email)"
        $message | Out-File -FilePath $logFile -Append
    }
    catch {
        # Hvis der opstår en fejl, skrives det i loggen
        $errorMessage = "Fejl ved oprettelse af bruger: $($user.FirstName) $($user.LastName) ($($user.Username)). Fejl: $($_.Exception.Message)"
        $errorMessage | Out-File -FilePath $logFile -Append
    }
}


