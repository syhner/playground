# Download ISO from https://nixos.org/download
# UTM
# Create a new VM
# Virtualize if using same architecture as host, otherwise Emulate
# Linux
# Memory 8GiB preferable minimum
# CPU Cores 4 preferred minimum
# Can disable display output if using minimal ISO
# Boot from ISO
# Storage 64 GiB preferred minimum
# (optional) Sharing -> Select macOS folder (e.g., ~/shared-utm)
# Name - nixos
# Check 'Open VM Settings'
# QEMU - Should be enabled: UEFI Boot, RNG Device, Use Hypervisor
# Network - Should be Shared Network
# Display (if not using minimal ISO) - Emulated Display Card: Can be changed from 'virtio-gpu-pci' to 'virtio-ramfb-gl (GPU Supported)'
# Start VM
# Use LTS installer

# -------------------------------------
# Sanity checks
# -------------------------------------

# uname = Unix name/system info.
# -m prints the machine architecture.
[nixos@nixos:~]$ uname -m
aarch64 # ARM64 architecture: correct for Apple Silicon/UTM

# ip manages Linux networking.
# link lists network devices/interfaces, not IP addresses.
[nixos@nixos:~]$ ip link
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00  # local loopback interface
2: enp0s1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP mode DEFAULT group default qlen 1000
    link/ether 7a:b5:e5:c4:56:27 brd ff:ff:ff:ff:ff:ff     # active virtual ethernet device
    altname enx7ab5e5c45627

# ping tests network + DNS.
# -c 3 sends exactly 3 packets, then stops.
[nixos@nixos:~]$ ping -c 3 nixos.org
PING nixos.org (75.2.60.5) 56(84) bytes of data.
64 bytes from acd89244c803f7181.awsglobalaccelerator.com (75.2.60.5): icmp_seq=1 ttl=255 time=17.6 ms
64 bytes from acd89244c803f7181.awsglobalaccelerator.com (75.2.60.5): icmp_seq=2 ttl=255 time=16.5 ms
64 bytes from acd89244c803f7181.awsglobalaccelerator.com (75.2.60.5): icmp_seq=3 ttl=255 time=18.8 ms

--- nixos.org ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2005ms  # internet/DNS OK
rtt min/avg/max/mdev = 16.492/17.612/18.758/0.925 ms            # good latency

# -------------------------------------
# Partitioning
# -------------------------------------

# lsblk = list block devices.
# Shows disks, partitions, sizes, and mountpoints.
[nixos@nixos:~]$ lsblk
NAME   MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
loop0    7:0    0   1.5G  1 loop /nix/.ro-store   # live ISO read-only Nix store
sr0     11:0    1   1.6G  0 rom  /iso             # attached installer ISO/CD-ROM
vda    254:0    0    64G  0 disk                  # target VM disk, currently unpartitioned

# switch to root user to run privileged commands
[nixos@nixos:~]$ sudo su

# parted edits disk partition tables.
# mklabel gpt creates a new GPT partition table on /dev/vda.
# This effectively resets the disk partition layout.
[root@nixos:/home/nixos]# parted /dev/vda -- mklabel gpt
Information: You may need to update /etc/fstab.        # normal; config not generated yet

# mkpart creates a partition.
# ESP = EFI System Partition, used by UEFI firmware to boot.
# fat32 is the intended filesystem type marker.
[root@nixos:/home/nixos]# parted /dev/vda -- mkpart ESP fat32 1MiB 512MiB
Information: You may need to update /etc/fstab.        # normal

# set 1 esp on marks partition 1 as the EFI System Partition.
[root@nixos:/home/nixos]# parted /dev/vda -- set 1 esp on
Information: You may need to update /etc/fstab.        # normal

# Create the main Linux partition from 512MiB to the end of the disk.
[root@nixos:/home/nixos]# parted /dev/vda -- mkpart primary ext4 512MiB 100%
Information: You may need to update /etc/fstab.        # normal

