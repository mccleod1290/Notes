---
id: 511
title: "TryHackMe Wireshark 101 - Walkthrough"
created: 2023-06-29T15:40:54+00:00
url: https://hacklido.com/blog/511-tryhackme-wireshark-101-walkthrough
words: 1777
---

# TryHackMe Wireshark 101 - Walkthrough

[image]

This time on tryhackme, we will be looking on a subscriber only room which focuses network security, specially on pcap analysis  using wireshark. This one will be a fun and beginner friendly room so without wasting our time let’s get started.

# Task-1 Introduction

For completing this task material, no answer is required, just a quick introduction to our wireshark tool which is used to analyze network packet capture files. It’s widely used and a popular tool for analyzing network packet.

This room assumes that you have some familiarity or understanding of some introductory network concepts and tryhackme recommends _completing the ‘ https://tryhackme.com/module/network-fundamentals Introductory Networking’.

# Task-2 Installation

For this you can refer wireshark website or check it’s official documentation. On parrot os and on kali linux it’s installed by default. You can install wireshark alternatively on linux using the following command.

```
`sudo apt-get install wireshark-qt`
```

# Task-3 Wireshark Overview

This task does not need any answer, it just brushes of basic concepts on how to start wireshark, selecting the right interface and what type of information does the wireshark give such as the packet number, time, source , destination , protocol, length, and packet information. This task does not need any answers so just go through the information and make sure to check out features and options on wireshark.

# Task- 4 Collection Methods

Again this task does not require answering any of the hard questions, as no questions are asked. Just some reading material on the network taps,  and introduction on what is mac flooding and arp posioning is given, which you guys out there can check or learn from google search and I am sure most of us must know or atleast be familiar with these terminologies by this time.

# Task- 5 Filtering Captures

Filters in wireshark is simple if you are familiar with these operators:

- and - operator: and / &&

- or - operator: or / ||

- equals - operator: eq / ==

- not equal - operator: ne / !=

- greater than - operator: gt /  >

- less than - operator: lt / <

Now check out the  https://www.wireshark.org/docs/wsug_html_chunked/ChWorkBuildDisplayFilterSection.html Wireshark Filtering Documentation can be a great starting point.

Basic Filtering

For reference feel free to check out the  https://wiki.wireshark.org/DisplayFilters Wireshark filtering documentation. Without any meaningless explanations, let’s quickly have a glance on the filters that we can apply on wireshark to get things done.

- IP address filtering

```
`ip.addr == <IP Address>`
```

- Filtering source and destination address

```
`ip.src == <SRC IP Address> and ip.dst == <DST IP Address>`
```

- Filter to filter packets by port number and protocol names.[tcp]

