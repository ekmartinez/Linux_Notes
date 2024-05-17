# Virtualization

This section contains instructions on how to install and configure virtualization software on Gentoo Linux. Instructions on how to setup a wired ethernet bridge will also be provided:

**Installation Steps:**

* [Qemu](#Qemu)
* [Libvirt](#Libvirt)
* [Virt-Manager](#Virt-Manager)
* [Bridge](#Bridge)

## Qemu

`/etc/portage/make.conf`
```bash
QEMU_SOFTMMU_TARGETS="arm x86_64 sparc"
QEMU_USER_TARGETS="x86_64"
```

`/etc/portage/package.use/qemu`
```bash
#You may or may not want iptables.
app-emulation/qemu gtk spice usbredir -vnc -iptables -xen
```

```bash
sudo emerge -av app-emulation/qemu
```

## Libvirt

`/etc/portage/package.use/libvirt`
```bash
app-emulation/libvirt pcap virt-network numa fuse macvtap vepa qemu firewalld policykit
```
Install libvirt:

```bash
sudo emerge --ask app-emulation/libvirt
```

Add user to libvirt group:

```bash
sudo usermod -a -G libvirt <user>
```

`/etc/libvirt/libvirtd.conf`
```bash
auth_unix_ro = "none"
auth_unix_rw = "none"
unix_sock_group = "libvirt"
unix_sock_ro_perms = "0777"
unix_sock_rw_perms = "0770"
```

Start/Enable service:

```bash
sudo rc-service libvirtd start && rc-update add libvirtd default
```

## Virt-Manager

`/etc/portage/package.use/virt-manager`
```bash
>=net-dns/dnsmasq-2.90 script
>=net-libs/gnutls-3.8.0 pkcs11 tools
>=net-misc/spice-gtk-0.42-r3 usbredir
```

Installation:

```bash
sudo emerge --ask app-emulation/virt-manager
```

## Network Bridge

When we create a bridge we need to understand that a new network interface has to be created, then we need to **bridge** our physical ethernet adapter to that newly created interface (br0).  We accomplish this using netifrc and dhcpcd.

`/etc/conf.d/net`
```bash
config_eth0="null"
bridge_br0="eth0"
config_br0="dhcp"
bridge_forward_delay_br0=0
bridge_hello_time_br0=1000
```
What we are saying above is that we are disabling our ethernet interface `eth0` to create a new one called `br0`, then our `eth0` adapter is assigned to our newly created `br0` which then finally gets an `ip` from `dhcpcd`.

`/etc/qemu/bridge.conf`
```bash
allow br0
```

Start / Enable interface at boot:

```bash
sudo rc-service net.br0 start && sudo rc-update add net.br0 boot
```




