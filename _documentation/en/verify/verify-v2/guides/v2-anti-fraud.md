---
title: Verify V2 Anti-Fraud System
description: Verify V2's anti-fraud system
navigation_weight: 1
---

# Verify V2 Anti-Fraud System

Verify V2 customers have several options on how to manage fraud if fraudulent traffic has surfaced and a network block has been issued by the [Verify Anti-Fraud System](/verify/guides/anti-fraud-system).

## Network Block Callbacks

A network block prevents Verify messages being sent over SMS and Voice channels on that network for your API key. When this happens the platform sends a callback to your designated webhook indicating the request was blocked. For example:

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

## Network Unblock API

When a network becomes blocked due to fraudulent traffic, customers can use the [Network Unblock API](/api/verify#networkUnblock) to unblock a network. Before using the Network Unblock API we highly recommend checking the most recent blocked verification attempts sent to this network (or country) and confirm they are genuine verification attempts. If your latest traffic looks genuine then feel free to lift the block on a particular network. Be sure to carefully monitor your Verify traffic as it’s likely fraudsters have identified a vulnerability in your application’s 2FA implementation and will try sending fraudulent traffic to the same or different destinations.

## WhatsApp and Email

WhatsApp and Email are new channels as part of  Verify V2. When a block is issued on a network, WhatsApp and Email will continue to function as normal. In the below example, if there is a block on your API key for a given network, Verify will determine that SMS messages should not be sent and will deliver the one-time passcode (OTP) through WhatsApp.

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

## Bypassing a Network Block using the Fraud Check parameter

The `fraud_check` parameter will bypass a network block for a single Verify V2 request. Add the parameter `fraud_check` as demonstrated below to skip the fraud check. It is important to note, `fraud_check` set to false will bypass the network block only for the individual request (e.g. an end-user contacts your support team who need an escalation tool).

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