# Verify the partition layout.
[root@nixos:/home/nixos]# lsblk
NAME   MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
loop0    7:0    0   1.5G  1 loop /nix/.ro-store       # live ISO store
sr0     11:0    1   1.6G  1 rom  /iso                 # installer ISO
vda    254:0    0    64G  0 disk
├─vda1 254:1    0   511M  0 part                      # EFI boot partition
└─vda2 254:2    0  63.5G  0 part                      # main NixOS partition

# mkfs = make filesystem.
# mkfs.fat formats the EFI partition as FAT.
# -F 32 selects FAT32.
# -n boot sets the filesystem label to "boot".
[root@nixos:/home/nixos]# mkfs.fat -F 32 -n boot /dev/vda1
mkfs.fat 4.2 (2021-01-31)
mkfs.fat: Warning: lowercase labels might not work properly on some systems
# harmless for NixOS/UTM
# label "boot" should still work

# mkfs.ext4 creates an ext4 filesystem on the main Linux partition.
# -L nixos sets the filesystem label to "nixos".
[root@nixos:/home/nixos]# mkfs.ext4 -L nixos /dev/vda2
mke2fs 1.47.4 (6-Mar-2025)
Discarding device blocks: done                            # trim/discard on virtual disk
Creating filesystem with 16645888 4k blocks and 4161536 inodes
Filesystem UUID: 0fad7d37-6251-4363-9594-4efd22cfa16e     # unique ID for this filesystem
Superblock backups stored on blocks:
        32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 2654208,
        4096000, 7962624, 11239424

Allocating group tables: done
Writing inode tables: done
Creating journal (65536 blocks): done                    # ext4 journal for crash recovery
Writing superblocks and filesystem accounting information: done

# mount attaches a filesystem into the current directory tree.
# /dev/disk/by-label/nixos is the main filesystem you just created.
[root@nixos:/home/nixos]# mount /dev/disk/by-label/nixos /mnt

# mkdir = make directory.
# -p creates parent directories if needed and does nothing if they already exist.
[root@nixos:/home/nixos]# mkdir -p /mnt/boot

# Mount the EFI partition at /mnt/boot so the installer can place boot files there.
[root@nixos:/home/nixos]# mount /dev/disk/by-label/boot /mnt/boot

# nixos-generate-config creates the initial NixOS config for the mounted target system.
# --root /mnt tells it to inspect the filesystems mounted under /mnt.
[root@nixos:/home/nixos]# nixos-generate-config --root /mnt
writing /mnt/etc/nixos/hardware-configuration.nix...   # detected disks/filesystems/hardware
writing /mnt/etc/nixos/configuration.nix...            # main editable system config
For more hardware-specific settings, see https://github.com/NixOS/nixos-hardware.

# Edit the configuration.nix file to customize your system (e.g. initial/configuration.nix -> updated/configuration.nix)
[root@nixos:/home/nixos]# sudo vim /mnt/etc/nixos/configuration.nix

# Run nixos-install, enter a root password when prompted.
[root@nixos:/home/nixos]# nixos-install
...
Mount point '/boot' which backs the random seed file is world accessible, which is a security hole!    # warning, not install failure
Random seed file '/boot/loader/.#bootctlrandom-seed...' is world accessible, which is a security hole! # common on VFAT EFI mounts
...
Installation finished!

[root@nixos:/home/nixos]# shutdown -h now

# UTM VM settings -> Drives -> USB Drive -> Clear ISO -> Save
# Run the VM, boot into NixOS (this will create hardware-configuration.nix)
# Can skip to 'Using flakes' section from here

# -------------------------------------
# Checking VM
# -------------------------------------

# Run the VM, boot into NixOS

<<< Welcome to NixOS 26.05.3021.34268251cf55 (aarch64) - tty1 >>>

Run 'nixos-help' for the NixOS manual.

nixos login:

# Enter username previously set in configuration.nix (changeme)

# Change the password for the user
[siraj@nixos:~]$ passwd

# Check network connectivity
[siraj@nixos:~]$ ip addr

# Check internet connectivity
[siraj@nixos:~]$ ping -c 3 nixos.org

# Check network connectivity
[siraj@nixos:~]$ ip addr
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host noprefixroute
       valid_lft forever preferred_lft forever
