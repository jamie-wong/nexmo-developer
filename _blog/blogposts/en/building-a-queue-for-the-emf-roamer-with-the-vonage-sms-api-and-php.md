---
title: Building a Queue for the EMF Roamer with the Vonage SMS API and PHP
description: Learn about the EMF Roamer, a quarter-scale wooden Tesla Cybertruck
  controlled by anyone over the internet!
thumbnail: /content/blog/building-a-queue-for-the-emf-roamer-with-the-vonage-sms-api-and-php/building-queue_roamer.png
author: chris-stubbs
published: true
published_at: 2022-10-06T22:27:53.156Z
updated_at: 2022-10-06T22:27:53.233Z
category: community
tags:
  - PHP
  - EMF-camp
comments: true
spotlight: true
redirect: ""
canonical: ""
outdated: false
replacement_url: ""
---
If you haven't heard of [Electromagnetic Field (EMF) Camp](https://www.emfcamp.org/), imagine a field in the quaint English countryside, temporarily populated by 2,500 curious tech/maker enthusiasts; fiber internet, radio masts, robotic bartenders, lasers illuminating the sky, and wild/wacky inventions as far as the eye can see.

One of these wacky inventions was the EMF Roamer, a quarter-scale wooden Tesla Cybertruck, deployed to roam around the side, controlled by anyone over the internet!

![The Roamer, photographed at dusk with RGB underglow lighting.](/content/blog/building-a-queue-for-the-emf-roamer-with-the-vonage-sms-api-and-php/52125273707_4ab982b7a7_c.jpg "The Roamer, photographed at dusk with RGB underglow lighting.")

