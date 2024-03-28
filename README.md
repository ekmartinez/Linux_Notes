# Linux_Notes 

This repositories contains personal notes on the installation, configuration and usage of the Linux Operating System,with a special focus on Arch Linux.  The primary purpose of this is to aid the author in configuring his own system whenever he needs to, with the tools and procedures that work for him.  This is by no means a tutorial or a guide on setting up stuff on Linux.  

## General Commands

This area will contain the most common commands on linux.

* System administration
* File navigation
* Permissions
* Searching

## System Administration

### Package Management

To install a package:

```bash
sudo pacman -S <package>
```

To install a package by first refreshing repositories:

```bash
sudo pacman -Sy <package>
```

To remove a package:

```bash
sudo pacman -R <package>
```

To remove a package an its dependencies:

```bash
sudo pacman -Rs <package>
```

To upgrade the system:

```bash
sudo pacman -Syu <package>
```

### User Management

To add a user:

```bash
useradd <user>
```

To set or change password for the user:

```bash
passwd <user>
```

To add user to a group:

```bash
usermod -G <group> -a <user>
```

## Searching

Finding files:

Find the file named “flag1.txt” in the current directory:

```bash
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

