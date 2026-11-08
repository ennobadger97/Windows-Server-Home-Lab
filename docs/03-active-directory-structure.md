# 03. Active Directory Structure

## Structure
```text
lab.local
├── Lab Users            (OU)  - user accounts
│   ├── Thandi Mokoena
│   ├── Sipho Dlamini
│   └── Anna Smith
├── Lab Computers        (OU)  - CLIENT100, CLIENT200
├── Disabled Users       (OU)  - leavers, accounts on hold
└── Groups
    └── Sales            (security group)
```

## Accounts
| Account | Purpose | Notes |
|---|---|---|
| `tmokoena`, `sdlamini`, `asmith` | Sample users for support scenarios | Fictional names, lab passwords only |
| `Sales` (global security group) | Controls access to the Sales share | Members: `tmokoena`, `sdlamini` |
| `labadmin` (optional) | Daily admin account for CLIENT200 | Separate from the built-in `Administrator` (least privilege) |

## Why the OUs exist
- Group Policy links to OUs, not to the default `Computers` container. A computer left in the default container receives no OU-linked policies.
- Moving leavers to **Disabled Users** keeps the directory tidy and makes an access review easy.

## Conventions
- Computers are named by role and number: `DC01`, `CLIENT100`, `CLIENT200`.
- User logon names use first initial plus surname: `tmokoena`.
- Permissions are given to security groups, never to individual users.

## Common tasks practised
| Task | Console | PowerShell |
|---|---|---|
| Reset a password | Right-click user, Reset Password | `Set-ADAccountPassword -Identity tmokoena -Reset` |
| Unlock an account | User Properties, Account tab | `Unlock-ADAccount -Identity tmokoena` |
| Add to a group | Properties, Member Of | `Add-ADGroupMember -Identity Sales -Members tmokoena` |
| Disable a leaver | Right-click, Disable Account | `Disable-ADAccount -Identity tmokoena` |
