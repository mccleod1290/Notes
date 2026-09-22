---
id: 1329
title: "Azure Arsenal (Fundamentals Track):  Cloud Basics"
created: 2025-11-30T14:44:14+00:00
url: https://hacklido.com/blog/1329-azure-arsenal-fundamentals-track-cloud-basics
words: 1785
---

# Azure Arsenal (Fundamentals Track):  Cloud Basics

[image]

Before we start this blog, I would like to thank everyone who were with me during  https://hacklido.com/lists/8 Complete Web App Pentesting Series, and now we will be starting an new series for cloud (Azure) and it will be called as `Azure Arsenal: Security Engineering from Zero to Hero`. Do note that this series got two tracks, track one (T1) consisting of 11 blogs, each covering concepts of `az-900` (azure fundamentals) and track 2 (T2) would be for azure security (`az-500`).

## Introduction: Your Azure Security Journey Starts Here

Therefore, you are a developer, an IT professional, or a security enthusiast, who is going to plunge into Azure (depending on your interests or career goals). You have read the adverts: scaling, cost-effectiveness, and internationality. However, unless you are one of those unconcerned with security, there is only one irking thought that ranks above the excitement, which is: **How do I secure this?

The reality, however, is, most of the Azure security breaches do not originate in the advanced nation-state zero-day attack. Their occurrence is based on a fundamental misconception of one crucial concept. It is the foundation on which cloud security is based. It is not a firewall or an encryption tool, rather it is a model.

Having finished a course on full web app testing (30 blogs) (hacklido.com/lists/8), I have come to the idea that security is not about knowing the terms- it is about knowing attack vectors and how to develop defense strategies. Therefore, starting my path of becoming an Azure Security Engineer (AZ-500), I am coming with you with another mindset: security-first thinking the day one.

Before we learn security aspect of `Azure`. One has to be familiar with basic terms, and it is often recommended to complete a course like `az-900`. There is no strict requirement to complete and pass the `az-900` exam unless you have an compelling reason, if your organization requires you to be good in azure or you if you have interest in azure and you could afford to take the exam, what ever be your reason to take exam, here is one tip that saved my time.

```
`There is no reward for long study hours especially for an fundamentals exam.`
```

 https://www.youtube.com/watch?v=hEyA6Rsmotk&pp=ygUgaG93IHRvIHBhc3MgYXogOTAwIG9uIGEgd2Vla2VuZWQ%3D This video on youtube explains how one could pass the exam on a weekend, and surely it is possible. I took exam before latest exam revision that is on OCT 30, 2025 and passed the exam. All I did was  https://www.youtube.com/watch?v=8n-kWJetQRk&t=21s watch this video twice, took notes once revised multiple times before exam, and took practice test from the same video. Additionally  https://www.udemy.com/course/azure-certification-az-900-azure-fundamentals/ you could take this course from udemy and take additional practice exams from udemy, but I personally did not.

For someone who wises just to learn fundamentals and not take exam, it’s highly recommended   https://www.youtube.com/watch?v=8n-kWJetQRk&t=21s watch this video , understand and take notes if possible, before jumping to courses like `AZ-500` (Azure Security Engineer). Here are some additional supplementary study resources to absorb the content outlined in this blog.

#### Additional study resources

In order to completely digest and internalize the knowledge outline in our first part of this blog, it is highly recommended to watch additional videos and read the additional resources, pause, study, take notes and re-study as many times as possible to understand concepts.

-  https://www.youtube.com/watch?v=gIhf-S7BCdo&list=PLGjZwEtPN7j-Q59JYso3L4_yoCjj2syrM&index=1 First six videos from `Adam Marczak`

-  https://youtu.be/8n-kWJetQRk?si=Wj5X9ZjDYY35abWx Watch the study cram upto 21:40 time stamp

Now if possible do consider reading microsoft learn documentation for these topics which are:

-  https://learn.microsoft.com/en-gb/training/modules/describe-cloud-compute/ Cloud Computing

Now some concepts are easy to understand in single read and others are not. And re reading a single concept again and again does not mean you are less smarter, but rather it helps you to create new neural path ways in your brain and the additional effort you put into learning would re-enforce the newly studied material to your brain.

## Introduction to cloud & azure

#### 1.1 Describe Cloud Computing

###### Introduction to Cloud Computing

Consider cloud computing as the option of renting a complete furnished apartment rather than creating your own house. According to Microsoft, it is easy to define: *the provision of computing services on the Internet. The industry standard (NIST) is a bit more technical, but the basic premise is the same, that is, you can have on-demand access to servers, storage, apps, and services without constructing your own data center.

In the definition provided by NIST, cloud computing is defined as a model that allows a convenient and on-demand network access to a common pool of configurable computing resources (networks, servers, storage, applications, services) that can be provisioned quickly with little provider interaction. Microsoft makes it easy: provision of computing services via the internet.

