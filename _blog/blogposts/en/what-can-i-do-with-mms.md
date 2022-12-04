---
title: What Can I Do With MMS?
description: An overview of the MMS channel of the Vonage Messages API, with a
  walkthrough of an example application which uses the Ruby SDK to send an MMS
  image message.
thumbnail: /content/blog/what-can-i-do-with-mms/what-mms-can-do.png
author: karl-lingiah
published: true
published_at: 2022-08-30T09:27:46.549Z
updated_at: 2022-08-30T09:27:47.191Z
category: inspiration
tags:
  - messages-api
  - ruby
  - mms
comments: true
spotlight: false
redirect: ""
canonical: ""
outdated: false
replacement_url: ""
---
## What Can I do with MMS?

A question along these lines was recently posted on one of our internal Slack channels.

![Slack screenshot showing the message "Hi team, what types of files can be sent over MMS?"](/content/blog/what-can-i-do-with-mms/slack-screenshot.png "Slack screenshot")

MMS as a communications channel is probably best known for sending images, and in its early days MMS was often referred to as "picture messaging". In this blog post, we'll look at an example of sending an image file via MMS using the Vonage Messages API. Before we get to that though, I wanted to provide a bit more background about MMS and some of its other capabilities.

Although it is mainly associated with sending images, the acronym MMS actually stands for 'Multi Media Service'. MMS isn't just confined to sending image files, but lets you send many different file types over the cellular network.

The Vonage Messages API currently supports four different MMS message types:

* Image: Supports sending `.jpg`, `.jpeg`, `.png` and `.gif` files
* Audio: Supports sending `.mp3` files
* Video: Supports sending `.mp4` files
* vCard: Supports sending `.vcf` files

## Why Use MMS?

There are many different use cases for MMS messaging. Used for *promotional messaging*, MMS can add an extra dimension when compared to SMS messaging, by promoting a product with images, videos, or even sound clips. There are also many *transactional* uses, such as instructional videos as part of a customer support workflow, or providing proof of parcel deliveries.

## Sending an MMS Message with the Vonage Messages API

If you've already been using Vonage to send SMS messages, or even if you haven't, it's super easy to get started sending MMS messages using Vonage, especially now that the [Vonage Messages API has been added to our Server SDKs](https://developer.vonage.com/blog/22/07/05/the-vonage-messages-api-is-now-in-our-server-sdks).

The Messages API exposes a single `POST` endpoint: `https://api.nexmo.com/v1/messages`, and expects an `Authorization` header (we recommend using Bearer Token authentication here) and a JSON payload that looks something like this:

```json
{
  "message_type": "image",
  "image": {
    "url": "https://example.com/image.jpg"
  },
  "to": "447700900000",
  "from": "447700900001",
  "channel": "mms"
}
```

The above example is the JSON structure you would use to send an image message via MMS.

There are a few things to be aware of here: the `url` property for the image needs to be a publicly accessible URL, and there are certain requirements regarding the `to` and `from` numbers.

### To Number

The Messages API currently supports sending MMS in the **USA** to numbers on the following networks:

* AT&T
* T-Mobile
* Verizon

The `to` number provided to the Vonage Messages API needs to be a number that can receive MMS on one of these networks.

### From Number

