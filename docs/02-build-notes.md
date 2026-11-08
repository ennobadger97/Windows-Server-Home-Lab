# 02. Build Notes

A condensed record of how the lab was built. Commands are shown so the steps can be repeated.

## 1. Host preparation
- Confirmed virtualization (VT-x or AMD-V) was enabled in Task Manager and the BIOS.
- Installed Oracle VM VirtualBox 7.x (Extension Pack not needed).
- Downloaded evaluation ISOs for Windows Server and Windows 11 from the Microsoft Evaluation Center.

## 2. DC01: install and prepare
1. Created the VM (4 GB RAM, 2 CPUs, 60 GB dynamic disk), with **Skip Unattended Installation** ticked.
2. Added Adapter 2 as an Internal Network named `labnet`, and kept Adapter 1 on NAT.
3. Installed Windows Server **Standard Evaluation (Desktop Experience)**.
4. Installed VirtualBox Guest Additions.
5. Renamed the server to `DC01` and renamed the adapters `Internet` and `LabNet`.
6. Set a static address on LabNet: `192.168.50.10`, mask `255.255.255.0`, DNS `192.168.50.10`, no gateway.

Problems met during this stage are documented in [incidents](../incidents/).

## 3. Active Directory
1. Added the **Active Directory Domain Services** role in Server Manager.
2. Promoted the server to a domain controller with a new forest named `lab.local` and a Directory Services Restore Mode password.
3. Restarted and signed in as `LAB\Administrator`.

## 4. DHCP
1. Added the **DHCP Server** role and completed the configuration (authorised the server in AD).
2. Created the scope `LabScope`: `192.168.50.100` to `192.168.50.200`, DNS `192.168.50.10`, domain `lab.local`, no router option.
3. Activated the scope.

## 5. Users and groups
Created an OU, sample users and a security group. See [03-active-directory-structure.md](03-active-directory-structure.md).

## 6. Domain clients
1. Created CLIENT100 as a Windows 11 VM with EFI and TPM 2.0 enabled and the adapter on `labnet`.
2. Confirmed it received a DHCP lease with `ipconfig /all`, tested `ping 192.168.50.10` and `nslookup lab.local`.
3. Joined it to `lab.local` with `sysdm.cpl` and signed in as a domain user.
4. The VM was originally named CLIENT01 and was renamed to **CLIENT100** to match the naming plan.

## 7. Admin workstation with RSAT (CLIENT200)
1. Built CLIENT200 the same way as CLIENT100 and joined it to the domain.
2. Installed the RSAT features (Server Manager, AD DS tools, Group Policy Management, DNS and DHCP tools) using Optional Features or PowerShell:
   ```powershell
   Add-WindowsCapability -Online -Name Rsat.ServerManager.Tools~~~~0.0.1.0
   Add-WindowsCapability -Online -Name Rsat.ActiveDirectory.DS-LDS.Tools~~~~0.0.1.0
   Add-WindowsCapability -Online -Name Rsat.GroupPolicy.Management.Tools~~~~0.0.1.0
   Add-WindowsCapability -Online -Name Rsat.Dns.Tools~~~~0.0.1.0
   Add-WindowsCapability -Online -Name Rsat.DHCP.Tools~~~~0.0.1.0
   ```
3. In Server Manager chose **Manage > Add Servers** and added `DC01`.
4. Tested `dsa.msc` and `gpmc.msc` from CLIENT200.

## 8. Snapshots
`Server ready`, `Domain joined` and `Policies done` for each VM, plus a snapshot before every experiment.

## Useful commands used during the build
| Command | Why |
|---|---|
| `ipconfig /all` | Check IP, DNS and DHCP server |
| `ping`, `nslookup lab.local` | Test connectivity and DNS |
| `gpupdate /force`, `gpresult /r` | Refresh and verify Group Policy |
| `nltest /dsgetdc:lab.local` | Confirm the client can find a domain controller |
| `whoami` | Confirm which account is signed in |
