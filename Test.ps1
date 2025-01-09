<#
.SYNOPSIS
Script for adding users to a AD-server. 

.DESCRIPTION
This scripts gives you 2 choises, one for Auto mode and one for manual.
Auto mode reads a csv-file and adds the users from the list to the AD-server.
The manual mode, lest you press in the infomation one step at the time for each user.

.PARAMETER Message
The message to log to the specified log file log.txt.

.NOTES
Author: Rune Willum Geertsen
Version: 1.0
Date: 07-01-2025
#>


Write-Host "Select metode of adding users"
Write-Host "Automated from csv file"
Write-Host "Manuel mode"

$choice = Read-Host "Press your option (1 or 2)"

if ($choice -eq "1") {

# Placering af csv filen med brugere
$csvFile = "./users.csv"

# Placering af logfilen
$logFile = "./log.txt"
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
} elseif ($choice -eq "2") {
    # Manuel indtastning
    $Name = Read-Host "Indtast navn"
    $GivenName = Read-Host "Indtast fornavn"
    $Surname = Read-Host "Indtast efternavn"
    $Password = Read-Host "Indtast brugerens kodeord"

    # Opret AD-bruger med indtastede data
    try {
        New-ADUser -Navn $Name 
                   -Fornavn $GivenName 
                   -Efternavn $Surname 
                   -AccountPassword (ConvertTo-SecureString $Password -AsPlainText -Force) 
                   -Enabled $true
        Write-Host "Bruger $Name er oprettet."
    } catch {
        Write-Host "Fejl ved oprettelse af bruger $($Name): $_"
    }
} else {
    Write-Host "Not a valid choice"
}

