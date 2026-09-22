---
id: 825
title: "Web Recon Made Simple: Beginner's Handbook - reNgine, Pagodo, Recon FTW, GooFuzz & More"
created: 2024-05-30T14:22:40+00:00
url: https://hacklido.com/blog/825-web-recon-made-simple-beginners-handbook-rengine-pagodo-recon-ftw-goofuzz-more
words: 1600
---

# Web Recon Made Simple: Beginner's Handbook - reNgine, Pagodo, Recon FTW, GooFuzz & More

[image]

```
`"Give ordinary people the right tools, and they will design and build the extraordinary." - Neil Gershenfeld`
```

Often the infosec mocks and grins upon people who rely on automated tools, even today most people consider manual work to be the best approach, but this case is not true atleast for the reconnaissance process. This blog we will look some automated tools and frameworks, which does our work easy, there is a saying leave the boring automated work for the machines, let them do for us.

Note that this blog will be mostly focused on web application recon and a tool is anything that extends our ability to interact and modify our surrounding environment whereas a framework is a collection of tool. Stay till the end of this blog where you get to witness two powerful recon frameworks.

### 1. BigBountyRecon

##### Installation guide

- For windows user just download the repo, go the repo and install the `.exe` file.

- For linux and mac os users it’s recommended to install wine as it’s outlined in the official website.

- Check ther  https://wiki.winehq.org/ https://wiki.winehq.org/ for installation guide and since i am Ubuntu I will follow the instructions from  https://wiki.winehq.org/Ubuntu https://wiki.winehq.org/Ubuntu

```
`sudo dpkg --add-architecture i386
sudo mkdir -pm755 /etc/apt/keyrings
sudo wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key

sudo wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/ubuntu/dists/jammy/winehq-jammy.sources

###### [Note I use ubuntu 22.04, for you it might be different URL, it's recommended to check with the official documentation]

sudo apt update

sudo apt install --install-recommends winehq-stable`
```

##### Usage

##### Windows user

- Double click the exe from where `BigBountyRecon` is cloned and you are good to go

##### Linux user

- Navigate to the directory where `BigBountRecon`is installed.

- For linux users type in the following command

```
`wine BigBountyRecon.exe`
```

Now all that is left is to start using the GUI application and you are good to go.

Note: At start of gui application you will see an coloum that asks to enter your domain, here you are supposed to enter your example which is www.target.com and for some weird reasons if you hit enter (this issue occured in ubuntu) then the entire text disappears, the key is to just enter your domain and not hit enter !!!

[image]

[image]

The above two images should be self explanatory, this one tool performs up to 52 searches from google dorking for sensitive files, any backups, login pages, subdomains, to censys, shodan and other queries. After using this tool one does not have the need to ever perform manual dorking. Imagine the hassel keeping an archive of all the google dorks and doing one by one, I am not saying that using custom dorks is a bad idea, but why use manual method when there is quick and easier way of doing things?

Now you do see the disadvantage here right, this tool only performs few google dorks, but what if I want to do perform dorks that are literally thousands. Well I got you covered there are two tools and they are

- Pagodo [Passive Google Dork]

- goofuzz

### 2.Pagado

##### Installation guide

```
`git clone https://github.com/opsdisk/pagodo.git
cd pagodo
python3 -m venv .venv  # If using a virtual environment.
source .venv/bin/activate  # If using a virtual environment.
pip install -r requirements.txt`
```

##### Using pagodo.py as a script

```
`python pagodo.py -d example.com -g dorks.txt `
```

Now for `wordlists` there are a lot of lot of ways but I personally found a repo  https://github.com/Ishanoshada/GDorks https://github.com/Ishanoshada/GDorks, but this has a lot of directories and text files, so I personally grouped these text files and uploaded into my own github repo which you can check at  https://github.com/mccleod1290/google-dork-wordlists https://github.com/mccleod1290/google-dork-wordlists.

I have cloned this in my home directory, and the command used is-

```
`python pagodo.py -d example.com -g /home/mccleod/google-dork-wordlists/all-dorks-merged.txt`
```

[image]

### 3.Goofuzz

##### Installation guide:

```
`git clone https://github.com/m3n0sd0n4ld/GooFuzz.git
cd GooFuzz
chmod +x GooFuzz
./GooFuzz -h`
```

Now for the goofuzz, it was a bit faster, but soon it the tool says my ip is temporally blocked by google. So I guess it’s better to use pagodo,.py or use `-t` for including time delay feature.

##### Usage:

```
`./GooFuzz -t example.com -w /home/mccleod/google-dork-wordlists/all-dorks-merged.txt -t 5`
```

[image]

