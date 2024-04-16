# Linux_Notes 

General Notes on the Linux Operating System

## General Commands

This area will contain the most common commands on linux.

* File navigation
* Permissions
* Searching
* System administration

### Searching

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