The `from` number needs to be either a **USSC** (US short code), **10DLC** (10-digit long code), or **TFN** (Toll-free number) enabled for MMS and linked to a [registered campaign](https://api.support.vonage.com/hc/en-us/articles/360053422591-10-DLC-Campaign-Registration-Guide). The different types of numbers support different MMS capabilities:

* USSC: images, vCard
* 10DLC: images, audio, video, vCard
* TFN: images, audio, video

[Find out more about the different types of phone numbers](https://www.vonage.co.uk/communications-apis/phone-numbers/).

## Example Application

The best way to demonstrate using the Vonage Message API to send MMS messages is to walk through an example application.

I don't have any products to promote via MMS, but I do love [xkcd comics](https://xkcd.com/), so I used the [Vonage Ruby SDK](https://github.com/Vonage/vonage-ruby-sdk) to build a small Ruby application that sends a daily MMS message containing a random comic from xkcd. If you're not a Rubyist, though, you could use one of our other [Server SDKs](https://developer.vonage.com/tools), or work with the Messages API directly, to implement something similar.

My Ruby app does two things:

* Gets the data for a random xkcd comic from the [xkcd API](https://xkcd.com/json.html)
* Sends the comic as an MMS using the [Vonage Messages API](https://developer.vonage.com/messages/overview)

I then set up a Cron job which runs the application once a day at a set time.

### Setting up the Dependencies

For the first task of the application -- getting the data from the xkcd API -- I came across a [RubyGem](https://rubygems.org/gems/xkcd) that provided this functionality. Unfortunately, it didn't do exactly what I wanted for my app in terms of how it returned the data, so I decided to write [my own RubyGem](https://rubygems.org/gems/get_xkcd), `get_xkcd`, which did. If you want to dig into the implementation, you can check out the [source code](https://github.com/superchilled/get-xkcd) on GitHub.

My `Gemfile` looks like this:

```ruby
source "https://rubygems.org"

ruby "3.0"

gem "dotenv"
gem "vonage"
gem "rake"
gem "whenever", require: false
gem "get_xkcd"
```

The most important dependency here is the `vonage` [gem](https://github.com/Vonage/vonage-ruby-sdk), which I use to send the MMS via the Vonage Messages API.

I'm using my `get_xkcd` to interact with the xkcd API. The `dotenv` [gem](https://github.com/bkeepers/dotenv) is for managing the environment variables for my application. The `rake` [gem](https://github.com/ruby/rake) and `whenever` [gem](https://github.com/javan/whenever) are for setting up a task to be run via Cron.

### The Application File

I created an `app.rb` file which contains the logic for getting the xkcd comic data and then sending an MMS message using some of that data.

My main application file looks like this:

```ruby
# app.rb

require 'dotenv'
require 'vonage'
require 'get_xkcd'

Dotenv.load

random_issue_data = GetXkcd::Comic.fetch_random_issue_data

client = Vonage::Client.new(
  application_id: ENV['APP_ID'],
  private_key: File.read(ENV['PATH_TO_PRIVATE_KEY_PATH'])
)

message = Vonage::Messaging::Message.mms(
  type: 'image',
  message: {
    url: random_issue_data['img'],
    caption: random_issue_data['title']
  }
)

client.messaging.send(from: ENV['FROM_NUMBER'], to: ENV['TO_NUMBER'], **message)
```

The application starts off by requiring the `dotenv`, `vonage`, and `get_xkcd` gems.

```ruby
require 'dotenv'
require 'vonage'
require 'get_xkcd'
```

All of the necessary environment variables are defined in an `.env` file in the root directory of my project and loaded then into an `ENV` hash using the `Dotenv.load` method.

```ruby
Dotenv.load
```

The first thing my app needs to do is get the data for a random xkcd comic. My `GetXkcd` library defines a `Comic` class which provides several methods. One of these methods is `fetch_random_issue_data` which, as the name suggests, fetches data for a random issue of the xkcd comic.

```ruby
random_issue_data = GetXkcd::Comic.fetch_random_issue_data
```

The app stores the return in a `random_issue_data` variable. The return value of the method is a Ruby Hash of data for a random xkcd comic, including a URL for the comic image as the value of the `img` key and the comic's title as the value for the `title` key. These values will be used later when creating the MMS message.

The rest of the `app.rb` file deals with creating and sending the MMS message.

#### Instantiating the Client Object

The first step in sending a message using the Vonage Messages API is to instantiate a Vonage `Client` object. Here we pass in two keyword arguments: `application_id` and `private_key`.

```ruby
client = Vonage::Client.new(
  application_id: ENV['APP_ID'],
  private_key: File.read(ENV['PATH_TO_PRIVATE_KEY_PATH'])
)
```

You might be wondering what these two arguments represent.

To use the Messages API, you need to create a [Vonage Application](https://developer.vonage.com/application/overview), via either the [Developer Dashboard](https://dashboard.nexmo.com/applications/) or the [Applications API](https://developer.vonage.com/api/application.v2), and enable it for Messages.

![Screenshot of the Messages toggle in the Dashboard Application Capabilities, with the toggle set to "on"](/content/blog/what-can-i-do-with-mms/vonage-dashboard-enable-messages.png "Screenshot of the Messages toggle in the Dashboard")

Once created, the application will have a unique application ID. You will also be able to generate, and download, a private key for this application.

![Screenshot of the Generate Private Key button in the Dashboard Application page](/content/blog/what-can-i-do-with-mms/vonage-dashboard-generate-keys.png "Screenshot of the Generate Private Key button in the Dashboard")

My private key is stored in the root directory of my project file. My app ID and the path to my private key are defined in my `.env` file.

One of the details that our Server SDKs take care of for you is dealing with authentication and generating HTTP request headers. The `application_id` and `private_key` data passed in when instantiating the `Client` object are subsequently used to generate a JWT ([JSON Web Token](https://developer.vonage.com/concepts/guides/authentication#json-web-tokens-jwt)) which is then set as the value of the `Authorization` header sent with the HTTP request to the Messages API.

#### Instantiating the MMS Message Object

The Vonage Ruby SDK defines a `Messaging::Message` object which provides methods for creating specific message objects for each channel. Here, calling the `mms` method returns an `MMS` object with properties based on the arguments passed in.

```ruby
message = Vonage::Messaging::Message.mms(
  type: 'image',
  message: {
    url: random_issue_data['img'],
    caption: random_issue_data['title']
  }
)
```

Here we set the `type` to `image` (other options for `MMS` `type` are `audio`, `video`, or `vcard`). In the `message` hash, we set the `url` to the URL of the `img` from the xkcd data, and an optional `caption` to the `title` from that data.

#### Sending the MMS Message

And so to the important part of the application: sending the MMS message!

```ruby
client.messaging.send(from: ENV['FROM_NUMBER'], to: ENV['TO_NUMBER'], **message)
```

Calling the `messaging` method on the `Client` object we created earlier returns a `Messaging` object. We then chain a `send` method invocation onto this returned object which combines the `from` and `to` number arguments with the `message` object passed in, converts it to JSON, and sends it as the body of an HTTP request to the Messages API `POST` endpoint.

Bear in mind the restrictions on `from` and `to` numbers explained earlier in this article.

### Setting up the Cron Job

The final task is to set up the Cron job. I could edit my system's `crontab` manually, but there's a really useful Rubygem called `whenever` which simplifies the process. The `whenever` gem provides a few different options for running tasks, such as executing a `bash` command or running a `rake` task.

[Rake](https://github.com/ruby/rake) is a task-runner for Ruby. It lets you define certain tasks with Ruby syntax, which can then be executed by being passed to the `rake` command. Tasks are defined in a `Rakefile`, so we need to add one to our project directory.

```ruby
# Rakefile

desc "Send a random XKCD comic via MMS"
task :send_xkcd_mms do
  ruby 'app.rb'
end
```

Here I define a single task with a description (`desc`), a task name `send_xkcd_mms`, and the task itself (defined within a `do..end` block) which is simply to run my `app.rb` file.

To schedule the task with the `whenever` [gem](https://github.com/javan/whenever) I need to create a `schedule.rb` file within a `config` directory and define the schedule in there.

```ruby
# schedule.rb

job_type :rake, "cd :path && bundle exec rake :task"

every 1.day, at: '9:00 am' do
  rake "send_xkcd_mms"
end
```

The `job_type :rake, "cd :path && bundle exec rake :task"` line sets some defaults for how the task is run. The task itself uses Ruby syntax to set an interval (`every 1.day`), a specific time (`at: '9:00 am'`), and then the task we want to schedule within a `do..end` block (`rake "send_xkcd_mms"`).

To update my system's `crontab` with this schedule, I then need to run `whenever --update-crontab` from the command line.

And voila! Daily xkcd comics via MMS.

![Screenshot of xkcd comic issue 974 'The General Problem' in an MMS](/content/blog/what-can-i-do-with-mms/xkcd-mms-screenshot.png "Screenshot of xkcd comic in an MMS")

## Conclusion and Next Steps

In this blog post we learned a bit more MMS, what you can do with it, and how to use the Vonage Messages API to send an MMS message.

We always welcome community involvement. Please feel free to join us on the [Vonage Community Slack](https://developer.vonage.com/community/slack) or send us a message on [Twitter](https://twitter.com/VonageDev).
