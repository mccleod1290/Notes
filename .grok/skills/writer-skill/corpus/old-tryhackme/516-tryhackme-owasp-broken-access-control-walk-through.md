---
id: 516
title: "TryHackMe OWASP Broken Access Control - Walk-through"
created: 2023-07-01T17:34:49+00:00
url: https://hacklido.com/blog/516-tryhackme-owasp-broken-access-control-walk-through
words: 1823
---

# TryHackMe OWASP Broken Access Control - Walk-through

[image]

This time on tryhackme, we will be looking at recent room from tryhackme, and the good news is that this is a free room. We will be exploiting broken access control vulnerability, which is number 1 vulnerability among the top 10 web security risks. We all might have used these kind of vulnerabilities, or IDOR to gain access to senstive information like changing the numbers in the url parameter to see our friend’s mark list, of course more recent school websites are secure but I am sure some of the leet haxors might have changed the number in the ID parameter  on the URL to check their friend’s mark list. This is very simple introduction in this room we will be looking over ways to get things done rather than simply playing with url parameters.

# Task-1 Introduction  - [No answers required]

Broken access controls occurs when an application or system does not properly restrict data or functionality. This allows attacker to access content that should be restricted or only available to selected users such as, account, files, or administrative functions. Tryhackme websites gives an comprehensive list of per-requisites for this room such as knowing, json, http protocols, familiarity with php and javascript, knowledge of frameworks like owasp top 10 and knowledge on how to use tools like burp suite. Personally, in my humble opinion, if you can set up burp suite in your browser and proxy your web traffic via burp suite that is more than enough to get started.

Setting up burp suite…

Make sure that you have installed your burp suite or make sure that you are using an operating system that comes pre-installed with burp such as parrot os or kali. Type in burpsuite in your terminal to start the burp, keep the settings to default and start your application. Then go to `http://burpsuite` or go to `http://127.0.0.18080/` and download the  burp browser certificate.  https://portswigger.net/burp/documentation/desktop/external-browser-config/certificate Refer this url to import this browser certificate to your needs..

With this we are half done. We still need to proxy our traffic via  http://127.0.0.18080/ http://127.0.0.18080/ [burp-suite] so that this tool can monitor all our web traffic, intercept and then modify them.  To do that install foxy-proxy browser extension, set an unique name for this proxy, such as `burp`, set ip-address to `127.0.0.1` and port to `8080`.  https://blog.eldernode.com/use-foxyproxy-and-burp-suite-for-change-proxy/ Refer this url in case you are stuck .

# Task-2 What is Access Control ?

Access control is a security protocol used in to see if users or systems [in a network/website] are authorized or are allowed to access a particular resource such as a system, an account, file, data etc. The main goal of access control is to protect sensitive information and to make sure that only it is accessible to intended users.  Tryhackme explains essential access controls in depth, but for this task let’s look at each of the essential terminologies.

1. Discretionary Access Control (DAC): In this the administrator decides who gets to access a resource and what actions they can perform. Used in operating systems and in file systems.

2.Mandatory Access Control (MAC) Similar to first one, but in this the access to resources are decided by a set of predefined rules / policies that are enforced by an system which could be an government or a company, and these polices are non-negotiable.

- Role-Based Access Control (RBAC) As the name suggest access is based on the roles that user’s are designated to, and this is commonly used in enterprise systems or in big corporate companies.

- Attribute-Based Access Control (ABAC) In this the access is based on certain properties like user role, time of day, location and device. This is commonly used in cloud and web application.

Terminologies related to broken access control

- Horizontal privilege escalation - this occurs when attacker can access resources/data that belongs to other user on same level of access. Example would be an attacker moving from system A to system B having same level of access.

2.Vertical privilege escalation  is the exact opposite of horizontal , attacker gains access to resources/data that is on higher access levels. Example would be an attacker from normal user account gains data and resources to an admin account or system.

- Insufficient access control checks occurs when attacker can access unintended data by exploiting system or application’s access control mechanism. Example would be a situation when attacker gains access to sensitive information without verifying proper permissions.

- Insecure direct object references , which brings back to our starting example, in which an attacker exploits guessable identifiers, exploit or change them in such a way that attacker gets access to sensitive information at same

bypassing poor or insufficient access controls.

Questions

- What is IDOR?

```
`Insecure direct object reference`
```

- What occurs when an attacker can access resources or data belonging to other users with the same level of access?

```
`Horizontal privilege escalation`
```

- What occurs when an attacker can access resources or data from users with higher access levels?

```
`Vertical privilege escalation`
```

- What is ABAC?

```
`Attribute-Based Access Control`
```

- What is RBAC?

```
`Role-Based Access Control`
```

# Task-3 Deploy the Machine  - [No answers required]

Once you have deployed the machine, go around, look around the website, make sure you get any juicy stuff like any hidden directories, or something inside the source code [spoiler alert this room does not have any juicy stuff hidden ], so we see that to view the content we need to create an account so let’s go ahead and do. Note that you can use any username and any password, for this. This task also does not need any answers.

