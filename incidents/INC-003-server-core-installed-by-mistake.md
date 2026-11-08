# INC-003: Server Core installed instead of Desktop Experience

| Field | Value |
|---|---|
| Date | November 2026 |
| Reported by | Self (lab build) |
| Priority | P3 |
| Category | Operating system installation |
| Affected | DC01 virtual machine |
| Status | Resolved |

## Symptom
After installation, the server showed a text-only menu (SConfig) titled *Welcome to Windows Server 2025 Standard Evaluation*, with no desktop and no Server Manager.

## What changed / environment
On the edition selection screen the first option, without "(Desktop Experience)", was chosen. That edition is **Server Core**, which has no graphical tools.

## Troubleshooting timeline
| Step | Action | Result |
|---|---|---|
| 1 | Read the SConfig screen: Server Core, computer name DC01, workgroup mode | Confirmed edition |
| 2 | Checked whether it could be converted to Desktop Experience | In-place conversion is not supported for current versions |
| 3 | Shut down with option 14, attached the ISO again, booted from it (F12 boot menu) | Setup started |
| 4 | Selected **Standard Evaluation (Desktop Experience)**, deleted old partitions, installed to unallocated space | Fresh install with the GUI |
| 5 | Removed the ISO after the first restart | Booted from disk |

## Root cause
Wrong edition selected during setup (user error).

## Resolution
Reinstalled with **Windows Server 2025 Standard Evaluation (Desktop Experience)**. Nothing had been configured yet, so no work was lost.

## Verification
Signed in to a full desktop with Server Manager.

## Prevention / follow-up
Read the edition list carefully before clicking Next. For learning, always choose **Desktop Experience**. Server Core suits experienced administrators using PowerShell and remote tools.
