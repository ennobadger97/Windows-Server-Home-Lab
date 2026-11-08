<#
.SYNOPSIS
    Resets a lab user's password safely, with logging.

.DESCRIPTION
    Helper for helpdesk practice in the lab.local domain. The script:
      - checks the account exists and is enabled
      - requires you to confirm identity was verified (-IdentityVerified)
      - generates a random temporary password
      - resets the password, unlocks the account and forces a change at next logon
      - writes an audit entry (who, when, which account, ticket number)
    The password is NEVER written to the log. It is shown once on screen so you can
    pass it to the verified user through the approved secure channel.

.PARAMETER SamAccountName
    Logon name of the user, for example tmokoena.

.PARAMETER TicketNumber
    Ticket reference recorded in the audit log.

.PARAMETER IdentityVerified
    Confirms you verified the user's identity using the approved method.

.PARAMETER Length
    Length of the temporary password (default 14).

.PARAMETER LogPath
    CSV file for the audit log (default: logs/password-resets.csv next to the script).

.EXAMPLE
    .\Reset-LabUserPassword.ps1 -SamAccountName tmokoena -TicketNumber INC-0123 -IdentityVerified -WhatIf
    Shows what would happen without changing anything.

.EXAMPLE
    .\Reset-LabUserPassword.ps1 -SamAccountName tmokoena -TicketNumber INC-0123 -IdentityVerified

.NOTES
    Requires the ActiveDirectory module (RSAT or run on the domain controller) and rights
    to reset passwords. For lab and learning use. Test with -WhatIf first.
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [Parameter(Mandatory = $true)]
    [string]$SamAccountName,

    [string]$TicketNumber = 'N/A',

    [switch]$IdentityVerified,

    [ValidateRange(12, 64)]
    [int]$Length = 14,

    [string]$LogPath = (Join-Path $PSScriptRoot 'logs/password-resets.csv')
)

Import-Module ActiveDirectory -ErrorAction Stop

if (-not $IdentityVerified) {
    Write-Error 'Identity must be verified first. Re-run with -IdentityVerified once you have verified the user.'
    return
}

$script:Rng = New-Object System.Security.Cryptography.RNGCryptoServiceProvider

function Get-RandomIndex {
    param([int]$Max)
    $bytes = New-Object byte[] 4
    $script:Rng.GetBytes($bytes)
    return [int]([BitConverter]::ToUInt32($bytes, 0) % $Max)
}

function New-TempPassword {
    param([int]$Length = 14)
    $sets = @('ABCDEFGHJKLMNPQRSTUVWXYZ', 'abcdefghijkmnopqrstuvwxyz', '23456789', '!@#$%*?')
    $chars = New-Object System.Collections.Generic.List[char]
    foreach ($set in $sets) { $chars.Add($set[(Get-RandomIndex $set.Length)]) }   # one from each set
    $all = ($sets -join '').ToCharArray()
    while ($chars.Count -lt $Length) { $chars.Add($all[(Get-RandomIndex $all.Length)]) }
    $arr = $chars.ToArray()
    for ($i = $arr.Length - 1; $i -gt 0; $i--) {                                    # shuffle
        $j = Get-RandomIndex ($i + 1)
        $tmp = $arr[$i]; $arr[$i] = $arr[$j]; $arr[$j] = $tmp
    }
    return -join $arr
}

$user = Get-ADUser -Filter "SamAccountName -eq '$SamAccountName'" -Properties Enabled, LockedOut
if (-not $user) {
    Write-Error "User '$SamAccountName' was not found."
    return
}
if (-not $user.Enabled) {
    Write-Warning "Account '$SamAccountName' is DISABLED. Do not continue without approval from the manager or HR."
    return
}

if ($PSCmdlet.ShouldProcess($SamAccountName, 'Reset password, unlock account and force change at next logon')) {
    $tempPassword = New-TempPassword -Length $Length
    $secure = ConvertTo-SecureString $tempPassword -AsPlainText -Force

    Set-ADAccountPassword -Identity $user.DistinguishedName -Reset -NewPassword $secure
    if ($user.LockedOut) { Unlock-ADAccount -Identity $user.DistinguishedName }
    Set-ADUser -Identity $user.DistinguishedName -ChangePasswordAtLogon $true

    $logDir = Split-Path -Path $LogPath -Parent
    if (-not (Test-Path $logDir)) { New-Item -ItemType Directory -Path $logDir | Out-Null }
    [pscustomobject]@{
        Timestamp    = Get-Date -Format 's'
        Technician   = $env:USERNAME
        Account      = $SamAccountName
        Ticket       = $TicketNumber
        WasLockedOut = $user.LockedOut
        Action       = 'PasswordReset'
    } | Export-Csv -Path $LogPath -Append -NoTypeInformation

    Write-Host "Password reset for $SamAccountName." -ForegroundColor Green
    Write-Host "Temporary password (shown once): $tempPassword" -ForegroundColor Yellow
    Write-Host 'Give it to the verified user through the approved secure channel. The user must change it at next logon.'
}