[image]

[image]

# Task-4 Assessing the web application

Now in task 3 we have created an account, this time in this task let’s turn on our intercept as on and let’s see what happens when we login. Use the credentials we have use at the time of registration to complete login process and take a note what happens new while this query is registered.

[image]

As you might have noticed, this query is sent to /functions.php after login, Now in order to know what happens under the hood, in order to know what are the website’s http request and response, you can send it to tools like `repeater` for further processing. Before you forward this packet, make sure that you have sent it to repeater, which you can do by right clicking on the text, and forward to repeater will be visible.

[image]

Now after the previous steps are done, hop to the repeater tab and take a detailed note on what’s happening. We see that upon finishing the login process web application gives an json response which tells us some important information and details like `message`, `first_name`, `last_name`, `is_admin` and `redirect_link`.  Also at the top of the response section, we see important information like the server is `Apache/2.4.38` and is using `Debian` operating system. This web server also runs `PHP/8.0.19` as it’s backend programming language. Take good note of the json response which will be helpful in escalating our privileges in next task.

[image]

Questions

- What is the type of server that is hosting the web application? This can be found in the response of the request in Burp Suite.

```
`apache`
```

- What is the name of the parameter in the JSON response from the login request that contains a redirect link?

```
`redirect_link`
```

- What Burp Suite module allows us to capture requests and responses between ourselves and our target?

```
`proxy`
```

- What is the admin’s email that can be found in the online users’ table?

```
`admin@admin.com`
```

# Task-5 Exploiting the Web Application

From the previous task, the login query at `function.php` , in it’s json response especially at the `redirect_link` parameter you should have noticed that it shows `dashboard.php?isadmin=false`. Since this parameter gets processed in the backend of the server,we don’t get a chance to notice this parameter pop-up while we perform an login operation [at-least that’s what we have to assume since we got hold of this parameter only via intercepting the web-traffic]. What happens, in the url if we place `dashboard.php?isadmin=true`? After using this parameter in the url you should be able to notice this request in your burp suite, as you can see we are able to access admin.php without any password.

[image]

Forward the request and here you go you should be able to access the admin account, without any password and on the landing page we have our flag.

[image]

Questions

- What kind of privilege escalation happened after accessing admin.php?

```
`vertical`
```

- What parameter allows the attacker to access the admin page?

```
`isadmin`
```

- What is the flag in the admin page?

```
`THM{flag-redacted}`
```

# Task 6  Mitigation - [No answers required]

Quickly let’s look at some mitigation methods along with their code snippets.

1. Implement Role-Based Access Control (RBAC). Programmer can use the `hasPermission` to achieve this.

```
`// Define roles and permissions
 $roles = [
     'admin' => ['create', 'read', 'update', 'delete'],
     'editor' => ['create', 'read', 'update'],
     'user' => ['read'],
 ];

 // Check user permissions
 function hasPermission($userRole, $requiredPermission) {
     global $roles;
     return in_array($requiredPermission, $roles[$userRole]);
 }

 // Example usage
 if (hasPermission('admin', 'delete')) {
     // Allow delete operation
 } else {
     // Deny delete operation
 }`
```

2. Use Parameterized Queries: - [self explanatory]

```
`// Example of vulnerable query
 $username = $_POST['username'];
 $password = $_POST['password'];
 $query = "SELECT * FROM users WHERE username='$username' AND password='$password'";

 // Example of secure query using prepared statements
 $username = $_POST['username'];
 $password = $_POST['password'];
 $stmt = $pdo->prepare("SELECT * FROM users WHERE username=? AND password=?");
 $stmt->execute([$username, $password]);
 $user = $stmt->fetch();`
```

3. Proper Session Management: - [self explanatory]

```
`// Start session
 session_start();

 // Set session variables
 $_SESSION['user_id'] = $user_id;
 $_SESSION['last_activity'] = time();

 // Check if session is still valid
 if (isset($_SESSION['last_activity']) && (time() - $_SESSION['last_activity'] > 1800)) {
     // Session has expired
     session_unset();
     session_destroy();
 }`
```

- Use Secure Coding Practices: [self explanatory]

```
`// Validate user input
 $username = filter_input(INPUT_POST, 'username', FILTER_SANITIZE_STRING);
 $password = filter_input(INPUT_POST, 'password', FILTER_SANITIZE_STRING);

 // Avoid insecure functions
 // Example of vulnerable code using md5
 $password = md5($password);
 // Example of secure code using password_hash
 $password = password_hash($password, PASSWORD_DEFAULT);`
```

# Task 7 Conclusion  - [No answers required]

With this we complete the room for the leet haxors who need something more to learn and explore have a look at these resources.

-  https://cheatsheetseries.owasp.org/cheatsheets/PHP_Configuration_Cheat_Sheet.html OWASP PHP Configuration Cheat Sheet

-  https://phptherightway.com/#security PHP The Right Way: Security

-  https://www.php.net/manual/en/security.php Secure Coding in PHP