2: enp0s1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 76:28:89:96:43:5d brd ff:ff:ff:ff:ff:ff
    altname enx76288996435d
    inet 192.168.64.3/24 brd 192.168.64.255 scope global dynamic noprefixroute enp0s1
       valid_lft 3510sec preferred_lft 3510sec
    inet6 fd7c:fef4:9027:db87:4f1:1d74:4d35:f390/64 scope global temporary dynamic
       valid_lft 604712sec preferred_lft 85785sec
    inet6 fd7c:fef4:9027:db87:9688:da0a:c6cd:d1a/64 scope global dynamic mngtmpaddr noprefixroute
       valid_lft 2591928sec preferred_lft 604728sec
    inet6 fe80::63cf:1839:e33d:db11/64 scope link noprefixroute
       valid_lft forever preferred_lft forever

# Check internet connectivity
[siraj@nixos:~]$ sudo systemctl status sshd
* sshd.service - SSH Daemon
     Loaded: loaded (/etc/systemd/system/sshd.service; enabled; preset: ignored)
     Active: active (running) since Wed 2026-06-24 20:35:08 CEST; 2min 18s ago
 Invocation: 5284760c55d640a6afe7f6cb592fa7a2
   Main PID: 711 (sshd)
         IP: 0B in, 0B out
         IO: 1.3M read, 0B written
      Tasks: 1 (limit: 9522)
     Memory: 2.6M (peak: 3.3M)
        CPU: 4ms
     CGroup: /system.slice/sshd.service
             `-711 "/nix/store/mk6ngc1zz5by9qycq2g187k324s0q3ub-openssh-10.3p1/bin/sshd -D -f /etc/ssh/sshd_config [listener] 0 of 10-100 startups"

Jun 24 20:35:08 nixos systemd[1]: Starting SSH Daemon...
Jun 24 20:35:08 nixos sshd[711]: Server listening on 0.0.0.0 port 22.
Jun 24 20:35:08 nixos sshd[711]: Server listening on :: port 22.
Jun 24 20:35:08 nixos systemd[1]: Started SSH Daemon.

# Check SSH status
[siraj@nixos:~]$ ss -tlp | grep ':22'
LISTEN 0      128        0.0.0.0:22      0.0.0.0:*
LISTEN 0      128           [::]:22         [::]:*

# Check sudo access
[siraj@nixos:~]$ sudo -v

# From host machine, using ip address shown by `ip addr`
siraj@macbook:~ > ssh siraj@192.168.64.3

# Or, if Avahi was set up in configuration.nix
siraj@macbook:~ > ssh siraj@nixos.local

# -------------------------------------
# Creating a shared directory manually, if not already included in configuration.nix
# -------------------------------------

# UTM VM settings -> Sharing -> Select macOS folder (e.g., ~/shared-utm)
# Run VM

# make directory for mount point
[siraj@nixos:~]$ sudo mkdir --parents /mnt/share

# mount attaches a filesystem to a directory
# filesystem type: 9p, transport: virtio, exported share name: /mnt/share
[siraj@nixos:~]$ sudo mount --types 9p --options trans=virtio share /mnt/share

# List contents of shared directory
[siraj@nixos:~]$ ls /mnt/share
# no output = directory is empty

# Show mounted filesystems, then filter to the mount point
[siraj@nixos:~]$ mount | grep /mnt/shared
share on /mnt/shared type 9p (rw,relatime,access=client,trans=virtio)
# mounted successfully:
# - `rw` = read/write
# - `relatime` = update access times less aggressively
# - `access=client` = access checks handled client-side
# - `trans=virtio` = using virtio transport

# Write a test file to the shared directory
siraj@macbook:~ > echo "hello" > ~/shared-utm/hello-from-macbook.txt

# test.txt should now appear in the UTM shared directory
[siraj@nixos:~]$ ls /mnt/share
hello-from-macbook.txt

# Change ownership of shared directory to current user, so we can write to it without root
[siraj@nixos:~]$ sudo chown -R siraj:users /mnt/share

[siraj@nixos:~]$ echo "hello" > /mnt/share/hello-from-nixos.txt

siraj@macbook:~ > ls ~/shared-utm
hello-from-macbook.txt hello-from-nixos.txt

[siraj@nixos:~]$ sudo vim /mnt/etc/nixos/configuration.nix
# Add to configuration.nix:
#   # Auto-mount UTM shared directory on boot
#   fileSystems."/mnt/share" = {
#     device = "share"; # share name
#     fsType = "9p";    # filesystem protocol, 9p is usual for QEMU
#     options = [
#       "trans=virtio"         # usual for QEMU
#       "version=9p2000.L"     # protocol variant with Linux extensions, commonly required for Linux guests
#       "rw"                   # read and write access
#     ];
#   };

[siraj@nixos:~]$ sudo nixos-rebuild switch
building the system configuration...
these 4 derivations will be built:
  /nix/store/y0pp4xry4m2i3lipfhqwnlkplgg23zs2-etc-fstab.drv
  /nix/store/ab9k9czarvqxckfcnj9q7dlivddj06mh-etc.drv
  /nix/store/k2zxxsknx8vg661a5gd1723y3xlv4577-activate.drv
  /nix/store/fxk8862hxmrrpxp3n4ynb7kpgphwb97z-nixos-system-nixos-26.05.3021.34268251cf55.drv
building '/nix/store/y0pp4xry4m2i3lipfhqwnlkplgg23zs2-etc-fstab.drv'...
building '/nix/store/ab9k9czarvqxckfcnj9q7dlivddj06mh-etc.drv'...
building '/nix/store/k2zxxsknx8vg661a5gd1723y3xlv4577-activate.drv'...
building '/nix/store/fxk8862hxmrrpxp3n4ynb7kpgphwb97z-nixos-system-nixos-26.05.3021.34268251cf55.drv'...
structuredAttrs is enabled
Checking swith inhibitors... done
activating the configuration...
setting up /etc...
reloading user units for siraj...
restarting the following user units: nixos-activation.service
restarting sysinit-reactivation.target
the following new units were started: NetworkManager-dispatcher.service, sysinit-reactivation.target, systemd-tmpfiles-resetup.service
Done. The new configuration is /nix/store/c40wp467ydxc6jqa9sgd058di8p78fjh-nixos-system-nixos-26.05.3021.34268251cf55

[siraj@nixos:~]$ reboot

# check if the share is available and writeable after reboot
[siraj@nixos:~]$ echo "hello" > /mnt/share/hello-from-nixos-after-reboot.txt

[siraj@nixos:~]$ ls /mnt/share
hello-from-macbook.txt hello-from-nixos-after-reboot.txt hello-from-nixos.txt

# -------------------------------------
# Using flakes
# -------------------------------------

# Create flake.nix (updated/flake.nix)
[siraj@nixos:~]$ sudo tee /etc/nixos/flake.nix > /dev/null <<'EOF'
{
  description = "NixOS config for UTM VM";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
  };

  outputs = { self, nixpkgs, ... }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      modules = [
        ./configuration.nix
      ];
    };
  };
}
EOF

[siraj@nixos:~]$ sudo nixos-rebuild switch --flake
warning: creating lock file "/etc/nixos/flake.lock":
• Added input 'nixpkgs':
    'github:NixOS/nixpkgs/667d5cf1c59585031d743c78b394b0a647537c35?narHash=sha256-QyuGP5%2BQOtmXpy4i2X4DhBVBaySBdDKQEhqKcphcp34%3D' (2026-06-23)
building the system configuration...
Checking switch inhibitors... done
activating the configuration...
setting up /etc...
reloading user units for siraj...
restarting the following user units: nixos-activation.service
restarting sysinit-reactivation.target
reloading the following units: dbus-broker.service
the following new units were started: NetworkManager-dispatcher.service, sysinit-reactivation.target, systemd-tmpfiles-resetup.service
Done. The new configuration is /nix/store/47sfg6zlyvrcazf83cbi5kzpva1fsdfs-nixos-system-nixos-26.05.20260623.667d5cf

[siraj@nixos:~]$ sudo shutdown -h now

# Create a backup: UTM -> VM -> Clone
