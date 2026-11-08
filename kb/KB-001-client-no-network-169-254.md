# KB-001: Client has no network or shows a 169.254 address

**Applies to:** Windows 11 clients on the `lab.local` network
**Last tested:** ____ (update this date after you test the steps)

## Symptoms
- `ping` fails, or shows "PING: transmit failed. General failure"
- `ipconfig /all` shows `169.254.x.x` (APIPA) or "Media disconnected"
- Cannot reach shares, the domain or the internet

## Cause
The client did not get an address from DHCP, usually because the network cable is disconnected in the VM, the adapter is on the wrong network, or the DHCP server is not running.

## Steps
1. Run `ipconfig /all`. Note the address and the DHCP server.
2. Confirm the VM adapter is attached to **Internal Network** `labnet` and **Cable Connected** is ticked (VirtualBox Settings > Network > Advanced).
3. Make sure **DC01 is running** and fully started.
4. On DC01 check the **DHCP Server** service is running and the scope is active.
5. On the client run:
   ```text
   ipconfig /release
   ipconfig /renew
   ```
6. Test the chain: `ping 192.168.50.10`, then `nslookup lab.local`.

## Verify
- `ipconfig /all` shows `192.168.50.1xx`, DHCP server `192.168.50.10`, DNS `192.168.50.10`.
- `ping 192.168.50.10` replies.

## Escalate when
The DHCP scope is exhausted or deleted, DC01 cannot start, or many clients are affected at once (a P1 or P2 incident).
