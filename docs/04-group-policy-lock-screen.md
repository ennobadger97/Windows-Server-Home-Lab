# 04. Group Policy: Lock Screen Inactivity Timeout

## Objective
Make every lab workstation lock itself after a period of inactivity, so an unattended PC cannot be used by someone else. This is a common security requirement and a typical helpdesk and administration task.

## Design
| Item | Choice |
|---|---|
| GPO name | `Lab - Lock Screen Timeout` |
| Linked to | `Lab Computers` OU (contains CLIENT100 and CLIENT200) |
| Setting type | Computer Configuration (applies to the PC regardless of who signs in) |
| Setting | *Interactive logon: Machine inactivity limit* |
| Value | 300 seconds in normal use. 120 seconds while testing |

## Steps
1. In AD Users and Computers, moved CLIENT100 and CLIENT200 into the `Lab Computers` OU. Computers in the default `Computers` container cannot receive OU-linked policies.
2. In Group Policy Management (`gpmc.msc`), right-clicked `Lab Computers` and chose **Create a GPO in this domain, and Link it here**.
3. Edited the GPO: **Computer Configuration > Policies > Windows Settings > Security Settings > Local Policies > Security Options**.
4. Opened **Interactive logon: Machine inactivity limit**, ticked **Define this policy setting**, and entered the value in **seconds**.
5. On the client ran `gpupdate /force` and restarted, because this setting is read at startup.

## Verification checklist
Tick each item as you test it.

- [ ] `gpresult /r` on the client lists `Lab - Lock Screen Timeout` under applied Computer Settings policies
- [ ] After the configured idle time with no keyboard or mouse input, the screen locks
- [ ] The setting still applies after a restart
- [ ] A computer moved out of the `Lab Computers` OU stops receiving the policy (negative test)

## Troubleshooting notes
| Symptom | Likely cause | Check |
|---|---|---|
| Policy not listed in `gpresult` | Computer is in the wrong OU, or the link is disabled | OU location, GPO link and Scope tab |
| Policy listed but PC never locks | Value entered in minutes instead of seconds, or no restart after the change | Setting value, restart |
| `gpupdate` errors | Client cannot reach DC01 | `nltest /dsgetdc:lab.local`, DNS pointing at `192.168.50.10` |

## Rollback
Unlink the GPO from the OU (or disable the link) and run `gpupdate /force` on the clients. Do not delete the GPO until the change is confirmed unwanted.

## What I learned
- Computer and user settings are applied at different times, so some changes only take effect after a restart or a new sign-in.
- Always test with a short timer first, and snapshot the VM before making policy changes.
- Policies only apply where they are linked, so the OU structure matters as much as the setting itself.
