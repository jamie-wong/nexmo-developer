---
title: 5 Things You Probably Didn’t Know About Vonage AI Studio
description: Five tips to help anyone to get started with Vonage AI Studio!
thumbnail: /content/blog/5-things-you-probably-did-not-know-about-vonage-ai-studio/5-things_ai-studio.png
author: michael-crump
published: true
published_at: 2022-09-22T07:10:00.000Z
updated_at: 2022-09-22T09:16:36.715Z
category: inspiration
tags:
  - ai-studio
  - low-code
  - no-code
comments: true
spotlight: false
redirect: ""
canonical: ""
outdated: false
replacement_url: ""
---
## Introduction

I was recently introduced to [Studio by Vonage AI](https://dashboard.nexmo.com/studio). For the uninitiated, Studio is a Low/No code virtual assistant builder that allows developers and non-developers alike to design, create and deploy Virtual agents that operate with Natural language understanding. It uses your Vonage API account to create customer engagements over voice, SMS, HTTP and WhatsApp channels.

I built a Virtual Agent for a fictitious event that allowed customers to ask questions regarding event logistics. They would then get a reply with the information requested.

I wrote about my initial experiences in a blog post, "[If You Can Point and Click, Then You Can Make a Conversational AI](https://developer.vonage.com/blog/22/09/13/if-you-can-point-and-click-then-you-can-make-a-conversational-ai)." During that whole process, I came across a number of features that are super-useful. I thought it would be helpful to summarize these features as five tips for anyone getting started with AI Studio!

Let's jump into it!

## Tip #1 - Learn how to easily Export and Import Agents

Maybe you'd like to export your Virtual Agent after creation, keep it on your servers, or import it to a different account. Thankfully, this is straightforward to do. Navigate to your **Agents**  list, click on the three dots next to the agent name and select **Export Agent**.

![Export Agent Option](/content/blog/5-things-you-probably-did-not-know-about-vonage-ai-studio/export-agent.png "export-agent.png")

After a few minutes, you'll receive an email from `ai.vonage.com` with the Subject, "Your Agent is ready!". Click on the download link to save your Agent to your local computer.

![Export Agent Email Sample](/content/blog/5-things-you-probably-did-not-know-about-vonage-ai-studio/export-agent-email.png "export-agent-email.png")

Once you download your Agent, you can import it back into AI Studio anytime. If you are curious as to what the `.zip` file contains, you'll see the following structure:

```text
C:\Vonage\ai-structure>tree /f
Folder PATH listing
Volume serial number is F650-8A54
C:.
│   Agent.json
│   nlu-application.zip
│   version.json
│
└───files
```

Below is a summary of what each file does:

* The `Agent.json` contains information about the Agent that you specified during the Agent creation process. Items such as the Agent Name, Language, TimeZone, etc.
* The `nlu-application.zip` contains two files: the `<id>.json` and a `signature.sig`. The `<id>.json` contains application-specific information, `intents`, and `entities`, whereas the `signature.sig` is the application's signature.

The `version.json` contain information specific to the different versions that your Agent has. There is more to come on this topic later.

Now that we know how to **Export an Agent** let's cover **Importing** one.

Next, to import your agent, log into your desired Studio account and click on the Import agent button on the top right of your screen. It should be right next to the **Create Agent** button.

![Import Agent Option](/content/blog/5-things-you-probably-didn’t-know-about-vonage-ai-studio/import-agent.png "import-agent.png")

You can now go ahead and upload the agent file that you previously downloaded here, You will also have the opportunity to update the following information:

* Agent Name: Give your Agent a unique name you haven't used before.
* Region: Where will your Agent typically be used - The USA or Europe?
* Time Zone: Choose the time zone where your Agent will operate.

![Import Agent Dialog Box](/content/blog/5-things-you-probably-did-not-know-about-vonage-ai-studio/import-agent-dialog.png "import-agent-dialog.png")

Finally, click on the **Import Agent** button on the top right. Your new agent will now be listed on the Agents dashboard.

![Imported Agent Successfully](/content/blog/5-things-you-probably-did-not-know-about-vonage-ai-studio/agent-imported-successfully.png "agent-imported-successfully.png")

**Note** - After creating your Agent, you will need to assign a new phone number in order to publish it.

## Tip #2 - Reporting features for past channel conversations

Sometimes you need to view past What's App, SMS, HTTP conversations between a user and your virtual Agent for reporting or troubleshooting purposes. Select the **Agent** from which you want to view the conversation data and click on **Reports** from the top menu navigation.

![Reports](/content/blog/5-things-you-probably-did-not-know-about-vonage-ai-studio/reports.png "reports.png")

You can filter reports by **Session ID** or the **Caller Number**. Regardless of which item is selected, you'll see a **Search** box where you can enter information.

![Filter Reports](/content/blog/5-things-you-probably-did-not-know-about-vonage-ai-studio/filter-report.png "filter-report.png")

Before you search, you'll see a **Generate Report** option on the right-hand side that allows you to filter the data shown. You will have the following options:

* Region: The USA or Europe
* Report Type: A variety of different [options](https://studio.docs.ai.vonage.com/ai-studio/reports) depending on your needs
* Date and Time: The Start Date and the End Date
* Agents: Which Virtual Agents would you like to run the report?
* Time Zone: The time zone that you'd like to filter.
* Report State: You can choose between **Success**, **Warning**, **Error**, or **All**.

![Generate Report Filter Options](/content/blog/5-things-you-probably-did-not-know-about-vonage-ai-studio/generate-report.png "generate-report.png")

Once you press **Apply**, you will see if the data exists, as shown below.

![Reports Results](/content/blog/5-things-you-probably-did-not-know-about-vonage-ai-studio/report-results.png "report-results.png")

If you click on the **ID**, you'll see details such as the **Caller phone**, **Agent phone**, **Session ID**, and a **Transcript** of the recorded conversation.

![Reports Details](/content/blog/5-things-you-probably-did-not-know-about-vonage-ai-studio/report-details.png "report-details.png")

You can also view the **Parameters** data captured and review the **Flow Path** that the Virtual Agent took them through. Very cool!

## Tip #3 - You can quickly go back to previous versions of an Agent

The canvas in AI studio is typically where you do a majority of your work and it is called the Editor mode. But once you are ready to connect your Agent to a live environment, you will have to publish the Agent.

Sometimes after publishing your Agent, you might wish to go back to a previous version to revert a change. If you click on the three dots on the top of the page next to the Agent's name, you will see an option labeled **Versions**.

![Versions Option](/content/blog/5-things-you-probably-did-not-know-about-vonage-ai-studio/versions.png "versions.png")

Once clicked the canvas will display all the different agent versions you have created so far. You will be able to see the differences between the published agent and draft versions. By default, the current view will be your most recent published version.

![Click on Versions](/content/blog/5-things-you-probably-did-not-know-about-vonage-ai-studio/click-on-versions.png "click-on-versions.png")

If you want to revert to a previous version, you can click on the three dots next to the version and select "**Open in editor**." We'll do this for **Version 1** (as shown in the previous screenshot) of our SMS Virtual Agent.

![Open in Editor](/content/blog/5-things-you-probably-did-not-know-about-vonage-ai-studio/open-in-editor.png "open-in-editor.png")

A warning will pop up notifying you that any unsaved changes will be lost if you proceed.

![Dialog to Save New Version](/content/blog/5-things-you-probably-did-not-know-about-vonage-ai-studio/dialog-save-new-version.png "dialog-save-new-version.png")

 Click "Back to Editor" on the top left to begin working with the previous version.

![Restored Version](/content/blog/5-things-you-probably-did-not-know-about-vonage-ai-studio/restored-version.png "restored-version.png")

## Tip #4 - Would you prefer an actual voice vs. using text-to-speech?

AI Studio's Text-to-speech (powered by Amazon Polly voices) offers a wide variety of human-sounding voices with different accents, however in the case that you would prefer to give your customers a human voice vs. using text-to-speech for your conversation flow. You can do this simply by looking under **Properties**, then **Recordings**.

NOTE: Recordings is only for telephony.

![Recordings Option](/content/blog/5-things-you-probably-did-not-know-about-vonage-ai-studio/recordings.png "recordings.png")

You can **Drag and Drop** an audio file on the **Recordings** dialog.

![Recordings Dialog](/content/blog/5-things-you-probably-did-not-know-about-vonage-ai-studio/recordings-dialog.png "recordings-dialog.png")

**Quick Tip:** Please note that the supported file types are wav, mp3, and ogg and that files may not be larger than four MB in file size.

Once you've uploaded your file, you can preview it and see a **Transcript** of the audio.

![Uploaded Recording](/content/blog/5-things-you-probably-did-not-know-about-vonage-ai-studio/uploaded-recording.png "uploaded-recording.png")

Using a **Telephony** Agent, you'll see the **Speak** node under **Conversation**. Select this and drag and drop it onto the designer.

![Speak Node](/content/blog/5-things-you-probably-did-not-know-about-vonage-ai-studio/speak-node.png "speak-node.png")

Click on **Speak 1**, and you'll see an option to select **Audio**. Under **Use Recording**, you'll see the recording  you uploaded from the earlier step.

![Selecting an Audio Recording](/content/blog/5-things-you-probably-did-not-know-about-vonage-ai-studio/selecting-audio-recording.png "selecting-audio-recording.png")

Select **Done** and then **Save & Exit**.

![Speak Node Connected](/content/blog/5-things-you-probably-did-not-know-about-vonage-ai-studio/speak-1-connected.png "speak-1-connected.png")

## Tip #5 - Integrations

Sometimes you will need to integrate with a third-party service to send and receive data. Vonage AI Studio has several **Integration** nodes that you can use.

![Integrations](/content/blog/5-things-you-probably-did-not-know-about-vonage-ai-studio/integrations.png "integrations.png")

There are three main types at the time of writing this blog post:

1. Webhook - It supports multiple ways to send an API request, such as **GET, POST, PUT, DELETE, and PATCH**. It also provides support for **HTTP headers** and **Response Mapping**.

A built-in way to test your Webhook is by clicking on **Test Request** on the top right of the node settings.

![WebHook](/content/blog/5-things-you-probably-did-not-know-about-vonage-ai-studio/webhook.png "webhook.png")

2. Salesforce Authentication - This node handles the required authentication to access your Salesforce domain.

![Salesforce Authentication](/content/blog/5-things-you-probably-did-not-know-about-vonage-ai-studio/salesforce-authentication.png "salesforce-authentication.png")

3. Salesforce Actions - The Salesforce Action node allows you to retrieve, create and update a record via SOQL query.

![Salesforce Actions](/content/blog/5-things-you-probably-did-not-know-about-vonage-ai-studio/salesforce-actions.png "salesforce-actions.png")

## Wrap-up

There you have it! You know five more things about Vonage AI Studio to help you get started. If you haven't explored [Vonage AI Studio](https://studio.ai.vonage.com/), I will encourage you to do so, and please share your unique creation with us!

As always, if you have questions or feedback, join us on the [Vonage Developer Slack](https://developer.vonage.com/community/slack) or send me a Tweet on [Twitter](https://twitter.com/mbcrump), and I will get back to you. Thanks again for reading, and I will catch you on the next one!
