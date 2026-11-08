# Screenshots

Evidence matters. Add these screenshots to this folder, then reference them from the write-ups.

| File name | What to capture |
|---|---|
| `01-virtualbox-vm-list.png` | VirtualBox main window showing DC01, CLIENT100 and CLIENT200 |
| `02-dc01-network-adapters.png` | DC01 VirtualBox network settings (NAT and `labnet`) |
| `03-dc01-ipconfig.png` | `ipconfig /all` on DC01 |
| `04-ad-users-and-computers.png` | The OU structure, users and the `Sales` group |
| `05-dhcp-scope.png` | The active DHCP scope and address range |
| `06-client100-ipconfig.png` | `ipconfig /all` on CLIENT100 showing a DHCP lease from `192.168.50.10` |
| `07-client100-domain-join.png` | System properties showing the `lab.local` domain |
| `08-gpmc-lock-screen-gpo.png` | Group Policy Management showing the linked GPO |
| `09-gpresult.png` | `gpresult /r` showing the GPO applied |
| `10-sales-share-permissions.png` | The Security tab for the Sales folder |
| `11-access-denied-test.png` | The Access denied message for a non-member |
| `12-client200-server-manager.png` | Server Manager on CLIENT200 managing DC01 |

## Before you commit a screenshot
- Crop out personal information, your real computer name, Wi-Fi names and any browser tabs.
- Never show real passwords, product keys or licence keys.
- Use lab data only. Keep file sizes small (PNG, under 1 MB each).
