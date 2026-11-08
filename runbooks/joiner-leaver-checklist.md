# Runbook: Joiner and Leaver Checklist

## New starter (joiner)
- [ ] Approved request received (name, role, start date, manager)
- [ ] Account created in the correct OU with the standard naming (`firstinitial+surname`)
- [ ] Added to role-based security groups (for example `Sales`)
- [ ] Temporary password set with change at next logon, handed over securely
- [ ] Computer prepared, joined to the domain and placed in the `Lab Computers` OU
- [ ] Device recorded in the asset list (name, serial number, assigned user)
- [ ] Access tested by signing in as the user
- [ ] Ticket updated and closed

## Leaver
- [ ] Approved request received (HR or manager) with the last working day
- [ ] Account **disabled** (not deleted) at the agreed time
- [ ] Password reset to a random value
- [ ] Removed from all groups and moved to the `Disabled Users` OU
- [ ] Shared drives, mailbox and files handled as instructed by the manager
- [ ] Equipment collected and recorded
- [ ] Ticket updated with what was done and when

## Mover (changes role)
- [ ] Old group memberships removed
- [ ] New role groups added
- [ ] Manager confirms access is correct
