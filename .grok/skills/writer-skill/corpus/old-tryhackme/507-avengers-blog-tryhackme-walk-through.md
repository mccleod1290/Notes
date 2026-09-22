---
id: 507
title: "Avenger's Blog | TryHackMe  walk-through "
created: 2023-06-26T15:21:13+00:00
url: https://hacklido.com/blog/507-avengers-blog-tryhackme-walk-through
words: 799
---

# Avenger's Blog | TryHackMe  walk-through 

[image]

This time we will be looking at another easy but subscriber only room. We all love Tony Stark don’t we, in this room we will be hacking into his machine, enumerate, bypass a login portal via SQL injection and gain root access and most important of all we will be having fun pwning our favorite hero’s infrastructure [imaginary one, that is hosted on tryhackme].

# Task-1 Deploy

This task does not need you to answer, just deploy your machine and you are good to go.

# Task-2 Cookies

To complete this task, we need get http header, and in simplest terms http cookies contains information essential for the website to worker, such as login information and items in your shopping cart and these information are stored in user’s web browser.

You can inspect the page, check on the application menu option under that refer to the cookie’s section and there you will get the flag1 cookie value.

[image]

Alternatively there is a less painful way of doing things i.e to use  https://chrome.google.com/webstore/detail/cookie-editor/hlkenndednhfkekhgcdicdfddnkalmdm/related cookie-editor plugin from chrome.

[image]

# Task 3 - HTTP Headers

On chrome to solve this task you need to get http headers. Inspect the page, check on the click network tab [1] and check the website column [2] and scroll and check http header section [3].  https://www.youtube.com/watch?v=ue6oEH_NeNY Refer this youtube video if you are stuck.

HTTP headers let a client and server share information with each other using HTTP request or response. There are two main HTTP requests i.e request and response. If someone needs to check and learn more about HTTP headers then check these links.

-  https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers

-  https://developer.mozilla.org/en-US/docs/Web/HTTP https://developer.mozilla.org/en-US/docs/Web/HTTP

-  https://chrome.google.com/webstore/detail/http-headers/fabjnpecogealbfoebkcjfbmdhnnfhbj?hl=en-GB https://chrome.google.com/webstore/detail/http-headers/fabjnpecogealbfoebkcjfbmdhnnfhbj?hl=en-GB [extension]

[image]

Using the extension you can check the headers with just one click, which displays the flags.

[image]

# Task 4-  Enumeration and FTP

So without fasting a single minute let’s fire up our favorite tool rust-scan.

```
` rustscan -g -a 10.10.50.206`
```

The above command let’s us know the open ports. As we have habituated for scanning all the important things like services and operating system scanning along with vuln-scan.

```
`sudo rustscan  --ulimit 5000 -a 10.10.50.206 -- -A -sN --top-ports 1024 --script=vuln -oX avenger.xml --reason --stats-every 5s `
```

So generate a readable output for the scans using this command, and open the web browser to view it.

```
`xsltproc attackerkb.xml -o attackerkb.html`
```

Since this room is not designed to gain access via vulnerable exploit we will avoid going down this rabbit hole, but it’s a good practice to include vuln-scan in all of your scanning and converting your scans from .xml to .html to increase the readability. Now we are asked to FTP  into the machine and to get flag 3.

[image]

# Task-5 GoBuster

Now since this is a website, let’s see and check if there are any juicy information within the website directories. For this we will use a tool called '‘gobuster’' and this will return the answer for our question.

```
`gobuster dir -u http://10.10.50.206 -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt`
```

[image]

# Task-6 SQL Injection

To complete this task, one need to bypass the login page, and to get number of lines there are present in this web-page. The room gives us a hint for exploiting the sql injection, that command can be translated into the following code, which when inserted into the username and password, which can be used to bypass the login page.

```
`' OR 1=1 --`
```

[image]

# Task-7  Remote Code Execution and Linux

[image]

Now the jarvis program executes only certain commands like ls, and other commands like whoami or cat is not getting executed. So for this let’s look hint, the room hint gives us to use the reverse word of ‘cat’ which is ‘tac’. The room tells us to execute the following command to get the flag.

```
`cd ../; ls; cat flag5.txt`
```

Now in place of cat, put tac and execute the command which should give us the flag.

```
`cd ../; ls; tac flag5.txt`
```

[image]

With this we have successfully hacked into avenger’s blog and it kinda feel good as it simulates the environment of the best inventor aka '‘Tony Stark’'. Until then keep hacking !
