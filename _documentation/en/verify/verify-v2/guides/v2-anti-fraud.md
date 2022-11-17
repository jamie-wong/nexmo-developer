---
title: Verify V2 Anti-Fraud System
description: Verify V2's anti-fraud system
navigation_weight: 1
---

# Verify V2 Anti-Fraud System

Verify V2 has added a number of features to the existing [Verify Anti-Fraud System](/verify/guides/anti-fraud-system).

## Network Blocks

The Verify Anti-Fraud System blocks suspicious traffic based on a combination of volume threshold and conversion rates for our customer accounts. A converted request is a request where the pin code is successfully returned to the API; when the conversion rate for your account on a network drops below a certain threshold over a certain time period, then a block is issued.

A block prevents Verify messages being sent over Voice and SMS channels on that network for your API key - this results in a callback indicating that the request was blocked. For example:

```
POST - /your_callback_endpoint
Content-Type: application/json

{
"request_id": "c11236f4-00bf-4b89-84ba-88b25df97316",
"submitted_at": "2020-01-01T14:00:00.000Z",
"status": "blocked",
"type": "summary",
"workflow": [
    {
    "channel": "sms",
    "initiated_at": "2020-01-01T14:00:00.000Z",
    "status": "blocked",
    "reason": "Fraudulent traffic detected for your account on network [ 23415 ]."
    }
],
"finalized_at": "2020-01-01T14:00:00.000Z"
}
```

### Temporary Blocks

In Verify V1 blocks were permanent, whereas in Verify V2 blocks are only issued for a temporary amount of time and will then allow traffic to resume as normal. If fraudulent traffic persists on a network, blocks will be issued for longer periods until they eventually become permanent. If a block becomes permanent, the only way for traffic to resume on this network is to use the [Network Unblock API](/api/verify#networkUnblock).

Before using the Network Unblock API we advise you check the most recent blocked verification attempts sent to this network (or country) and confirm they are legitimate verification attempts. If your latest traffic looks genuine then feel free to lift the block on a particular network, but we ask you to closely monitor your 2FA traffic as fraudsters have identified your application is vulnerable and will likely try sending fraudulent traffic to the same or different destinations.

## WhatsApp and Email

WhatsApp and Email are new channels introduced in Verify V2 - when a block is issued on a network, WhatsApp and Email will continue to function as normal. In the below example, if there is a block on your API key for a given network, Verify will determine that SMS messages should not be sent. This will then failover to the next channel, which is WhatsApp, and the API will attempt to deliver to the end user.

```
POST - /v2/verify
Content-Type: application/json

{
"brand": "ACME, Inc",
"workflow": [
    {
    "channel": "sms",
    "to": "447700900000",
    },
    {
    "channel": "whatsapp",
    "to": "447700900000"
    }
],
}
```

## Bypassing Fraud Check

If a block exists on a network, but you have a legitimate end user your application needs to deliver a verification request to, there are now have a few options with Verify V2. WhatsApp and Email may be used as mentioned above, however blocks can also be overridden on a per request basis. Add the parameter `fraud_check` as demonstrated below to skip the fraud check.

This parameter is optional and will default to true.

```
POST - /v2/verify
Content-Type: application/json

{
"fraud_check": false,
"brand": "ACME, Inc",
"workflow": [    
    {
    "channel": "sms",
    "to": "447700900000",
    }
],
}
```
