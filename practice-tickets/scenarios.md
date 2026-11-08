# Practice Ticket Scenarios

Helpdesk scenarios I work through in the lab. For each one I create the fault, log a ticket, troubleshoot with notes and write the result up.

| ID | Scenario | Priority | Status |
|---|---|---|---|
| T-001 | Forgotten password after leave | P3 | Planned |
| T-002 | Access denied to the Sales share | P3 | Planned |
| T-003 | No network and shared drive missing (DHCP down) | P2 | Planned |
| T-004 | Trust relationship failed | P2 | Planned |
| T-005 | Screen lock timeout not applying | P4 | Planned |

As each one is completed, add a write-up in `incidents/` using [TICKET-TEMPLATE.md](../incidents/TICKET-TEMPLATE.md) and link it here.

## Scenario summaries
1. **T-001:** A user cannot remember their password and has a call at 10:00. Verify identity, reset with change at next logon, confirm sign-in.
2. **T-002:** A Sales user gets "Access is denied" on `\\DC01\Sales`. Check group membership, share and NTFS permissions, sign-out and sign-in, and approval.
3. **T-003:** A client shows a 169.254 address and has no drive mappings. Check the adapter, DHCP service and scope, then renew the lease.
4. **T-004:** A user gets the trust relationship error. Repair the secure channel or rejoin the domain.
5. **T-005:** The lock timeout policy is not applying. Check the OU, GPO link and `gpresult /r`.
