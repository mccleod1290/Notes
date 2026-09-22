---
id: 496
title: "AttackerKB & Source | TryHackMe Walk-through"
created: 2023-06-21T07:15:41+00:00
url: https://hacklido.com/blog/496-attackerkb-source-tryhackme-walk-through
words: 1596
---

# AttackerKB & Source | TryHackMe Walk-through

[image]

Judging by the title you guys might be wondering two rooms in a single blog, well fear not my friend, source is the vulnerable machine set for both the tryhackme rooms therefore flags for the attackerkb is as same as flags for source room at least as of June 21 2023. Strictly speaking this is a beginner room good enough to brush up skills in basic pentesting, and there are only two task in this room.

Room url-  https://tryhackme.com/room/attackerkb https://tryhackme.com/room/attackerkb

- To scan, enumerate and to find vulnerabilities in this machine.

- Hack into the machine using the exploit, gain access and get flag.

Where as if you are asked to complete the tasks you will be asked to do some other things like looking into the ssl certificate to see the host name, browsing into attackerkb website to look around and to read and learn more about the exploit, as questions will be based on that. This walk through specifically will be focused less on answering stuff and more on pwning and gaining access.

For people who are still wondering what is attackerkb, it’s essentially like exploit db, but with more specific information on exploits and mostly they focus on the exploits that the real pentesters exploit in wild. So one could say it’s essentially concise version of exploit db, but on steroids.

# Discovering the lay of the land [scanning and enumeration]

Well for those who are ready to launch nmap in haste they are going to get disappointed as nmap is very slow. Try running aggressive scan [nmap’s default scripts plus operating system detection plus version scanning] along with vulnerability scrip, it will take a quite lot of time. Rust scan essentially completed all these things under a minute which is a great thing.

For people interested in using rustscan, I highly suggest you to go through the following youtube videos first to get a good glance on how to install and basic usage.

To install rust scan, go to  https://github.com/RustScan/RustScan/releases https://github.com/RustScan/RustScan/releases and then pull out rustscan 2.0.1 version which has .deb extension. Installing using a .deb executable file is far less annoying, and hassel free over doing the things in docker way, especially when a person like me does not have enough system resources.

```
`sudo dpkg -i rustscan_2.0.1_amd64.deb`
```

The above command should essentially installs rustscan on your device. After installing run both commands listed below.

```
` rustscan -g -a 10.10.25.159`
```

```
`sudo rustscan  --ulimit 5000 -a 10.10.25.159 -- -A -sN --top-ports 1024 --script=vuln -oX attackerkb.xml --reason --stats-every 5s `
```

Let’s breakdown the commands used in the scan.

- -g is used for grep-able format, displays short and concise version of available ports without any extra technical jargon. Extremly useful to know the open ports, and if we want to see what these ports are for, then just use google.

- Note that unlike nmap, without specifying -a flag that is address flag you can’t scan any IP address, in nutshell, the first command simply gives out the results of open ports in the target.

- We are setting a ulimit, as without this parameter rust scan does not work smoothly. Essentially this command allows rust scan to use the our own system resources which it needs to perform the scan and by default setting it to 5000 will increase the speed of the scan. NO wonder why the scan just completed in 59.36 seconds.

- Rust scan allows nmap commands to be executed only if we inlucde – [double hyphen ].

- -A performs nmap aggressive scan which is a combination of nmap default scripts along with operating system detection and service detection.

- Here were are telling –top-ports 1024 rustscan to scan 1024 well known ports because from the system admin mindset, he or she is less probably likely to configure anything apart from default port number, because doing so has high probability of messing things up. So there is high chances that if we scan only well known 1024 ports out of 65k ports, we can find the same open ports which we have gotten if we scanned for whole 65k ports. Still don’t trust me, scan all the ports using -p- and you can verify for yourself and in ctf this is extremely useful when you have time constraints.

- –script=vuln performs a vulnerability scan, as in ctf we are given a vulnerability to exploit but in real world guess work does not go well and there is no one to tell what vulnerability we are facing so it’s a good practice to include vulnerability scanning in all of our scans.

- -oX saves output into a file and we specify it to be attackerkb. xml

- –reason tells us the reason for why this tool has detected certain service and detailed output for every thing it displays.

- –stats-every 5s this is my favorite flag. Almost every one in this world including youtubers and some seasoned pentesters, run scans and stare at blank black screen hoping that their scan would complete at some part of the day without having no clue when it will actually get completed. This command displays statistics of scanning operating and updates status every 5 seconds automatically and tells us how much time is left for the scan to get completed.

Give few minutes and your scan will be completed. Now you might have notice that we have used an xml file to save output rather than .txt or some other format. Because if we chose to save in .xml file we can convert into a .html file which gives us neat output of vulnerabilities and open ports.  To do that we will be using a tool called '‘xsltproc’'. [By default installed in parrot os].

```
`xsltproc attackerkb.xml -o attackerkb.html`
```

Now select you favorite browser to open this file.

[image]

Here we see some vulnerabilities for the webmin service, which is indeed the vulnerability we are going to exploit, but not the one that is displayed in the nmap vulnerability script, but we will be using webmin backdoor exploit for this.

For the other task, simply viewing the ssl certificate which you can do On Firefox, you can view this by clicking on the ‘i’ in the URL, then the ‘>’ in Connection, ‘More Information’, and then ‘View Certificate’ on the Security tab. Doing so will reveal your host name for the machine.

[image]

[image]

# Learning to Fly

In my humble opinion, this section exists for us to get familiar with the Attackerkb website and to know more about the exploit we are doing to run against this vulnerable web server. Give some time to go through this section, read and if stuck feel free to rely on google to answer questions asked.

# Blasting Away [Exploiting and Gaining Access]

In this task we are doing to use linux/http/webmin_backdoor exploit to gain access into the machine. Launch metasploit using msfconsole -q  command.

You can either directly '‘use’' the exploit or search for the exploit and then use it, choice is yours. Once you have selected the exploit, you need to set up four parameters to get meterpreter shell.

- lhost or listening host that will be your tryhackme vpn ip.

- rhost what well be your remote host or the machine you are attacking.

- Set ssl = true as we this machine uses ssl.

- Set target = 1 to run this exploit in memory and to get meterpreter shell.

[image]

 In this you need to set target = 1 to get meterpreter shell. Once you have set, simply type in exploit and wait few seconds you will get the shell.

If you are facing any errors,  https://forum.hackthebox.com/t/solved-exploit-completed-but-no-sessions-created/2488 refer to this url and make sure that you are doing everything right, i.e putting right values for rhost and lhost and make sure that your firewall is turned off.

After gaining shell, as a proof that we have compromised the machines you are expected to find some text files that contain flags. As these files are only accessible after hacking into the machine, tryhackme assumes that you have successfully hacked your way in. It’s easy to guess that flags are hidden in user directory, or in desktop or in root directory, but let’s not rely on out ability to guess and make it more realistic.

```
`search -f *.txt`
```

This command searched for all file in the format something . txt in the whole system as meterpreter’s search command allows us to search for any file format as long as we specify it’s name and it’s full file extension type i.e txt for text and so on.

But instead of going through all the list we know that flag will be named either flag.txt or user.txt and root.txt , turns out that there are two files one is root.txt and another is flag.txt

[image]

```
`cat /root/root.txt
cat /home/dark/user.txt`
```

Running the above two commands will give you root flag and user file respectively.

Note that these root flag and user flag are same for the tryhackme room called as source, as same vulnerable machine is used in both room, feel free to check out and fill answers for that room too.

 https://tryhackme.com/room/source https://tryhackme.com/room/source
