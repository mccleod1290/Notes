---
id: 522
title: "TryHackme John The Ripper - Writeup"
created: 2023-07-05T10:59:14+00:00
url: https://hacklido.com/blog/522-tryhackme-john-the-ripper-writeup
words: 1950
---

# TryHackme John The Ripper - Writeup

[image]

This time on tryhackme we will be looking at another subscriber room, which focuses on password cracking using industry wide popular tool called ‘john the ripper’. This is a great room to get started into password cracking, learn about hashes and all. Without much talking, let’s get started.

# Task-1 John who? - [No answer required]

Before we dive into cool password attacks, let’s pause for a while and consider learning what are hashes. Hashes is a way or representing data in another form which is of a proper fixed length, and masks the original value of the data. This is done through hashing algorithms, such as MD4,MD5,SHA256,SHA512 etc.

Now one might wonder what makes a hash secure? Hashing algorithms are designed in such a way that they operate only one way, meaning that calculated hash can’t be reversed using the output given. The good news is that even though reversing of original value from hash does not occur that does not mean that cracking of the hashes is impossible. One common way to do is to do via dictionary attack in which the tools analyses given hash with the hash or large set of most probable words that the password could be, if the hash of the word and the password matches then it’s your lucky day else not. Note that this process can be time consuming and success of the attack depends on both the complexity of the password as well as the broad range of words used in the attack.

# Task-2 Setting up John the Ripper

- In kali or parrot you can install using `sudo apt-get install john` to install this tool.[Skip this step as by default john the ripper is installed in kali/parrot].

- On black arch you can isntall using `packman -S john`

- You can build from source on any linux distribution using the following commands

```
`git clone https://github.com/openwall/john -b bleeding-jumbo john
cd john/src/
./configure
make -s clean && make -sj4
cd ../run`
```

Questions

- What is the most popular extended version of John the Ripper?

```
`Jumbo John`
```

———–

# Task-3 Wordlists

The two popular word lists we will be using as pentesters are  https://github.com/danielmiessler/SecLists SecLists and rockyou.txt word list which comes pre-loaded in most distributions like kali or parrot. To get started we need to extract the rockyou.txt.tar.gz file which you can do using the following command.

```
`sudo gzip -d /usr/share/wordslists/rockyou.txt.tar.gz`
```

Note that by default in kali or in parrot, `/usr/share/wordlists` is the directory in which you have all the wordlists stored and do make a small note that rockyou.txt is obtained from data breach on a website called `rockyou.com` in 2009.

Questions

- What website was the rockyou.txt wordlist created from a breach on?

```
`rockyou.com`
```

# Task-4 Cracking Basic Hashes

Now john functions in two modes, one you can automatically crack hashes without specifying the format, which detects the format you are given and it performs the task automatically, but do note that this is not the best idea and it is not always reliable.

```
`john --wordlist=/usr/share/wordlists/rockyou.txt hash.txt`
```

Another method is to identify the hash and then explicitly mentioning the format of the hash which one can do with the help of `--format=` flag. Alternatively you can also use hash-id.py or hash identifier a python tool to identify the hash.

```
`wget https://gitlab.com/kalilinux/packages/hash-identifier/-/raw/kali/master/hash-id.py
python3 hash-id.py
john --format=[format] --wordlist=[path of wordlist] [path to file]`
```

Now with this knowledge let’s try solving the questions.

Questions

- What type of hash is hash1.txt?

```
`md5`
```

[image]

- What is the cracked value of hash1.txt?

```
`john --format=md5 --wordlist=/usr/share/wordlists/rockyou.txt `
```

[image]

- What type of hash is hash2.txt?

[image]

```
`SHA1`
```

- What is the cracked value of hash2.txt

```
`john --format=raw-sha1 --wordlist=/usr/share/wordlists/rockyou.txt hash2.txt `
```

[image]

- What type of hash is hash3.txt?

[image]

- What is the cracked value of hash3.txt

```
`john --format=raw-sha256 --wordlist=/usr/share/wordlists/rockyou.txt hash3.txt`
```

[image]

- What type of hash is hash4.txt?

[image]

```
`whirlpool`
```

- What is the cracked value of hash4.txt

```
`john --format=whirlpool --wordlist=/usr/share/wordlists/rockyou.txt hash4.txt`
```

[image]

Note that I am already in the directory where the task files are located and I did not exit the hash-identifier program, which lead me automatically giving in the input of hashes to the program without manually typing in every time program name followed by hash. Do note these minute details and don’t waste your time on doing silly mistakes. And for the last question `raw` prefix is not required.

# Task-5 Cracking Windows Authentication Hashes

Now to complete the task all we need to know is that if we specify the `--format=nt` we will be able to questions in this task. That’s all we do need to know, but since we are haxors we will be spending on what is nt, and some learn some terms related to it. NT originally meant ‘new technology’, which stores users and service passwords in operating system. Do make a note that NThash is the modern format and NTLM references the previous version of windows format for hashing passwords.

