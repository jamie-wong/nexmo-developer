---
title: Troubleshooting
navigation_weight: 9
ignore_in_list: true
---

# Troubleshooting

## Overview

The Vonage Voice API offers a highly available service. However, due to the nature of providing service across hundreds of phone carriers around the world, problems may arise occasionally that are outside of Vonage's control. In addition there are certain limitations placed on Vonage by partner networks, which can have an impact on how your application functions. While not exhaustive here are a few things to look for if you are experiencing problems.

## Timeouts

When Vonage sends a webhook to your Answer URL it expects the server to respond in a certain time frame:

1. The TCP connection should be established within 3 seconds.
2. The HTTP response (NCCO) should be returned within 5 seconds.

If Vonage does not get a response within these time frames it will retry the request twice. If this fails, Vonage will make two further attempts to access your Fallback Answer URL, if it is configured. If Vonage does not get a response within these time frames from your Fallback Answer URL it will retry again. If the Fallback Answer URL responds with a HTTP error code or invalid NCCO then the call is disconnected.

## Regions

The Vonage Voice API resides in five geographic data centers. Phone numbers are associated with the closest data center: US East Coast, US West Coast, Dublin, Frankfurt, Singapore or Sydney. API requests are routed to the closest data center to the requesting client. However, a call currently only exists in a single region, this means that if you are receiving a call on a number connected to Singapore but making an API request from a server hosted in the US it will return a 404.

You can work around this issue by sending your API request to the correct region, either:

* https://api-us-3.vonage.com (Virginia)
* https://api-us-4.vonage.com (Oregon)
* https://api-eu-3.vonage.com (Dublin)
* https://api-eu-4.vonage.com (Frankfurt)
* https://api-ap-3.vonage.com (Singapore)
* https://api-ap-4.vonage.com (Sydney)

API endpoint corresponding to particular call is returned as `region_url` parameter in [Answer webhook](/voice/voice-api/webhook-reference#answer-webhook).

The following are examples of how to override the default hosts using the [Vonage Server SDKs](/tools):

```tabbed_content
source: '/_examples/voice/dc-config'
```

## Capacity

As standard the Voice API has the following capacity limitations:

1. Maximum of 3 outgoing calls per second created either via the REST API or using the `connect` action within another call.
2. Maximum of 15 requests per second to the REST API (excluding create calls).

If you exceed these limits you will receive an HTTP 429 response or a webhook to your `event_url` with an error.

## Error events

The Vonage Voice API sends error events to the `event_url` associated with the application. For example, when we encounter an invalid NCCO or an outbound call failure.
