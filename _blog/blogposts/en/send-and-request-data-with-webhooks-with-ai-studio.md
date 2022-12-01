---
title: Send and Request Data With Webhooks With AI Studio
description: Learn how to send and request data with webhooks with Vonage AI Studio
thumbnail: /content/blog/send-and-request-data-with-webhooks-with-ai-studio/send-request-data_webhooks_ai-studio.png
author: michael-crump
published: true
published_at: 2022-11-29T11:09:10.243Z
updated_at: 2022-11-29T11:09:11.171Z
category: tutorial
tags:
  - rest
  - ai-studio
comments: true
spotlight: false
redirect: ""
canonical: ""
outdated: false
replacement_url: ""
---
## Introduction

[Vonage AI Studio](https://www.vonage.com/communications-apis/ai-studio/?icmp=l3nav%7Cl3nav_gototheaistudiooverviewpage_novalue) is a Low-Code / No-Code conversational AI platform that helps businesses handle complex customer interactions through voice and text. As you create virtual agents with AI Studio, it won't take long before you need to retrieve data from a third-party source such as a Webhook. In this blog post, you'll learn: 

* How to retrieve data from a Webhook in AI Studio from a REST Endpoint
* How to store the data as a parameter (for later use)
* Examples of conditional statements to perform operations with the data

To understand how to interact with a Webhook in AI Studio, we'll use a scenario where a bank would like to validate a customer's identity by matching a pin number with the number retrieved from a Webhook. 

## Understanding the Payload Data

Below is a snippet of what data is returned in our sample payload:

```json
[
  ...
  {
    "id": 4,
    "email": "michael.crump@vonage.com",
    "phone": "14259999999",
    "name": "Michael Crump",
    "cc_balance": "76.31",
    "pin": "1234"
  }
]
```

Once the customer dials the Bank's phone number, we'll use the **phone** number to look up the correct value for the **pin** via this Webhook. 


## Integrating the [Webhook](https://studio.docs.ai.vonage.com/voice/nodes/integrations/webhook)

At this point, you have already created an AI Studio project that uses an **Inbound** call. If you still need to, then please follow this [guide](https://studio.docs.ai.vonage.com/voice/get-started). Scroll down from the **Nodes** menu until you get to **Integrations**, select **Webhook**, and drag and drop that onto your canvas. 

![Integrations Dialog](/content/blog/send-and-request-data-with-webhooks-with-ai-studio/integrations.png "integrations.png")

Click on the newly created Webhook event, as you will need to provide your endpoint URL. 

Since we will query based on the phone number, we'll use the following hardcoded URL (which points to a specific phone number): `https://my-json-server.typicode.com/mbcrump/ai-studio-api/customers?phone=14259999999`. Once you've added it, then press [**Test request**](https://studio.docs.ai.vonage.com/voice/nodes/integrations/webhook#how-to-test-the-webhook-node) as shown below. 

> If you'd like to learn more about the Chatbot Tester, then click [here](https://studio.docs.ai.vonage.com/ai-studio/chatbot-tester).

![Testing our Webhook call](/content/blog/send-and-request-data-with-webhooks-with-ai-studio/test-webhook-1.png "test-webhook-1.png")

If you see a status of 200, that means the request returned successfully (You can see in the **Response** the information we got back based on this user's phone number (which was hardcoded).

While this data was hardcoded in the query URL, how does AI Studio pass this information based on the number that is called in? This is where we'll use one of the predefined [system parameters](https://studio.docs.ai.vonage.com/properties-1/parameters#system-parameters) called **CALLER_PHONE_NUMBER,** as shown below.

![Testing our Webhook call](/content/blog/send-and-request-data-with-webhooks-with-ai-studio/system_parameters.png "system_parameters.png")

You can trigger this dialog by pressing the `$` and selecting the system parameter you wish to use. Now our URL is `https://my-json-server.typicode.com/mbcrump/ai-studio-api/customers?phone=$CALLER_PHONE_NUMBER`.

Once complete, remember to press **Save & Exit**. 

![Testing our Webhook call](/content/blog/send-and-request-data-with-webhooks-with-ai-studio/webhook-with-phone-number.png "webhook-with-phone-number.png")

If we try to test the WebHook now, you'll get a 200 status code, but there won't be any data inside the response.

![No Data Returned](/content/blog/send-and-request-data-with-webhooks-with-ai-studio/no-data-returned.png "no-data-returned.png")

We can fix this by clicking the **Settings** icon and specifying a **CALLER_PHONE_NUMBER,** as shown below. 

![Specifying a Phone Number](/content/blog/send-and-request-data-with-webhooks-with-ai-studio/setting-system-parameters.png "setting-system-parameters.png")

Now, if you press **Resend request**, you will get a proper response, as shown below.

![Resent Webhook Request](/content/blog/send-and-request-data-with-webhooks-with-ai-studio/successful-response.png "successful-response.png")

## [Setting up Parameters to Do Something With the Data Returned](https://studio.docs.ai.vonage.com/properties-1/parameters)

Now that we can call a WebHook from AI Studio and return data, we will use **Parameters** to extract and utilize specific information from the user’s input. For example, To collect a user's information (i.e., PIN or Account Balance), you need to define a parameter that will store the information so that it can be accessed later. 

To **Create** a parameter, in the left navigation, click on **Properties** then **Parameters**. 

![Parameters Selection](/content/blog/send-and-request-data-with-webhooks-with-ai-studio/parameters-selection.png "parameters-selection.png")

Add a parameter by clicking on the first row of the **Custom Parameters** table.

We need to add four parameters here to store the PIN that belongs to the customer, the PIN that the customer typed in, the customer's name, and the account balance in case they successfully entered a pin number.

| Name         | Entity Type  |
| ------------ | ------------ |
| pin_number   | @ sys.number |
| input_number | @ sys.number |
| name         | @ sys.any    |
| balance      | @ sys.number |

Your screen should look like the following once complete: 

![Custom Parameters](/content/blog/send-and-request-data-with-webhooks-with-ai-studio/parameters.png "parameters.png")

Press **Close** once all the information has been entered.  

Click on **Webhook 1** again and look under **Response Mapping**. Here we'll enter the first **Object path** as `[0][name]` and give it the **parameter** we created called **name**. 

![Response Mapping](/content/blog/send-and-request-data-with-webhooks-with-ai-studio/response-mapping.png "response-mapping.png")

We'll collect the **balance** and **PIN** while we are here. 

After you add them, your screen should look like the following: 

![Response Mapping](.//content/blog/send-and-request-data-with-webhooks-with-ai-studio/response-mapping-1.png "response-mapping-1.png")

Once complete, do not forget to press **Save & Exit**. 

We will use a [**Collect Input**](https://studio.docs.ai.vonage.com/voice/nodes/basic/collect-input) node to ask the user for their PIN. Go ahead and drag and drop the node from the **Conversation** menu. 

![Collect Input Node](/content/blog/send-and-request-data-with-webhooks-with-ai-studio/collect-input.png "collect-input.png")

For the **Parameter**, use the **input_number** that we defined earlier. For **Prompts**, enter "Enter your four-digit pin number to access your account." or something similar, as shown below. 

![Collect Input Node](/content/blog/send-and-request-data-with-webhooks-with-ai-studio/parameter-input-number.png "parameter-input-number.png")

Now we will connect the **Webhook 1** to the **Collect Input 1** node as shown below. 

![Connect Webhook Collect Input](/content/blog/send-and-request-data-with-webhooks-with-ai-studio/connect-webhook-collect-input.png "connect-webhook-collect-input.png")

Drag and drop a [**Condition**](https://studio.docs.ai.vonage.com/voice/nodes/basic/conditions) node from the **Conversation** menu. Click on "Default" inside the note and press **Create Condition**. 

As shown below, we will create a condition that checks if the **Input Number** they entered matches the **PIN** from our Webhook.

![Condition Requirements](/content/blog/send-and-request-data-with-webhooks-with-ai-studio/condition-req.png "condition-req.png")

Once complete, do not forget to press **Save & Exit**.

Drag and drop two more **Speak** Conversation Nodes onto the canvas. For the **Speak 2** node, enter the message, `Verification Successful Welcome $name. Your balance is $balance.` Where `$name` is the parameter that we defined earlier.

![Speak 2 Node](/content/blog/send-and-request-data-with-webhooks-with-ai-studio/speak-2-node.png "speak-2-node.png")

For the **Speak 3** node, enter the message, "I'm sorry that was not correct." where `$name` is the parameter that we defined earlier. Once complete, press Enter and do not forget to press **Save & Exit**. 

Finally, add an [**End call**](https://studio.docs.ai.vonage.com/voice/nodes/actions/end-call) node onto the canvas. 

Now you need to connect the **Condition 1** (New Condition) to **Speak 2** and **Condition 1** (Default) to **Speak 3**. Then connect **Speak 2** and **Speak 3** to the **End Call 1** node, as shown below. 

![Final Result](/content/blog/send-and-request-data-with-webhooks-with-ai-studio/final-result.png "final-result.png")

Press the **Tester** button at the top right of the screen, then select **Inbound call** as the event, then **Start chat**. You'll need to set the initial parameters as we did earlier for the **CALLER_PHONE_NUMBER** and set it to `14259999999`. 

![Set Inital Parameters](/content/blog/send-and-request-data-with-webhooks-with-ai-studio/set-initial-parameters.png "set-initial-parameters.png")

Now, if you re-run the tester tool, you can supply a four-digit number (such as 1234), and the Virtual Agent will return your **Name**, and **Account Balance** found from the `db.json` file as shown below.

![Tester Chat Completed](/content/blog/send-and-request-data-with-webhooks-with-ai-studio/tester-chat-completed.png "tester-chat-completed.png")

Awesome! We've successfully implemented a Webhook and created logic with what the data returned. 

## Wrap-up

Now it is your turn. There are several ways that we could extend the application, such as:

* The logic for an instance when no PIN is found
* Webhook Authentication for security purposes such as authentication tokens, etc.
* Maximum number of retries in case of a failed attempt

What are you waiting for? Head over to [AI Studio](https://www.vonage.com/communications-apis/ai-studio/?icmp=l3nav%7Cl3nav_gototheaistudiooverviewpage_novalue)  to begin your journey. 

If you have questions or feedback, join us on the [Vonage Developer Slack](https://developer.vonage.com/community/slack) or send me a Tweet on [Twitter](https://twitter.com/mbcrump), and I will get back to you. Thanks again for reading, and I will catch you on the next one!
