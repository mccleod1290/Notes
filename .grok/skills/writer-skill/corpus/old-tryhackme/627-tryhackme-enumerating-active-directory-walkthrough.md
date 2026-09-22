---
id: 627
title: "TryHackMe Enumerating Active Directory Walkthrough"
created: 2023-10-17T14:25:55+00:00
url: https://hacklido.com/blog/627-tryhackme-enumerating-active-directory-walkthrough
words: 3082
---

# TryHackMe Enumerating Active Directory Walkthrough

[image]

This is continuation, second part of the active directory networks from tryhackme. You guys can always check part 1  https://hacklido.com/blog/626-breaching-ad-tryhackme-writeup here. Now let’s start the with the second part of the series which is ‘Enumerating Active Directory’. As the name suggests we will be enumerating looking around active directory environment for potential entry points to break in.

# Task 1 Why enumerating AD.

This room starts with theoretical explanation on hacking and breaching ad, importance of enumeration and very cool mind map which you can check for reference. There are no questions to be answered but before we proceed let’s do couple of things.

Step 1 - Use attack box, and connect to the network by resolving dns using the following command.

```
`root@mccleod1290:~# systemd-resolve --interface enumad --set-dns 10.200.76.101  --set-domain za.tryhackme.com
root@ip-10-10-177-59:~# nslookup za.tryhackme.com
Server:		127.0.0.53
Address:	127.0.0.53#53

Non-authoritative answer:
Name:	za.tryhackme.com
Address: 10.200.76.101`
```

Step 2 - Visit the following URL, grab the credentials.

 http://distributor.za.tryhackme.com/creds http://distributor.za.tryhackme.com/creds

[image]

Step 3- With the credentials obtained, SSH into the machine.

```
`root@mccleod1290:~# ssh za.tryhackme.com\\derek.bell@thmjmp1.za.tryhackme.com
The authenticity of host 'thmjmp1.za.tryhackme.com (10.200.76.248)' can't be established.
ECDSA key fingerprint is SHA256:HTvSA1Qt987SOP3SRopzSQ22Q8lPttrUzTwuTyGDLck.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added 'thmjmp1.za.tryhackme.com,10.200.76.248' (ECDSA) to the list of known hosts.
za.tryhackme.com\derek.bell@thmjmp1.za.tryhackme.com's password:

Microsoft Windows [Version 10.0.17763.1098]
(c) 2018 Microsoft Corporation. All rights reserved.

za\derek.bell@THMJMP1 C:\Users\derek.bell>`
```

# Task 2 Credential Injection

Tryhackme teaches us two things in this task.

- Using `runas.exe` an legit windows binary used to inject the credentials into memory.

- Configuring DNS in windows machine, but since we can perform nslookup for `za.tryhackme.com` our’s is already configured so it’s of no harm to skip this part but do take a small note of it.

```
`C:\Users\derek.bell>nslookup za.tryhackme.com
DNS request timed out.
    timeout was 2 seconds.
Server:  UnKnown
Address:  10.200.76.101

DNS request timed out.
    timeout was 2 seconds.
DNS request timed out.
    timeout was 2 seconds.
Name:    za.tryhackme.com
Address:  10.200.76.101

za\derek.bell@THMJMP1 C:\Users\derek.bell>runas.exe /netonly /user:za.tryhackme.
com\derek.bell cmd.exe
Enter the password for za.tryhackme.com\derek.bell:
Attempting to start cmd.exe as user "za.tryhackme.com\derek.bell" ...`
```

Questions

What native Windows binary allows us to inject credentials legitimately into memory?

```
`runas.exe`
```

What parameter option of the runas binary will ensure that the injected credentials are used for all network connections?

```
`/netonly`
```

What network folder on a domain controller is accessible by any authenticated AD account and stores GPO information?

```
`SYSVOL`
```

When performing dir \za.tryhackme.com\SYSVOL, what type of authentication is performed by default?

