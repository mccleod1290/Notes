---
id: 501
title: "STARTUP | TryHackMe walk-through"
created: 2023-06-23T07:41:13+00:00
url: https://hacklido.com/blog/501-startup-tryhackme-walk-through
words: 1179
---

# STARTUP | TryHackMe walk-through

[image]

This time we are looking at another tryhackme room which focuses on ftp access, file upload and remote code execution, pcap analysis and some privilege escalation. Now this is an beginner or easy room, although all these tasks might appear complex but remember that simple tasks are just stacked upon each other. So without wasting our time let’s get started.

🚪  https://tryhackme.com/room/startup Room Link - StartUp

## 1. Initial scan and directory brute forcing.

Now we will use our rust-scan to know the ports first and then scan for any vulnerabilities, services and what type of operating system is running. For the first port scanning we will use the following command.

```
`rustscan -g -a 10.10.18.233`
```

For service enumeration, and operating system detection along with basic nmap scripts we will be using -A  or the aggressive scan, along with vulnerability script to know if any vulnerabilities exist.

```
`sudo rustscan  --ulimit 5000 -a 10.10.18.233 -- -A -sN --top-ports 1024 --script=vuln -oX startup.xml --reason --stats-every 5s`
```

Now to get a grasp of what this scan actually did let’s convert the xml file into html file and use your favorite web browser to open the file.

```
`xlstproc startup.xml -o startup.html`
```

After running these scans we get a basic idea on what ports are running we see that ftp, ssh and http are running. There are some vulnerability in this room but that’s not the way this machine was intended to be rooted/exploited so we go as it was expected to be hacked.

Now since there is a web-site running, as usual we check if there is some juicy interesting directories present there. We fire our gobuster tool on to the website to find any content.

```
`sudo gobuster dir -u http://10.10.18.233/  -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt  | tee gobuster.txt`
```

[image]

The tee command saves the output into gobuster.txt which is quite useful if we ever need to know what was the directories found in this website. We see a directory called files and co-incidentally if we ftp into the machine using anonymous authentication, both directory matches. So maybe if we put a php reverse shell would it should give us access.

[image]

[image]

Notice how similar ftp files and the files in the files directory are similar. If we upload a reverse shell in ftp directory we should get initial access into the machine.

## 2. Initial access.

Grab a php reverse shell from pentest monkey, and give it executable permission using chmod command.

```
`wget https://raw.githubusercontent.com/pentestmonkey/php-reverse-shell/master/php-reverse-shell.php && chmod +x php-reverse-shell.php`
```

Make sure that you put this in the directory where you access your ftp, and also make sure you have changed IP address from the shell to your tryhackme vpn address.

[image]

In the ftp service, make sure that you are in ftp directory only then you can transfer file using put command. Which you can confirm by going into /files/ftp directory on the website.

```
`put php-reverse-shell.php`
```

[image]

Start your netcat listener to the port you mentioned in your reverse-shell and after starting your netcat listener click on the file, wait few seconds and you should get a reverse shell if you have done everything correctly.

[image]

As you can see we have successfully logged into the machine. But we did not get a stable shell. To get a stable shell there are couple of things you can do, but we will be sticking on to the age old method of stabilizing shell using python. Alternatively you can also check if python is installed by typing in which command.

```
`which python
#to check if python is installed or not
python -c 'import pty; pty.spawn("/bin/bash")'`
```

And in this directory we find a recipe.txt which is our answer for the first question.

[image]

## 3. PCAP analysis

In the incidents directory we see a pcap file named '‘suspicious.pcapng’'. So for easy access we just copy this file into the ftp folder, and then we once again ftp into this machine to get this pcap file.

```
`cp suspicious.pcapng /var/www/html/files/ftp`
```

And on your attacker/host machine ftp into the machine to get the pcap file. Make sure that you check ftp directory after logging into the ftp service and there you will find the pcap file.

[image]

Now to analyze this file just simply type in the following command.

```
`sudo wireshark suspicious.pcapng`
```

Let’s apply some filters as there are hundreds of packets, so let’s try somethings.

- Check for http.request.methods [no luck on this one]

- Check for something on port 4444, as many script kiddies who use metasploit use these port for skiddie hacks. And if we apply this filter we find something on packet number 35.

```
`tcp.port == 4444`
```

If we click on packet number 35 and follow the tcp stream we check some command run in the system and after scroll downs we see password for the user lennie.

[image]

## 4.Lateral movement

You can either ssh into the lennie machine, but we have already got php-backdoor running in one terminal so just changing the user to lennie using su should effectively work as well.

```
`su lennie`
```

And after logging into this user, we should be able to access the lennie folder that was not earlier accessible to us. In this lennie directory we have user.txt which is answer to our second question.

[image]

## 5. Privilege Escalation

So we got user flag, to get root flag let’s dig a bit deep. Along side of user.txt we see a directory called as '‘scripts’'. Let’s dig into this directory.

[image]

Digging further we see a script called planner.sh, but we find that this is owned by the root user and can’t be edited. So the odds of this script getting edited and we inserting an reverse-shell in this file is very low. Let’s see what this file does.

[image]

The script planner.sh periodically runs print.sh and you can check the permissions for this command using the age old way i.e using the ‘ls -al ’ command. This turns out that we have access to edit the file so quickly let’s grab a bash reverse shell from google and paste in here with out try hack me vpn addresss and add these lines at the /etc/print.sh file.

[image]

Now start a reverse shell listener on port 8080 using netcat wait a minute or two and you should get the root shell.

[image]

With this we solve startup tryhackme machine this is similar to  https://hacklido.com/blog/498-valley-tryhackme-walkthrough TryHackMe Valley Room  and it was indeed an easy room but it was stacked upon many beginner tasks so it took some time so solve the machine.