When combined, cloud computing implies scalable, fast, and flexible computing, without owning any hardware. Businesses are able to expand their presence at a very fast rate, decrease risk and leave upgrades, maintenance and security to the cloud provider.

###### Shared Responsibility Model

Let us quickly start of visually imagining the above term in our heads so that we get an better understanding of the term `shared responsilibity model`. In simple terms both `cloud service prodiver (CSP)` and `user` have some responsibility to configure and operate the systems. How much of it relies on whom is the sole discussion of this term.

On-premises: You do EVERYTHING and you are responsible for EVERYTHING . Below we see an self explanatory diagram that explains `Iaas`, `Paas` and `SaaS`.

[image]

```
`Security is usually enhanced by cloud since the loads are distributed to a provider who is better equipped to ensure the security issue is not so burdensome and risky. `
```

Mnemonic to remember this concept easily:

- ME vs. AZURE.

Remember this flow: **On-prem → IaaS → PaaS → SaaS,

Mnemonic: M.E A.Z.U.R.E (My Effort goes down, A.Z.U.R.E goes up).

###### Cloud Models

Azure supports three main cloud models (Public Cloud, Private Cloud and Hybrid Cloud) and this could be understood better visually through the following infographic.

[image]

Mnemonic for easily remembering the concept — “Pu-Pr-Hy = Speed, Control, Both”

- Public → SPEED

- Private → CONTROL

- Hybrid → BOTH

###### Cloud Billing

Cloud pricing is mostly a consumption-based scheme: you only pay for what you use:

 - VMs - per unit of time

 - Storage - per GB

 - Functions - per execution

You need have no fear that we will discuss the stuff discussed here in further posts of our blog. Please bear in mind that cloud pricing is based on two philosophies:

- CapEx (Capital Expenditure) = Paying for initial investment (setup cost, server deployment cost etc)

- Cloud model is OpEx ( Operational Expenditure) = Pay-as-you-go, which means you only pay for things you use (only for things that are running or operational)

Remember that during the shift to the cloud, the operational spending generally raises whereas the capital spending declines or vanishes altogether. Cloud model reduces the capital investment that one needs in infrastructure and replaces it with the operational costs that are incurred over time depending on the utilization.

There are however fixed-price models of cloud resources. These are reserve capacity at a fixed cost irrespective of utilization and this gives foreseeable monthly expenditures. This method is best suited in cases where the budgetary certainty is more and less important than usability flexibility.

Azure is also capable of serverless computing models in which the code is executed on-demand at the response of triggers. These are event based, stateless and transient architectures. These are Azure Functions, Logic Apps, and Event grid all charged per use and are designed to automatically scale with the demand. This serverless model is the ultimate consumption-driven pricing, in which you only pay at the time your code is run.

Mnemonic:

PAYGO = Pay-As-You-Go

- Per second/minute

- Auto-scale

- You only pay for what runs

- Great for budgets

- Opex-focused

###### Serverless Architecture

Serverless does not imply no servers, it just means that you do not want to manage servers anymore. Microsoft does all the stuff as you concentrate on code. In other words Azure serverless architecture is ==a cloud-based development model where developers build and run applications without having to provision or manage underlying infrastructure==.

We could better understand the serverless Architecture using the magic Keywords: SET. Which stands for :

- Stateless

- Ephemeral (short-lived)

- Triggered

Now, having made the connection between the dots, comparing the words Paas and Serverless, do not sound very different, however, they have some differences, which are illustrated neatly in the following diagram:

[image]

- PaaS: More exertion, manual autoscale beginning, decreased initiation.

- Serverless: Autoscale, On-Method Scaling, Control-Less (but who cares when it is automatic?).

Azure currently has three serverless services that include:

- Azure Functions = An serverless compute service that executes code when it is triggered by events (which maybe from azure of on-premise systems).

- Azure Logic Apps : This is used for `automating` and `orchestrating tasks`, `business processes` and `workflows`. Usually minimal coding required.

- Event Grid = Azure Event Grid is a fully managed event routing service that enables you to easily manage events across many different Azure services and applications using a publish-subscribe (pub-sub) model .No polling, highly efficient. Billed per event delivered.

[image]

Common Serverless Principles are:

- No server management

- Pay-per-use pricing

- Automatic scaling

- Stateless and ephemeral

Mnemonic: “FLE” for Serverless

F = Functions → Fired by triggers (event-driven code execution)

L = Logic Apps → Link services with connectors (workflow orchestration)

E = Event Grid → Events pushed (pub-sub routing)

## Conclusion

With this we come to an halt, and it is highly recommended to re-read blog, explore and read and study the `additional study resources` and take notes. For some this might be very simple straight forward blog, and for others you might find something new which you may not have heard of before. Do make a strong note that security in cloud starts with understanding how cloud works and rushing in would not work in the long run. We are just getting started and the best parts of this series are ahead. Until next time, stay curious and keep learning !!

This is part of the “Azure Arsenal: Security Engineering from Zero to Hero” series. Follow along as I document my journey from Azure fundamentals to security engineer certification.