```
`Kerberos Authentication`
```

# Task 3

For this task we have to `RDP` into this machine. Use the below attached image as reference to login to the RDP using your creds.

[image]

If in case you see a pop-up asking `unc=lock login keyring` then ignore it. Just hit cancel, and yes it does not impact your present attack box session.

[image]

Now I can’t explain how important it is to search and open `Active Directory Users and computers`. I literally opened `Active Directory Domains and Trees` and lol I was wasting 15-20 minutes of time looking around, found nothing and got frustrated for now reason. If you are struck in this look, simply hit right click and the correct tab will open up.

[image]

Simply navigating through tab will give you answers for our question.

[image]

Questions

How many Computer objects are part of the Servers OU?

[image]

```
`2`
```

How many Computer objects are part of the Workstations OU?

[image]

```
`1`
```

How many departments (Organisational Units) does this organisation consist of?

[image]

```
`7`
```

How many Admin tiers does this organisation have?

```
`3 `
```

Note that the tiers of the admin can be seen in the image attached to the next question.

What is the value of the flag stored in the description attribute of the t0_tinus.green account?

[image]

```
`THM{Enumerating.Via.MMC}`
```

# TASK 4 Enumeration through Command Prompt

If you made it this far, congrats give yourself a pat in your back. From now things will be getting easier as you have to just type in commands and understand them. Most of the commands are easy to understand and we will be using `net` command to enumerate and find answers to the questions.

Questions

Apart from the Domain Users group, what other group is the aaron.harris account a member of?

Direct question related to `user` called `arron.harris` in the `domain` the command will be `net` followed by…

```
`C:\Users\derek.bell>net user aaron.harris /domain
The request will be processed at a domain controller for domain za.tryhackme.com
.

User name                    aaron.harris
Full Name                    Aaron Harris
Comment
User's comment
Country/region code          000 (System Default)
Account active               Yes
Account expires              Never

Password last set            2/24/2022 11:05:11 PM
Password expires             Never
Password changeable          2/24/2022 11:05:11 PM
Password required            Yes
User may change password     Yes

Workstations allowed         All
Logon script
User profile
Home directory
Last logon                   Never

Logon hours allowed          All

Local Group Memberships
Global Group memberships     *Domain Users         *Internet Access
The command completed successfully.`
```

```
`Internet Access`
```

Is the Guest account active? (Yay,Nay)

This is a direct question related to guest user from the domain. So the command will …

```
`C:\Users\derek.bell>net user guest /domain
The request will be processed at a domain controller for domain za.tryhackme.com
.

User name                    Guest
Full Name
Comment                      Built-in account for guest access to the computer/d
omain
User's comment
Country/region code          000 (System Default)
Account active               No
Account expires              Never

Password last set            10/16/2023 4:53:09 AM
Password expires             Never
Password changeable          10/16/2023 4:53:09 AM
Password required            No
User may change password     Yes

Workstations allowed         All
Logon script
User profile
Home directory
Last logon                   Never

Logon hours allowed          All

Local Group Memberships      *Guests
Global Group memberships     *Domain Guests
The command completed successfully.`
```

```
`nay`
```

How many accounts are a member of the Tier 1 Admins group?

Another direct question related to group in the domain

```
` C:\Users\derek.bell>net group "Tier 1 Admins" /domain
The request will be processed at a domain controller for domain za.tryhackme.com
.

Group name     Tier 1 Admins
Comment

Members

-------------------------------------------------------------------------------
t1_arthur.tyler          t1_gary.moss             t1_henry.miller
t1_jill.wallis           t1_joel.stephenson       t1_marian.yates
t1_rosie.bryant
The command completed successfully.`
```

```
`7`
```

What is the account lockout duration of the current password policy in minutes?

Question related to accounts in the `domain`.

```
`C:\Users\derek.bell>net accounts /domain
The request will be processed at a domain controller for domain za.tryhackme.com
.

