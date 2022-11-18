---
title: "Improve Your Software Project - Part Two: Making Changes"
description: Want to update an old project? This will help!
thumbnail: /content/blog/improve-your-software-project-part-two-making-changes/making-projects-better_part-two.png
author: max-kahan
published: 
published_at:
updated_at: 
category: inspiration
tags:
  - technical-debt
  - enhancement
  - python
comments: true
spotlight: false
redirect: ""
canonical: ""
outdated: false
replacement_url: ""
---
Have you ever taken over a codebase and realised that you're not happy with how the code is written or organised? It's a common story, but one that can cause a lot of headaches. Technical debt can snowball, making it exponentially harder to understand the code and add new features.

In this three-part series, I'll walk through some of the key things you'll want to do to become happier with your shiny (old) project. To give some concrete examples, I'll tie everything together by explaining how I refactored and enhanced the open-source [Vonage Python SDK](https://github.com/Vonage/vonage-python-sdk), a library that makes HTTP calls to Vonage APIs, but the principles apply to any kind of software project. 

The examples in this post will be written in Python, but these principles apply to projects in any language. There's also [a handy checklist to follow](https://github.com/maxkahan/updating-an-old-project) if you're specifically trying to fix a Python project.

## The series, in sections

1. [Part One: Understanding a Codebase](https://developer.vonage.com/blog/22/11/15/improve-your-software-project-part-one-understanding-a-codebase)
2. Part Two: Making Changes (this article)
3. Part Three: Taking Things to the Next Level (will be published soon!)

## What does Part Two cover?

In Part Two, we'll talk about:

* Becoming confident to make changes and address technical debt
* Building trust with your boss, team, and users

By the end of the article, you'll be ready to change things for the better in your project whilst keeping the relevant people happy.

Let's get started!

## Fixing the structure

If you followed [Part One](https://developer.vonage.com/blog/22/11/15/improve-your-software-project-part-one-understanding-a-codebase) of this series, you'll already have a good understanding of the project you now own, as well as knowing how the codebase (and tests, if you're lucky enough to have them) is structured, and what purpose that structure serves. Now is a great time to think about the overall architecture and to start structuring the project in a logical way if you think it could be improved.

### A concrete example

The project I'm using as an example is the [Vonage Python SDK](https://github.com/Vonage/vonage-python-sdk), which allows a user to call many different Vonage APIs. In my case, the macro structure of my project looked like this:

![Image of the original structure of the Vonage Python SDK](/content/blog/improve-your-software-project-part-two-making-changes/original-structure.png)

You can see from the figure above that the code was split into six main modules (single files, yes Python is very compact!):
* An `__init__` module, typically a minimal file used for packaging up the code
* An `_internal` module which contained internal methods (and also one of the APIs we support, for some reason)
* `sms`, `voice` and `verify` modules which each contained code to call a single API
* An `errors` module, which contained all the custom errors

My first question when looking at this was: where are the other APIs? When I arrived at Vonage, the SDK supported 12 different APIs, yet there were only 3 modules related to these APIs.

It transpired that about 90% of the code was actually inside the `__init__.py` file, including implementations of many APIs, deprecated methods, logic for tasks like JWT generation, the base API requests and other optional settings... way too much for a file that should be very minimal. I decided to refactor this by creating a `Client` class and that would deal with the core logic, then classes named after APIs (with a small amount of logical grouping).

We ended up with a structure that looked like this:

![The structure of the source code, split up into the function each module serves](/content/blog/improve-your-software-project-part-two-making-changes/structure-after-refactor.png)

### Doing this yourself

Look at the structure of your project. Ask yourself: could I make this better? Group similar functionality into modules that are small enough to understand easily, but no smaller - you still want to be able to see the big picture of what the project does.

I'd also recommend creating classes to hold similar methods, as well as custom errors for each class to give yourself and your users more visibility on what's wrong, when things break.

## Branches

When you start on a new project, it probably hasn't been left in a "completed" state. Software projects are always a work in progress and the constant iterative improvements are a large part of why we use version control. In this situation, you might find that there are branches in your version control system that contain features, enhancements or bug fixes.

The ideal situation in a lot of cases looks like this: a single main branch, with features being developed on secondary feature branches, then merged back into the main branch.

![Main branch with branches created from it to deliver features - a "good" case](/content/blog/improve-your-software-project-part-two-making-changes/basic-branch-case.png)

In some projects, it might make sense to have a longer-running beta branch, if there's a beta feature you want to test and keep separate from your main codebase. In the Vonage Python SDK, we currently have a [beta branch](https://github.com/Vonage/vonage-python-sdk/tree/video-beta) that with code that calls our Vonage Video API, which is in beta. We don't want to merge this branch as the API it calls isn't officially released. In this case, your branch structure might look more like this:

![Main branch and a long-lived beta branch, both of which have features developed and merged.](/content/blog/improve-your-software-project-part-two-making-changes/main-and-beta-branch-case.png)

In the case where you have to develop features separately, it might be wise to periodically rebase the beta branch to pull in the changes from the main branch - this is what I do with the Vonage Python SDK.

Those are the "good" cases. But when you arrive at a project, it might look more like this:

![A branch structure that needs to be simplified](/content/blog/improve-your-software-project-part-two-making-changes/too-many-branches.png)

I.e. way too many branches, and a lack of consistency. Usually things end up like this when there were multiple developers working on many features, though it could also be the case that a previous engineer used new branches to plan their work that they never got around to finishing.

In this situation, these branches can be a great source of insight into how the previous project owner was handling the project, as well as a source of inspiration - some of the features or fixes might be good enough to implement yourself. However, once you understand what an extra branch contains, it's usually a good idea to close it - the aim is to give yourself as much of a blank slate as possible to implement your own ideas.

## Chesterton's Fence - Understand What You're Removing!

Now seems like a good time to remind everyone (myself included) about [Chesterton's Fence](https://en.wikipedia.org/wiki/G._K._Chesterton#Chesterton's_fence) - the saying that you shouldn't remove something, without understanding why it was put there in the first place. Make an effort to understand the purpose of a branch or part of the code before removing it! Most importantly: don't remove something just because you don't know why it's there, try to understand first.

## Choosing the right dependencies

Almost every software project will depend on other people's code. The beauty of open source is that a lot of problems and challenges have been solved before your code came along, by very smart people who are willing to share their work with you. However, it's important to understand the dependencies your code has, what they're used for and whether they're the very best tools for the job.

A dependency that was suitable in the past may also become less suitable over time, which leads us to ask the question:

### What makes a good dependency?

When choosing to keep (or replace) a dependency, this section should help you to evaluate whether a dependency is worth using.

First, consider the license. Make sure you're allowed to use the dependency for your project. If you can't, that's a no.

Next, is the dependency actively maintained? You can see the commit history of open-source projects. Some are so simple that they need very little maintenance, and this is fine. More complex projects should be actively maintained, i.e. there should be frequent commits, and issues and PRs aren't ignored for a long time. It's important as you want the dependency to support new language versions and play nicely with new features and other dependencies you're using.

It's also worth considering the popularity of the dependency. Picking a popular option means a lot of other people will have used the dependency so you're more likely to have questions answered if you get stuck!

Finally, consider the supporting assets - is the documentation clear? Are there reliable examples online that use the dependency? These things can help you get started or debug problems fast, so they're worth considering.

So you've found the perfect set of dependencies? Great news... for now. A well-maintained library that fits your needs might not stay that way - the maintainers could abandon the project or your requirements could change, rendering it unsuitable. The best piece of advice I have here is: continue to qualify your dependencies over time! Make sure they still fit your needs. And you never know, a new library might appear that suits your needs even more perfectly in future.

## Testing code you don't own

Scope your testing to only test what your code should send and recieve

## Making your first release

This is all about building trust - for your users and for your team, that you know what you're doing.

Use semantic versioning
Update the changelog
Keep docs/READMEs up to date
Transparency is key

## Easing in deprecations

Objects can be marked as deprecated in a minor release
Removing them needs a major release
Leave sufficient time for people to switch over - building trust

## Setting up automated tooling - maybe move to Part Three?

E.g. linting, coverage, mutation score

## Balancing improvements and new work

Work with your team
Set expectations
Advocate for yourself and your work
Create work tickets/todos for discovery/learning to show you're investing in your future efficiency
Create tickets for tech debt to give your boss insight into what you're doing whilst new features aren't exploding into being.

## What's next?

If you follow the suggestions in this article, your project will be looking much better already! The releases you'll have made will lay the groundwork for all the great things you want to do with your project. Check back soon for Part 3, where I'll explain some ways you can enhance your project and take it to the next level.

In the meantime, you can reach out to us on our [Vonage Community Slack](https://developer.vonage.com/community/slack) or send us a message on [Twitter](https://twitter.com/VonageDev).

