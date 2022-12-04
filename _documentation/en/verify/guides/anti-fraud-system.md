---
title: Verify Anti-Fraud System
description: Verify's anti-fraud system
navigation_weight: 4
---

# Verify Anti-Fraud System

The Verify API provides a quick way to implement 2FA into your application and avoid dubious sign-ups.

However, Vonage also needs to prevent fraudulent activity on its own platform. One way we achieve this is by detecting suspicious traffic using our Verify Anti-Fraud System.

## How It Works

The Verify Anti-Fraud System blocks suspicious traffic based on a combination of volume threshold and conversion rates for our customer accounts. The volume is the number of requests and the conversion rate is the percentage of successful verifications.

> The platform can only determine if a Verify request is successful if a call is subsequently made to the [Verify check endpoint](/verify/code-snippets/check-verify-request). For every Verify request, your code should perform a Verify check.

If our platform detects a customer’s volume and conversion rate are suspicious during a given period, our platform blocks any further traffic to that particular network. Any subsequent Verify requests will return code 7: `This number is blacklisted for verification`.

## Monitoring Your Conversions

You should monitor your volume and conversion rates to ensure that you are staying within the boundaries set by the Verify Anti-Fraud System.

The conversation rate is calculated by comparing the number of successful verification attempts to the total number of attempts, expressed as a percentage:

`Conversion rate = (# successful verifications / # total verifications) * 100`

> This information is available in the [Developer Dashboard](https://dashboard.nexmo.com/verify/analytics), from the Verify > Analytics navigation menu option.

You can also keep track of your conversion rate based on the responses you receive from the platform during the [Verify Check](/api/verify#verifyCheck) process.

If you are using Verify V2, you can keep track of your volume and conversions by monitoring and logging the [summary callbacks](/api/verify.v2#webhooks) of all your Verify V2 requests.

## Unblocking a Network Using the Network Unblock API

If your verification attempts are consistently returning error code 7: `This number is blacklisted for verification`, it is likely that the network has been blocked by the Verify Anti-Fraud System.

You can unblock the network access for your account by using the [Network Unblock API](/api/verify#networkUnblock). But first we advise you to:

* Check the most recent blocked verification attempts sent to this network (or country)
* Confirm that they are legitimate verification attempts

If your latest traffic looks genuine then feel free to lift the block on a particular network but we ask you to closely monitor your 2FA traffic as fraudsters have identified your application is vulnerable and will likely try sending fraudulent traffic to the same or different destinations.

## Further Information

* [Verify service to high-risk countries](https://help.nexmo.com/hc/en-us/articles/360018406532)
* [Toll-Fraud](https://www.vonage.com/resources/articles/what-is-toll-fraud/#:~:text=Toll%20fraud%20is%20when%20someone,access%20to%20a%20telecommunications%20network.)
* [Network Unblock API](/api/verify?theme=dark#fraud-management)
