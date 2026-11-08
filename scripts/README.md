# Scripts

## Reset-LabUserPassword.ps1

A helpdesk helper that resets a user's password the safe way.

**What it does**
- Requires `-IdentityVerified`, so the technician must confirm identity checks were done
- Checks the account exists and is not disabled
- Generates a random temporary password using a cryptographic random number generator
- Resets the password, unlocks the account and forces a change at next logon
- Writes an audit entry (time, technician, account, ticket) to `logs/password-resets.csv`
- **Never logs the password**

**Usage**
```powershell
# Dry run: shows what would happen, changes nothing
.\Reset-LabUserPassword.ps1 -SamAccountName tmokoena -TicketNumber INC-0123 -IdentityVerified -WhatIf

# Real run
.\Reset-LabUserPassword.ps1 -SamAccountName tmokoena -TicketNumber INC-0123 -IdentityVerified
```

**Requirements:** the ActiveDirectory PowerShell module (RSAT on CLIENT200, or the domain controller) and permission to reset passwords.

**Status:** draft. Update this section with the results of your own lab tests.

| Test | Result |
|---|---|
| `-WhatIf` makes no changes | |
| Active user is reset and must change password at next logon | |
| Locked user is unlocked and reset | |
| Disabled user is refused | |
| Missing user gives a clear error | |
| Log file contains no password | |

**Safety notes**
- Lab use only. In a real company follow the approved process, and never run scripts you do not understand.
- The password appears on screen once. Do not paste it into tickets or chats.
