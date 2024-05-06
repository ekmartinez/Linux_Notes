# Gentoo Installation Personal Guide

This is a very basic Gentoo Linux installation guide that has been based and adapted from the official documentation and other online sources. This distribution is too hard for me so I don't plan to use it as my daily driver.  I preffer easier alternatives like Microsoft Windows, but if I'm in the mood of using linux for some reason I use Linux Mint, Open Suse or Arch Linux.  This Gentoo guide is for educational purporses only.

* [Prepare Disk](#Prepare-Disk)
* [Stage 3](#Stage3)
* [Install Base System](#Install-Base-System)
* [Compiling The Linux Kernel](#Compiling-The-Linux-Kernel)
* [Configuring The System](#Configuring-The-System)
* [Installing a Bootloader](#Installing-a-Bootloader)


## Prepare disk

Use `cfdisk` to prepare the following partition structure:

* EFI - 100M - EFI 
* Swap - 8G - Linux Swap
* root - remainder - Linux File System

**Format Drives:**

EFI partition as Fat32

```bash
mkfs.vfat -F 32 /dev/sda1
```
Root partion as ext4:

```bash
mkfs.ext4 /dev/sda3
```

Activate swap partition:

```bash
mkswap /dev/sda2
swapon /dev/sda2
```

Mount root partion:

```bash
mkdir --parents /mnt/gentoo
mount /dev/sda3 /mnt/gentoo
```

## Stage 3

Change to installation directory:

```bash
cd /mnt/gentoo
```

Set date:

`MMDDhhmmYYYY` syntax (Month, Day, hour, minute and Year). 

```bash
date 050613552024
```

Using links, lynx or any other means, navigate to the gentoo download section and download the stage3 of your predilection.  Rembember that you need to be in `/mnt/gentoo` directory.  Also choose the verification method and verify your download, for example:

```bash
sha256sum --check stage3-amd64-<release>-<init>.tar.xz.sha256
```

If everything is ok, install the stage 3:

```bash
tar xpvf stage3-*.tar.xz --xattrs-include='*.*' --numeric-owner
```

Configure the compiling options:

```bash
nano /mnt/gentoo/etc/portage/make.conf
```

Include a `MAKEOPTS` declaration, this defines how many parallel compilations shoud occur when installing packages.
(Use ramsize/2)

```bash
MAKEOPTS="-j8 -l8"
```

## Install Base System

Ensure that networking still works even after entering the new environment:

```bash
cp --dereference /etc/resolv.conf /mnt/gentoo/etc/
```

**Mount Necessary Filesystems**

If using the gentoo installation media use:

```bash
arch-chroot /mnt/gentoo
source /etc/profile
export PS1="(chroot) ${PS1}"
```

Else:

```bash
mount --types proc /proc /mnt/gentoo/proc
mount --rbind /sys /mnt/gentoo/sys
mount --make-rslave /mnt/gentoo/sys
mount --rbind /dev /mnt/gentoo/dev
mount --make-rslave /mnt/gentoo/dev
mount --bind /run /mnt/gentoo/run
mount --make-slave /mnt/gentoo/run 
```

```bash
chroot /mnt/gentoo /bin/bash
source /etc/profile
export PS1="(chroot) ${PS1}"
```

Configure Portage:

```bash
mkdir --parents /etc/portage/repos.conf
cp /usr/share/portage/config/repos.conf /etc/portage/repos.conf/gentoo.conf
```

Install a snapshot of the Gentoo ebuild repository:

```bash
emerge-webrsync
```

Selecting mirrors:

```bash
emerge --ask --verbose --oneshot app-portage/mirrorselect
mirrorselect -i -o >> /etc/portage/make.conf
```

Check that the correct profile is selected:

```bash
eselect profile list
```
Note that this guide is for a very minimalistic installation so the default profile should be selected.

If necessary, change profile:

```bash
eselect profile set <int>
```

Create an accept license file (`etc/portage/package.license/kernel`):

```bash
sys-kernel/linux-firmware @BINARY-REDISTRIBUTABLE
sys-firmware/intel-microcode intel-ucode
```

Update @world set

```bash
emerge --ask --verbose --update --deep --newuse @world
```

Remove obsolete packages:

```bash
emerge --ask --depclean
```

Set time zone:

```bash
ls -l /usr/share/zoneinfo/Europe/
echo "Europe/Brussels" > /etc/timezone
emerge --config sys-libs/timezone-data
```

Configure locales:

```bash
nano /etc/locale.gen
```

Uncomment `en_US.UTF-8 UTF-8` and then run:

```bash
locale-gen
```

To view available locales:

```bash
eselect locale list
```

To select locale:

```bash
eselect locale set 2
```

Finally:

```bash
env-update && source /etc/profile && export PS1="(chroot) ${PS1}"
```

## Compiling The Linux Kernel

Installing the firmware:

```bash
emerge --ask sys-kernel/linux-firmware sys-firmware/sof-firmware
```

Install the microcode:

```bash
sys-firmware/intel-microcode
```

Ensure that you have a `symlink` USE flag in your make.conf, then install Gentoo kernel sources and genkernel:

```bash
emerge -q sys-kernel/gentoo-sources installkernel genkernel
```
Read(*https://www.gentoo.org/support/news-items/2024-03-12-debianutils-installkernel.html*)

Note: genkernel will only be used to generate an initramfs.

Install pciutils, this allows to query hardware:

```bash
emerge --ask sys-apps/pciutils
```

Now is time to configure the kernel, navigate to `/usr/src/linux` and run:


```bash
make menuconfig 
```

Now make the changes that you wish and remember to enable options for your system (ex. nvme support, etc).

When you are finished, save the config file and compile your kernel:

```bash
make && make modules_install
make install
```

Now generate an initramfs with genkernel:

```bash
genkernel --install --kernel-config=/usr/src/linux.config initramfs
```

## Configuring The System

**Editing fstab**

First run `blkid` and take note of the drive's uuids, your `/etc/fstab` should look something like this:

```bash 
PARTUUID=c12a7328-f81f-11d2-ba4b-00a0c93ec93b   /boot        vfat    umask=0077                   0 2
PARTUUID=0657fd6d-a4ab-43c4-84e5-0933c84b4f4f   none        swap    sw                           0 0
PARTUUID=4f68bce3-e8cd-4db1-96e7-fbcaf984b709   /           xfs     defaults,noatime             0 1
``` 
**Install a logger**

Installing a logger:

```bash 
emerge --ask app-admin/sysklogd
rc-update add sysklogd default
```

TODO: syslog-ng


**Configure Networking**

Set the hostname:

```bash
echo gentoo_machine > /etc/hostname
```

Install `netifrc`:

```bash
emerge --ask --noreplace net-misc/netifrc dhcpd
```
Edit configuration file:

```bash
nano /etc/conf.d/net
```

For static Ip:

```bash
config_eth0="192.168.0.2 netmask 255.255.255.0 brd 192.168.0.255"
routes_eth0="default via 192.168.0.1"
```

For dhcp:

```bash
config_eth0="dhcp"
```

Enable networking at boot:

```bash
cd /etc/init.d
ln -s net.lo net.eth0
rc-update add net.eth0 default
```

Install wireless support:

```bash
emerge --ask net-wireless/iw net-wireless/wpa_supplicant
```

Set a root password:

```bash
passwd
```

## Installing a bootloader

Mount the boot partition:

```bash
mount /dev/sda1 /boot
```

Add the following to your `make.conf`:

```bash
echo 'GRUB_PLATFORMS="efi-64"' >> /etc/portage/make.conf
```

Install and Configure Grub:

```bash
emerge --verbose sys-boot/grub:2
grub-isntall --target=x86_64-efi --efi-directory=/boot
grub-mkconfig -o /boot/grub/grub.cfg
```

## Rebooting the System

```bash
exit
```

```bash
cd
umount -R /mnt/gentoo
reboot
```
