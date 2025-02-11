---
title: Contact Center
products: client-sdk
description: How to build your own contact center application.
languages: 
    - Node
---

# Build Your Own Contact Center

In this use case, you’ll learn how to build an application with contact center features.

Your contact center application has two agents: `Jane` and `Joe`, that are users of your client-side application. Your agents make and receive in-app calls, whereas the caller can use a regular phone.

To achieve that, this guide consists of three parts:

1. [**A server-side application**](#set-up-your-backend), for fundamental server-side functionalities, such as managing users and authorization. This is implemented with the [Conversation API](/conversation/overview).

2. [**A client-side application**](#set-up-your-client-side-application), for your contact center users to log in, make and receive calls. This can be a web, iOS or Android application, which integrates [Vonage Client SDK](/client-sdk/in-app-voice/overview).

3. [Adding advanced voice capabilities](#add-voice-functionality), utilizing the [Voice API](/voice/voice-api/overview) on your backend side application.

> **NOTE:** Under the hood, the Voice API and Client SDK both use the Conversation API. That means that all communication is done over a [Conversation](/conversation/concepts/conversation). That allows you to maintain the communication context of your users, for any communication channel. All of the Conversations and the [Events](/conversation/concepts/event) are accessible for you to utilize, through [Conversation API](/conversation/overview).

## Before You Begin

Make sure you have a Vonage account, or [sign up](https://ui.idp.vonage.com/ui/auth/registration?icid=tryitfree_adpdocs_nexmodashbdfreetrialsignup_inpagelink) to get started for free!

## Set Up Your Backend

To use the Client SDK you must have a backend application that uses [Conversation API](/conversation/overview). Some functionality, like managing users can only be done through the backend. Other capabilities, such as creating Conversations, can be done by both client and server side.

### Deploy Your Server Side Application

You may implement any backend that you'd like to use for [the required Conversation API functionality](/conversation/guides/application-setup).

However, to help you get started with this guide, you can use our demo sample backend application.

#### Ruby on Rails Version

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy?template=https://github.com/nexmo-community/contact-center-server-rails)

Fork or contribute to this project, which is open source and available on [GitHub](https://github.com/nexmo-community/contact-center-server-rails).

#### Node.js Version

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy?template=https://github.com/nexmo-community/contact-center-server-node)

Fork or contribute to this project, which is open source and available on [GitHub](https://github.com/nexmo-community/contact-center-server-node).

### Create a Vonage Application

Once you have created a Vonage Account you will be able to create multiple [Vonage Applications](/conversation/concepts/application). A Vonage Application can contain a unique set of [Users](/conversation/concepts/user) and [Conversations](/conversation/concepts/conversation).

After deploying the demo backend application on the previous step, you will need to:

1. Log in using your *api key* and *api secret*, which you can obtain from [the Dashboard](https://dashboard.nexmo.com/)
![Login](/images/client-sdk/contact-center/login.png)

2. Create a new Vonage Application by typing an application name and clicking *Create*
![Setup](/images/client-sdk/contact-center/setup.png)

> That uses [Vonage Applications API](/api/application.v2). The demo application sets the required webhooks and exposes them for your ease of use. More on that will be mentioned below.

### Connect a Vonage Number

In order to make and receive calls, you should rent a [Vonage Number](/numbers/overview) and connect it to your Vonage Application.

Use our demo backend application, navigate to the **Numbers** tab on the top bar, and search for a number.

![Number search](/images/client-sdk/contact-center/numbers-search.png)

After you rented the number, assign it to the Vonage Application you've created.

![Number assign](/images/client-sdk/contact-center/numbers.png)

> For more features and number management, read more on [Numbers API](/numbers/overview) or visit the [dashboard](https://dashboard.nexmo.com/buy-numbers).

### Create Users

A [user](/conversation/concepts/user) can log in to your application in order create a conversation, join a conversation, make and receive calls and more.

For the purpose of this guide, you will use two users one with the name `Jane` and another user with the name `Joe`. Each represents an agent that can log in to your contact center application.

To create users, on the demo backend application interface, on the top menu select **Users** and then **New User**.

![New User](/images/client-sdk/contact-center/users-new.png)

Behind the scenes it uses [Conversation API](https://developer.nexmo.com/api/conversation#createUser).

For simplicity, the demo application creates users as they attempt to log in.

### Authenticate Users

The Vonage Client SDK uses [JWTs](https://jwt.io/) to authenticate a user when logging in to the SDK and the API. These JWTs are generated using the application ID and private key that is provided when a new Vonage application is created.

For security reasons, your client app should not hold your private key. Therefore, the JWT must be provided by your backend.

Your backend should expose an endpoint that would allow the client-side app to request a valid JWT per user. In a real life scenario, you would probably add an authentication system, in order to ensure the identity of the user who attempts to log in to your app.

For the purpose of this guide, the backend demo application exposes an endpoint which accepts the username and API key provided by the demo application:

```
POST YOUR_BACKEND/api/jwt
```

The payload in the body of this request is as follows:

```
Payload: {"mobile_api_key":"xxxxxxx","user_name":"Jane"}
```

The `mobile_api_key` can be found in the `SDK Integration` page, as a rudimentary security mechanism.

> For more information on implementing the authentication system for a real life use case, you can [read this topic](/conversation/guides/user-authentication).
> You can read more about JWTs and ACLs [in this topic](/conversation/concepts/jwt-acl).

## Set Up Your Client-Side Application

### Choose Your Client App

Vonage Client SDK supports web (JavaScript), iOS and Android.

You may [integrate the SDK](/client-sdk/setup/add-sdk-to-your-app) to your own client-side application and [add in-app voice functionality](/client-sdk/in-app-voice/guides/make-call).

However, to get started you may clone and run one of the demo client-side applications.

#### iOS (Swift) Version

Download, fork or contribute to this project, which is open source and available on [GitHub](https://github.com/nexmo-community/contact-center-client-swift).

#### Android (Kotlin) Version

Download, fork or contribute to this project, which is open source and available on [GitHub](https://github.com/nexmo-community/contact-center-client-android-kt).

#### Web (JavaScript/React) Version

Download, fork or contribute to this project, which is open source and available on [GitHub](https://github.com/nexmo-community/contact-center-client-react).

> **Important:**  After cloning, make sure you check the `README` file and update the required client-side app configurations.

### Run Your Client App

At this point you have a client-side application and a backend application to support it.

You can run the client app on two different devices, and log in as the user `Jane` on one device and the user `Joe` on the other.

You are now ready to make and receive calls, and add other advanced voice functionality with the Voice API.

## Add Voice Functionality

Upon Vonage application creation, you assign an `answer_url` [webhook](/concepts/guides/webhooks) to it. The `answer_url` contains the actions that will execute as soon as a call is placed to the Vonage number assigned to your Vonage application. Those actions are defined in the JSON code the `answer_url` returns, which follows the structure of a [Nexmo Call Control Object (NCCO)](/voice/voice-api/ncco-reference).

Updating the NCCO that returns from your `answer_url` changes the call functionality and allows you to add rich capabilities to your contact center application.

The backend demo application already set the `answer_url` endpoint for you. To update the NCCO content and functionality it enables, navigate to  **App Settings** on the top menu. You will find buttons that have sample NCCOs, as well as a button to provide a custom one.

### Receive a Phone Call

For the primary use case, when a caller calls your contact center application, connect the call to the agent `Jane`, which will receive the call in-app.

Clicking the `Inbound Call` button will result in an NCCO as follows:

```json
[
    {
        "action": "talk",
        "text": "Thank you for calling Jane"
    },
    {
        "action": "connect",
        "endpoint": [
            {
                "type": "app",
                "user": "Jane"
            }
        ]
    }
]
```

Try this out by executing the following steps:

1. Run your client-side app.
2. Log in as `Jane`.
3. On another phone, call the Vonage number assigned to your Vonage application.
4. Receive the call on the client-side app.

### Make a Phone Call

To allow a logged in user, for example the agent `Jane`, to call from the app to a phone number, click the `Outbound Call` button. That results in an NCCO as follows:

```json
[
    {
        "action": "talk",
        "text": "Please wait while we connect you."
    },
    {
        "action": "connect",
        "timeout": 20,
        "from": "YOUR_NEXMO_NUMBER",
        "endpoint": [
            {
                "type": "phone",
                "number": "PARAMS_TO"
            }
        ]
    }
]
```

>**Note:** `PARAMS_TO` will be replaced at runtime with the phone number the app user dials in with. The app passes this number to the SDK, which passes this number as a parameter in the `answer_url` request parameters. The demo backend application takes that parameter and replaces it with the `PARAMS_TO` in this NCCO, on your behalf. To read more about passing parameters through `answer_url` [in this topic](/voice/voice-api/webhook-reference#answer-webhook-data-field-examples).

Try it! If you are already logged in, tap the "Call" button in the client app. A call will be placed from the app to the phone number you configured in the NCCO.

### Create an Interactive Voice Response (IVR)

IVR allows you to direct the call according to user's input. For instance, if the caller presses the `1` digit, call is directed to the agent `Jane`. Otherwise, if the caller presses `2` the call is directed to the agent `Joe`.

To implement that, click the `IVR` button to result in an NCCO as such:

```json
[
    {
        "action": "talk",
        "text": "Thank you for calling my contact center."
    },
    {
        "action": "talk",
        "text": "To talk to Jane, please press 1, or, to talk to Joe, press 2."
    },
    {
        "action": "input",
        "eventUrl": ["DTMF_URL"]
    }
]
```

In the NCCO, the `input` action collects the digit that the user pressed, and sends it to the indicated `eventUrl`. That `eventUrl` is another NCCO that is executed to continue to handle the call, according to the user input. In this case, `DTMF_URL` is an endpoint that is implemented and exposed on your behalf by the backend demo application, to connect the call to the respective agent.

For this example the NCCO merely connects the caller to the respected agent. The `DTMF_URL` is very similar to the one you have seen previously:

```json
[
    {
        "action": "talk",
        "text": "Please wait while we connect you to Jane"
    },
    {
        "action": "connect",
        "endpoint": [
            {
                "type": "app",
                "user": "Jane"
            }
        ]
    }
]
```

The NCCO that will be executed to connect to `Joe` is similar, except for the user name.

1. Run two different instances of your client-side app, on two emulators, devices or browser tabs.
2. Log in as `Jane` in one instance, and log in as `Joe` on the other instance.
3. On another phone, call the Vonage number assigned to your Vonage application.
4. On the phone call, press the digit of the agent you want to connect to.
5. Receive the call on the client app, of the agent you asked to be connected to.

## Custom NCCO

You are encouraged to explore more [NCCO capabilities](/voice/voice-api/ncco-reference), and update the sample NCCOs used above, by clicking on the `Custom` button.

## Summary

Congratulations! You now have a running contact center application!

You have:

* Used a backend application that enables user management, authorization, webhooks and more.
* Used a client-side application, that uses NexmoClient SDK to make and receive in-app calls.
* Enabled voice capabilities by updating the NCCO returned by your Vonage application `answer_url`.

## What's Next?

* [Learn more about event flow between the different Vonage components](/conversation/guides/event-flow).
* [Learn more about the required components when setting up your Conversation API and Client SDK application](/conversation/guides/application-setup).
* [Add push notification to your mobile app](/client-sdk/setup/set-up-push-notifications).

## Reference

* Explore [Client SDK](/client-sdk/overview)
* Explore [Voice API](/voice/voice-api/overview)
* Explore [Conversation API](/conversation/overview)