```
`tcp.port eq <Port #> or <Protocol Name>`
```

- Doing the same operation but for UDP packets.

```
`udp.port eq <Port #> or <Protocol Name>`
```

This task does not need answering any questions, just read make note of things and move ahead to next task.

# Task-6 Packet Dissection

This task does not need any answers, all it does talk about is OSI Model and then how to view each packet, and to gather information on clicking on each packets.

# Task-7 ARP traffic

Tryhackme covers this topic in elementary level someone willing to go deep down the rabbit holes it’s suggested to refer the following websites to learn about arp.

 https://study-ccna.com/arp/ https://study-ccna.com/arp/

 https://www.geeksforgeeks.org/how-address-resolution-protocol-arp-works/ https://www.geeksforgeeks.org/how-address-resolution-protocol-arp-works/

 https://en.wikipedia.org/wiki/Address_Resolution_Protocol https://en.wikipedia.org/wiki/Address_Resolution_Protocol

To solve the challenges, just go the packet number asked in the question, click on the packet, below you will see a window pop-up which will contains all answers for the questions. If you right click on the value from the table below, you will see an option to copy the value which would be super useful in answering the questions instead of manually typing out.Download the task file and open it up using the following command.

```
`wireshark nb6-startup.pcap`
```

- What is the Opcode for Packet 6?

```
`request (1)`
```

[image]

- What is the source MAC Address of Packet 19?

```
`80:fb:06:f0:45:d7`
```

[image]

- What 4 packets are Reply packets?

```
`arp.opcode==2`
```

If the opcode for arp request is one then for the reply it must be two, just a wild guess but it turns out to be true and here we get our answers.

[image]

While answering, don’t add any extra space as it will produce errors.

```
`76,400,459,520`
```

- What IP Address is at 80:fb:06:f0:45:d7?

```
`10.251.23.1`
```

[image]

# Task- 8 ICMP Traffic

Utilities like ping or traceroute use ICMP packets for their working, and it’s recommended to read the  https://tools.ietf.org/html/rfc792 IETF documentation for now just to know that there are two protocol within icmp one is `icmp request` and the another one is `icmp reply`. Download the task file and open it up using the following command.

```
`wireshark dns+icmp.pcapng`
```

Questions

- What is the type for packet 4?

```
`8`
```

[image]

- What is the type for packet 5?

```
`0`
```

[image]

- What is the timestamp for packet 12, only including month day and year?

```
``
```

[image]

But do note that Wireshark bases it’s time off of your devices time zone, if your answer is wrong try one day more or less. So let’s subtract one day and we get our answer.

```
`May 30, 2013`
```

- What is the full data string for packet 18?

```
`08090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f202122232425262728292a2b2c2d2e2f3031323334353637`
```

[image]

# Task -9 TCP traffic

In this task ‘TCP Overview’ and ‘TCP Packet Analysis’ which dives on checking ’sequence number’and ‘acknowledge number’ which you can also edit by navigating to `edit > preferences > protocols > TCP > relative sequence numbers (uncheck boxes)`

This task does not need to answer any questions and let’s move ahead.

# Task- 10 DNS Traffic

Tryhackme recommends to read the  https://www.ietf.org/rfc/rfc1035.txt IETF DNS Documentation to learn about DNS protocols. The two most important things to notice are `dns query` and `dns response`.

Let’s check at the questions. Note that the same pcapng we used on task 8 will be used here. Download the task file and open it up using the following command.

```
`wireshark dns+icmp.pcapng`
```

- What is being queried in packet 1?

```
`8.8.8.8.in-addr.arpa`
```

[image]

- What site is being queried in packet 26?

```
`www.wireshark.org`
```

[image]

- What is the Transaction ID for packet 26?

```
`0x2c58`
```

[image]

# Task -11 HTTP traffic

Again we all must have heard about `http` protocol at some point and we all know it’s `hyper text transfer protocol` used in web technologies which popularly uses `get` and `post` method to function. For the technical geeks out there feel free to check out the official paper by the  https://www.ietf.org/rfc/rfc2616.txt IETF on HTTP methods, and the rest download the task file and open it using wireshark using the below command.

```
`wireshark http.cap`
```

- What percent of packets originate from Domain Name System?

For this go to `statistics > protocol hierarchy` options and you should be able to see this pop-up which has the answer.

```
`4.7`
```

[image]

- What endpoint ends in .237?

```
`145.254.160.237`
```

Apply the http filter and the last ip address of the last packet will be our answer.

[image]

- What is the user-agent listed in packet 4?

```
`Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.6) Gecko/20040113`
```

[image]

- Looking at the data stream what is the full request URI from packet 18?

```
`http://pagead2.googlesyndication.com/pagead/ads?client=ca-pub-2309191948673629&random=1084443430285&lmt=1082467020&format=468x60_as&output=html&url=http%3A%2F%2Fwww.ethereal.com%2Fdownload.html&color_bg=FFFFFF&color_text=333333&color_link=000000&color_url=666633&color_border=666633`
```

[image]

- What domain name was requested from packet 38?

```
`www.ethereal.com`
```

- Looking at the data stream what is the full request URI from packet 38?

```
`http://www.ethereal.com/download.html`
```

[image]

# Task -12 HTTPS Traffic

This one is similar to the http traffic but since it’s encrypted with tls or transport security layer, we need to import the rsa key that comes with the task files. Extract the zip file and import the rsa key into the wireshark while analyzing the packet. For now the first step would be to extract the file and running wireshark with the https pcap file on the very same directory. Take a look at the files present in this task after extracting the zip files.

[image]

```
`wireshark rsasnakeoil2.cap`
```

To add the rsakey, we need to go to `edit > preferences > protocols > tls` and add the following data. Once you have done the following settings a quick way to check that you have done everything right is that the packets color will change.

```
`IP Address: 127.0.0.1

Port: start_tls

Protocol: http

Keyfile: RSA key location`
```

[image]

- Looking at the data stream what is the full request URI for packet 31?

```
`https://localhost/icons/apache_pb.png`
```

[image]

- Looking at the data stream what is the full request URI for packet 50?

```
`https://localhost/icons/back.gif`
```

- What is the User-Agent listed in packet 50?

```
`Mozilla/5.0 (X11; U; Linux i686; fr; rv:1.8.0.2) Gecko/20060308 Firefox/1.5.0.2`
```

[image]

# Task -13 Analyzing Exploit PCAPs

In this task we are not expected to answer any questions, simply looking and at the pcap files, noting down the how the packets are arranged, which information such as ip address of an attacker are given and checking at smb traffic to analyze and check where and how secretsdump traffic is present in this network packet. Since this is a subscriber only room task files can’t be shared but you can look online and find some pcap files of this exploit one such example is here in github.

 https://github.com/corelight/zerologon/blob/master/testing/Traces/CVE-2020-1472_exploit_win2019.pcap https://github.com/corelight/zerologon/blob/master/testing/Traces/CVE-2020-1472_exploit_win2019.pcap

# Task -14 Conclusion

With his we complete wireshark room, tryhackme recommends to refer documentation for further learning and to check their  https://wiki.wireshark.org/SampleCaptures Wireshark Sample Captures. or to check   https://dfirmadness.com/case-001-pcap-analysis/ Case: 001 PCAP Analysis for real world threat hunting challenge. But if you want to try your analysis skills do check similar rooms to this ones like  https://tryhackme.com/room/overpass2hacked Overpass 2 - Hacked.