Now from google dorks, we will be moving towards the next one, testing for sensitive information, and for this we will use a tool called `trufflehog`.

### 4.Trufflehog.

The easiest way to install trugglehog is to find the latest version from the releases, which you can check from  https://github.com/trufflesecurity/trufflehog/releases here

As of now the latest version is v3.77.0 so we will be using the following command to install.

##### Installation Guide

```
`sudo su
curl -sSfL https://raw.githubusercontent.com/trufflesecurity/trufflehog/main/scripts/install.sh | sh -s -- -b /usr/local/bin  v3.77.0`
```

The simplest command line usage for this tool to test any github repo for sensitive information would be to use the following command.

##### Usage

```
`trufflehog git https://github.com/trufflesecurity/test_keys --only-verified --no-update`
```

[image]

So by now the traditional guys who perform whois, and other looks must be screaming around there claiming this guide is not complete without doing these searches. Well I got you covered there is another framework that does more than just whois and other searches.

### 5.WTFIS

Wtfis is a commandline tool that gathers information about a domain, FQDN or IP address using various OSINT services. To run this tool you might require API key from services like virustotal and others, but this tool works like a charm

##### Installation Guide

```
`pip install wtfis`
```

##### Usage

```
`wtfis google.com`
```

[image]

To add the API key for each service you can use the following command and make use after = symbol you replace it with your API keys.

```
`cat > ~/.env.wtfis <<EOF
VT_API_KEY=
PT_API_KEY=
PT_API_USER=
IP2WHOIS_API_KEY=
SHODAN_API_KEY=
GREYNOISE_API_KEY=
ABUSEIPDB_API_KEY=
WTFIS_DEFAULTS=
EOF`
```

Now a small portion of you guys must be yelling from inside, but I haven’t covered subdomain enumeration and other vulnerability scanning and content discovery tips. Well stay around till the end you will get more than you have expected for.

### 5.Reconftw

This is my number one automated framework, trust me when I say this this tool alone does all types of OSINT from google dorks to github search for sensitive information, email address of employees, ip address and then subdomains. It does not end here you get interesting javascript files, and also it gets any interesting API data which is hard coded into the js files. This tool does not stop here, it performs full fledged nuclei scan and if you opt for attack mode it does automated analysis for various vulnerabilities like xss and sql injection using tools like dalfox, sqlmap and ghauri. You can check all the actions performed from this framework using this  https://github.com/six2dez/reconftw/blob/main/images/mindmap_obsidian.png link and this  https://github.com/six2dez/reconftw?tab=readme-ov-file#fire-features-fire link

##### Installation Guide

```
`git clone https://github.com/six2dez/reconftw
cd reconftw/
./install.sh`
```

###### Usage

###### To perform a full recon on single target

```
`./reconftw.sh -d target.com -r`
```

###### Perform all steps (whole recon + all attacks) a.k.a. YOLO mode

```
`./reconftw.sh -d target.com -a`
```

[image]

### 6.Rengine

If you are an fan of GUI tool and wish to attain results of reconftw then this should be your go to tool. You can read more about this tool features using this  https://github.com/yogeshojha/rengine?tab=readme-ov-file#features link.

##### Installation

Make sure before installing you have installed `docker` and `docker-compose`.

```
`sudo apt-get install docker docker-compose`
```

Now let’s start with the installation of rengine.

```
`git clone https://github.com/yogeshojha/rengine && cd rengine`
```

Edit the dotenv file using `nano .env` or `vi .env` or `vim .env`.

and edit the concurrency value.

Here is the ideal value for MIN_CONCURRENCY and MAX_CONCURRENCY depending on the number of RAM your machine has:

- 4GB: `MAX_CONCURRENCY=10`

- 8GB: `MAX_CONCURRENCY=30`

- 16GB: `MAX_CONCURRENCY=50`

Then finally run the installation script. If `install.sh` does not have install permission, please change it, `chmod +x install.sh`

```
`sudo ./install.sh`
```

[image]

##### Usage

reNgine can now be accessed from  https://127.0.0.1 https://127.0.0.1

First if you visit the above url, you will be prompted to enter your username and password which you have set during installation phase.

[image]

Navigate to the `targets section`

[image]

Click on `add target`.

[image]

Once you have entered the target details, you will see an option to initiate the scan, and then click on the scan option which you wish to do.

[image]

Now to start stop and to restart this docker container in which the tool is running, go to the `rengine` directory and then use the following commands as per your the objective which you want to attain.

Start all containers:

```
`sudo docker-compose up -d`
```

Stop and remove all containers:

```
`sudo docker-compose down`
```

Check the status of all containers:

```
`sudo docker-compose ps`
```