Force user logoff how long after time expires?:       Never
Minimum password age (days):                          0
Maximum password age (days):                          Unlimited
Minimum password length:                              0
Length of password history maintained:                None
Lockout threshold:                                    Never
Lockout duration (minutes):                           30
Lockout observation window (minutes):                 30
Computer role:                                        PRIMARY
The command completed successfully.`
```

```
`30`
```

# Task 5 Enumeration through PowerShell

Now the following tasks are fairly simple. Jus remember that in previous task we had used `net` command against `user`, `group` , and `account`. In powershell we will be using similar utility but instead of single command we will be using `Get-ADUser`, `Get-ADGroup` and lastly `Get-ADDomain`. Very similar right…

And not to mention we will be specifying `-Identity` which is our username, `-Server` which is za.tryhackme.com and `-Properties` which will be our data which we are looking for. In case you feel lost use `*` symbol in the `-Properties` attribute.

What is the value of the Title attribute of Beth Nolan (beth.nolan)?

```
`C:\Users\derek.bell>powershell
Windows PowerShellCopyright (C) Microsoft Corporation. All rights reserved.
PS C:\Users\derek.bell> Get-ADUser -Identity beth.nolan -Server za.tryhackme.com
 -Properties Title

DistinguishedName : CN=beth.nolan,OU=Sales,OU=People,DC=za,DC=tryhackme,DC=com
Enabled           : True
GivenName         : Beth
Name              : beth.nolan
ObjectClass       : user
ObjectGUID        : c4ae7c4c-4f98-4366-b3a1-c57debe3256f
SamAccountName    : beth.nolan
SID               : S-1-5-21-3330634377-1326264276-632209373-2760
Surname           : Nolan
Title             : Senior
UserPrincipalName :`
```

```
`Senior`
```

What is the value of the DistinguishedName attribute of Annette Manning (annette.manning)?

```
`PS C:\Users\derek.bell> Get-ADUser -Identity annette.manning -Server za.tryhackme.com -Properties DistinguishedName

DistinguishedName : CN=annette.manning,OU=Marketing,OU=People,DC=za,DC=tryhackme,DC=com
Enabled           : True
GivenName         : Annette
Name              : annette.manning
ObjectClass       : user
ObjectGUID        : 57069bf6-db28-4988-ac9e-0254ca51bb2f
SamAccountName    : annette.manning
SID               : S-1-5-21-3330634377-1326264276-632209373-1257
Surname           : Manning
UserPrincipalName :`
```

```
`CN=annette.manning,OU=Marketing,OU=People,DC=za,DC=tryhackme,DC=com`
```

When was the Tier 2 Admins group created?

```
`PS C:\Users\derek.bell> Get-ADGroup -Identity "Tier 2 Admins" -Server za.tryhack
me.com -Properties whenCreated

DistinguishedName : CN=Tier 2 Admins,OU=Groups,DC=za,DC=tryhackme,DC=com
GroupCategory     : Security
GroupScope        : Global
Name              : Tier 2 Admins
ObjectClass       : group
ObjectGUID        : 6edab731-c305-4959-bd34-4ca1eefe2b3f
SamAccountName    : Tier 2 Admins
SID               : S-1-5-21-3330634377-1326264276-632209373-1104
whenCreated       : 2/24/2022 10:04:41 PM`
```

```
`2/24/2022 10:04:41 PM`
```

What is the value of the SID attribute of the Enterprise Admins group?

```
`PS C:\Users\derek.bell> Get-ADGroup -Identity "Enterprise Admins" -Server za.try
hackme.com -Properties SID

DistinguishedName : CN=Enterprise Admins,CN=Users,DC=za,DC=tryhackme,DC=com
GroupCategory     : Security
GroupScope        : Universal
Name              : Enterprise Admins
ObjectClass       : group
ObjectGUID        : 93846b04-25b9-4915-baca-e98cce4541c6
SamAccountName    : Enterprise Admins
SID               : S-1-5-21-3330634377-1326264276-632209373-519`
```

