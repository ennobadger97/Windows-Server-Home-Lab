# KB-002: "Access is denied" on a shared folder

**Applies to:** Shares on DC01, for example `\\DC01\Sales`
**Last tested:** ____

## Symptoms
A user gets "Access is denied" or "You do not have permission" when opening a share they used to be able to open.

## Cause
Usually the user is not (or is no longer) a member of the security group that holds the permission, or the access token has not refreshed since the group change.

## Steps
1. Confirm the path and that the server is reachable: `ping DC01`, `nslookup DC01`.
2. Run `whoami` to confirm which account is signed in. Clear old connections with `net use * /delete`.
3. In AD Users and Computers check the user's **Member Of** tab for the right group (for example `Sales`).
4. Check **share permissions** and **NTFS permissions**. The most restrictive wins. Use the folder's **Security > Advanced > Effective Access** tab to test the user.
5. Get approval from the manager before restoring access that was removed on purpose.
6. After a group change, ask the user to **sign out and in** (or restart).

## Verify
The user opens the share and creates a test file. Record the approver and the fix in the ticket.

## Escalate when
The permissions look correct but access still fails, or the file server itself shows errors in Event Viewer.
