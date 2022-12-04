---
title: Introducing the Laravel Vonage Helpdesk
description: "The best way of showing Vonage APIs in action is through examples:
  welcome to our PHP App!"
thumbnail: /content/blog/introducing-the-laravel-vonage-helpdesk/laravel-vonage-helpdesk.png
author: james-seconde
published: true
published_at: 2022-11-01T09:59:56.351Z
updated_at: 2022-11-01T09:59:58.343Z
category: tutorial
tags:
  - php
  - laravel
comments: true
spotlight: false
redirect: ""
canonical: ""
outdated: false
replacement_url: ""
---
The biggest shift that we are seeing in web applications is the requirement for multi-channel communications. It isn't enough anymore for your e-commerce site to have *just* a "Contact Us" page, where you can email while also having a popup semi-instant messager like Hotjar. Now, you can choose to be ahead of the curve by changing or promoting the medium by which you communicate with customers; an example being that an email conversation can be switched to a live WhatsApp chat, or automated voice call queues that connect with real (human) agents.

It's time we demonstrated how these channels work, so without further ado (for my PHP developers), I would like to introduce *The Vonage Helpdesk*. In this article, I'll show you how to fire it up locally and then dig into how the SMS aspect of the app works to start us off.

### What is the Vonage Helpdesk?

Some time ago, we had a concept web application called Deskmo. This is a new reinterpretation of that: a web application that will slowly be built over time to include best practises for working with Vonage APIs and demonstrations of modern PHP code.

### What is it written in?