```
`S-1-5-21-3330634377-1326264276-632209373-519`
```

Which container is used to store deleted AD objects?

```
`PS C:\Users\derek.bell> Get-ADDomain

AllowedDNSSuffixes                 : {}
ChildDomains                       : {}
ComputersContainer                 : CN=Computers,DC=za,DC=tryhackme,DC=com
DeletedObjectsContainer            : CN=Deleted
                                     Objects,DC=za,DC=tryhackme,DC=com
DistinguishedName                  : DC=za,DC=tryhackme,DC=com
DNSRoot                            : za.tryhackme.com
DomainControllersContainer         : OU=Domain
                                     Controllers,DC=za,DC=tryhackme,DC=com
DomainMode                         : Windows2012R2Domain
DomainSID                          : S-1-5-21-3330634377-1326264276-632209373
ForeignSecurityPrincipalsContainer : CN=ForeignSecurityPrincipals,DC=za,DC=tryh
                                     ackme,DC=com
Forest                             : za.tryhackme.com
InfrastructureMaster               : THMDC.za.tryhackme.com
LastLogonReplicationInterval       :
LinkedGroupPolicyObjects           : {CN={31B2F340-016D-11D2-945F-00C04FB984F9}
                                     ,CN=Policies,CN=System,DC=za,DC=tryhackme,
                                     DC=com}
LostAndFoundContainer              : CN=LostAndFound,DC=za,DC=tryhackme,DC=com
ManagedBy                          :
Name                               : za
NetBIOSName                        : ZA
ObjectClass                        : domainDNS
ObjectGUID                         : 518ee1e7-f427-4e91-a081-bb75e655ce7a
ParentDomain                       :
PDCEmulator                        : THMDC.za.tryhackme.com
PublicKeyRequiredPasswordRolling   :
QuotasContainer                    : CN=NTDS Quotas,DC=za,DC=tryhackme,DC=com
ReadOnlyReplicaDirectoryServers    : {}
ReplicaDirectoryServers            : {THMDC.za.tryhackme.com}
RIDMaster                          : THMDC.za.tryhackme.com
SubordinateReferences              : {DC=ForestDnsZones,DC=za,DC=tryhackme,DC=c
                                     om, DC=DomainDnsZones,DC=za,DC=tryhackme,D
                                     C=com, CN=Configuration,DC=za,DC=tryhackme
                                     ,DC=com}
SystemsContainer                   : CN=System,DC=za,DC=tryhackme,DC=com
UsersContainer                     : CN=Users,DC=za,DC=tryhackme,DC=com`
```

```
`DeletedObjectsContainer`
```

# Task 6 Enumeration through Bloodhound

If this is your first time hearing this tool and you are like blood what, then fear not my friend. It’s just another tool that maps out systems and networks inside an active directory environment and gives us a cool graph view. That’s all we need to know about bloodhound to get started.

```
`**Benefits**

- Provides a GUI for AD enumeration.
- Has the ability to show attack paths for the enumerated AD information.
- Provides more profound insights into AD objects that usually require several manual queries to recover.

**Drawbacks**

- Requires the execution of Sharphound, which is noisy and can often be detected by AV or EDR solutions.`
```

Questions

What command can be used to execute Sharphound.exe and request that it recovers Session information only from the za.tryhackme.com domain without touching domain controllers?

```
`Sharphound.exe --CollectionMethods Session --Domain za.tryhackme.com --ExcludeDCs`
```

### Now let’s practically use `bloodhound`

Step 1- Use the previously mentioned command in your victim machine, to the one we have `ssh` session running.

