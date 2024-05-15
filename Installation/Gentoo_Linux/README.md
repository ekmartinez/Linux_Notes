# Gentoo Linux Installation Guide 2024

This is an installation guide on how to install Gentoo Linux (Openrc) on physical hardware.  This guide was tested using a distribution kernel, nevertheless, instructions on how to compile a custom kernel will also be provided.  This guide asumes UEFI.

* [Prepare Disk](#Prepare-Disk) 
* [Stage 3](#Stage3)
* [Install Base System](#Install-Base-System)
* [Compiling The Linux Kernel](#Compiling-The-Linux-Kernel)
* [Configuring The System](#Configuring-The-System)
* [Installing a Bootloader](#Installing-a-Bootloader)
* [Post Installation Tasks](#Post-Installation-Tasks)

## Prepare disk

Use `cfdisk` to prepare the following partition structure (choose gpt):

* EFI - 1G - EFI 
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

## Stage 3 Download & Installation

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

Lets configure our `make.conf` file:

```bash
nano /mnt/gentoo/etc/portage/make.conf
```

```bash
COMMON_FLAGS="-march=native -O2 -pipe"
MAKEOPTS="-j8 -l8"
USE="-kde -gnome -systemd -seatd elogind wayland X"
ACCEPT_LICENSE="*"
GRUB_PLATFORMS="efi-64"
VIDEO_CARDS="radeon intel"
```

* The `-march=native` flag specifies the name of the target architecture
* The `MAKEOPTS` declaration, this defines how many parallel compilations shoud occur when installing packages. (Use ramsize/2).
* Use flags specifies compilation options globally.
* Accept license * means accept them all without asking.
* Grub platforms gives instructions to grub at the boot loader installation stage.
* Video cards specifies which video card drivers are goin to be installed.

Some of these options aren't really necessary at this point, but we include them now to avoid problems and errors down the road.


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
```
```bash
cp /usr/share/portage/config/repos.conf /etc/portage/repos.conf/gentoo.conf
```

Install a snapshot of the Gentoo ebuild repository:

```bash
emerge-webrsync
```
Even if it is not necessary at this point, it doesn't hurt to update the repositories:

```bash
emerge --sync
```

Selecting mirrors:

```bash
emerge --ask --verbose --oneshot app-portage/mirrorselect
```
```bash
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

Configure CPU flags to match them to the system's architecture:

```bash
emerge --ask --oneshot app-portage/cpuid2cpuflags
```
```bash
echo "*/* $(cpuid2cpuflags)" > /etc/portage/package.use/00cpu-flags
```

Add the following line to you make.conf, to avoid licensing problems going forward:

```bash
echo ACCEPT_LICENSE="*" >> /etc/portage/make.conf
```

Update @world set:

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
```
```bash
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

In this section we will cover how to configure and install the Linux kernel, two methods will be presented:

* Distribution Kernel (Easy way)
* Compiling from source (Hard way)

A good idea would be to install Gentoo using the easy approach first, once you ensure you have a working system you can then compile your own kerenel.  Regardless of the method chosen we begin by installing the firmware.  If you are using an Intel cpu you should also install the microcode (Amd's microcode is included in the firmware package).

Installing the firmware:

```bash
emerge --ask sys-kernel/linux-firmware
```

Install the microcode:

```bash
emerge --ask sys-firmware/intel-microcode
```

With whatever option you choose create a `etc/portage/package.use/installkernel` file with the following:

```bash
sys-kernel/installkernel dracut
```

Now get the `installkernel` package:

```bash
emerge --ask sys-kernel/installkernel
```

This automates the kernel installation, the initramfs generation and ensures images are placed in the proper locations.

**Distribution Kernel (Easy Way)**

The distribution kernel can be installed by downloading a binary kernel or by compiling (automatically, without user intervention) the source code.

To download the binary:

```bash
emerge --ask sys-kernel/gentoo-kernel-bin
```

To download the source binary:

```bash
emerge --ask sys-kernel/gentoo-kernel
```

Create a symbolic link to `/usr/src/linux` by using the eselect's kernel module:

```bash
eselect kernel list
```
```bash
eselect kernel set <int>
```

**Compiling and Building the Linux kernel from source**

Install `pciutils`, this allows you to know what kind of hardware you have which helps you in choosing which drivers gets compiled in the kernel.

```bash
emerge --ask sys-apps/pciutils
```

Install kernel sources:

```bash
emerge --ask sys-kernel/gentoo-sources
```

As in the easy method, create a symbolic link to `/usr/src/linux` by using the eselect's kernel module:

```bash
eselect kernel list
```
```bash
eselect kernel set <int>
```

To configure the kernel, navigate to `/usr/src/linux` and run:

```bash
make menuconfig 
```

Now make the changes that you wish, enable and/or disable drivers that are not needed, and remember to enable options for your system (ex. nvme support, etc).

When you are finished, save the config file and compile your kernel:

```bash
make && make modules_install
make install
```

## Configuring The System

**Editing fstab**

First run `blkid` and take note of the drive's uuids, your `/etc/fstab` should look something like this:

```bash 
/dev/sda1   /boot   vfat    umask=0077  0 2
/dev/sda2   none    swap    sw          0 0
/dev/sda3   /       ext4    defaults,noatime    0 1
``` 

**Install a Log System** 

At this point, you don't need this in order to install the system, but you dont want to install the system without it.

```bash 
emerge --ask app-admin/sysklogd
```
```bash 
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
Add the hosts file:

```bash
# This defines the current system and must be set
127.0.0.1     tux.homenetwork tux localhost
  
# Optional definition of extra systems on the network
192.168.0.5   jenny.homenetwork jenny
192.168.0.6   benny.homenetwork benny
```

Install `iwd` to have access to the iwctl tool after booting up:

```bash
emerge --ask net-wireless/iwd
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
emerge --ask --verbose sys-boot/grub
```
```bash
grub-install --target=x86_64-efi --efi-directory=/boot
```
```bash
grub-mkconfig -o /boot/grub/grub.cfg
```

## Finish the installation

Exit chroot environment, unmount root partion and reboot the system.

```bash
exit
```
```bash
cd
```
```bash
umount -R /mnt/gentoo
```
```bash
reboot
```

If you get a login prompt, that means you made it alive.

## Post Installation Tasks

**Install sudo and add a regular user**

Install sudo:

```bash
emerge --ask app-admin/sudo
```

As the documentation warns, only use visudo to edit the sudoers file:

```bash
visudo
```
Uncomment relevant line:

```bash
## Uncomment to allow members of group wheel to execute any command
%wheel ALL=(ALL:ALL) ALL
```

Create a regular user:

```bash
useradd -m -G users,wheel,audio -s /bin/bash user_name 
```

Assign a password:

```bash
passwd user_name
```

**Adjust Display Brightness**

Install `xbacklight`:

```bash
 sys-power/acpilight
```

To control the brightness through the command prompt:

First add user to the video group:

```bash
sudo usermod -aG video user_name
```

To get the current brightness level:

```bash
xbacklight -get
```

To set brightness in percentage terms:

```bash
xbacklight -set 50
```

In order to control the display brightness through the keyboard,  we have to create some configurations:

`~/.config/sway/config`

```bash
bindsym XF86MonBrightnessDown exec xbacklight -dec 2
bindsym XF86MonBrightnessUp exec xbacklight -inc 4
```

`/etc/udev/rules.d/90-backlight.rules`

```bash
SUBSYSTEM=="backlight", ACTION=="add", \
  RUN+="/bin/chgrp video /sys/class/backlight/%k/brightness", \
  RUN+="/bin/chmod g+w /sys/class/backlight/%k/brightness"

SUBSYSTEM=="leds", ACTION=="add", KERNEL=="*::kbd_backlight", \
  RUN+="/bin/chgrp video /sys/class/leds/%k/brightness", \
  RUN+="/bin/chmod g+w /sys/class/leds/%k/brightness"
```

Control of brightness usign the keyboard was not working at the time of this writting, however you can do so via the waybar brightness icon.

**Firewall**

Install firewalld:

```bash
sudo emerge -av net-firewall/firewalld
```

Start service:

```bash
sudo rc-service firewalld start
```

Enable service:

```bash
sudo rc-update add firewalld default
```

Get default zone:

```bash
sudo firewall-cmd --get-default-zone
```

List permited services:

```bash
sudo firewall-cmd --zone=<name> --list-services
```

Remove service:

```bash
sudo firewall-cmd --zone=<name> --remove-service=<name> --permanent
```

Reload firewall:

```bash
sudo firewall-cmd --reload
```

Ensure changes are permanent:

```bash
firewall-cmd --runtime-to-permanent
```

