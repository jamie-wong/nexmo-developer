---
title: Before You Begin
navigation_weight: 1
---

# Before You Begin

## What are Code Snippets?

Code snippets are short pieces of code you can reuse in your own applications.
The code snippets use code from [example repositories](https://github.com/topics/nexmo-quickstart).

Please read this information carefully, so you can best use the code snippets.  

## Prerequisites

#### Vonage Developer Account

If you don’t have a Vonage account yet, you can get sign up for one here: [Vonage Developers Account](https://ui.idp.vonage.com/ui/auth/registration?icid=tryitfree_adpdocs_nexmodashbdfreetrialsignup_inpagelink).

#### Application ID and Private Key

Once you’re logged in to the [Vonage API Dashboard](https://dashboard.nexmo.com), click on Applications and create a new Application. Generate a public and private key and record the private key.

Also ensure that the Meetings API is enabled for your application under 'Capabilities':

![Enable the Meetings API for your application using the dashboard](/images/meetings/meetings-application.png)

#### JSON Web Token (JWT)

JWTs are used by the Meetings API to authenticate your requests. Use the [JWT Generator](https://developer.vonage.com/jwt) to create a JWT using the Application ID and Private Token mentioned above.

For further details about JWTs, please see [Vonage Authentication](/concepts/guides/authentication).
