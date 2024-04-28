# Virtualization

This area will has instructions on how to install and configure virtual machines using the kvm hypervisor with virt-manager, qemu & libvirt.

Install the necesary packages:

```bash
sudo pacman -S virt-manager virt-viewer qemu bridge-utils libguestfs dnsmasq vde2 iptables ebtables openbsd-netcat
```

Add your current user to to the libvirt group:

```bash
usermod -G libvirt -a $(whoami)
```

Navigate to /etc/libvirt/libvirtd.conf and uncomment the following lines:


```bash
# UNIX socket access controls

# This is restricted to 'root' by default.
unix_sock_group = "libvirt"

#Uncomment and change the following line from:

unix_sock_ro_perms = "0777"

#To

unix_sock_ro_perms = "0770"

```

