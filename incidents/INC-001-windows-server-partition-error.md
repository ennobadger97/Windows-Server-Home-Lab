# INC-001: Windows Server setup cannot select the partition

| Field | Value |
|---|---|
| Date | November 2026 |
| Reported by | Self (lab build) |
| Priority | P3 (one VM blocked, no deadline) |
| Category | Operating system installation |
| Affected | DC01 virtual machine |
| Status | Resolved |

## Symptom
On the "Select location to install Windows Server" screen, `Disk 0 Partition 1` (60 GB, Primary) was shown. Clicking **Next** gave: *"There is an error selecting this partition for install. Please select a different partition or refresh selections."*

## What changed / environment
New VirtualBox VM, fresh 60 GB dynamic disk, Windows Server 2025 evaluation ISO, first install attempt.

## Troubleshooting timeline
| Step | Action | Result |
|---|---|---|
| 1 | Confirmed the disk was new and empty, so nothing could be lost | Safe to wipe |
| 2 | Selected the partition, clicked **Delete Partition** | Disk showed as **Unallocated Space** |
| 3 | Selected the unallocated space and clicked **Next** | Windows created its own partitions and continued |
| Fallback | If it recurred: **Shift+F10**, `diskpart`, `list disk`, `select disk 0`, `clean`, then **Refresh** | Documented, not needed if step 3 worked |
| Fallback 2 | Toggle **Enable EFI** in VM Settings > System > Motherboard | Documented for boot-mode mismatch |

## Root cause
The pre-existing partition on the new virtual disk was not compatible with how the installer wanted to lay out the disk (partition layout or boot-mode mismatch). Letting Windows create the partitions on unallocated space avoids the problem.

## Resolution
Deleted the partition and installed to the unallocated space.

## Verification
Setup began copying files and the VM restarted into the installation.

## Prevention / follow-up
Always install to unallocated space on a new virtual disk, and do not create partitions manually.

## Related
[docs/02-build-notes.md](../docs/02-build-notes.md)
