# Virtualization

This area will has instructions on how to install and configure virtual machines using the kvm hypervisor with virt-manager, qemu & libvirt.

Install the necesary packages:

```bash
sudo pacman -S virt-manager virt-viewer qemu bridge-utils libguestfs dnsmasq
```

Add your current user to to the libvirt group:

```bash
usermod -G libvirt -a $(whoami)
```

Navigate to /etc/libvirt/libvirtd.conf and uncomment the following lines:



