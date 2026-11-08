# INC-002: "It looks like you started an upgrade" after restart

| Field | Value |
|---|---|
| Date | November 2026 |
| Reported by | Self (lab build) |
| Priority | P3 |
| Category | Operating system installation |
| Affected | DC01 virtual machine |
| Status | Resolved |

## Symptom
During installation the VM restarted and Setup showed: *"It looks like you started an upgrade and booted from installation media. If you want to continue with the upgrade, remove the media from your PC and click Yes. If you want to perform a clean installation instead, click No."*

## What changed / environment
The installation ISO was still attached to the VM's virtual optical drive, and the boot order had Optical first, so the VM booted from the ISO again after the first restart.

## Troubleshooting timeline
| Step | Action | Result |
|---|---|---|
| 1 | Did **not** click No, because that starts a clean install from scratch | Avoided restarting the whole install |
| 2 | VirtualBox menu: **Devices > Optical Drives > Remove Disk from Virtual Drive** (Force Unmount if asked) | ISO detached |
| 3 | Clicked **Yes** in Setup | VM restarted and booted from the hard disk, install continued |
| Fallback | Shut down, **Settings > Storage**, remove the ISO, set Hard Disk above Optical in the boot order | Documented |

## Root cause
Boot order and the attached ISO sent the VM back to the installer after the file-copy stage.

## Resolution
Removed the ISO from the virtual drive and continued the installation from the hard disk.

## Verification
Setup continued to the first sign-in screen, asking for the Administrator password.

## Prevention / follow-up
Detach the ISO after the first restart, and do not press a key at the "Press any key to boot from CD or DVD" prompt on later restarts.
