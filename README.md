# Linux_Notes 

General Notes on the Linux Operating System


This area will contain the most common commands on linux.

* [System administration](#System-Administration)
* [System Exploration](#System-Exploration)
* [Permissions](#File-Permissions)
* [Searching](#Searching)

## System Administration

This section includes tasks like adding users, groups, checking for hardware and package management.

### Checking for Hardware

Get a list of all the hardware:

```bash
lshw
```

To get a summarized list:

```bash
lshw -short
```

To get hardware in hmtl format:

```bash
lshw -html > file.html 
```

Checking for usb devices:

```bash
lsusb
```
The watch command allows for detecting usb devices as they are plugged in:

```bash
watch lsusb
```

To display cpu information:

```bash
lscpu
```

To display hard drive partitions:

```bash
lsblk
```

### Package Administration

**pacman**

Pacman is the default repository for Arch:

```bash
#Refresh repository
sudo pacman -Sy

#Update System
sudo pacman -Su

#Install a package
sudo pacman -S <package>

#Remove package
sudo pacman -Rs <package>
```


**flatpak**

I recommend flatpak for some packages becuase it allows them to run in a sandbox.

Install flatpak:

```bash
sudo pacman -S flatpak
```

To install flat packages, go to flathub.org and grab installation instructions for the desired app.

```bash
flatpak install com.exampleapp.ExampleApp
```

In order to run the flat app from wofi you will need to run the following command:

```bash
sudo ln -s /var/lib/flatpak/exports/bin/com.exampleapp.ExampleApp /usr/bin/com.exampleapp.ExampleApp
```

## System Exploration

List content of directory:

```bash
# Display content
ls

# Display content in list way:
ls -l

# Display content in list way including hidden files:
ls -la
```

Change directories:

```bash
# Change to specified directory
cd /

# Change to previous directory
cd .. 

# Go back multiple levels
cd ../..

# Go to home folder
cd -
```

## File Permissions

**Managing Permissions of Files on Linux**

Each file and directory in a file system is assigned “owner” and “group” attributes. To manage file permissions, you can use the `chmod` command, which allows you to change the permissions for the owner, group, or others.

**Understanding File Permissions**

In Linux, file permissions are represented by a combination of three letters: `r`, `w`, and `x`, which stand for read, write, and execute permissions, respectively. Each letter can be present in one of three states: `-` (denied), `+` (allowed), or `=` (set to a specific value).

The first character indicates whether the file is a directory (`d`) or a regular file (`-`). The next three characters represent the permissions for the owner, group, and others, respectively.

**Changing File Permissions**

To change file permissions, you can use the `chmod` command in either symbolic or octal mode.

**Symbolic Mode**

In symbolic mode, you specify the permission changes using the following syntax: `chmod [options] [permissions] [file]`. 

The options are:

* `u`: owner
* `g`: group
* `o`: others
* `a`: all (owner, group, and others)
* `+`: add permission
* `-`: remove permission
* `=`: set permission

For example:

```bash
# Adds read, write, and execute permissions to the owner
chmod u+rwx file.txt

# Adds write and execute permissions to the group
chmod g+wx file.txt
```

**Octal Mode**

In octal mode, you specify the permission changes using a three-digit octal number, where each digit represents the permissions for the owner, group, and others, respectively. 

The digits are:

* `0`: denied
* `1`: execute only
* `2`: write only
* `3`: write and execute
* `4`: read only
* `5`: read and execute
* `6`: read and write
* `7`: read, write, and execute

For example:

```bash
# sets permissions to rwxr-x for the owner and r-x for the group and others

chmod 755 file.txt
```

**Changing the Owner and Group**

To change the owner and group of a file or directory, you can use the chown command. The syntax is: `chown [owner]:[group] [file]`. 

For example:

```bash
# changes the file owner to number6 and the group to TheVillage

chown number6:TheVillage file.txt
```

**Best practices**

* Use the `chmod` command to set permissions for files and directories.
* Use the `chown` command to change the owner and group of files and directories.
* Use the `ls` command with the `-la` option to view the permissions of files and directories.

## Searching

Finding files:

Find the file named “flag1.txt” in the current directory

``bash
find . -name flag1.txt
```

Find the file names “flag1.txt” in the /home directory

```bash
find /home -name flag1.txt
```

Find the directory named config under “/”

```bash
find / -type d -name config
```

Find files with the 777 permissions (files readable, writable, and executable by all users):

```bash
find / -type f -perm 0777
```

Find executable files:

```bash
find / -perm a=x
```

Find all files for user “frank” under “/home”

```bash
find /home -user frank
```

Find files that were modified in the last 10 days:

```bash
find / -mtime 10
```

Find files that were accessed in the last 10 day:

```bash
find / -atime 10
```

Find files changed within the last hour (60 minutes):

```bash
find / -cmin -60
```

Find files accesses within the last hour (60 minutes)

```bash
find / -amin -60
```

Find files with a 50 MB size:

```bash
find / -size 50M
```

Find files with the SUID bit set.

```bash
find / -perm -u=s -type f 2>/dev/null
```

**Folders and files that can be written to or executed from:**

Find world-writeable folders:

```bash
find / -writable -type d 2>/dev/null 
```
```bash
find / -perm -222 -type d 2>/dev/null
```
```bash
find / -perm -o w -type d 2>/dev/null
```

Find world-executable folders:

```bash
find / -perm -o x -type d 2>/dev/null 
```

Find writable folders in a cleaner way.

```bash
find / -writable 2>/dev/null | cut -d "/" -f 2,3 | grep -v proc | sort -u 
```

Find development tools and supported languages:

```bash
find / -name perl*
```
```bash
find / -name python*
```
```bash
find / -name gcc*
```

## Networking

This area will have instructions on networking operations.

* netstat
* route
* DNS analysis

### netstat

netstat -a: shows all listening ports and established connections.

netstat -at or netstat -au can also be used to list TCP or UDP protocols respectively.

netstat -l: list ports in “listening” mode. These ports are open and ready to accept incoming connections. This can be used with the “t” option to list only ports that are listening using the TCP protocol.

netstat -s: list network usage statistics by protocol (below) This can also be used with the -t or -u options to limit the output to a specific protocol.

netstat -tp: list connections with the service name and PID information.

netstat -i: Shows interface statistics. We see below that “eth0” and “tun0” are more active than “tun1”.

netstat -ano

-a: Display all sockets

-n: Do not resolve names

-o: Display timers


