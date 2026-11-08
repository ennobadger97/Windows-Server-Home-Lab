# KB-003: Group Policy is not applying to a computer

**Applies to:** Domain-joined Windows 11 clients
**Last tested:** ____

## Symptoms
A policy (for example the lock screen timeout) does not take effect on a PC.

## Cause
Common causes: the computer is in the wrong OU, the GPO is not linked or the link is disabled, security filtering excludes the object, the PC cannot reach the domain controller, or the PC has not restarted since a computer-side change.

## Steps
1. Check the computer's OU in AD Users and Computers. It must not be in the default `Computers` container.
2. In Group Policy Management confirm the GPO is linked to that OU and the link is enabled. Check the **Scope** tab and security filtering.
3. On the client run `gpupdate /force`, then restart (computer settings apply at startup).
4. Run `gpresult /r` and look for the GPO under applied or denied objects.
5. Confirm the client reaches the DC: `nltest /dsgetdc:lab.local`, DNS set to `192.168.50.10`, and the clock is correct.
6. Check for conflicts with a higher-priority or enforced GPO.

## Verify
`gpresult /r` lists the GPO as applied, and the setting works as expected.

## Escalate when
The GPO looks correct and the client reaches the DC but the setting still does not apply, or many computers are affected.
