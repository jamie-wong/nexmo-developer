---
title: "Improve Your Software Project - Part Three: Taking It To The Next Level, And Handing Over"
description: Want to update an old project? This will help!
thumbnail: /content/blog/improve-your-software-project-part-two-making-changes/making-projects-better_part-three.png
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
2. [Part Two: Making Changes](link-when-it's-gone-live)
3. Part Three: Taking Things to the Next Level, And Handing Over (this article)

If you followed [Part One](https://developer.vonage.com/blog/22/11/15/improve-your-software-project-part-one-understanding-a-codebase) and [Part Two](link_when_it_exists) of this series, you'll have a good understanding of the project you now own and may have already done some refactoring, added features and released new versions.

## What does Part Three cover?

In Part Three, we'll talk about:

* Enhancing your project
* Tooling that you can use
* Automation
* Best practices for handing over a project to someone else

### Enhancements you can make

When thinking about enhancements that can be made to a codebase, they fall into two groups:

* Enhancements that directly benefit the user, and
* Enhancements that benefit the maintainer.

User enhancements refer to things that make the user's experience of using the code much easier, and maintainer enhancements refer to things that make development easier and build trust that the code behaves as expected. Let's start by discussing some user enhancements.

## Custom error handling

When a user encounters an error, how useful that error is to actually help them discover what's wrong with their use of your code can vary quite wildly. Let's consider two distinct examples.

Exhibit A shows one way to write a function that checks for a valid input parameter to a method. The method in question allows a user to send SMS, MMS, WhatsApp, Messenger and Viber messages with the [Vonage Messages API](https://developer.vonage.com/messages/overview) and this check makes sure they've specified a valid channel.

```python
def _check_valid_message_channel(self, params):
    if params['channel'] not in Messages.valid_message_channels:
        raise Exception
```

In this case, if the user doesn't specify a valid message channel, they will simply see that an exception has been raised. They won't have any specific information here and will have to dig through their call stack to see what caused the error.

![The exception a user will see if they run the above code](/content/blog/improve-your-software-project-part-three-taking-it-to-the-next-level/exception.png)

Exhibit B shows another way to write this code.

```python
def _check_valid_message_channel(self, params):
    if params['channel'] not in Messages.valid_message_channels:
        raise MessagesError(f"""
          '{params['channel']}' is an invalid message channel. 
          Must be one of the following types: {self.valid_message_channels}'
        """)
```

In this case, I created a custom error related to the Vonage Messages API. I specify an error message that describes the exact problem with the user's code, and what they can do to fix it. This is much clearer for the user and can save them serious debugging time!

![The (more useful) exception a user will see if they run the new code with the custom error class](/content/blog/improve-your-software-project-part-three-taking-it-to-the-next-level/custom-error.png)

We can see above that the user tried to send a "carrier pigeon" message via the Messages API, which is an unsupported channel. Hopefully this example shows how much you can help your users if you create custom exceptions to help with debugging.

## Input validation

If you users have to interact with your code by passing in data to functions etc., you might want to consider what checks you're doing on that input data. If you're using a strongly-typed class-based approach, like Object-Oriented Java, your code will try to marshal the data that's passed in into an appropriate structure. If you're using a less strict approach, you may want to validate user input to return an error as soon as possible if things aren't right.

Let's look at a couple of real examples. This is some code from the SDK that sends an SMS:

```python
def send_message(self, params):
    ...
    return self._client.post(
        self._client.host(), 
        "/sms/json", 
        params, # This is the user's input!
        supports_signature_auth=True,
        **Sms.defaults,
    )
```

You can see that all that really happens is that the `params` passed in by the user who calls the function are passed into another function, that makes a post request and returns the response of this to the user. This is fine for simple cases, but if the API we're communicating with accepts many combinations of options, we may want to consider validating user input.

### Why bother validating input?

Great question. If all we're going to do is throw an error anyway, why bother? Well, catching errors at the source of the problem makes debugging a lot easier and means fewer resources are used sending requests that will be rejected anyway.

Here's another example, this time from the [Vonage Messages API](https://developer.vonage.com/messages/overview):

```python
def send_message(self, params: dict):        
    self.validate_send_message_input(params) # This calls the function below
    ...
    return self._client.post(
        self._client.api_host(), 
        "/v1/messages",
        params, # This is still the user's input, but if we get to here, we know it's valid!
        auth_type=self._auth_type,
        )

def validate_send_message_input(self, params):
    # Each of these lines calls a different check on the user's input
    # An error is thrown if any of the checks fail
    self._check_input_is_dict(params)
    self._check_valid_message_channel(params)
    self._check_valid_message_type(params)
    self._check_valid_recipient(params)
    self._check_valid_sender(params)
    self._channel_specific_checks(params)
    self._check_valid_client_ref(params)
```

We can see that this time a user's input is carefully checked so we don't send an erroneous request.

Whilst writing manual checks is effective, it's also worth considering class- or model-based approach if you have to validate a lot of user input. Some langages have this function implemented via classes, where the constructor of a class expects specific input in order to create an instance of that class. In this case, having the user create valid classes and passing those to your other functions can ensure the user passes in the right data. In Python, we don't have an out-of-the-box typing system that works in this way, but there are [libraries such as Pydantic](https://pydantic-docs.helpmanual.io/) that can create models to do this for you.

An example of the model-based approach in Python, using Pydantic the Vonage Messages API code again as the example, is below.

```python
# I created classes that inherit from Pydantic's BaseModel class.
# I'm able to specify specific constraints, including the type and length of parameters, and specify defaults.
class Message(BaseModel):
    to: constr(min_length=7, max_length=15)
    sender: constr(min_length=1)
    client_ref: Optional[str]
    
class SmsMessage(Message): # Inherits the properties of the "Message" model
    channel = Field(default='sms', const=True)
    message_type = Field(default='text', const=True)
    text: constr(max_length=1000)

... # More classes for each type of message that the Messages API can send

class Messages: # Class that contains the code to call the Messages API
... # Skipping showing the constructor etc. here
    def send_message_from_model(self, message: Message):
        params = message.dict()
        ...
        return self._client.post(
            self._client.api_host(), 
            "/v1/messages",
            params,
            auth_type=self._auth_type,
        )
```

This version may look more complicated, but it saves us manually writing all of the checks. Now if a user wants to send a message and gets part of the input wrong, they'll get a sensible error that indicates what they might have done wrong.

![The exception generated by Pydantic](/content/blog/improve-your-software-project-part-three-taking-it-to-the-next-level/pydantic-error.png)

In summary, when dealing with user input, consider validating it. How you do that validation depends on your language and the approach you've taken with it, but having some form of validation can really help your users understand how to use your code.

## Making it async

The final potential user-facing enhancement I want to identify is to do with asynchronous code. Unless your project deals with io-bound operations, you might not need to consider this at all - in which case, just skip to the next section.

If your project does rely on io-based operations, consider whether making the code asynchronous would benefit your users. 

### What does async actually mean?

Asynchronous code is code where operations can give up control of a thread to allow other things to happen. Compare that with synchronous code, which waits for every operation to complete before starting the next one. Some languages (e.g. Node.js) are asynchronous by default, but other languages have asynchronous features that can be used when needed. If you're a JavaScript developer, you can probably skip this section.

If your code makes a request and has to wait a long time for a response, it might be worth writing your code asynchronously, i.e. allow other things to happen whilst you wait for a response. In the case of the Vonage Python SDK, we're making HTTP requests which need to communicate with a remote server. We're doing this synchronously, so it's worth considering if making an async version of part of the SDK would be of benefit to my users. We can guess that making an async method would make it possible to send more requests at once with the SDK... but why guess? Let's do an experiment.

### Should we use async? A real-life example

To investigate if making some async methods would decrease the time taken to make requests, I wrote 2 pieces of code. One used a function from the Vonage Python SDK as normal to make 100 HTTP requests to the [Vonage Number Insight API](https://developer.vonage.com/number-insight/overview) and the other used an async version of the function that I created. I profiled both versions of the code ([using the profiling method I described in Part One of this series, here](https://developer.vonage.com/blog/22/11/15/improve-your-software-project-part-one-understanding-a-codebase#understand-the-call-stack-by-profiling-your-sample)) and we can see that the majority of the time spent in the program is spent making HTTP requests.

The first image below is an icicle plot that shows the top of the call stack for our SDK as it makes 100 requests to a Vonage API.

![The top of an icicle plot of a series of synchronous SDK operations](/content/blog/improve-your-software-project-part-three-taking-it-to-the-next-level/sync-icicle-plot-top.png)

The next image shows the very bottom of the call stack. As you can see here, most of the time the whole program takes to run (2.78/3.42 seconds, or 81%!) is spent waiting for SSL connections to be established between our code and the remote server.

![The bottom level of the same icicle plot, showing that most of the time is spent waiting for connections](/content/blog/improve-your-software-project-part-three-taking-it-to-the-next-level/sync-icicle-plot-bottom.png)

This suggests that if the code was able to give up control of the running thread until connections are established, this time could be improved a lot.

Below is the data for the async version of the code, that performs the same 100 requests to the same API.

![An icicle plot of a series of asynchronous SDK operations - much faster](/content/blog/improve-your-software-project-part-three-taking-it-to-the-next-level/async-icicle-plot.png)

We can see from the plot above that the entire task was completed in 0.33s, about 10 times faster than the synchronous version! In this case, it makes sense for me to explore whether I should make my code async.

The last paragraph seems pretty non-commital, given that I just made the code 10x faster. Why wouldn't I want to immediately start async-ifying my code? Well, async gives... and async takes away.

### Drawbacks of async - should I use it?

Whilst async code can work very well in a lot of cases, there are significant drawbacks. To make my code async, I'd have to rewrite a lot of it. In Python, async methods behave very differently to regular ones; they have to be called and dealt with very differently.

Worse than that, though, is the question of support. If I were to fully rewrite the entire library to make it async and make a new major release of the project (as we discussed in Part 2), I would force my users to rewrite all of their code that uses my SDK! If I didn't want to put my users through this ordeal, I would need to support a synchronous and an asynchronous version of the same code, effectively doubling the size of the codebase. That's twice as much code to test, and if I wanted to add any new features I'd have to add them twice.

There are ways to lighten the load, but adding async support would still be a significant time investment. Overall, async is very powerful, but consider carefully what the use cases are for your codebase. If you think there would be a very significant benefit, consider making things async, but consider it very carefully before committing to deliver it. And if you're a JavaScript programmer who read this section even though this is how your code works anyway, I hope this was insightful, or at least entertaining. 🤷

## Setting up automated tooling

If you really want to invest in the long-term health of your project, you will probably want to set up tooling that helps you write your code, or gives you insight into aspects of it. I mentioned some tools in [Part One of this series](https://developer.vonage.com/blog/22/11/15/improve-your-software-project-part-one-understanding-a-codebase#tooling-that-can-help-you) but let's talk more practically now about applying tooling to your code in an automated way. It's possible to manually run analysis tools etc., but having them run automatically gives you a consistent set of metrics and one fewer thing to worry about when you commit code.

Assuming your code uses version control, it's possible to set up tooling to run when code is pushed/PRs are made, etc. There are many tools to do this. In my case the Vonage Python SDK uses [GitHub Actions](https://github.com/features/actions), which is free for open-source projects hosted on GitHub, and even for private GitHub repos below a certain usage quota.

### Test running and code coverage

In my repo, [I've set up a GitHub Action](https://github.com/Vonage/vonage-python-sdk/blob/main/.github/workflows/build.yml) that runs tests when a push or PR is made, and calculates the code coverage. The advantage of using automation to do this is that I can test on multiple platforms and versions of Python without having to manually set up a VM for each platform and a new virtual environment for each Python version. I'd recommend setting up your tests to run in this way, as you can catch some errors much faster before they get into your production environment.

![Part of the GitHub Action that runs my tests on multiple platforms and multiple versions of Python, whenever I push code to the repo or make a PR](/content/blog/improve-your-software-project-part-three-taking-it-to-the-next-level/github-action-test.png)

### Mutation score

In [Part One of this series](https://developer.vonage.com/blog/22/11/15/improve-your-software-project-part-one-understanding-a-codebase#mutation-score) we briefly discussed the benefits that mutation testing can bring. It can be easy to fall into the code coverage trap of increasing coverage, no matter the cost otherwise. [Goodhart's Law](https://en.wikipedia.org/wiki/Goodhart%27s_law) states that "when a measure becomes a target, it ceases to be a good measure". Developers who get too invested in code coverage metrics tend to sacrifice test quality, for coverage quantity. Mutation score is a way to prevent this from happening.

Mutation score is related to the ability of your tests to be resilient to changes. As we discussed in Part One, mutation tests work by changing your code in subtle ways, then applying your unit tests to these new, "mutant" versions of your code. In order to 





### Vulnerability scanning

If your project is using dependencies, you should know that you're using versions that don't compromise the safety of your users.







## Handing over the project

This series has focused mostly on the situation where you've started to work on a legacy project, but you probably won't be the one responsible for that project forever. At some point, you'll likely hand over the code to somebody else, and it's a good practice to use your final weeks with a project to make sure the handover goes as smoothly as possible.

With 2 weeks until a handover, it's time to stop accepting any new work. Your job at this point should be to create a seamless handover. Finish or discontinue any features and merge or close any open PRs. Ideally, you want to get on to the important process of writing stuff down as soon as you can.

Document the state of the code. This includes making sure READMEs and docs are up to date, in case the code isn't touched for a while, but also: write a handover document! You don't want your successor to have to sift through many open branches of uncommitted code to work out what you were planning. Your handover document should include:

* An overview of the codebase
* How to get started with developing on the project
* Testing overview
* The work you started but didn't finish
* Work that you planned to do, and why
* Anything else that's undocumented or non-obvious

Finally, your successor might reach out to you to discuss the code. Consider engaging with them, if you have time. It's nice to be nice!

## Final thoughts

If you got to this sentence, congratulations! This puts you in a great position to make a project you own as awesome as it can possibly be.

If you have any thoughts you want to share, you can reach out to us on our [Vonage Community Slack](https://developer.vonage.com/community/slack) or send us a message on [Twitter](https://twitter.com/VonageDev). 

Thanks for coming on this journey with me, and good luck with all your future projects.
