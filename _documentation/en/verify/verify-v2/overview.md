---
title: Overview
meta_title: Enable 2FA with the Verify API
description: The Verify API enables you to confirm that you can contact a user at a specific number.
navigation_weight: 1
---
## Verify V2 Overview

> This product is in the Early Access product stage.

The Verify V2 product is our next generation two-factor authentication (2FA) product. It has the benefits of more channels including over-the-top (OTT) channels like WhatsApp and more traditional channels like SMS, Voice, and Email.

We added event and summary callbacks that open the door to a multitude of integration and customization opportunities. To start, you can configure a webhook to ingest summary callbacks that details which channels successfully converted and which did not. Event callbacks allow us to offer unique end-users experiences such as the WhatsApp Codeless channel. Here an end-user can push a button within the WhatsApp message in order to authenticate, then we send an event callback to the backend to instruct you on how to proceed with the end-user experience.

## Verify V2 Early Access Pricing

We bill for each channel used and currently do not bill for successful conversions. Specific to WhatsApp, billing is per WhatsApp message (business initiated pricing) plus the passthrough.

**For example, in the USA when ``channel=whatsapp`` then expected bill is $0.0147 WhatsApp fee + $0.0122 passthrough fee for a total of $0.0269.**

## Verification Channels

### SMS

SMS is the most popular channel for two-factor authentication (2FA). That's because most people can receive text messages and onboarding is seamless. Plus, SMS 2FA works: Google found that SMS 2FA helped block "100% of automated bots, 96% of bulk phishing attacks, and 76% of targeted attacks."

### WhatsApp

WhatsApp is a great channel for two-factor authentication because of its popularity around the world and delivery of messages only requires a WiFi connection. Adding WhatsApp to supplement SMS can improve your overall conversion rates.

Unlike the WhatsApp Business API you might use for customer support, Vonage Verify + WhatsApp lets you start sending one-time passcodes with a generic WhatsApp Business Account (WABA) or your own WABA, if your company already has one registered.

> By default WhatsApp messages will be sent using a Vonage WhatsApp Business Account (WABA). Please contact [Sales](https://www.vonage.com/communications-apis/contact-api/) in order to configure Verify V2 to use your company’s WABA.

### WhatsApp Codeless

WhatsApp Codeless allows you to authenticate an end-user without sending a one-time passcode. This improves the experience because there is no need to remember a code. The end-user presses "yes" or "no" in WhatsApp and an event callback is sent to your back-end on when to proceed.

> By default WhatsApp messages will be sent using a Vonage WhatsApp Business Account (WABA). Please contact [Sales](https://www.vonage.com/communications-apis/contact-api/) in order to configure Verify V2 to use your company’s WABA.

> For non-managed accounts, please contact [Sales](https://www.vonage.com/communications-apis/contact-api/) in order to configure Verify V2 to use your company’s WhatsApp Business Account. For managed accounts, please reach out to your dedicated account manager.

### Voice

Voice is a great backup to SMS for two-factor authentication, especially in geographies where it’s difficult to terminate SMS or if the local regulations require lengthy SMS pre-registration processes.

### Email

One-time passcodes sent to email are also a good alternative to the channels mentioned above, especially in the instance of network congestion at the mobile operator level.

> Our email solution supports domain registration, if you plan to scale email verification to high volumes with Verify V2, please contact [Sales](https://www.vonage.com/communications-apis/contact-api/) in order to get your account configured properly.

## Verify V2 Sequence Diagrams

### Verify V2 Request with Summary Callbacks

![Verify V2 Request with Summary Callbacks](/images/verifyv2_request_summary_callbacks.png)

### Verify V2 Request with Event & Summary Callbacks Using WhatsApp Codeless

![Verify V2 Request with Event & Summary Callbacks Using WhatsApp Codeless](/images/verifyv2_whatsapp_sequence_diagram.png)

> You can view the Verify V2 API Reference [here](/api/verify.v2).
