---
title: Build a Vonage Message Custom Activity with Salesforce Marketing Cloud
description: Learn about a new starter template for creating a Vonage Messages
  API activity in the Salesforce Marketing Cloud Journey Builder
thumbnail: /content/blog/build-a-vonage-message-custom-activity-with-salesforce-marketing-cloud/salesforce_messagesapi.png
author: kitt-phi
published: true
published_at: 2022-10-27T08:39:42.846Z
updated_at: 2022-10-27T08:39:44.860Z
category: tutorial
tags:
  - message-api
  - salesforce
  - api
comments: true
spotlight: false
redirect: ""
canonical: ""
outdated: false
replacement_url: ""
---
## Introduction

Today, I will introduce a starter template for creating a Vonage Messages API activity in the Salesforce Marketing Cloud Journey Builder using Heroku. The custom activity allows you to send marketing campaign messages using Vonage Messages API and Salesforce Marketing Cloud Contacts (Attribute Group in Contact Builder).

In this post, I will walk you through the creation of the activity step by step. I have also put together a short video to show you how to integrate Vonage Communication APIs into Salesforce Marketing Cloud to build a contextual customer journey with different channels. 

<youtube id="AyD3gk1RDFk"></youtube>

## Getting Started

### Pre-Requisites

* [Node.js, NPM](https://docs.npmjs.com/downloading-and-installing-node-js-and-npm), [Heroku account](https://signup.heroku.com/), [Heroku CLI](https://devcenter.heroku.com/articles/heroku-cli) installed
* A Vonage account - you can sign up for a [free Vonage account](https://ui.idp.vonage.com/ui/auth/registration).
* A [Salesforce account](https://help.salesforce.com/s/articleView?id=000381579&type=1) with Salesforce Marketing Cloud.
* We will use a [Heroku account](https://signup.heroku.com/) for the instruction below, or you may choose a public-facing web server. 
* The instructions below are for Heroku.
* [WhatsApp Business Account](https://www.facebook.com/business/help/2055875911147364?id=2129163877102343) or [Postman](https://www.postman.com/downloads/) to create a WhatsApp Template.

### Create Heroku app

* Login or Signup for a free [Heroku account](https://signup.heroku.com/). Then create a new app.
* Click on New and select Create new app. Save the Heroku app name for later use. Then click Create app.
* To update changes to our forked repo, we will set up the CICD pipeline here. You will see the benefit later. You can also skip the following steps if you prefer.
* Select GitHub as our Deployment method. Search for your forked repo and then click Connect.
* Enable Automatic Deploys. At this time, we will not Deploy the Branch due to some configurations to our forked repo.
* If you click Open app, you will see the Heroku App we just created. Save the Heroku App URL for later use.

### Create Vonage Application

* [Create a new Vonage application](https://dashboard.nexmo.com/applications) by clicking Create a new application.
* Enter an Application Name and click Generate public and private key. Save the `private.key` for later use.
* Enable the Messages. Update the `HEROKU_APP_NAME` with your Heroku App name.
* Enter the Heroku endpoints and update the `HEROKU_APP_NAME`.
* a. `https://HEROKU_APP_NAME.herokuapp.com/inbound`
* b. `https://HEROKU_APP_NAME.herokuapp.com/status`
* Scroll below and click `Generate new application` when done.
* [Buy a Vonage Number](https://dashboard.nexmo.com/buy-numbers) and link the number to the Vonage Application you just created.

### Configure Salesforce Marketing Cloud Contact Builder

* Log in to Marketing Cloud, and at the top right, click on the profile icon and select Setup.
* Once in Setup, on the left pane, click on Apps and then select Installed Packages.
* Click on New, enter a Name, e.g., your Heroku App name, and then click Save.
* Click Add Component, select Journey Builder Activity, and then click Next.
* Give the activity a Name, e.g., your Heroku App name. Please select the category where this activity will appear within Journey Builder; we will select Custom. Enter your Heroku app URL, e.g., `https://HEROKU_APP_NAME.herokuapp.com`, then click Save.
* Copy the `Unique Key` value from the Journey Builder Activity panel and save it for later use.

### Create Data Extension

* Open Salesforce Marketing Cloud, navigate to `Email Studio > Email > Subscribers > Data Extension`, and click Create to create a new Data Extension.
* Select Standard Data Extension
* Select Create, then New
* Name, e.g., your Heroku App name.
* External key - leave blank.
* Enable both: Is Sendable and Is Testable
* Click next and leave Data Retention Policy settings to Yes.
* Enter fields as shown in the image below. 

![Create New Data Extension](/content/blog/build-a-vonage-message-custom-activity-with-salesforce-marketing-cloud/da-field.png "da-field.png")

* Set emailAddress to data type EmailAddress and as the `Primary Key`.
* Set toNumber to data type `Phone`.
* Set Send Relationship: `emailAddress` relates to Subscribers on `Subscriber Key` and then click Create when done.
* Update the `SAMPLE.csv` file with your contact's `To number`'s. If you update the email, remember that the email must be unique.

> At the time of this blog, setting the `toNumber` as the primary key did not work. I was putting the two numbers as the `Phone`, which did not work.

* Navigate to the Data Extension you created > Records > Import> Browse, select the file `SAMPLE.csv` and click Next. 

![Import Into Data Extension](/content/blog/build-a-vonage-message-custom-activity-with-salesforce-marketing-cloud/import-de1.png "import-de1.png")

* Keep the default `Map by Header Row` and click Next. 

![Upload File](/content/blog/build-a-vonage-message-custom-activity-with-salesforce-marketing-cloud/import-de2.png "import-de2.png")

* Lastly, click Import and close the modal. 

![Configure Mapping](/content/blog/build-a-vonage-message-custom-activity-with-salesforce-marketing-cloud/import-de3.png "import-de3.png")

* You must refresh and navigate the Data Extension > Records to see the CSV data we just imported.

### Configure Contact Builder

* Navigate to `Audience Builder > Contact Builder > Create Attribute Group`.
* Please give it a Name, e.g., your Heroku App name, and select the people icon.
* Click on Link Data Extension, navigate to Data Extensions, and select your Data Extension.
* Link the Data Extension by selecting `Contact Key` for the Customer Data and `emailAddress` for your Data Extension, then click Save when done. 

![Link Data Extension](/content/blog/build-a-vonage-message-custom-activity-with-salesforce-marketing-cloud/link-da.png "link-da.png")

### Configure Vonage Messages Activity

Edit `/public/config.json`

* Replace `JOURNEY_BUILDER_UNIQUE_KEY` with the Journey Builder Activity `Unique Key` from earlier.
* Replace all instances of `HEROKU_APP_NAME` with the name of your Heroku App from earlier:

  * <https://HEROKU_APP_NAME.herokuapp.com/journeybuilder/execute>
  * <https://HEROKU_APP_NAME.herokuapp.com/publish>
  * <https://HEROKU_APP_NAME.herokuapp.com/validate>
  * <https://HEROKU_APP_NAME.herokuapp.com/stop>
  * <https://HEROKU_APP_NAME.herokuapp.com/save>

Edit `/public/js/customActivity.js`

* Replace all instances of `DATA_EXTENSION_NAME` with your Data Extension Name, e.g., your Heroku App name.

### Deploy updated Custom Journey Activity Package to Heroku

## Configure Heroku Config Vars

* Login to [Heroku](https://heroku.com/)
* Navigate to Settings > Reveal Config Vars, then add the Variables below and their values.

  * FROM_NUMBER
  * VONAGE_API_KEY
  * VONAGE_API_SECRET
  * VONAGE_APPLICATION_ID
  * VONAGE_APPLICATION_ID_PRIVATE_KEY
  * WHATSAPP_NUMBER
  * WHATSAPP_TEMPLATE_NAMESPACE
  * WHATSAPP_TEMPLATE_NAME

### Create WhatsApp Template

* You have two options to create a WhatsApp Template.

  * Option 1 use WhatsApp Manager
  * Option 2 use Vonage WhatsApp Template Manager API and Postman

    * Import the provided `WhatsApp Template API Blog.postman_collection.json` into Postman and
      populate the Authorization with your Vonage `API_KEY` and `API_SECRET`. Then replace that
      Postman Request Body name with `YOUR_WHATSAPP_TEMPLATE_NAME`. Sending the `POST Request` will return an ID.
    * You can also see the status of that WhatsApp Template by using the provided `GET Request`.
      Make sure to populate the Authentication with your Vonage `API_KEY` and `API_SECRET` as well.

### Configure Journey Builder

* Navigate to Journey Builder > Journey Builder > click Create New Journey.
* Rename the Journey, e.g., your Heroku App name.
* Select Multi-Step Journey and then click the Create button hidden at the bottom.

![Journey Builder](/content/blog/build-a-vonage-message-custom-activity-with-salesforce-marketing-cloud/journey-builder-1.png "journey-builder-1.png")

* On the left pane in Entry Sources, drag `Data Extension` to `Start with an Entry Source`.

![Journey Builder - Entry Source](/content/blog/build-a-vonage-message-custom-activity-with-salesforce-marketing-cloud/da-and-journey.png "da-and-journey.png")

* Click on the dragged Data Extension icon and select Data Extension.
* Select your Data Extension, click Summary, and then click Done.
* On the left pane in Messages, drag and drop your Installed Package `Vonage SFMC` to the area just before `one day`.
* Click Save when done.
* Click on the package you just dragged, `Vonage SFMC`, to see your Heroku App.

### Sending a campaign via SMS or WhatsApp Message

Back in the package, you dragged `Vonage SFMC`. You can send either an SMS or WhatsApp Template Message.

**Option 1:** If SMS is selected, a message body will appear. Copy the line below and edit `DATA_EXTENSION_NAME` to yours.

* Hi there `{{Contact.Attribute.DATA_EXTENSION_NAME.firstName}}`, are you interested in a 75% promotion?

Marketing Cloud uses Data Binding using the Mustache syntax. E.g. `{{Contact.Attribute.DATA_EXTENSION_NAME.firstName}}`

![Vonage SFMC](/content/blog/build-a-vonage-message-custom-activity-with-salesforce-marketing-cloud/journey-sms.png "journey-sms.png")

* Click Done once you pasted the line.

**Option 2:** If WhatsApp is selected, the WhatsApp Template you created earlier will be used.

* e.g. Hi there `{{1}}`, are you interested in a `{{2}}` promotion?
* Select WhatsApp. The WhatsApp Template message has two parameters. `{{1}}` is the `{{Contact.Attribute.DATA_EXTENSION_NAME.firstName}}`and `{{2}}` is the `client-ref`.
* The Client Ref will be the second parameter for the WhatsApp Template.

![Vonage SFMC](/content/blog/build-a-vonage-message-custom-activity-with-salesforce-marketing-cloud/journey-wa.png "journey-wa.png")

Finish the steps below to send the message.

* Click Save and then Validate. 2 errors will show up, so let's set this.
* Edit Entry Source, select Run Once, click Select and then click Done.
* Edit Settings, select Re-Entry anytime
* Click the Data tab, select your Contact Builder Attribute Group name and then click Done.

> You must click Done to save the message.

* Click `Activate` and then click `Activate` to send the message. This will send a Message to all recipients in your CSV.
* Looking at the terminal where you ran the deployment, you will see three executions.

```js
2022-10-14T21:06:54.869228+00:00 app[web.1]: ✅ Success: message_uuid= b16363e2-aa12-4796-aaf1-1f7b3b7f9901
2022-10-14T21:06:54.870964+00:00 app[web.1]: ✅ Success: message_uuid= 13dcf471-4bdd-4d23-a691-862c3022f4d2
2022-10-14T21:06:54.876695+00:00 app[web.1]: ✅ Success: message_uuid= 3643d0a9-2663-4534-8c77-e1567fde6d3d
```

* If you reply, you will see the response in the terminal

```js
// example response logged from inbound
🚚 inbound {
2022-10-13T23:48:58.472615+00:00 app[web.1]: to: 'YOUR_VONAGE_NUMBER',
2022-10-13T23:48:58.472616+00:00 app[web.1]: from: 'RESPONSE_FROM_NUMBER',
2022-10-13T23:48:58.472616+00:00 app[web.1]: channel: 'sms',
2022-10-13T23:48:58.472617+00:00 app[web.1]: message_uuid: 'xxxxxx',
2022-10-13T23:48:58.472619+00:00 app[web.1]: timestamp: '2022-10-13T23:48:58Z',
2022-10-13T23:48:58.472619+00:00 app[web.1]: usage: { price: '0.0057', currency: 'EUR' },
2022-10-13T23:48:58.472619+00:00 app[web.1]: message_type: 'text',
2022-10-13T23:48:58.472620+00:00 app[web.1]: text: 'Yes, I am interested in the promotion!',
2022-10-13T23:48:58.472621+00:00 app[web.1]: sms: { num_messages: '1' }
2022-10-13T23:48:58.472621+00:00 app[web.1]: }
```

## Wrap-up

As you can see, we can use Salesforce Marketing Cloud to leverage Vonage Messages API to send and receive messages. It is a powerful way to send marketing campaigns to a number of customers quickly and easily. 

To take this further, you can use [Vonage AI Studio](https://studio.docs.ai.vonage.com/) to form engaging conversation from Inbound replies. You can also add multiple Data Extensions to a [Contact Builder](https://help.salesforce.com/s/articleView?id=sf.mc_cab_contact_builder.htm&type=5) Attribute Group and link them, which would allow you to send messages like this: e.g. Hello {{Contact.Attribute.DATA_EXT_1.FirstName}}. Join us at this event {{Contact.Attribute.DATA_EXT_2.EventName}}.

If you have questions or feedback, join us on the [Vonage Developer Slack](https://developer.vonage.com/community/slack) or reach the author via [email](mailto:kitt.phi@vonage.com) or [LinkedIn](https://www.linkedin.com/in/kitt-phi-22a875136/). If you'd like access to a [GitHub repository](https://github.com/nexmo-se/vonage-sfmc-blog) for this project, then feel free to email me with the link above. Then you could fork and clone the repository to explore further. I hope you enjoyed this and find it useful. Thanks for reading!
