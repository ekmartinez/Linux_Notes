# Arch Linux Installation Personal Guide

**General Steps**

1. Prepare installation media (Assumes UEFI)
2. Establish Network Connectivity
3. Storage Partion
4. Luks setup
5. Prepare File Systems
5. Base system installation
6. Installing a Wayland compositor

## Prepare Media 

Download and prepare the media for the latest ISO from the Arch Linux website (https://archlinux.org/download/)

** Verify signature

```bash

pacman-key -v archlinux-version-x86_64.iso.sig

```

## Storage Partition

Check for different drives and partitions with:

```bash

lsblk

```

** Partition:

```bash

gdisk /dev/nvme0n1

```

* Create boot partition with n with default number, default first sector, last sector at +512M and select ef00 “EFI System” as the type.

* Create root partition with n with default number, default first sector, default last sector 
and select 8300 “Linux filesystem” as the type.

## Luks

```bash

cryptsetup -y -v luksFormat /dev/nvme0n1p2

```
Type YES and the new encryption password to encrypt the root partition.

Open the encrypted partition.

```bash

cryptsetup open /dev/nvme0n1p2 cryptroot

```

## Prepare File Systems

Format the files systems as:

```bash

#Create boot file system.
mkfs.fat -F32 /dev/nvme0n1p1

#Create root file system.
mkfs.ext4 /dev/mapper/cryptroot

```

Mount File Systems

```bash

#mount the root file system
mount /dev/mapper/cryptroot /mnt

#create boot directory
mkdir /mnt/boot

#mount boot file system
mount /dev/nvme0n1p1 /mnt/boot
```
Comfirm with:

```bash 

lsblk

```

** Swapfile

```bash

#create swap file
dd if=/dev/zero of=/mnt/swapfile bs=1M count=24576 status=progress

#set permissions
chmod 600 /mnt/swapfile

#make it an actual swap file
mkswap /mnt/swapfile

#activate
swapon /mnt/swapfile

```

## Installation

* Install base system

```bash

#Optimize mirror list
reflector -c US -a 6 --sort rate --save /etc/pacman.d/mirrorlist

#Refresh repositories
pacman -Syyy

#Install Arch Linux
pacstrap /mnt base base-devel git linux linux-firmware linux-headers intel-ucode mkinitcpio lvm2 neovim  

```bash

Generate fstab file

```bash

genfstab -U /mnt >> /mnt/etc/fstab

```

Enter into root environment

```bash

arch-chroot /mnt to switch to your new Arch Linux installation

```

Set Locales

```bash

ln -sf /usr/share/zoneinfo/Europe/Zurich /etc/localtime (or whatever your timezone is) to set your time zone
hwclock --systohc
vim /etc/locale.gen and uncomment yours (e.g. en_US.UTF-8 UTF-8)

#Generate locales
locale-gen
echo LANG=en_US.UTF-8 > /etc/locale.conf

```

Set Hostname

```bash
echo arch > /etc/hostname (or whatever your hostname should be)
vim /etc/hosts and insert the following lines:

127.0.0.1     localhost
::1           localhost
127.0.1.1     arch.localdomain        arch

```

Set Root Password


Run passwd and set your root password

-Configure Initramfs
Run vim /etc/mkinitcpio.conf and, to the HOOKS array, add keyboard between autodetect and modconf 
and add encrypt between block and filesystems
Run mkinitcpio -P

-Install Boot Loader
Run pacman -S grub efibootmgr networkmanager intel-ucode (or amd-ucode if you have an AMD processor) to install the GRUB package and CPU microcode

Run blkid -s UUID -o value /dev/nvme0n1p2 to get the UUID of the device

Run vim /etc/default/grub and set GRUB_TIMEOUT=0 to disable GRUB waiting until it chooses your OS 
(only makes sense if you don’t dual-boot with another OS), 

set GRUB_CMDLINE_LINUX="cryptdevice=UUID=xxxx:cryptroot" while replacing “xxxx” with the UUID of the 
nvme0n1p2 device to tell GRUB about our encrypted file system

Run grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB to install GRUB for your system

Run grub-mkconfig -o /boot/grub/grub.cfg to configure GRUB

systemctl enable NetworkManager.service

Run exit to return to the outer shell
Run reboot to get out of the setup

edit the fstab configuration to add an entry for the swap file: (if necesary, since it was already configured)
vim /etc/fstab
/swapfile none swap defaults 0 0 

ip link set interface up (if needed (ethernet or wifi)

-Add  non root user
Run useradd -m -g- users -G wheel -s /bin/bash user_name

Set password passwd user_name

Install sudo (if needed, it was installed)
run EDITOR=vim visudo
uncomment % wheel ALL=(ALL) ALL

exit
login as user_name

-Optional(Install a Desktop Environment)

KDE
sudo pacman -Sy xorg plasma plasma-wayland-session sddm konsole
sudo systemctl enable sddm

Xfce
sudo pacman -S xfce4 xfce4-goodies
sudo pacman -S lightdm lightdm-gtk-greeter
sudo systemctl enable lightdm.service -f
sudo sytemctl start lightdm.service

