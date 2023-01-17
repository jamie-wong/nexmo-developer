---
title: How to Make a Text-to-Speech Phone Call in ASP.NET
description: Learn how to make a Text-to-Speech Phone Call in ASP.NET with the
  Vonage Voice API.
thumbnail: /content/blog/how-to-make-a-text-to-speech-phone-call-in-asp-net/text-to-speech_asp_net.png
author: michael-crump
published: true
published_at: 2023-01-16T01:36:05.997Z
updated_at: 2023-01-16T01:36:06.086Z
category: tutorial
tags:
  - asp.net
  - dotnet
  - voice
comments: true
spotlight: false
redirect: ""
canonical: ""
outdated: false
replacement_url: ""
---
## Introduction

Building a high-quality voice application is easy with the [Vonage Voice API](https://www.vonage.com/communications-apis/voice/). It allows you to make and receive phone calls with your ASP.NET applications amongst other things.

In this tutorial, we are going to set up an ASP.NET project in Visual Studio that uses the Vonage Voice API to make a Text-to-Speech phone call with ASP.NET.

## Prerequisites

Before you begin, make sure you have the following:

* [Visual Studio 2022 - Community Edition or higher](https://visualstudio.microsoft.com/) installed. You may also use a prior version of Visual Studio beginning with Visual Studio 2017.
* [Vonage CLI - Optional](https://www.npmjs.com/package/@vonage/cli) - Once Node.js is installed, you can use `npm install -g @vonage/cli` to install it. This tool allows you to create and manage your Vonage applications without using the Developer Portal.

## Configuring a Vonage application

In order to be able to use the [Vonage Voice API](https://developer.vonage.com/voice/voice-api/overview), you'll have to create a [Vonage Application](https://developer.vonage.com/application/overview) from the developer portal.

A Vonage application contains the security and configuration information you need to interact with the Vonage Voice APIs.

All requests to the Vonage Voice API requires authentication. You must generate a private key with the Application API, which allows you to create JSON Web Tokens (JWT) to make the requests. 

The application's associated public and private keys can be created in two ways:

* Through the [Vonage Developer Portal](https://developer.vonage.com/) 
* Through the [Vonage CLI](https://developer.vonage.com/application/vonage-cli)

For the purpose of this tutorial, we'll use the Vonage Developer Dashboard. 

## The Vonage Developer Dashboard

Log into the Vonage Developer Dashboard, look for the [Application section](https://dashboard.nexmo.com/applications), and from here you can create a new application. Ensure that the **Voice** capability is toggled on as shown below and press **Generate new application**.

![Creating a Voice enabled application](/content/blog/how-to-make-a-text-to-speech-phone-call-in-asp-net/create-voice-application.png "create-voice-application.png")

You can link a number if you choose but it won't be necessary for this tutorial. 

Head back into the application that you just created and press **Generate public and private key** this will prompt you to download your private key as well as populate the public key for you. Please keep this information safe as anyone who has access to it can use your account!

![Creating a Voice app, retrieving the public key](/content/blog/how-to-make-a-text-to-speech-phone-call-in-asp-net/create-voice-application-keys.png "create-voice-application-keys.png")

## ASP.Net Web project setup

Now that we have generated our public/private key pair and our Vonage Voice application through the developer dashboard, let’s look at how we should configure our ASP.NET project in Visual Studio. 

Begin by launching Visual Studio (Community Edition or higher) and selecting Create a New Project, and selecting **ASP.NET Core Web App (Model-View-Controller)** as shown below. 

![Initiating an ASP.Net project](/content/blog/how-to-make-a-text-to-speech-phone-call-in-asp-net/new-asp-net-core-web-app-project.png "new-asp-net-core-web-app-project.png")

Give your project a name and press **Next**. For **Framework**, ensure it is set to **.NET 6.0** and leave the other options as their default settings and press the **Create** button.

![Visual Studio - Additional Settings](/content/blog/how-to-make-a-text-to-speech-phone-call-in-asp-net/additionalinfo.png "AdditionalInfo.png")

## Installing the Vonage .NET SDK

In **Solution Explorer**, right-click **Dependencies** and select **Manage NuGet Packages**. Now select the **Browse** tab and search for **Vonage**. You'll see [Vonage](https://www.nuget.org/packages/Vonage/) appear and press **Install** on the latest stable release (6.03 at the time of this writing). 

![Installing Vonage dependancies](/content/blog/how-to-make-a-text-to-speech-phone-call-in-asp-net/installvonage.png "InstallVonage.png")

## Configuration Settings

Open the **appsettings.json** file that is already added to your project. Inside you will need to add the **appSettings** section as detailed below and fill in the respective field with the data specific to your application. 

* **VONAGE_APPLICATION_ID** - can be found inside the Voice Application that you created earlier inside the Vonage Developer Dashboard.
* **VONAGE_PRIVATE_KEY_PATH** - should be a direct link to your private key path. 
* **VONAGE_FROM_NUMBER** - is the number that you linked to earlier. 

```json
{
  "Logging": {
    "LogLevel": {
      "Default": "Information",
      "Microsoft.AspNetCore": "Warning"
    }
  },
  "appSettings": {
    "VONAGE_APPLICATION_ID": "VONAGE_APPLICATION_ID",
    "VONAGE_PRIVATE_KEY_PATH": "VONAGE_PRIVATE_KEY_PATH",
    "VONAGE_FROM_NUMBER": "VONAGE_FROM_NUMBER"
  },
  "AllowedHosts": "*"
}
```

## Defining the View (UI)

Let's create the page that is presented to the end user now. 

Select **Views** then add a new folder called **Voice**. Within this folder, create a new view called **MakeCall**. Then, add the following code to the page to let the user input a phone number for our application to call and a **Submit** button to submit the form. 

```csharp
@using (Html.BeginForm("MakeCall", "Voice", FormMethod.Post))
{
    <input type="text" name="to" id="to" placeholder="To" />
    <input type="submit" value="Call" />
}
```

Now we will create a link to the View by going to **Views** then **Home** and editing the **Index.cshtml** file with the following contents.

```csharp
@{
    ViewData["Title"] = "Home Page";
}

<div class="text-center">
    <h2>@Html.ActionLink("Create Call", "MakeCall", "Voice")</h2>
</div>
```

## Adding the Controller (Business Logic)

Create a new controller called **VoiceController.cs** in which we'll paste the following code.

```csharp
using Microsoft.AspNetCore.Mvc;
using System.Diagnostics;
using Vonage;
using Vonage.Request;
using Vonage.Voice.Nccos.Endpoints;
using Vonage.Voice;
using Vonage.Numbers;
using Vonage.Voice.Nccos;

namespace TextToSpeechVonage.Controllers
{
    public class VoiceController : Controller
    {
        public IActionResult Index()
        {
            return View();
        }

        [HttpGet]
        public ActionResult MakeCall()
        {
            return View();
        }

        [HttpPost]
        public async Task<ActionResult> MakeCallAsync(string to)
        {
            var VONAGE_FROM_NUMBER = Configuration.Instance.Settings["appsettings:VONAGE_FROM_NUMBER"];
            var VONAGE_TO_NUMBER = to;
            var vonageApplicationId = Configuration.Instance.Settings["appsettings:VONAGE_APPLICATION_ID"];
            var vonagePrivateKeyPath = Configuration.Instance.Settings["appsettings:VONAGE_PRIVATE_KEY_PATH"];
            
            var creds = Credentials.FromAppIdAndPrivateKeyPath(vonageApplicationId, vonagePrivateKeyPath);
            var client = new VonageClient(creds);

            var toEndpoint = new PhoneEndpoint() { Number = VONAGE_TO_NUMBER };
            var fromEndpoint = new PhoneEndpoint() { Number = VONAGE_FROM_NUMBER };

            var talkAction = new TalkAction() { Text = "This is a text to speech call from Vonage! " };
            var ncco = new Ncco(talkAction);

            var command = new CallCommand() { To = new Vonage.Voice.Nccos.Endpoints.Endpoint[] { toEndpoint }, From = fromEndpoint, Ncco = ncco };
            var response = await client.VoiceClient.CreateCallAsync(command);

            return RedirectToAction("MakeCall", "Voice");
        }
    }
}
```

In the **MakeCallAsync** method, we are retrieving the Vonage Application ID, and the path to the Private Key and passing those into the **VonageClient** as **Credentials**. Once the client is instantiated, we specify the phone number that is sending and receiving the call. We then specify the text that we want read to the caller with **TalkAction** and finally create the call asynchronous passing in the endpoints. Once complete, we redirect to our **GET** method called **MakeCall** in the **Voice** Controller.

## Run the App

Now, let's run the app and make a Text-to-Speech phone call.

![Running the app](/content/blog/how-to-make-a-text-to-speech-phone-call-in-asp-net/create-call.png "create-call.png")

When it is successful, it calls the number specified, reads the text, and finally terminates the call.

You may observe some delay before your phone rings depending on your phone carrier.

## Wrap-up

Now that you have learned how to make ASP.NET send a Text-to-Speech call, you could extend this project to having the Voice API respond to text that the caller sent! You also might want to try to check out some of our use cases, such as [this one](https://developer.vonage.com/use-cases/asr-use-case-voice-bot) which creates a bot answering service for an inbound phone call. 

If you have questions or feedback, join us on the [Vonage Developer Slack](https://developer.vonage.com/community/slack) or send me a Tweet on [Twitter](https://twitter.com/mbcrump), and I will get back to you. Thanks again for reading, and I will catch you on the next one!
