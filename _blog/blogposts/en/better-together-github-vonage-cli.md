---
title: "Better together: GitHub & Vonage CLI"
description: Learn how you can take advantage of the GitHub & Vonage CLI to
  increase developer productivity with your upcoming apps.
thumbnail: /content/blog/better-together-github-vonage-cli/github_vonage-cli.png
author: michael-crump
published: true
published_at: 2022-09-20T08:39:30.063Z
updated_at: 2022-09-20T08:39:31.572Z
category: tutorial
tags:
  - cli
  - vonage
  - git
comments: true
spotlight: false
redirect: ""
canonical: ""
outdated: false
replacement_url: ""
---
## Introduction

We're almost halfway through 2022, and the need for the [CLI (Command Line Interface)](https://en.wikipedia.org/wiki/Command-line_interface) is more vital than ever. Traditionally, Command Line Interfaces are used by advanced users (such as a developer or power users), whereas GUIs (Graphical User Interface) is sought after by beginners as they are user-friendly and easy to learn. Let's step back to the beginning of computing to learn more.

With early computer systems, users only had a keyboard to input information, and screens (for the most part) would only display text. You could risk closing a program or removing important files if you entered a command incorrectly. Years later, there were mouse and color screens, and popular operating systems like Windows 3.11 or OS/2 Warp began providing users with a more friendly way to interact (through a GUI). But even with this decisive step forward, we continued to see advancements with CLIs with the [Command Prompt in Windows](https://en.wikipedia.org/wiki/Cmd.exe) and the [Terminal for MacOS](https://en.wikipedia.org/wiki/Terminal_(macOS)). (Which originated in Apple's acquisition of NeXTSTEP and OPENSTEP.) 

Which leaves us with an important question, why are we seeing more and more companies (and developers) still investing in CLI tooling for their customers when they could use modern hardware and software technologies?

I believe that we can sum up the purpose of CLIs in 2022 as follows: 

* It can drastically speed up productivity once you are familiar with the commands
* It requires fewer resources (such as memory) compared to a GUI, which means you can run it on all types of hardware
* It provides a tighter level of control (and understanding) of what is happening behind the scenes.

Today, many power users and developers use the CLI to display and work with file systems, manage computer processes, deploy code, and perform repetitive tasks.

So if software developers and power users prefer these benefits over a GUI, then it makes sense for the companies that offer services to provide a native CLI to make interacting with those applications and APIs even more straightforward. That is why I picked 2 CLIs I wanted to cover in this post which will hopefully enhance your workflows while working with git and Vonage APIs. I believe together that they will help you and your team become more productive than ever. Let's get started!

## GitHub CLI

The [GitHub CLI](https://cli.github.com/) allows you to work with GitHub in your terminal of choice. It is free and open source but there are a few differences between the GitHub CLI and `git.` `git` is used for git operations in general such as using your locally hosted version of git, Bitbucket, GitLab, etc. Whereas, the Github CLI is specifically made for GitHub and allows you to manage a variety of GitHub features such as issue tracking, etc. 

Installation is straightforward. You head to the [GitHub CLI docs](https://github.com/cli/cli#installation) and look for your Operating System and preferred package manager. Since this tutorial is about the CLI, I wouldn't advise you to download the GUI installer. :) 

![The Windows GUI Installer](/content/blog/better-together-github-vonage-cli/windowsinstaller.png)

Since I'm using Windows 11 and [Chocolatey](https://chocolatey.org/), I'll run the following command `choco install gh`. 

Once installed, the very first command that we'll use is `gh help`, as shown below: 

![Running gh help](/content/blog/better-together-github-vonage-cli/gh-help.png)

We can also combine the help functionality with a core command such as `gh pr --help` to get help for a specific git command:

![Running gh pr help](/content/blog/better-together-github-vonage-cli/gh-pr-help.png)

Now that you know how to use the help feature, we should authenticate with GitHub to manage our account. We can do so by `gh auth login`. The GitHub CLI will ask you several questions: 

* To select between a personal account or an enterprise server 
* Your preferred protocol for git operations
* How you'd like to authenticate (via browser or token)

Once complete, you should see the following if you've logged in successfully:

![Successful Login](/content/blog/better-together-github-vonage-cli/gh-setup.png)

You can always check to see your authentication status by running `gh auth status`. 

![GitHub Authentication Status](/content/blog/better-together-github-vonage-cli/gh-auth-status.png)

You can now create or clone a repo to begin work. If you'd like to make a brand new repo, use `gh repo create`. You'll now be in interactive mode, so select the option to **Create a new repository on GitHub from scratch**. Follow the on-screen prompts and be sure to clone the repository locally. Here is an example of what mine looks like:

![Finished GitHub repo setup](/content/blog/better-together-github-vonage-cli/gh-repo-create.png)

If you want to clone a repo, you can use `gh repo clone <directory>`. Here is an example of cloning my Real Estate C# Example - `gh repo clone Vonage-Community/blog-sms-csharp-realestate`. Again, here is an example of what the output looks like:

![Finished GitHub repo clone setup ](/content/blog/better-together-github-vonage-cli/gh-repo-clone.png)

Now that we know how to perform basic operations with the GitHub CLI let's see what the Vonage CLI has to offer. 

## Vonage CLI

The [Vonage CLI](https://github.com/Vonage/vonage-cli) allows you to manage your Vonage account and numbers and configure your applications from the command line. Like the GitHub CLI, it is also free and open source and could be considered an alternative to managing your Vonage account via the [Vonage Developer Dashboard](https://developer.vonage.com).

Installation requires that you have [Node.js](https://nodejs.org/) installed. Once you have Node.js installed, you can use npm (Node Package Manager) to install it by typing `npm install -g @vonage/cli`. 

Once installed, run `vonage help` to get a quick glimpse of the commands you can use along with a description. 

![Running vonage help](/content/blog/better-together-github-vonage-cli/vonage-help.png)

We can also combine the help functionality with a core command such as `vonage apps --help` as shown below:

![Running Vonage apps help](/content/blog/better-together-github-vonage-cli/vonage-apps-help.png)

This information will provide specifics on how to interact with the core command. 

> Note: you can also use the shorthand syntax by passing `vonage apps -h` instead of spelling out the word "help." 

We'll also need to authenticate with Vonage as we did with the GitHub CLI so that the CLI understands which account to provision.

To do so, you'll need to get your current API Key and API Secret by visiting the [Vonage Developer Portal](https://developer.vonage.com) and copying the keys as shown below to a safe location. 

![Keys from the portal](/content/blog/better-together-github-vonage-cli/apidashboard.png)

**Quick tip:** If you don't have an [account](https://developer.vonage.com), you can create one for free, and we'll give you some credits to get started. 

Head back to the command prompt, and we'll need to pass the ApiKey and APISecret with the following format: `vonage config:set --apiKey=XXXXXX --apiSecret=XXXXXX`

Once set, you can verify the information was stored successfully by typing `vonage config` as shown below:

![Vonage Config](/content/blog/better-together-github-vonage-cli/vonage-config.png)

The next thing you might want to do is create an application for the Vonage APIs you plan on using. We can take advantage of the interactive mode of the CLI by typing `vonage apps:create`. 

We'll need to supply:

* An Application Name
* Which app capabilities that we'd like to use
* Indicate if we need message webhooks
* An option to opt-in to use the data for AI training

The completed form looks like the following:

![Vonage App Created Successfully](/content/blog/better-together-github-vonage-cli/vonage-app-created-successfully.png)

Note that it provides our Message settings (our webhook addresses), Public Key, and independent app files (such as our Vonage App File and our Private Key). It also creates two files on your hard disk drive named `vonage_app.json` and `app_name.key`, which contains the Application ID, Application name, and private key. We could now use those keys to interact with the Vonage APIs - all through the CLI!

## Conclusion

As you can see, the CLI is still a powerful way for developers to enhance productivity and get more things done! I hope this tutorial helped jumpstart your adventure using both of these CLIs. As always, if you have questions or feedback about our CLI tooling, join us on the [Vonage Developer Slack](https://developer.vonage.com/community/slack) or send me a Tweet on [Twitter](https://twitter.com/mbcrump), and I'll get back to you. Thanks again for reading, and I'll catch you on the next one!