Vonage Helpdesk is a PHP web application built in [Laravel 9](https://laravel.com/docs/9.x). It uses Laravel's [Sail](https://laravel.com/docs/9.x/sail) for portability, so you have a fully Dockerized app (goodbye, system-level dependencies!) that uses [MySQL](https://www.mysql.com/) as the database.

### Installing

#### Requirements

* A Windows, Linux, or Mac machine that can run Docker v20+ (the current version)
* PHP v8.0+
* [NodeJS v17+](https://nodejs.org/en/download/)
* npm v8.5+
* [Composer v2+](https://getcomposer.org/doc/00-intro.md)
* [Git installed](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
* [A Vonage account in credit](https://ui.idp.vonage.com/ui/auth/registration)

First up, we need to download the repository. Type the following into the command line:

```bash
git clone git@github.com:Vonage-Community/sample-messages_voice-php-helpdesk.git
```

Now, we should have the application in a new folder. Next up, we install the PHP dependencies. Do this by navigating into the folder (i.e., `cd sample-messages_voice-php-helpdesk`) and running Composer:

```bash
composer install
```

Laravel Sail should have been added into the `vendor` folder, so providing you have Docker installed, you can run the following command to boot up the application:

```bash
./vendor/bin/sail up
```

### Migrations, Seeders and Vite

Next up, we need to run the database migrations:

```bash
./vendor/bin/sail artisan migrate
```

Our application needs a super user to log in, so we run the database seeder:

```bash
./vendor/bin/sail artisan db:seed
```

Because the application uses [Laravel Breeze scaffolding](https://laravel.com/docs/9.x/starter-kits#laravel-breeze) for authentication out-of-the box, we'll need to run the [Vite](https://vitejs.dev/) development server outside of your Docker containers to compile your JavaScript (this now comes with Laravel pre-configured). To run Vite, open a new terminal in your application folder and run the following:

```bash
npm run dev
```

<sign-up></sign-up>

### Hook up the app via. Ngrok

In order to connect the application to Vonage's servers, we'll need a tunnel to our application. You can do this by using [ngrok](https://ngrok.com/), a neat little tool for doing just this. It's also worth noting there is actually a PHP-written tool from [Beyond Code](https://beyondco.de/) called [Expose](https://expose.dev/docs/introduction) that does the same thing, so well worth a look.

Start the Ngrok process like so:

```bash

ngrok http 8080

```

You should get back a new URL to tunnel into your application. The last thing to do here is to set up your keys - navigate to your Vonage dashboard, create a new application and enable SMS. Once this is done you can tell Vonage where incoming data should be routed: in this case, back to our local app. Edit your application in the dashboard, so that you can add the callback address for your local app. The form should look like this:

![](/content/blog/introducing-the-laravel-vonage-helpdesk/screenshot-2022-10-24-at-12.07.16.png)

The important part here is to use your Ngrok URL, followed by `tickets/webhook`, which is a route defined in the Laravel application. You will also need to purchase a Vonage number to hook it up to the newly created application.

OK, we should all be set. Open a browser and navigate to `localhost` and hopefully, you should see the splash screen:

![Splash screen for helpdesk with Vonage logo](/content/blog/introducing-the-laravel-vonage-helpdesk/screenshot-2022-10-20-at-11.17.47.png)

### The Ticket System

So, what have we got? The Vonage Helpdesk emulates a ticketing system where customers all have an account and can create a ticket, choosing a communication medium of choice. Admins can then view the tickets, and respond to them. The application will take the users' provided phone number and use that for ticket responses from the admin on the web application side.

### How does it do that? Part 1: SMS

You can log in now as the superuser (the seeded user is `admin@vonage.com` and the password is `password` - hey, it's a concept app, so by all means change it to a not-awful password!). Now we need a new "customer" user.

On the splash screen, navigate to the top right-hand link to register. We will be looking at SMS interactions so we will choose 'SMS' as the communication method. Make sure you select a working phone number.

![Filled out helpdesk sign up form](/content/blog/introducing-the-laravel-vonage-helpdesk/screenshot-2022-10-21-at-10.42.18.png)

Now log in with your new details, and you should see the dashboard:

![Helpdesk dashboard with no tickets](/content/blog/introducing-the-laravel-vonage-helpdesk/screenshot-2022-10-21-at-11.15.46.png)

OK! Time to create a new ticket. Hit 'New Ticket' and fill out the details like so:

![creating a new ticket in the dashboard](/content/blog/introducing-the-laravel-vonage-helpdesk/screenshot-2022-10-21-at-11.23.01.png)

For reference, `In-App Messaging` is for using the [Conversation API](https://developer.vonage.com/conversation/overview) for realtime messaging, which we're not doing in this article, so leave that unchecked. Once you create the ticket, after hitting submit you'll be taken to the new ticket:

![newly created ticket with email. channel source and message](/content/blog/introducing-the-laravel-vonage-helpdesk/screenshot-2022-10-21-at-11.23.18.png)

Success! Nothing has happened over the communication channel, as you are the ticket creator. But logging in as the administrator to respond to the ticket is where the magic comes in. You'll notice the ticket entry has `web` on it: this is where our multichannel communications come in. For this SMS chat, if the admin responds, it will be sent to the user via SMS, which they can then reply to using their phone. However, the user could **also** reply via the web application as well. So, we're already multichannel.

We can respond to the ticket if we log out and re-login as the admin.

This is where things get interesting. Once you respond, the application checks what notification channel has been selected for this ticket, then notifies the user of the response. The user is then able to respond via SMS. And there we go: a web and SMS multichannel conversation!

### Under The Hood

So, what is the code doing? Database-wise we have tables for `tickets`, `users`, and `ticket_entries`, all wired together. Each `ticket_entry` contains a user and ticket reference. Each update created locally first works out whether to send out a notification:

```php
        $validatedRequestData = $request->validate([
            'content' => 'required',
            'channel' => 'required'
        ]);

        $ticketEntry = new TicketEntry([
            'content' => $validatedRequestData['content'],
            'channel' => $validatedRequestData['channel'],
        ]);

        $ticketEntry->user()->associate(Auth::user());
        $ticketEntry->ticket()->associate($ticket);
        $ticketEntry->save();

        $userTicket = $ticket->user()->get()->first();

        // If this is not my ticket, I need to notify its creator
        if ($userTicket->id !== Auth::id()) {

            if ($userTicket->notification_method === 'sms') {
                $sms = new SMSText(
                    $userTicket->phone_number,
                    config('vonage.sms_from'),
                    $ticketEntry->content
                );
                $client = app(Client::class);
                $client->messages()->send($sms);
            }
```

The important line here is the comparison: I need to send a notification out if it's not my ticket. It pulls out the notification method from the ticket entry. If it is SMS, it uses [the native PHP Vonage SDK integration with Laravel](https://github.com/Vonage/vonage-laravel) to boot up a new Client, autoconfigured. It then uses the Messages API to fire off an SMS Notification.

At the other end, when the customer replies to the text, Vonage sends a webhook to our app and the `IncomingSmsController` handles it:

```php
        $ticket = $user->latestTicket();

        $entry = new TicketEntry([
            'content' => $request->text,
            'channel' => 'sms',
        ]);

        $entry->user()->associate($user);
        $entry->ticket()->associate($ticket);
        $entry->save();
        
```

It has a limitation for now, in that it matches the incoming phone number to pull out the user, then gets the latest ticket. But, the joy of this app is what is...

### Coming Next...

We're not done yet by a country mile! Keep an eye out for more articles in the series as we add to the app, including Voice capabilities using Deepgram, real-time updates using Laravel Livewire, and building out the test suite with PEST.