Image credit [VicHarkness](https://www.flickr.com/photos/vicharkness/52125273707/in/album-72177720299576154/).

Just allowing people to drive it line of sight wasn’t good enough! Especially not in the world of the Internet of Things. Live video from a camera, along with the location on a map is streamed to the user while they have control of the roamer. 

A free for all in terms of control would have been a mess, so we devised a queue system. People could join the queue in their web browser and wait their turn, or provide a mobile phone number to receive an SMS when their turn is up (thanks Vonage!). The queue system is “serverless”, in that it does not require a dedicated server. Instead, it runs on simple shared hosting, with PHP coordinating the queue on-demand, which is stored in a MySQL database.

## What We're Building

This article will describe how to set up the required libraries and database, then create a simple example queue, like that used to drive the EMF Roamer. If users provide a phone number and close the page after joining the queue, they will be sent an SMS using Vonage when it's their turn. The system is written in PHP with a MySQL backend, designed to run on shared hosting. If you don’t have a web host already, you can follow along on your own computer using software such as [WAMP](https://www.wampserver.com/en/).

![Flowchart illustrating the queueing process (Start > Wait until at the front > Control until time is up > Leave](/content/blog/building-a-queue-for-the-emf-roamer-with-the-vonage-sms-api-and-php/diagram.png "Flowchart illustrating the queueing process (Start > Wait until at the front > Control until time is up > Leave")


## Installation

To make full use of the SMS delivery, you'll need a [Vonage Developer account](https://developer.vonage.com/). You can sign up for one today and follow this tutorial using free credit. Find your API Key/Secret at the top of the [Vonage API Dashboard](https://developer.vonage.com/).

You will need to clone the [PHP Web User Queue](https://github.com/chrisstubbs93/WebUserQueue) from GitHub.

You will also need to install the Vonage PHP client library. This can be done using [Composer](https://getcomposer.org/).

```
composer require vonage/client
```

If you're new to Composer, you may find Composer's [Getting Started](https://getcomposer.org/doc/00-intro.md) page useful.

To install the PHP Web User Queue library to your project, copy the PHPWebUserQueue to your server and rename `settings.template.php` to `settings.php`, then edit it:

```php
$selfdrive = TRUE; //Allow user page requests to self drive the worker in order to keep things running faster
$timeout =3*60; //Time in seconds, how long a session lasts
$noshowtimeout = 2*60; //Time in seconds their place at the front of the queue will be held
$sqlserver = "localhost";
$sql_db = "queuetest";
$sql_user = "queuetest";
$sql_pass = "abab";
$vonagekey = "abab";
$vonagesecret = "abab";
$composerpath = __DIR__ . "/../vendor/autoload.php";
$sitepath = "https://your.site";
```

Create a blank database using MySQL server with default settings and associate a user with the below permissions:

![Minimum required MySQL permissions are SELECT, INSERT, UPDATE, DELETE, CREATE, ALTER, INDEX.](/content/blog/building-a-queue-for-the-emf-roamer-with-the-vonage-sms-api-and-php/database-specific.png "Minimum required MySQL permissions are SELECT, INSERT, UPDATE, DELETE, CREATE, ALTER, INDEX.")


Then run the setup script to create the required tables:

```
http://[your site]/PHPWebUserQueue/setup.php
```

If you’re new to MySQL, check your hosting provider’s documentation, or use a tool such as [phpMyAdmin](https://www.phpmyadmin.net/).

It is recommended that you set your server up to periodically run the worker script as a cron job. This keeps things ticking over and text messages being sent, even if all users have closed the page.
If your web host doesn’t support this, don’t worry. The queue is also “self driven” whenever a page is accessed which calls the Web User Queue library. A technique borrowed from “wp-cron”, how WordPress handles tasks. If your site is particularly high-traffic, you may only wish to run server crons and remove the overhead on each page execution. This can be achieved by setting the `$selfdrive` flag `FALSE`.

Ensure the `cronworker.php` script is executable:

```sh
chmod +x PHPWebUserQueue/cronworker.php
```

Example implementation running the worker every minute using crontab:

```sh
*     *     *     *     *         /path/to/site/PHPWebUserQueue/cronworker.php
```

If you’re new to cron, check your hosting provider’s documentation, or use a tool such as [cron-job.org](https://cron-job.org/en/).

## Building an example

We are going to build a simple example queue. You will join the queue and wait your turn on `index.php`, then finally reach `control.php` when it’s your turn. Follow along with the below tutorial from scratch, or access [the complete example in the “Example” folder on GitHub](https://github.com/chrisstubbs93/WebUserQueue/tree/main/Example).

### Joining and Queueing

Create the file `index.php`, include the library file, and create your first queue:

```php
<?php
include '../PHPWebUserQueue/WebUserQueue.php';
$q = new WebUserQueue();
```

Our queue will also allow people to resume their position by following a link from the SMS, so we grab those values now:

```php
if (isset($_GET["i"]) and isset($_GET["s"]))
{
    $_SESSION["i"] = $_GET["i"];
    $_SESSION["s"] = $_GET["s"];
}
```

We check if the user already has a session, or if they’ve submitted the form to join the queue. If not, we show them the form:

```php
if (!isset($_SESSION["i"])){ 
	//User is not already in the queue.
	if(!isset($_POST['name'])){
		//User has not posted the form, so show them the form.
		echo "<form method=\"post\"><input type=\"text\" name=\"name\" placeholder=\"Name\"> (optional)<br />";
		echo "<input type=\"text\" name=\"phone\" placeholder=\"Phone # e.g. 07712345678\"> (optional)<br />";
		echo "We can send you an SMS when it's your turn.<br /><button>Put me in the queue</button></form>";
	}
```

![The form before joining the queue.](/content/blog/building-a-queue-for-the-emf-roamer-with-the-vonage-sms-api-and-php/smsqueue.png "The form before joining the queue.")


If the user has posted the form, we add them to the queue:

```php
	else{
		//user has posted the form, add them to the queue.
		if($q->join($_POST["name"],$_POST["phone"])){
			echo "<head><meta http-equiv=\"refresh\" content=\"2\" ></head>";
            echo "Welcome to the queue, your ID is: " . $_SESSION["i"] . " <br />";
		}
	}
}
```

If the user does have a session and is in the queue, we check their details and let them know how long to wait. If it’s their turn, send them to the control page:

```php
else{//User is in the queue
	if($q->checkValid($_SESSION["i"],$_SESSION["s"])) { //Their session matches the database
		if(isset($_GET["end"])){ //Request to end their session
			if($q->kick($_SESSION["i"],$_SESSION["s"])){
        		echo "Thank you for queueing.<br /><a href='index.php'>Click here to enter the queue again</a>";
    		}
		}
		else{
	        list($queuePos,$waitTime) = $q->checkWait($_SESSION["i"],$_SESSION["s"]);
	        if ($queuePos == 0){ //It's their turn
	            header("Location: control.php");
	        }
	        else{ //They're waiting
	            echo "<head><meta http-equiv=\"refresh\" content=\"5\" ></head>";
	            echo "There are " . $queuePos . " people in front of you. This will take about ". $waitTime . "  seconds.<br />";
	        }
    	}
	} else { //Session is not valid
	    echo "Your session has expired. Please refresh the page to queue again!";
	    unset($_SESSION['i']);
	    unset($_SESSION['s']);
	}
}
?>
```

![Waiting in the queue](/content/blog/building-a-queue-for-the-emf-roamer-with-the-vonage-sms-api-and-php/smsqueue1.png "Waiting in the queue")


### Reaching the front

Create the file `control.php`, include the library file, and a queue:

```php
<?php
include '../PHPWebUserQueue/WebUserQueue.php';
$q = new WebUserQueue();
```

Check the user’s session is valid, and that it is their turn:

```php
//User already has a session. Check it's not already used, all their details are valid, and they are first in the queue.
if (isset($_SESSION["i"]))
{
    if($q->checkFirst($_SESSION["i"],$_SESSION["s"])){

    } else {
        echo "<a href='index.php'>Your session is not valid or has expired. Please click here to join the queue</a>";
        die();
    }
} else {
    header("Location: index.php");
    echo "<a href='index.php'>Your session is not valid. Please go back to the home page</a>";
    die();
}
?>
```

Then let them know the good news!

```php
<html>
  <head>
    <title>Front of queue</title>
    <script>
      var secondsleft = <?php echo $q->checkRemaining($_SESSION["i"],$_SESSION["s"]);?>;
      var countdowncaller = setInterval(function(){countdown()}, 1000);//Update the countdown every second.
      function countdown() {
            secondsleft = secondsleft - 1;
            document.getElementById('timeleft').innerHTML = secondsleft + " seconds remaining.";
            if (secondsleft < 10) {
              document.body.style.backgroundColor = "red";//warn them
            }
            if (secondsleft <= 0) {
              window.location.replace("index.php?end");//kick them
            }
          }
    </script>
  </head>
  <body>
    You are at the front of the queue! <br />
    <div id="timeleft">Loading...</div>
    <button onclick="window.location.href='index.php?end'">End session</button>
  </body>
</html>
```

![At the front of the queue](/content/blog/building-a-queue-for-the-emf-roamer-with-the-vonage-sms-api-and-php/frontqueue.png "At the front of the queue")

## Next Steps

Congratulations on setting up your first online queue. You’re now ready to build this into your own internet-controlled robot (plus a little electronics work)! This concept could be applied to a variety of applications which lend themselves to being operated by a single user at a time, rather than the alternative  free-for-all of multiple users concurrently sending different commands. See [Twitch Plays Pokémon](https://en.wikipedia.org/wiki/Twitch_Plays_Pok%C3%A9mon) for an amusing example of this!

If you’d like to build upon this example further with some administrative tools to manage the queue, check out the ‘bouncer’ script on the [GitHub repo](https://github.com/chrisstubbs93/WebUserQueue/tree/main/Admin).

![The queue bouncer (queue admin tool)](/content/blog/building-a-queue-for-the-emf-roamer-with-the-vonage-sms-api-and-php/admin.png "The queue bouncer (queue admin tool)")


We hope to see the EMF Roamer again at EMF Camp in 2024!


## Useful Resources
* [Vonage Developer Center - *free credits to get started!*](https://developer.vonage.com/)
* [Vonage Documentation](https://developer.vonage.com/documentation)
 
* [Vonage Client Library for PHP](https://github.com/vonage/vonage-php-sdk-core)
* [PHP Web User Queue on GitHub](https://github.com/chrisstubbs93/WebUserQueue)
* [Electromagnetic Field](https://www.emfcamp.org/)