```
`PS C:\Tools> .\SharpHound.exe --CollectionMethods All --Domain za.tryhackme.com
--ExcludeDCs
2023-10-16T06:50:53.5856201+01:00|INFORMATION|Resolved Collection Methods: Group
, LocalAdmin, GPOLocalGroup, Session, LoggedOn, Trusts, ACL, Container, RDP, Obj
ectProps, DCOM, SPNTargets, PSRemote
2023-10-16T06:50:53.6018654+01:00|INFORMATION|Initializing SharpHound at 6:50 AM
 on 10/16/2023
2023-10-16T06:50:54.3841018+01:00|INFORMATION|Loaded cache with stats: 2119 ID t
o type mappings.
 2122 name to SID mappings.
 0 machine sid mappings.
 2 sid to domain mappings.
 0 global catalog mappings.
2023-10-16T06:50:54.3841018+01:00|INFORMATION|Flags: Group, LocalAdmin, GPOLocal
Group, Session, LoggedOn, Trusts, ACL, Container, RDP, ObjectProps, DCOM, SPNTar
gets, PSRemote
2023-10-16T06:50:54.5716037+01:00|INFORMATION|Beginning LDAP search for za.tryha
ckme.com
2023-10-16T06:51:25.3036578+01:00|INFORMATION|Status: 0 objects finished (+0 0)/
s -- Using 56 MB RAM
2023-10-16T06:51:42.3095355+01:00|INFORMATION|Producer has finished, closing LDA
P channel
2023-10-16T06:51:42.3251397+01:00|INFORMATION|LDAP channel closed, waiting for c
onsumers
2023-10-16T06:51:43.1383947+01:00|INFORMATION|Consumers finished, closing output
 channel
Closing writers
2023-10-16T06:51:43.1852597+01:00|INFORMATION|Output channel closed, waiting for
 output task to complete
2023-10-16T06:51:43.3571278+01:00|INFORMATION|Status: 2159 objects finished (+21
59 44.97917)/s -- Using 66 MB RAM
2023-10-16T06:51:43.3571278+01:00|INFORMATION|Enumeration finished in 00:00:48.7
961217

Unhandled Exception: System.UnauthorizedAccessException: Access to the path 'C:\
Tools\YzE4MDdkYjAtYjc2MC00OTYyLTk1YTEtYjI0NjhiZmRiOWY1.bin' is denied.
   at System.IO.__Error.WinIOError(Int32 errorCode, String maybeFullPath)
   at System.IO.FileStream.Init(String path, FileMode mode, FileAccess access, I
nt32 rights, Boolean useRights, FileShare share, Int32 bufferSize, FileOptions o
n useLongPath, Boolean checkHost)
   at System.IO.FileStream..ctor(String path, FileMode mode, FileAccess access,
FileShare share)
   at Sharphound.SharpLinks.SaveCacheFile(IContext context)
   at Sharphound.Program.<>c__DisplayClass0_0.<<Main>b__1>d.MoveNext()
--- End of stack trace from previous location where exception was thrown ---
   at System.Runtime.ExceptionServices.ExceptionDispatchInfo.Throw()
   at System.Runtime.CompilerServices.TaskAwaiter.HandleNonSuccessAndDebuggerNot
