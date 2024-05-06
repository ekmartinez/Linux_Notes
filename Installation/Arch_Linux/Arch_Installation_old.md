# Arch Linux Installation

**General Steps**

1. Prepare installation media
2. Establish Network Connectivity
3. Storage Partion
4. Luks setup
5. Prepare File Systems
5. Base system installation
6. Install Desktop Environment (Optional)

Note: Procedures herein assumes UEFI.

## Prepare Media 

Download and prepare the media for the latest ISO from the Arch Linux website (https://archlinux.org/download/)

Verify signature

```bash

pacman-key -v archlinux-version-x86_64.iso.sig

```

## Storage Partition

Check for different drives and partitions with:

```bash

lsblk

```

Partition:

```bash

gdisk /dev/nvme0n1

```

* Create boot partition with n, default number, default first sector, last sector at +512M and select ef00 “EFI System” as the type.

* Create root partition with n, default number, default first sector, default last sector and select 8300 “Linux filesystem” as the type.

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

Format the files systems:

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

Swapfile

```bash

#create swap file
dd if=/dev/zero of=/mnt/swapfile bs=1M count=8192 status=progress

#set permissions
chmod 600 /mnt/swapfile

#make it an actual swap file
mkswap /mnt/swapfile

#activate
swapon /mnt/swapfile

```

## Installation

Install base system

```bash

#Optimize mirror list
reflector --country US --age 12 --protocol https --sort rate --save /etc/pacman.d/mirrorlist

#Refresh repositories
pacman -Syyy

#Install Arch Linux
pacstrap /mnt base base-devel linux linux-firmware linux-headers intel-ucode mkinitcpio lvm2 vim  
```

Generate fstab file

```bash

genfstab -U /mnt >> /mnt/etc/fstab

```

Enter into root environment

```bash

arch-chroot /mnt

```

Set Locales

```bash

ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime
hwclock --systohc
 
#Uncomment en_US.UTF-8 UTF-8
vim /etc/locale.gen

#Generate locales
locale-gen
echo LANG=en_US.UTF-8 > /etc/locale.conf

```

Set Hostname

```bash
echo arch > /etc/hostname

vim /etc/hosts and insert the following lines:

127.0.0.1     localhost
::1           localhost
127.0.1.1     arch.localdomain        arch

```

# Set Root Password

```bash
passwd
```

# Configure Initramfs

```bash
vim /etc/mkinitcpio.conf 
# Add encrypt between block and filesystems in the HOOKS array.

Run mkinitcpio -P
```

# Install Boot Loader

```bash
#To install the GRUB package, network manager

pacman -S grub efibootmgr networkmanager 
 
#Get the UUID of the device
blkid -s UUID -o value /dev/nvme0n1p2
 
#To disable GRUB timeout.  
vim /etc/default/grub and set GRUB_TIMEOUT=0

#set GRUB_CMDLINE_LINUX="" while replacing “xxxx” with the UUID of the nvme0n1p2 device to tell GRUB about our encrypted file system
GRUB_CMDLINE_LINUX="cryptdevice=UUID=xxxx:cryptroot"
 
#Install & Configure GRUB
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg
```
# Finish Installation

```bash
systemctl enable NetworkManager.service
exit
reboot
```
Finishing steps

```bash
#Add swapfile to the fstab configuration. 
vim /etc/fstab
/swapfile none swap defaults 0 0 

-Add  non root user
useradd -m -g users -G wheel -s /bin/bash user_name

#Set password for new user
passwd user_name

#Install & configure sudo 
EDITOR=vim visudo
uncomment % wheel ALL=(ALL) ALL

exit
login as user_name
```

## Optional(Install a Desktop Environment)

Gnome
```bash
sudo pacman -S gnome
sudo systemctl enable gdm
```

KDE
```bash
sudo pacman -Sy plasma plasma-wayland-session sddm konsole
sudo systemctl enable sddm
sudo systemctl start sddm
```
Xfce
```bash
sudo pacman -S xfce4 xfce4-goodies
sudo pacman -S lightdm lightdm-gtk-greeter
sudo systemctl enable lightdm.service -f
sudo sytemctl start lightdm.service
```
