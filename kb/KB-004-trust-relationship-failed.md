# KB-004: "The trust relationship between this workstation and the primary domain failed"

**Applies to:** Domain-joined Windows 11 clients
**Last tested:** ____

## Symptoms
A domain user cannot sign in. The sign-in screen shows the trust relationship error.

## Cause
The computer's machine account password is out of sync with AD, for example after restoring an old VM snapshot, resetting the computer account, or the PC being offline for a long time.

## Steps
1. Check the basics first: network, DNS pointing at `192.168.50.10`, correct time.
2. Sign in with the **local administrator** account.
3. In an elevated PowerShell run:
   ```powershell
   Test-ComputerSecureChannel -Repair -Credential LAB\Administrator
   ```
4. If that fails, remove the PC from the domain (switch to a workgroup), restart, rejoin `lab.local`, and restart again.
5. Move the computer object back into the `Lab Computers` OU if it was recreated.

## Verify
A domain user can sign in, and `Test-ComputerSecureChannel` returns `True`.

## Prevention
Avoid restoring old snapshots of domain-joined machines without checking the trust afterwards.
