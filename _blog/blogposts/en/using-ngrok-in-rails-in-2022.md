---
title: Using ngrok in Rails in 2022
description: A quick guide to using ngrok with Ruby on Rakils for tunneling in
  development environment.
thumbnail: /content/blog/using-ngrok-in-rails-in-2022/ngrok_rails.png
author: benjamin-aronov
published: true
published_at: 2022-08-24T12:32:43.833Z
updated_at: 2022-08-24T12:32:43.870Z
category: tutorial
tags:
  - ruby-on-rails
  - ngrok
  - ruby
comments: true
spotlight: false
redirect: ""
canonical: ""
outdated: false
replacement_url: ""
---
There are many times in development when a localhost server just won’t cut it. That’s when we can use a nifty tool called [ngrok](https://ngrok.com/). ngrok creates tunnels. These tunnels connect your local codebase with a public site, without having to do any annoying configuration. The main use case for Vonage developers is when using an API that relies on webhooks to send automated information. You can read more about that in [Testing with ngrok](https://developer.vonage.com/getting-started/tools/ngrok) in our developer portal tools.

The use case we’re interested in this article is using ngrok with Ruby on Rails when building a project and allowing other users to access it from their browser. This allows for the most realistic simulation. Also, it’s pretty sweet to share something with friends, even if you never deploy it publicly.

*Disclaimer: ngrok is free for non-commercial use, but requires a paid account if your product is commercial. An alternative to ngrok is [LocalTunnel](https://github.com/localtunnel) which is open source and covered by the MIT license. The Vonage Developer Relations Tooling team uses LocalTunnel for work with the Vonage Client SDKs. Use what is best for your needs.*

## Installing ngrok

Straight from the ngrok documentation, the full installation of ngrok is 3 steps: installing the ngrok agent, creating an account, and then connecting to your agent to your account. And for Rails we have one additional step, adding ngrok to your development environment.

### Installing the agent

For MacOS, use HomeBrew:

`brew install ngrok/ngrok/ngrok`

<br>
For Linux, use Apt:

```curl -s https://ngrok-agent.s3.amazonaws.com/ngrok.asc | \
      sudo tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null && \
      echo "deb https://ngrok-agent.s3.amazonaws.com buster main" | \
      sudo tee /etc/apt/sources.list.d/ngrok.list && \
      sudo apt update && sudo apt install ngrok\
 ```

For Windows, use [Chocolatey](https://chocolatey.org/):

`choco install ngrok`

#### Extract the agent
On Linux or Mac OS X you can unzip ngrok from a terminal with the following command. On Windows, just double click ngrok.zip to extract it.

`unzip /path/to/ngrok.zip`

### Creating an account

If you don’t have an account sign up for one at the [ngrok dashboard](https://dashboard.ngrok.com/). If you have an account then login. Either way with your free account you will need to retrieve your authtoken for the net step. Just go [here](https://dashboard.ngrok.com/get-started/your-authtoken).

### Connecting Your Agent to Your Account:

Here we will need that authtoken from the last step. The authotoken is what the agent uses to login to your account when creating a tunnel.

Run the following line in the command line. Don’t forget to replace TOKEN with your actual authtoken.

`ngrok config add-authtoken TOKEN`

## Running Ngrok

The best part of ngrok is that it has the easiest command ever. Just a single line to tell it which port to listen for and serve up. In a Rails application, we know that Puma loves port 3000!

`ngrok http 3000`

## Adding ngrok to your Rails development environment

In your application, you’ll have a file `config/environments/development.rb`. This file tells Rails how to configure the development environment. 

Here we’ll need to add one line:<br/>
`config.hosts << "\[ngrok url]"`

![](/content/blog/using-ngrok-in-rails-in-2022/screen-shot-2022-07-25-at-15.50.34.png)

For example, in the above instance of running ngrok I would add:<br/>
`config.hosts << "b994-77-73-159-12.ngrok.io"`

It is important that this line is added within the `Rails.application.configure do` 
block.

Now we can run our rails server:
`rails s`

And now our app is up and running and you can invite friends to join try it out by sending them the ngrok URL.

## Common Mistakes

These are some common mistakes I make, no matter how many times they always seem to persist.

* Leaving https in the confg.hosts
* Leaving a space in the config.hosts
* Forgetting to restart the rails server after adding or updating the config.hosts in development
* Adding the config.hosts outside of “Rails.application.configure do”


## Join the Conversation
Do you love using ngrok or do you have a preferred alternative? Share your thoughts on tooling with us! Come join the conversation on our [Vonage Community Slack](https://developer.vonage.com/community/slack) or send us a message on [Twitter](https://twitter.com/VonageDev).
