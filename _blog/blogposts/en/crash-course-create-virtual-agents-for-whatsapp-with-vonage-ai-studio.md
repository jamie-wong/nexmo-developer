---
title: "Crash Course: Create Virtual Agents for WhatsApp with Vonage AI Studio"
description: An overview of creating automated WhatsApp conversation flows with
  Vonage AI Studio. Learn about the different message types and use cases.
thumbnail: /content/blog/crash-course-create-virtual-agents-for-whatsapp-with-vonage-ai-studio/aistuido_whatsapp.png
author: sejal-dsouza
published: true
published_at: 2022-09-01T07:13:49.000Z
updated_at: 2022-09-01T07:13:50.068Z
category: inspiration
tags:
  - ai-studio
comments: true
spotlight: false
redirect: ""
canonical: ""
outdated: false
replacement_url: ""
---
Companies are increasingly looking at expanding the number of channels through which they communicate and keep in touch with customers. To help businesses meet the diverse communication needs of their client base, Vonage AI has begun to prioritize multi-channel offerings with their virtual assistants.

In addition to our Voice and HTTP virtual assistants, the [Vonage AI Studio](https://www.vonage.com/communications-apis/ai-studio/?icmp=l3nav|l3nav_gototheaistudiooverviewpage_novalue) platform (a low-code virtual agent builder) also offers you the ability to create agents for WhatsApp and SMS. Let's take a quick look at some of the nifty features available on our WhatsApp agent type.

## Message Types

Taking full advantage of the features already available on WhatsApp, our virtual agents can process numerous message formats on the platform.

In addition to the regular text input and output, our virtual assistants can also handle images, text, audio, files, and location, as both agent utterances and user responses.

### Images

Images are a great way to share visual evidence to resolve customer issues. One use case could be when end users need to upload images of damaged belongings or property as part of an insurance claim workflow. It is also possible for images to be sent from the virtual agent side, for example when providing evidence of a delivered package.

![Screenshot showing a WhatsApp Send Message flow in Vonage AI Studio with the Speak node being edited and type Image selected. The node is named 'Greeting' and the image is a of a puppy being held by an animal rescue agent](/content/blog/crash-course-create-virtual-agents-for-whatsapp-with-vonage-ai-studio/send-message-node-image-screenshot.png "Screenshot of AI Studio Send Message node with an Image message type selected")

### Audio

Audio files are an accepted input and output type. This file type can be particularly useful for improving accessibility for visually impaired users. The ability to upload voice notes for situations where audio inputs need to be stored makes this an effective feature, especially in the absence of a good phone network. We can also use ASR (Automated Speech Recognition) to transcribe audio inputs from users.

### Files

Your users can upload files if necessary through your WhatsApp virtual assistants. This is useful in cases where user files are required to be uploaded and stored. By uploading the file directly on the agent, it saves your user the hassle of having to be redirected elsewhere to upload the file. It's also possible to send files to a user. You could, for example, you can send your user a movie ticket, restaurant menu, etc. via the agent without leaving the conversation.

### Location

You can either send locations to your end users or receive them without ever having to leave WhatsApp. Some use cases for this include sending out the location of the closest brick-and-mortar store or knowing the exact location of your user to send roadside assistance.

![Screenshot of AI Studio Collect Input node with a Location message type selected](/content/blog/crash-course-create-virtual-agents-for-whatsapp-with-vonage-ai-studio/collect-input-location-screenshot.png "Screenshot of AI Studio Collect Input node with a Location message type selected")

💡 **Conversational Design Tip** 💡:  You can send out a predefined location to your end user by choosing 'map' once you have selected 'location' and entering the exact location you desire. Be sure to check if the location is correct before publishing the virtual agent since the maps are provided by Google Maps API.

💻Tech Tip💻: If you select "Audio", you can choose between a regular audio recording as well as the option to transcribe it to text. To transcribe the input, select the ASR symbol on the top right of the "Audio" box.

## List Messages and Reply Buttons

The virtual assistant can also send out both list messages and reply buttons to enhance the user experience. You can enable this feature by simply clicking on the message type in the [Collect Input node](https://studio.docs.ai.vonage.com/whatsapp-chatbot/whatsapp-chatbot/nodes/collect-input).

![Screenshot of a WhatsApp conversations showing a Reply Button. The virtual agent asks a question 'What issue would you like to report today?' with the reply button options 'Sick Animal', 'Injured or Trapped', and 'Cruelty or Neglect'](/content/blog/crash-course-create-virtual-agents-for-whatsapp-with-vonage-ai-studio/whatsapp-reply-button-screenshot.jpg "Screenshot of a WhatsApp conversations showing reply buttons")

![Screenshot of a WhatsApp conversations showing a List Message Button. The list category is 'Owner of Animal' with the list options 'My Pet', 'Stray or Abandoned', 'No Known Owner', and 'Owned by Someone Else'](/content/blog/crash-course-create-virtual-agents-for-whatsapp-with-vonage-ai-studio/whatsapp-list-message-screenshot.png "Screenshot of a WhatsApp conversations showing List Message")

💡 **Conversational Design Tip** 💡 :  Make sure to access the [Vonage AI Studio documentation](https://studio.docs.ai.vonage.com/whatsapp-chatbot/whatsapp-chatbot/nodes/collect-input) to understand what kind of information to enter under the various headers for buttons and list messages.

💻 **Tech Tip** 💻: You can also use a JSON code to create your own custom dynamic buttons, perhaps something like:

```json
[
  {
    "title": "Customer Support",
    "value": "support"
  },
  {
    "title": "Sales",
    "value": "sales"
  }
]
```

Our WhatsApp agents have been particularly effective in countries that already have a large number of users on the platform. It provides a convenient means of communicating with customers whilst also helping users come back to the same conversation to retrieve important details.

Note: To publish a WhatsApp Agent created on Vonage AI Studio, you need to have a functional WhatsApp Business Account along with a number linked to your account which supports Voice and SMS. For more information on how to build WhatsApp Agents on Vonage AI Studio, please visit the [AI Studio documentation](https://studio.docs.ai.vonage.com/whatsapp-chatbot/whatsapp-chatbot/nodes/collect-input).

Here's an example agent we built to record cases of animal sickness, injury, cruelty, and neglect. Go Ahead and send a “Hello” message on the number listed so you can try it out for yourself!

**Agent Phone number: +12012014995**

## Conclusion and Next Steps

In this blog post, we learned about the capabilities and uses of WhatsApp conversation agents in the Vonage AI Studio platform. Full documentation for the AI Studio platform can be found [here](https://studio.docs.ai.vonage.com/#_ga=2.52857896.1004057560.1652645262-2049185403.1651612958).

We always welcome community involvement. Please feel free to join us on the [Vonage Community Slack](https://developer.vonage.com/community/slack) or send us a message on [Twitter](https://twitter.com/VonageDev).
