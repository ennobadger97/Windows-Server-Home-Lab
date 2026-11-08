# 05. File Shares and Permissions

## Objective
Give the Sales team a shared folder on DC01 and prove that access is controlled by group membership.

## Design
| Item | Choice |
|---|---|
| Folder | `C:\Shares\Sales` on DC01 |
| UNC path | `\\DC01\Sales` |
| Share permission | Everyone: Change (the NTFS layer does the real restricting) |
| NTFS permission | `Sales` group: Modify. Administrators: Full control. Broad groups such as Users removed |
| Group members | `tmokoena`, `sdlamini` |
| Non-member used for testing | `asmith` |

## Key idea: two permission layers
Share permissions control access over the network. NTFS permissions control access to the folder itself. When both apply, **the most restrictive wins**. Access is given to a **group**, so adding or removing a person is a one-minute change.

## Steps
1. Created `C:\Shares\Sales` on DC01.
2. **Properties > Sharing > Advanced Sharing**: shared the folder and set the share permission.
3. **Security > Advanced**: disabled inheritance and converted inherited permissions to explicit ones, removed the broad `Users` group.
4. **Select a principal**: typed `Sales`, clicked **Check Names**, resolved it to `LAB\Sales`, and ticked **Modify**.
5. Signed in on CLIENT100 as `tmokoena` and opened `\\DC01\Sales`, then created a test file.
6. Signed in as `asmith` and confirmed access was denied.

PowerShell equivalent:
```powershell
New-SmbShare -Name Sales -Path C:\Shares\Sales -ChangeAccess "LAB\Sales"
Get-SmbShare
```

## Verification checklist
- [ ] `tmokoena` can create and edit files in `\\DC01\Sales`
- [ ] `asmith` receives "Access is denied"
- [ ] Removing `sdlamini` from `Sales` removes access after a sign-out and sign-in
- [ ] The Effective Access tab on the Security tab matches what I observe

## Troubleshooting notes
| Symptom | Check |
|---|---|
| Cannot reach `\\DC01\Sales` at all | Is DC01 running? `ping DC01`, `nslookup DC01`, correct path |
| Access denied for a member | Group membership, share and NTFS permissions, and whether the user signed out and in after being added |
| Old credentials causing errors | `net use * /delete`, then reconnect |

See also [KB-002](../kb/KB-002-access-denied-shared-folder.md).

## What I learned
- Always test with a member **and** a non-member.
- Group changes only take effect after the user signs out and in, because the access token is built at sign-in.
- Deny permissions override Allow, so I avoid them unless there is a clear reason.
