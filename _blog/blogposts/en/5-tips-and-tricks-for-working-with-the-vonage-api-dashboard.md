---
title: 5 Tips and Tricks for Working With the Vonage API Dashboard
description: 5 quick tips everyone can use for the dashboard that includes
  analytics, managing team member access, and more.
thumbnail: /content/blog/5-tips-and-tricks-for-working-with-the-vonage-api-dashboard/tips-and-tricks.png
author: michael-crump
published: true
published_at: 2022-10-13T08:58:42.161Z
updated_at: 2022-10-13T08:58:43.498Z
category: inspiration
tags:
  - API
  - dashboard
  - productivity
comments: true
spotlight: false
redirect: ""
canonical: ""
outdated: false
replacement_url: ""
---
## Introduction

There are many ways to manage your Vonage developer account, such as the [Vonage API Dashboard](https://developer.vonage.com/), the [CLI](https://developer.vonage.com/tools) (command line interface) tool, or by calling the [API](https://developer.vonage.com/api/account) directly or with one of the [Vonage Server SDKs](https://developer.vonage.com/tools) for your preferred technology stack. Each method allows you to check your balance, configure the account-level settings, and rotate your API secrets for security purposes.

In this blog post, I want to focus on the [Vonage API Dashboard](https://developer.vonage.com/) as I enjoy a point-and-click interface along with quick links to analytics, managing team member access, and quick start samples to get me on my way fast. So regardless if you are new to the Dashboard or a seasoned veteran, here are five tips to make you even more productive when using the Vonage API Dashboard.

## Getting Started

## Tip #1 - Platform Status Summary

We've made it easy for you to stay on top of the real-time status of your Vonage Unified Communications, Communications APIs, and Contact Center solutions. Once logged into the Vonage API Dashboard, you'll see **Platform Status Summary** to the right of your **API Key** and **API Secret**. 

![Platform Status Summary Option](/content/blog/5-tips-and-tricks-for-working-with-the-vonage-api-dashboard/platformstatus.png "PlatformStatus.png")

If you click on it, it will load <https://vonageapi.statuspage.io/>, which provides an overview of our services over the past 90 days and an [option](https://vonageapi.statuspage.io/uptime) to view historical data. 

![Uptime historical data](/content/blog/5-tips-and-tricks-for-working-with-the-vonage-api-dashboard/updatehistory.png "UpdateHistory.png")

You can even subscribe to updates and get notifications any way you choose with options such as email, Slack, SMS, RSS feed, and more!

![Subscribe To Updates](/content/blog/5-tips-and-tricks-for-working-with-the-vonage-api-dashboard/subscribetoupdates.png "SubscribeToUpdates.png")

## Tip #2 - Set up account notifications

From the Vonage API Dashboard to the right of the page, you'll see an option to **Set up account notifications**. 

![Set up account notifications](/content/blog/5-tips-and-tricks-for-working-with-the-vonage-api-dashboard/setupnotifications.png "SetupNotifications.png")

This [option](https://dashboard.nexmo.com/settings?notifications=true) is beneficial if your payment is due or your balance is low to avoid service disruption.

![Notification Settings](/content/blog/5-tips-and-tricks-for-working-with-the-vonage-api-dashboard/notificationsettings.png "NotificationSettings.png")

Low balance alerts are configured on the [Billing & Payments page](https://dashboard.nexmo.com/billing-and-payments/alerts).

![Low Balance Alerts Settings](/content/blog/5-tips-and-tricks-for-working-with-the-vonage-api-dashboard/lowbalancealerts.png "LowBalanceAlerts.png")

Once you toggle the **Switch on low balance alerts**, you specify:

* The balance threshold will trigger the alert.
* An Email address to which the service sends an alert.

Once you have, it configured to your liking, press the **Save** button. 

Back on the [Notification page](https://dashboard.nexmo.com/settings?notifications=true), you can opt-in for **Pricing updates** by providing your email below. Using a comma, you can send upcoming pricing changes to multiple email addresses—for example, example@vonage.com;example2@vonage.com.

## Tip #3 - Add team members

You can invite additional team members to your account from the **Add Team Members** section of the Vonage API Dashboard. 

![Add Team Members](/content/blog/5-tips-and-tricks-for-working-with-the-vonage-api-dashboard/addteammembers.png "AddTeamMembers.png")

Selecting this option will take you to the [Team Management](https://dashboard.nexmo.com/users) page. 

![Team Members Dialog](/content/blog/5-tips-and-tricks-for-working-with-the-vonage-api-dashboard/teammembers.png "TeamMembers.png")

If you press **Invite team member**, you can choose what level of access to give them once you fill out the required fields (First Name and Email) and assign them an **API Key**. 

![Invite Team Members - Profile](/content/blog/5-tips-and-tricks-for-working-with-the-vonage-api-dashboard/inviteteammember.png "InviteTeamMember.png")

![Invite Team Members - API Key](/content/blog/5-tips-and-tricks-for-working-with-the-vonage-api-dashboard/assisgnapikey.png "AssisgnAPIKey.png")

This option will send them an email invitation to sign up for a secondary account as a team member of your account on the Dashboard. 

> Please [note](https://api.support.vonage.com/hc/en-us/articles/217542027-Adding-Team-Members-to-Your-Vonage-API-Account-Dashboard) that you can only invite team members that don't have an account with us before. 

## Tip #4 - Quick access to Analytics information for an API

Vonage Communications APIs feature analytics built into the dashboard to quickly summarize how an individual API is performing. You can access this by going to **Analytics** and selecting an API. 

![Analytics](/content/blog/5-tips-and-tricks-for-working-with-the-vonage-api-dashboard/analytics.png "Analytics.png")

Here is an example of the **SMS Analytics** page. You'll see you can select the **Type** from options such as **Outbound** to **Inbound** and choose the **Duration**. 

![SMS Analytics](/content/blog/5-tips-and-tricks-for-working-with-the-vonage-api-dashboard/smsanalytics.png "SMSAnalytics.png")

This provides information such as the **Date** and **Total Messages** sent on that day and the **Cost**.

You can also view the **Delivery and Quality** tab for a breakdown per network based on dates or countries. You can also download the data in an Excel format for further analysis.

![SMS Delivery](/content/blog/5-tips-and-tricks-for-working-with-the-vonage-api-dashboard/smsdelivery.png "SMSDelivery.png")

## Tip #5 - Getting Started is Easy - No matter your preferred language

If you scroll down the page, you'll find a **Troubleshoot & Learn** section with a **Getting Started** subsection. 

![Getting Started](/content/blog/5-tips-and-tricks-for-working-with-the-vonage-api-dashboard/getstarted.png "GetStarted.png")

If we select **Send an SMS**, we'll see the following screen:

![Sample Getting Started](/content/blog/5-tips-and-tricks-for-working-with-the-vonage-api-dashboard/samplegettingstarted.png "SampleGettingStarted.png")

The programming language you specified when you created your developer account will be shown by default. In my instance, it is C#. Here you can make some sample requests without leaving the dashboard in the **Try it out** section. Then when you're ready to incorporate it into your application, there are handy code snippets that you can copy and paste into your application. This feature is excellent for testing the API to check that you have provided the correct parameters and are getting back the responses you want.

Also, most samples offer cURL snippets that you can easily copy, paste and modify for quick testing.

How cool is that?

## Bonus - Pricing

You can download the Pricing for all products and countries associated with your account by going to **Quicklinks**, then **Billing**, and selecting **Pricing**:

![Pricing Screen](/content/blog/5-tips-and-tricks-for-working-with-the-vonage-api-dashboard/pricing.png "Pricing.png")

Click on the **Download pricing** button to generate an Excel file that you can open to view the pricing information for your account. 

![Pricing in Excel](/content/blog/5-tips-and-tricks-for-working-with-the-vonage-api-dashboard/excelpricing.png "ExcelPricing.png")

## Wrap-up

As you can see, the Vonage API Dashboard is a powerful way for developers to work with our APIs, enhance productivity, add teammates and get work accomplished! If you don't have an account, then I'd encourage you to sign up for one at [Vonage API Dashboard](https://developer.vonage.com/). You'll get free credit to start! 

As always, if you have questions or feedback, join us on the [Vonage Developer Slack](https://developer.vonage.com/community/slack) or send me a Tweet on [Twitter](https://twitter.com/mbcrump), and I will get back to you. Thanks again for reading, and I will catch you on the next one!
