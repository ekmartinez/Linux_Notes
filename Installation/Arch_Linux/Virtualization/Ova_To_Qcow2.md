# Convert OVA to qcow2

Here are the instructions on how to convert an ova image into a to qcow2 disk image.

**Terms**

`ova` - Open Virtualization Appliance
`qcow2` - QEMU Copy-on-Write 2
`vmdk` - Virtual Machine Disk

## Step 1: Export Virtual Box Image

If you have virtual box installed you can export the image as follows:

List all the vms that are installed

```bash
VBoxManage list vms
```

Export the image as ova 1.0 (Better compatibility)

```bash
VBoxManage export vmName -O exportName.ova --ovf10
```

Even if you don't have Virtual Box, but you have a valid `ova` file, the following instructions may still work.

## Step 2: Extract the OVA file

Inside the `ova` file resides the `vmdk` disk image which we will use to convert into `qcow2`.

Extract content of ova file

```bash
tar -xvf file.ova
```

Convert vmdk into qcow2

```bash
qemu-img -f convert vmdk -O qcow2 file.vmdk destination_file.qcow2
```

If everyting worked you should now be able to import your new disk image into qemu-kvm.