ification(Task task)
   at CommandLine.ParserResultExtensions.<WithParsedAsync>d__20`1.MoveNext()
--- End of stack trace from previous location where exception was thrown ---
   at System.Runtime.ExceptionServices.ExceptionDispatchInfo.Throw()
   at System.Runtime.CompilerServices.TaskAwaiter.HandleNonSuccessAndDebuggerNot
ification(Task task)
   at Sharphound.Program.<Main>d__0.MoveNext()
--- End of stack trace from previous location where exception was thrown ---
   at System.Runtime.ExceptionServices.ExceptionDispatchInfo.Throw()
   at System.Runtime.CompilerServices.TaskAwaiter.HandleNonSuccessAndDebuggerNot
ification(Task task)
   at Sharphound.Program.<Main>(String[] args)
PS C:\Tools> dir

    Directory: C:\Tools

Mode                LastWriteTime         Length Name
----                -------------         ------ ----
-a----        10/8/2023   7:43 PM         121596 20231008194312_BloodHound.zip
-a----       10/15/2023   4:58 PM         120904 20231015165800_BloodHound.zip
-a----       10/16/2023   6:51 AM         121197 20231016065141_BloodHound.zip
-a----        3/16/2022   5:19 PM         906752 SharpHound.exe
-a----        10/8/2023   7:43 PM         359470 YzE4MDdkYjAtYjc2MC00OTYyLTk1YT
                                                 EtYjI0NjhiZmRiOWY1.bin

PS C:\Tools>`
```

Step 2- Transfer the files to our attack box using `scp` .

And remember there are already couple of zip files as it’s an shared with other users so ours should be the latest zip file which is `20231016065141_BloodHound.zip`.

```
`root@mccleod1290:~# sudo scp za.tryhackme.com\\derek.bell@thmjmp1.za.tryhackme.com:C:/Tools/20231016065141_BloodHound.zip .
za.tryhackme.com\derek.bell@thmjmp1.za.tryhackme.com's password:
20231016065141_BloodHound.zip                 100%  118KB   2.0MB/s   00:00
root@mccleod1290:~# scp derek.bell@za.tryhackme.com@thmjmp1.za.tryhackme.com:C:/Tools/20231016065141_BloodHound.zip .
derek.bell@za.tryhackme.com@thmjmp1.za.tryhackme.com's password:
20231016065141_BloodHound.zip                 100%  118KB   1.5MB/s   00:00
root@mccleod1290:~# ls
20231016065141_BloodHound.zip  Instructions  Rooms              Tools
Desktop                        Pictures      Scripts
Downloads                      Postman       thinclient_drives
root@mccleod1290:~# `
```

Step 3 - Start two terminal sessions on your attack box.

- On your first terminal type the following command

```
`neo4j console start`
```

- On your second terminal use the following command.

```
`bloodhound --no-sandbox`
```

Don’t mention to enter your credentials which are `neo4j:neo4j`. After you have logged in on to your right most corner, from top on the 5th option click on upload data. Select your zip file which is `20231016065141_BloodHound.zip` in my case and upload once it’s done simply navigating through the graph will give us answers.

[image]

Apart from the krbtgt account, how many other accounts are potentially kerberoastable?

```
`4`
```

How many machines do members of the Tier 1 Admins group have administrative access to?

```
`2`
```

How many users are members of the Tier 2 Admins group?

```
`15`
```

# Task 7 Conclusion

As a good cyberdefender we can stop and prevent hackers from enumerating active directories using the following steps…

   - Powerful AD enumeration techniques, such as Sharphound, generate a significant number of LogOn events when enumerating session information. Since it executes from a single AD account, these LogOn events will be associated with this single account. We can write detection rules to identify this type of behavior if it occurs from a user account.

   - We can write signature detection rules for the tools that must be installed for specific AD enumeration techniques, such as the SharpHound binaries and the AD-RSAT tooling.

   - Unless used by employees of our organization, we can monitor the use of Command Prompt and PowerShell in our organization to detect potential enumeration attempts from unauthorized sources.

[image]

Being a pro at hacking Active Directory is a must if you’re working on your OSCP certification. This TryHackMe box is a great introduction and it goes well with the  https://guidedhacking.com/threads/kenobi-tryhackme-walkthrough-oscp-like-machine.17202/ Kenobi TryHackMe Challenge, which is a popular beginner OSCP-like machine that covers all the basics. In fact, if you thought this one was a bit confusing, definitely give THM Kenobi a try as it’s more beginner oriented. Either way, it’s always fun to learn something new.



---

## Author follow-up 2

https://hacklido.com/blog/627/2 vampy Thanks bro ☺.
