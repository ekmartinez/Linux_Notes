# Arch Linux Installation

With Unified Kerkel image,  btrfs, luks2 & secure boot.

**Content**

1. [Disk Partition](#Disk-Partition)
2. [Disk Encryption](#Disk-Encryption)
3. [Format Disks](#Format-Disks)
4. [Mount Partitions](#Mount-Partitions)
5. [System Installation](#System-Installation)
6. [System Configuration](#System-Configuration)
10. [Secure Boot Configuration](#Secure-Boot-Configuration)
7. [Unified Kernel Image](#Unified-Kernel-Image)
8. [Bootloader Setup](#Bootloader-Setup)
9. [Reboot](#Reboot)

## Disk Partition

Look for your disk drive:

``bash
root@archiso ~ # lsblk

NAME  MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
loop0   7:0    0 787.8M  1 loop /run/archiso/airootfs
sda     8:0    0    25G  0 disk 
sr0    11:0    1 955.3M  0 rom  /run/archiso/bootmnt
```

Prepare for partition:

```bash
sgdisk -Z /dev/sda
```

Create partitions:

1. ef00 EFI 512M Boot Partition
2. 8304 Remainder of Disk as Linux Partition

```bash
sgdisk -n1:0:+512M -t1:ef00 -c1:EFI -N2 -t2:8304 -c2:encrypted /dev/sda

```

Finalize:

```bash
partprobe -s /dev/sda
```

Confirm:

```bash
root@archiso ~ # lsblk /dev/sda

NAME   MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
sda      8:0    0   25G  0 disk 
├─sda1   8:1    0  512M  0 part 
└─sda2   8:2    0 24.5G  0 part
```

## Disk Encryption

Encrypt and open Linux System Partition:

```bash
cryptsetup luksFormat --type luks2 /dev/sda2
cryptsetup luksOpen /dev/sda2 encrypted
```

## Format Disks

1. Boot Partition as Fat 32.
2. System Partition as btrfs.

```bash
mkfs.vfat -F32 -n EFI /dev/sda1
mkfs.btrfs -f -L encrypted /dev/mapper/encrypted
```

## Mount Partitions

Mount boot, system partitions and create btrfs subvolumes.

```bash
mount /dev/mapper/encrypted /mnt
mkdir /mnt/efi
mount /dev/sda1 /mnt/efi
btrfs subvolume create /mnt/home
btrfs subvolume create /mnt/srv
btrfs subvolume create /mnt/var
btrfs subvolume create /mnt/var/log
btrfs subvolume create /mnt/var/cache
btrfs subvolume create /mnt/var/tmp
````

## System Installation

Setup reflector:

```base
reflector --country us --age 24 --sort rate --protocol https --save /etc/pacman.d/mirrorlist
```

Install base system along with some additional packages:

```bash
pacstrap -K /mnt base base-devel linux linux-firmware linux-headers intel-ucode vim cryptsetup btrfs-progs dosfstools util-linux sbctl networkmanager sudo 
```
## System Configuration

Uncomment en_US.UTF-8 UTF-8 in the `/etc/locale.gen`

```bash
vim /etc/locale.gen
```

Run systemd-firstboot to finish locale settings:

```bash
systemd-firstboot --root /mnt --prompt
```

Generate locales:

```bash
arch-chroot /mnt locale-gen
```

Create non-root user, add it to the wheel group and set a password:

```bash
arch-chroot /mnt useradd -G wheel -m user_name 
arch-chroot /mnt passwd user_name
```

Give sudo privileges to the user:

At `/mnt/etc/sudoers` uncomment:

```bash
% wheel ALL=(ALL) ALL
```

## Unified Kernel Image

Create a kernel cmdline file:

```bash
echo "quiet rw" >/mnt/etc/kernel/cmdline
```

Create EFI folder structure:

```bash
mkdir -p /mnt/efi/EFI/Linux
```

Modify the HOOKS to include systemd at `/mnt/etc/mkinitcpio.conf`:

So it looks like this:

```bash
HOOKS = HOOKS=(base systemd autodetect modconf kms keyboard sd-vconsole sd-encrypt block filesystems fsck)
```

Modify the `/mnt/etc/mkinitcpio.d/linux.preset` file so it looks like this:

``bash
ALL_config="/etc/mkinitcpio.conf"
ALL_kver="/boot/vmlinuz-linux"

PRESETS=('default' 'fallback')

#default_config="/etc/mkinitcpio.conf"
#default_image="/boot/initramfs-linux.img"
default_uki="/efi/EFI/Linux/arch-linux.efi"
default_options="--splash /usr/share/systemd/bootctl/splash-arch.bmp"

#fallback_config="/etc/mkinitcpio.conf"
#fallback_image="/boot/initramfs-linux-fallback.img"
fallback_uki="/efi/EFI/Linux/arch-linux-fallback.efi"
fallback_options="-S autodetect"
```

Generate the Unified Kernel Images:

```bash
arch-chroot /mnt mkinitcpio -P
```

## Bootloader Setup

Make sure you have the following efi partition file structure: 

`/mnt/efi/EFI/Linux`

```bash
ls -lR /mnt/efi
```

## Bootloader Setup

Install the bootloader:

```bash
arch-chroot /mnt bootctl install --esp-path=/efi
```

## Reboot

Enable services:

```bash
systemctl --root /mnt enable systemd-resolved systemd-timesyncd NetworkManager
systemctl --root /mnt mask systemd-networkd
```

Reboot into firmware setup:

```bash
sync
systemctl reboot --firmware-setup
```

After rebooting, enter to the bios setup and clear secure boot keys.

## Secure Boot Configuration

Create Secure Boot keys:

```bash
sudo sbctl create-keys
```

Enroll secure boot keys:

```bash
sudo sbctl enroll-keys -m
```

Sign the boot files:

```bash
sudo sbctl sign -s -o /usr/lib/systemd/boot/efi/systemd-bootx64.efi.signed /usr/lib/systemd/boot/efi/systemd-bootx64.efi
sudo sbctl sign -s /efi/EFI/BOOT/BOOTX64.EFI
sudo sbctl sign -s /efi/EFI/Linux/arch-linux.efi
sudo sbctl sign -s /efi/EFI/Linux/arch-linux-fallback.efi
```

After rebooting, secure boot you automatically be enabled and you should have your encrypted, secured enabled Arch Linux ready to be used.

Unfortunately, these procedures fail to authenticate my image on my HP ZBOOK G3 for some reason, eventhough I was able to successfully test them on a virtual machine.

This information was adapted from:

Walian
https://www.walian.co.uk/arch-install-with-secure-boot-btrfs-tpm2-luks-encryption-unified-kernel-images.html


