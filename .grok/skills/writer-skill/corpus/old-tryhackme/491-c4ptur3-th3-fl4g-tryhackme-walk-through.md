---
id: 491
title: "c4ptur3-th3-fl4g | TryHackMe Walk-Through"
created: 2023-06-17T17:20:29+00:00
url: https://hacklido.com/blog/491-c4ptur3-th3-fl4g-tryhackme-walk-through
words: 1450
---

# c4ptur3-th3-fl4g | TryHackMe Walk-Through

[image]

Hello everyone, this time we will be seeing on some approaches to solve a beginner oriented CTF from tryhackme.

 https://tryhackme.com/room/c4ptur3th3fl4g Room link here.. Note that there could a lot of other way s but I found these to be useful, quick, fast and easy.

# Task 1 Translation & Shifting

1. c4n y0u c4p7u23 7h3 f149?

This is very easy, you can guess the words from the first glance, but if you are looking for some technical information on this, this type of writing is called '‘leet’' and it is quite popular among 1337 hackers online. You can either guess your way or try some leet converter online such as this one. [ http://www.robertecker.com/hp/research/leet-converter.php http://www.robertecker.com/hp/research/leet-converter.php]

```
`can you capture the flag`
```

2. 01101100 01100101 01110100 01110011 00100000 01110100 01110010 01111001 00100000 01110011 01101111 01101101 01100101 00100000 01100010 01101001 01101110 01100001 01110010 01111001 00100000 01101111 01110101 01110100 00100001

Clearly this is a binary code, and to decode this one you can use cyber chef, select from binary option paste the code and bake your recipe.  https://gchq.github.io/CyberChef/#recipe=From_Binary%28%27Space%27,8%29&input=CgowMTEwMTEwMCAwMTEwMDEwMSAwMTExMDEwMCAwMTExMDAxMSAwMDEwMDAwMCAwMTExMDEwMCAwMTExMDAxMCAwMTExMTAwMSAwMDEwMDAwMCAwMTExMDAxMSAwMTEwMTExMSAwMTEwMTEwMSAwMTEwMDEwMSAwMDEwMDAwMCAwMTEwMDAxMCAwMTEwMTAwMSAwMTEwMTExMCAwMTEwMDAwMSAwMTExMDAxMCAwMTExMTAwMSAwMDEwMDAwMCAwMTEwMTExMSAwMTExMDEwMSAwMTExMDEwMCAwMDEwMDAwMQo CHECK ON THIS LINK TO CHECK HOW IT’S DONE or bake on your own.

**3. MJQXGZJTGIQGS4ZAON2XAZLSEBRW63LNN5XCA2LOEBBVIRRHOM====== **

After looking for a while, the ====== looks somewhat similar to base64, but instead of two equal to symbols there are six. This encoding is '‘base32’'. Again you can use cyber chef to solve this one. https://gchq.github.io/CyberChef/#recipe=From_Base32%28%27A-Z2-7%3D%27,true%29&input=CgoKCk1KUVhHWkpUR0lRR1M0WkFPTjJYQVpMU0VCUlc2M0xOTjVYQ0EyTE9FQkJWSVJSSE9NPT09PT09Cg0 Answer for the challenge is embedded here

4. RWFjaCBCYXNlNjQgZGlnaXQgcmVwcmVzZW50cyBleGFjdGx5IDYgYml0cyBvZiBkYXRhLg==

For sure this looks like base64, but the problem is I did not get the proper decoded text from cyber chef.  https://www.base64decode.org/ So feel free to try a similar website, but this is exclusively for decoding base 64 encoding.

```
`Each Base64 digit represents exactly 6 bits of data.`
```

5. 68 65 78 61 64 65 63 69 6d 61 6c 20 6f 72 20 62 61 73 65 31 36 3f

If you look closely, there are numbers followed by some specific alphabets such as d, c, and f. Remember that hexadecimal has 16 characters, and after 0-9, we go through a, b, c, d, e, and f which equals to 10, 11, 12, 13, 14, and 15 respectively. So let’s try if our guess is right…

 https://gchq.github.io/CyberChef/#recipe=From_Hex%28%27Auto%27%29&input=Cgo2OCA2NSA3OCA2MSA2NCA2NSA2MyA2OSA2ZCA2MSA2YyAyMCA2ZiA3MiAyMCA2MiA2MSA3MyA2NSAzMSAzNiAzZg Seems like our guess is correct, click on this link to view the solution.

6. Ebgngr zr 13 cynprf!

First thing that pops in our head is if the given encoding is a Caesar Cipher, because the given encoding is in form of alphabets, and if we shift the value to a particular number we will get the correct text. But wait, there is 13 in this question, so are they implying something else, well turns out ROT13 rotates the cipher by 13 numeric forward. So let’s try that out.

 https://gchq.github.io/CyberChef/#recipe=ROT13%28true,true,false,13%29&input=CgogRWJnbmdyIHpyIDEzIGN5bnByZiE Note that you should also rotate the capital letter to get the answer, click on this line to view the answer.

7. *@F DA:? >6 C:89E C@F?5 323J C:89E C@F?5 Wcf E:>6DX

This one was tricky for me, it’s a mix of all characters and the alphabets are in capital letters. So I googled, cipher analyzer, which resulted in the two websites.[Spoiler this is a rot47 cipher]

a.  https://www.dcode.fr/cipher-identifier https://www.dcode.fr/cipher-identifier

ode.fr/cipher-identifier

[image]

b.  https://www.boxentriq.com/code-breaking/cipher-identifier https://www.boxentriq.com/code-breaking/cipher-identifier

The second website returned that the cipher is of unknown coding so we are only left with option A.

The website does not look clean enough, but nonetheless it gave us the answer we are looking for.

[image]

8. - . .-.. . -.-. — – – ..- -. .. -.-. .- - .. — -.

. -. -.-. — -.. .. -. –.

This might look intimidating at first glance, but it’s a combination of dash and dots. For someone familiar with world-war documentaries, this would be familiar of, and I am sure that most of you have heard this one, this is ‘morse code’.  https://morsedecoder.com/ There are a lot of decrypters online but I tried this one.

```
`TELECOMMUNICATION
ENCODING`
```

9. 85 110 112 97 99 107 32 116 104 105 115 32 66 67 68

At first glance, I thought what are these random numbers, but notice that these are normal numbers that we use on a daily basis. So instead of thinking much, I would have saved a lot of time if I was not over-thinking too much. Most of you might have already guessed it, it’s none other than decimal.  https://gchq.github.io/CyberChef/#recipe=From_Decimal%28%27Space%27,false%29&input=ODUgMTEwIDExMiA5NyA5OSAxMDcgMzIgMTE2IDEwNCAxMDUgMTE1IDMyIDY2IDY3IDY4Cg So we go back to cyber-chef and decode decimal to get the answer which is embedded in this url.

10. LS0tLS0gLi0tLS0gLi0tLS0gLS0tLS0gLS0tLS0gLi0tLS0gLi0tLS0gLS0tLS0KLS0tLS0gLi0tLS0gLi0tLS0gLS0tLS0gLS0tLS0gLi0tLS0gLS0tLS0gLi0tLS0KLS0tLS0gLS0tLS0gLi0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0KLS0tLS0gLi0tLS0gLi0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0KLS0tLS0gLi0tLS0gLS0tLS0gLi0tLS0gLi0tLS0gLi0tLS0gLi0tLS0gLi0tLS0KLS0tLS0gLi0tLS0gLi0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0KLS0tLS0gLS0tLS0gLi0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0KLS0tLS0gLi0tLS0gLi0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0KLS0tLS0gLi0tLS0gLi0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0KLS0tLS0gLi0tLS0gLi0tLS0gLS0tLS0gLS0tLS0gLi0tLS0gLS0tLS0gLi0tLS0KLS0tLS0gLS0tLS0gLi0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0KLS0tLS0gLi0tLS0gLi0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLi0tLS0gLS0tLS0KLS0tLS0gLi0tLS0gLi0tLS0gLS0tLS0gLi0tLS0gLS0tLS0gLS0tLS0gLS0tLS0KLS0tLS0gLS0tLS0gLi0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0KLS0tLS0gLi0tLS0gLi0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0KLS0tLS0gLi0tLS0gLi0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0KLS0tLS0gLi0tLS0gLi0tLS0gLS0tLS0gLS0tLS0gLi0tLS0gLS0tLS0gLS0tLS0KLS0tLS0gLS0tLS0gLi0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0KLS0tLS0gLi0tLS0gLi0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLi0tLS0gLS0tLS0KLS0tLS0gLi0tLS0gLi0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLi0tLS0KLS0tLS0gLS0tLS0gLi0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0KLS0tLS0gLi0tLS0gLi0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0KLS0tLS0gLi0tLS0gLS0tLS0gLi0tLS0gLi0tLS0gLi0tLS0gLi0tLS0gLi0tLS0KLS0tLS0gLi0tLS0gLi0tLS0gLS0tLS0gLi0tLS0gLS0tLS0gLS0tLS0gLS0tLS0KLS0tLS0gLS0tLS0gLi0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0KLS0tLS0gLi0tLS0gLi0tLS0gLS0tLS0gLi0tLS0gLS0tLS0gLS0tLS0gLS0tLS0KLS0tLS0gLi0tLS0gLi0tLS0gLS0tLS0gLS0tLS0gLi0tLS0gLi0tLS0gLS0tLS0KLS0tLS0gLS0tLS0gLi0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0KLS0tLS0gLi0tLS0gLi0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0KLS0tLS0gLi0tLS0gLS0tLS0gLi0tLS0gLi0tLS0gLi0tLS0gLi0tLS0gLi0tLS0KLS0tLS0gLi0tLS0gLi0tLS0gLS0tLS0gLS0tLS0gLi0tLS0gLi0tLS0gLS0tLS0KLS0tLS0gLS0tLS0gLi0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0KLS0tLS0gLi0tLS0gLi0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0KLS0tLS0gLi0tLS0gLS0tLS0gLi0tLS0gLi0tLS0gLi0tLS0gLi0tLS0gLi0tLS0KLS0tLS0gLi0tLS0gLi0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0KLS0tLS0gLS0tLS0gLi0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0KLS0tLS0gLi0tLS0gLi0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLi0tLS0gLS0tLS0KLS0tLS0gLi0tLS0gLi0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLi0tLS0KLS0tLS0gLS0tLS0gLi0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0KLS0tLS0gLi0tLS0gLi0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0KLS0tLS0gLi0tLS0gLi0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0KLS0tLS0gLi0tLS0gLi0tLS0gLS0tLS0gLS0tLS0gLi0tLS0gLS0tLS0gLi0tLS0KLS0tLS0gLS0tLS0gLi0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0KLS0tLS0gLi0tLS0gLi0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0KLS0tLS0gLi0tLS0gLS0tLS0gLi0tLS0gLi0tLS0gLi0tLS0gLi0tLS0gLi0tLS0KLS0tLS0gLi0tLS0gLi0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLi0tLS0gLi0tLS0KLS0tLS0gLS0tLS0gLi0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0KLS0tLS0gLi0tLS0gLi0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0KLS0tLS0gLi0tLS0gLS0tLS0gLi0tLS0gLi0tLS0gLi0tLS0gLi0tLS0gLi0tLS0KLS0tLS0gLi0tLS0gLi0tLS0gLS0tLS0gLS0tLS0gLi0tLS0gLS0tLS0gLS0tLS0KLS0tLS0gLS0tLS0gLi0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0KLS0tLS0gLi0tLS0gLi0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0KLS0tLS0gLi0tLS0gLi0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0KLS0tLS0gLi0tLS0gLi0tLS0gLS0tLS0gLS0tLS0gLi0tLS0gLS0tLS0gLS0tLS0KLS0tLS0gLS0tLS0gLi0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0KLS0tLS0gLi0tLS0gLi0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLi0tLS0gLS0tLS0KLS0tLS0gLi0tLS0gLi0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLi0tLS0KLS0tLS0gLS0tLS0gLi0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0KLS0tLS0gLi0tLS0gLi0tLS0gLS0tLS0gLi0tLS0gLS0tLS0gLS0tLS0gLS0tLS0KLS0tLS0gLi0tLS0gLi0tLS0gLS0tLS0gLS0tLS0gLi0tLS0gLi0tLS0gLS0tLS0KLS0tLS0gLS0tLS0gLi0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0KLS0tLS0gLi0tLS0gLi0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLi0tLS0gLS0tLS0KLS0tLS0gLi0tLS0gLi0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLi0tLS0KLS0tLS0gLS0tLS0gLi0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0KLS0tLS0gLi0tLS0gLi0tLS0gLS0tLS0gLi0tLS0gLS0tLS0gLS0tLS0gLS0tLS0KLS0tLS0gLi0tLS0gLi0tLS0gLS0tLS0gLS0tLS0gLi0tLS0gLi0tLS0gLi0tLS0KLS0tLS0gLS0tLS0gLi0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0KLS0tLS0gLi0tLS0gLi0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0KLS0tLS0gLi0tLS0gLS0tLS0gLi0tLS0gLi0tLS0gLi0tLS0gLi0tLS0gLi0tLS0KLS0tLS0gLi0tLS0gLi0tLS0gLS0tLS0gLS0tLS0gLi0tLS0gLS0tLS0gLS0tLS0KLS0tLS0gLS0tLS0gLi0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0KLS0tLS0gLi0tLS0gLi0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0KLS0tLS0gLi0tLS0gLi0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0KLS0tLS0gLi0tLS0gLi0tLS0gLS0tLS0gLS0tLS0gLi0tLS0gLS0tLS0gLi0tLS0KLS0tLS0gLS0tLS0gLi0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0KLS0tLS0gLi0tLS0gLi0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLi0tLS0gLS0tLS0KLS0tLS0gLi0tLS0gLi0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLi0tLS0KLS0tLS0gLS0tLS0gLi0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0KLS0tLS0gLi0tLS0gLi0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0KLS0tLS0gLi0tLS0gLi0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0KLS0tLS0gLi0tLS0gLi0tLS0gLS0tLS0gLS0tLS0gLi0tLS0gLS0tLS0gLi0tLS0KLS0tLS0gLS0tLS0gLi0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0KLS0tLS0gLi0tLS0gLi0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0KLS0tLS0gLi0tLS0gLi0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0KLS0tLS0gLi0tLS0gLi0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLi0tLS0gLi0tLS0KLS0tLS0gLS0tLS0gLi0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0KLS0tLS0gLi0tLS0gLi0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0KLS0tLS0gLi0tLS0gLS0tLS0gLi0tLS0gLi0tLS0gLi0tLS0gLi0tLS0gLi0tLS0KLS0tLS0gLi0tLS0gLi0tLS0gLS0tLS0gLS0tLS0gLi0tLS0gLS0tLS0gLS0tLS0KLS0tLS0gLS0tLS0gLi0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0KLS0tLS0gLi0tLS0gLi0tLS0gLS0tLS0gLi0tLS0gLS0tLS0gLS0tLS0gLS0tLS0KLS0tLS0gLi0tLS0gLi0tLS0gLS0tLS0gLi0tLS0gLS0tLS0gLS0tLS0gLS0tLS0KLS0tLS0gLS0tLS0gLi0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0KLS0tLS0gLi0tLS0gLi0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0KLS0tLS0gLi0tLS0gLS0tLS0gLi0tLS0gLi0tLS0gLi0tLS0gLi0tLS0gLi0tLS0KLS0tLS0gLi0tLS0gLi0tLS0gLS0tLS0gLS0tLS0gLi0tLS0gLi0tLS0gLS0tLS0KLS0tLS0gLS0tLS0gLi0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0KLS0tLS0gLi0tLS0gLi0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0KLS0tLS0gLi0tLS0gLS0tLS0gLi0tLS0gLi0tLS0gLi0tLS0gLi0tLS0gLi0tLS0KLS0tLS0gLi0tLS0gLi0tLS0gLS0tLS0gLS0tLS0gLi0tLS0gLS0tLS0gLS0tLS0KLS0tLS0gLS0tLS0gLi0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0KLS0tLS0gLi0tLS0gLi0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0KLS0tLS0gLi0tLS0gLS0tLS0gLi0tLS0gLi0tLS0gLi0tLS0gLi0tLS0gLi0tLS0KLS0tLS0gLi0tLS0gLi0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0KLS0tLS0gLS0tLS0gLi0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0KLS0tLS0gLi0tLS0gLi0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0KLS0tLS0gLi0tLS0gLi0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0KLS0tLS0gLi0tLS0gLi0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLi0tLS0gLi0tLS0KLS0tLS0gLS0tLS0gLi0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0KLS0tLS0gLi0tLS0gLi0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLi0tLS0gLi0tLS0KLS0tLS0gLi0tLS0gLi0tLS0gLS0tLS0gLS0tLS0gLi0tLS0gLS0tLS0gLi0tLS0KLS0tLS0gLS0tLS0gLi0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0KLS0tLS0gLi0tLS0gLi0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLi0tLS0gLi0tLS0KLS0tLS0gLi0tLS0gLi0tLS0gLS0tLS0gLS0tLS0gLi0tLS0gLS0tLS0gLi0tLS0KLS0tLS0gLS0tLS0gLi0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLS0tLS0KLS0tLS0gLi0tLS0gLi0tLS0gLS0tLS0gLS0tLS0gLS0tLS0gLi0tLS0gLi0tLS0KLS0tLS0gLi0tLS0gLi0tLS0gLS0tLS0gLS0tLS0gLi0tLS0gLS0tLS0gLi0tLS0=

This one was trick, one could use already mentioned website to check what type of cipher or encoding it is. Or, one could use magic option on cyber-chef to decide what type of encoding/cipher we are against and it works like a charm, which reveals it’s a base64.

Now, this is were it get’s tricky. One has to decode base64 and gets a morse code. If we decode morse code. Decoding this morse code gives us a values with binary. Decoding binary results with a random string of we get a random string of characters with English alphabets. Trying to decode with Rot47 gives us a decimal value and finally decoding this decimal text we get our answer.

[image]

# Task 2 Spectrograms

We are given an audio file, and somehow we are expected to get the message from this audio file. It might appear as an difficult task, but this one is the easier than the challenges that are in the task1. Clicking on the hint, tryhackme tells us audacity, with a quick google we learn it’s a tool used to deal with sounds and music editors, artists use this tool widely. Quickly we download the appimage, right click on it and give executable permissions or one can trying giving it executable permissions using chmod. Once done start it by double clicking or ./youraudacity filename in the terminal and make sure you are in it’s directory.

At first, opening the secretaudio.wav file we get to see waveform of the sound. Just rightclick on the left most column adjacent to the waveform and select '‘spectogram’' option. One should now be able to see the secret text message.  https://www.youtube.com/watch?v=VZbZa99ocPU If still stuck refer this youtube video to view spectogram of a sound.

[image]

# Task 3 Steganography

Downloading the task file, we see an image file called stegosteg.jpg and clearly we are expected to extract some hidden files with in this image. There is a tool called steghide which exactly does this and let’s try it out.

```
`steghide extract -sf stegosteg.jpg`
```

The following commands extracts any files from the specified file, and the results are displayed in the picture below. We see that the contents are saved to a file name called as ‘steganopayload2248.txt’, and inside this text file we have our answer.

[image]

# Task 4 Security through obscurity

This one is the easiest of all. We are given a file called meme.jpg from which we need to find some juicy information. For this task just getting the strings from the file would be suffice and will give us the answers.

```
`strings meme.jpg`
```

[image]

## Extra mile

For the 1337 leet hacker out there who want to extract hackerchat.png and see contents of the file, you can use binwalk another popular tool used to extract hidden information from files. You can list the contents of the file using this command.

```
`binwalk meme.jpg`
```

And to extract the contents, just simply use the below command.

```
`binwalk -e meme.jpg`
```

The above command extract the contents from the specified file, which in our case is meme.jpg and the contents gets stored in _meme.jpg.extracted.

Now, we can go into this directory, and we see a rar file called as 112A7.rar, use your favorite archive extractor, in my case it’s pea zip to extract the contents and you have successfully extracted the contents from the image file.

[image]