One can dump these NTHash/NTLM Hashes by dumping the SAm database on windows machine using tools like mimikatz or if you can AD, you can dump it from NTDS.dit file. Often if you can successfully perform the pass the hash attack you don’t need to crack the password. If the password policy is weak and if you want to try your luck then have fun cracking nthash/ntlm hash passwords.

Questions

- What do we need to set the “format” flag to, in order to crack this?

```
`nt`
```

- What is the cracked value of this password?

```
`john --format=nt --wordlist=/usr/share/wordlists/rockyou.txt ntlm.txt`
```

[image]

# Task 6 Cracking /etc/shadow Hashes

To crack passwords in linux from `etc/shadow` you need to combine it with `etc/passwd` file for this john has inbuilt utility called `unshadow`

```
`unshadow [path to passwd] [path to shadow]`
```

Luckily in this task, tryhackme already provides us unshadowed text file which has already been processed by john. Just we need to specify `--format=sha512crypt` and use the following command in the directory where you have downloaded `etchashes.txt` and you will get your answer.

```
`john --wordlist=/usr/share/wordlists/rockyou.txt --format=sha512crypt unshadowed.txt`
```

[image]

# Task-7 Single Crack Mode

Now in simplest terms if we get password hash or a particular user let’s say john, we assume that his password could be john1, john2 or john$, basically any permutation and combination which has the user-name. Luckily for us to crack such permutation and combination of passwords we don’t need a password list, all we need to specify `--single` mode in john, append or edit the file such a way that it has `username:password` hash and you are good to go.

Question

- What is Joker’s password?

Note that they have given use the user as joker, so let’s append our text file in order for the single mode in john the ripper to work.

```
`nano hash7.txt`
```

Change it to the following.

```
`joker:7bf6d9bb82bed1302f331fc6b816aada`
```

Now run the tool in single mode, and you will get the hash.

```
`john --single --format=raw-md5 hash7.txt `
```

[image]

# Task 8: Custom Rules

One can edit the configuration files on this tool to add customised rules, and this file is usually located at `/etc/john/john.conf` and also do note that you can also use the `--rule=` argument to do so. Full command using the recently mentioned argument would look something like this.

```
`john --wordlist=[path to wordlist] --rule=PoloPassword [path to file]`
```

Questions

- What do custom rules allow us to exploit?

```
`Password complexity predictability`
```

- What rule would we use to add all capital letters to the end of the word?

```
`Az"[A-Z]"`
```

- What flag would we use to call a custom rule called “THMRules”

```
`--rule=THMRules`
```

Reference-  https://www.openwall.com/john/doc/RULES.shtml https://www.openwall.com/john/doc/RULES.shtml

# Task 9: Cracking Password Protected Zip File

By this time you must have realised that one should give input as .txt in order to crack the hash. Well since it’s a zip file, to crack it’s password using john, we will be doing the same but instead we will be relying on `zip2john` to convert zip into text file and then crack it using john the ripper.

Questions

- What is the password for the secure.zip file?

For this use zip2john utility to convert zip into hash.txt.

```
`zip2john secure.zip > secure.txt
john secure.txt --wordlist=/usr/share/wordlists/rockyou.txt`
```

[image]

- What is the contents of the flag inside the zip file?

For this simply extract the zip file using your favourite zip extractor, and then display the contents of the text file.

[image]

# Task 10: Cracking Password Protected RAR File

We repeat the same process as we have done in the previous step, this time we will be relying on rar2john utility that comes pre-installed with john. You can use locate command to locate it’s place in the system and read manual pages and have learn a lot, but for completing this task all we need to do is to convert the rar file into a text file using rar2john utility and then crack the hash in the text file using john the ripper.

Questions

- What is the password for the secure.rar file?

```
`rar2john secure.rar > secure2.txt
john secure2.txt --wordlist=/usr/share/wordlists/rockyou.txt`
```

[image]

- What is the contents of the flag inside the zip file?

For this unrar the file, you can use unrar command to do so, and finally display the text file.

```
`sudo apt-get install unrar
unrar e secure.rar
cat flag.txt`
```

[image]

# Task 11: Cracking SSH Keys with John

With this, we come to final practical task in this room, don’t worry this one is also fairly simple. All you need to do is to convert the ssh keys into a text file using `ssh2john` utility and then crack the hash using john the ripper.

Well it turns out that this is not simple as it appears to, you need to tweak a little bit, locate where `ssh2john` is located, go in to that directory, install python2 and then run the command.

```
`sudo apt-get install python
sudo su
sudo python /usr/share/john/ssh2john.py /home/mccleod1290/idrsa.id_rsa > id.txt
john --wordlist=/usr/share/wordlists/rockyou.txt id.txt`
```

Note that you should be a root user to do anything under `/usr/share` directory and then make changes according to your user-directory and feel free to name the change of the output text file, in my case I have used `id.txt`

For some bizarre reasons, ssh2john does not load as other utilities, so we need to go to that directory as root user, use python2 to convert ssh into a text file and than crack it using john. Finally we get our password.

[image]

# Task 12 Further Reading

With this we successfully complete our room, feel free to check openwall wiki here for knowing more about using john, some advice and to stay updated about this tool.

 https://www.openwall.com/john/ https://www.openwall.com/john/
