# INC-004: Client cannot ping the server ("General failure")

| Field | Value |
|---|---|
| Date | November 2026 |
| Reported by | Self (lab testing) |
| Priority | P2 (client has no network connectivity to the domain controller) |
| Category | Network |
| Affected | Windows 11 client (before the rename to CLIENT100) |
| Status | Resolved |

## Symptom
On the client, `ping 192.168.50.10` returned **"PING: transmit failed. General failure"** four times, with 100% packet loss. File sharing had already been enabled on the server.

## Analysis
- A firewall block normally gives **"Request timed out"**.
- **"General failure"** means the client could not send the packet at all. The fault is on the **client side**: the adapter has no valid IP address, is disconnected, or is on the wrong virtual network.
- The server also has to be running, because it provides DHCP and DNS.

## Troubleshooting timeline
| Step | Action | What it tells you |
|---|---|---|
| 1 | `ipconfig /all` on the client | Adapter state and address |
| 2 | Looked for "Media disconnected", `169.254.x.x`, or `10.0.2.x` | Cable unplugged, DHCP failure, or wrong network attachment |
| 3 | VirtualBox **Settings > Network**: adapter attached to Internal Network named exactly `labnet`, cable connected ticked | Both VMs must share the same name |
| 4 | Started DC01 first, waited for the desktop, then started the client | DHCP server must be running |
| 5 | On DC01: checked `ipconfig /all` (`192.168.50.10`), DHCP service running, scope active | Server side healthy |
| 6 | Client: `ipconfig /release`, `ipconfig /renew`, then `ping 192.168.50.10` | Lease obtained and ping replies |

## Root cause
The client did not have a working connection to the `labnet` network and the DHCP server (adapter attachment or server not yet running when the client started). See [KB-001](../kb/KB-001-client-no-network-169-254.md).

## Resolution
Corrected the VirtualBox network settings, started DC01 first, renewed the DHCP lease, and confirmed with `ipconfig /all`, `ping` and `nslookup lab.local`.

## Verification
Ping replies from `192.168.50.10`, `nslookup lab.local` returned the server address, and the client joined the domain.

## Prevention / follow-up
Start servers before clients. Remember that all clients depend on the DC for DHCP and DNS.
