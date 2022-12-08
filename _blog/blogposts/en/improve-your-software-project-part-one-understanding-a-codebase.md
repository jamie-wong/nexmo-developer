---
title: "Improve Your Software Project - Part One: Understanding a Codebase"
description: Want to update an old project? This will help!
thumbnail: /content/blog/improve-your-software-project-part-one-understanding-a-codebase/making-projects-better_part-one.png
author: max-kahan
published: true
published_at: 2022-11-15T20:07:20.926Z
updated_at: 2022-11-15T20:02:32.694Z
category: inspiration
tags:
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

1. Part One: Understanding a Codebase (this article)
2. [Part Two: Making Changes](https://developer.vonage.com/blog/22/11/28/improve-your-software-project-part-two-making-changes)
3. Part Three: Taking Things to the Next Level (will be published soon!)

# What does this series cover?

In this series, we'll talk about:

1. Getting to grips with the code
2. Becoming confident to make changes and address technical debt
3. Building trust with your boss, team, and customers/community
3. Making enhancements
4. What to do when it's time to hand the project over

By the end of each article, you'll have some strategies to deal with this situation yourself and will feel empowered to do just that!

Without further ado, let's get on with Part One...

## Part One: Understanding the Project

### Read Stuff!

The first thing to do is to try and understand what the code you've inherited does, and how it's organised.

Start by speaking to anyone with knowledge of the project and reading any available documentation. In my case, there was a readme in the repo which served as my starting point. It provided a good snapshot of the state of the code when it was last updated.

![Image of readme](/content/blog/improve-your-software-project-part-one-understanding-a-codebase/readme.png)

There was also product documentation which helped me to understand what the code was currently expected to do, as it described the APIs I needed to call and their current behaviour.

![Image of main docs page](/content/blog/improve-your-software-project-part-one-understanding-a-codebase/main_docs_page.png)

### Build stuff!

Once you have an idea of what the code does, the next step is to explore it by building some kind of "Hello, World" project - a simple project that uses the code and does something small, but useful. As my project calls APIs, I wrote a very simple piece of code that sends me an SMS.

```python
import vonage


client = vonage.Client(key=MY_KEY, secret=MY_SECRET)

client.sms.send_message({
    "from": "Max",
    "to": MY_NUMBER,
    "text": "Hello, world!",
})
```

It worked!

![Screenshot of my phone with a new message](/content/blog/improve-your-software-project-part-one-understanding-a-codebase/hello_world.png)

Play with your codebase and build a "Hello, World" of your own.

### Understand how the code is structured

It's important to understand how the project's code is organised so you can more easily conceptualise what's going on when your "Hello, World" runs. This is also a great way to practice your architectural thinking skills as you'll need to develop a mental model of how the code operates. This way of thinking will help you split the project into distinct pieces that are easier to understand, which also helps later on when you want to reduce code coupling and other side effects.

In the case of our SDK, the code was organised into six separate files (Python is a very compact language, the equivalent Java codebase is about 10x larger!), which looks like this:

* A file to initialise the project and deal with imports,
* A file to hold internal methods,
* A file that held custom error classes, and
* Three files which each had a class relating to one of Vonage's APIs

![Image showing the different files with the descriptions above applied to them](/content/blog/improve-your-software-project-part-one-understanding-a-codebase/old_file_structure.png)

Alarm bells started ringing as I realised that there were 3 files named after Vonage APIs, but the README claimed that 12 different APIs were supported.

I realised that most of the code was in a file (`__init__.py`) typically used only for imports, in one large class that dealt with everything. As this didn't help with the structure at all, I decided to look at the structure of the tests for more information on how the code was organised.

The tests were grouped sensibly into modules, which helped me to understand the different components at play. I would recommend trying to understand the structure of both your code and your tests, as both can be insightful.

![Screenshot of the tests folder](/content/blog/improve-your-software-project-part-one-understanding-a-codebase/test_folder.png)

### Set up for development and run the tests!

Now, it's time to install the project dependencies and run the tests. If they pass, using the latest version of your language and dependencies, great news! Mine didn't, so I started with the exact dependency versions that were mentioned and incrementally upgraded the dependencies to find out which weren't playing nicely with the latest version of my coding language.

In this situation, upgrade dependencies incrementally and the problems should reveal themselves. One of your dependencies likely had a release with a breaking change since the codebase was last used. (In my case, a dependency changed the way it returned data between versions, so I had to rewrite a couple of tests to handle the data properly.)

## Tooling that can help you

This section mentions a few ways to use tooling to get up to speed on a project. Using code analysis tools can be extremely useful because their use can be automated, meaning that you can run tooling as often as you like and track your progress as you start to improve the codebase. 

Tooling is also great to use when it comes to planning work, as the insights it gives will tell you where the technical debt and code hotspots are and suggest how you might need to prioritise your time!

### Analysis tools

Static analysis is a way of automatically analysing source code without actually having to run it. It can give insight into the structure of a codebase, highlight duplication and other refactoring targets as well as warn you about any potential vulnerabilities. There are free tools available online for most languages, and many providers who charge for the service have a free tier for non-commercial or open-source projects, e.g. [sonarcloud](https://www.sonarsource.com/products/sonarcloud/).

Behavioural analysis refers to learning about a project based on the commit history. This can tell you who worked on the project and when, what was changed, and what components are frequently changed together, as well as a host of other insights. This is a really useful method for large projects with many committers. [CodeScene](https://codescene.com/) has a free tier for open-source projects and works well.

### Test coverage

Test coverage (the percentage of code statements covered by your tests) is useful to work out exactly what your unit tests are testing. It can also highlight areas of a codebase which are not tested. Tools are available in most languages; for Python, I recommend [coverage](https://coverage.readthedocs.io/).

![Image of test coverage outputs](/content/blog/improve-your-software-project-part-one-understanding-a-codebase/coverage.png)

### Mutation score

Test coverage can tell you how much of your code is covered by tests, but this doesn't tell you how good your tests are at actually testing the behaviour of your code! Mutation testing provides more insight into how much you can trust your tests to do their job and make sure your code works as intended.

It works by taking statements in your code and changing them slightly, e.g. changing a string/changing a plus to a minus, etc. to produce many "mutant" versions of your code. Your test suite is then run against each of these mutant versions of your code. Because things have changed, we expect the tests to fail - we say we caught the mutant. But if your tests pass despite these changes, the mutant escaped and these small changes could have made it it into production! Thus, the *mutation score* (ratio of mutants we caught to the total number that was created) tells us how much confidence we should have in our tests.

There are versions of this in many languages, including [Stryker](https://stryker-mutator.io/) which has support for Javascript, Node.js and C#. In Python, I recommend trying [mutmut](https://mutmut.readthedocs.io/en/latest/), which is simple and effective.

![Image of mutation score output](/content/blog/improve-your-software-project-part-one-understanding-a-codebase/mutation_score.png)

### Understand the call stack by profiling your sample!

I'd recommend trying to understand the stack of calls that happens when your "Hello, World" runs. There are tools in most languages to do this.

In Python, I like to recommend a tool called [Snakeviz](https://jiffyclub.github.io/snakeviz/) to display your call stack visually. Put your "Hello, World" code into a function and profile it, like so:

```python
with cProfile.Profile() as pr:
    send_sms() # This function is where the Hello, World code lives
stats = pstats.Stats(pr)
stats.dump_stats(filename='send_sms.prof')
```

That generates a file called `send_sms.prof`. If you run this on the command line with Snakeviz...

```bash
python -m pip install snakeviz

snakeviz send_sms.prof
```

...it will generate an interactive icicle plot that shows you all the functions that your function calls, all the functions _they_ call, and so on. This can be useful to help you follow the computer's path through the code, and can shine a light on how it works.

![Image of an icicle plot of my profiled function](/content/blog/improve-your-software-project-part-one-understanding-a-codebase/icicle_plot.png)

## What's next?

If you follow the suggestions in this article, you'll be in a great position to start building trust, tackling technical debt and making changes to your codebase. [Click here for Part 2, where we'll talk about all of this in detail](https://developer.vonage.com/blog/22/11/28/improve-your-software-project-part-two-making-changes).

If you want to get in touch, you can reach out to us on our [Vonage Community Slack](https://developer.vonage.com/community/slack) or send us a message on [Twitter](https://twitter.com/VonageDev).
