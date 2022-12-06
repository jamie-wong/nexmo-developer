---
title: Network Unblock API
description: Learn what the Vonage Network Unblock API is and how to use it.
navigation_weight: 5
---

# Network Unblock API

Network Unblock is an [anti-fraud](/verify/guides/anti-fraud-system) feature that provides a self-service capability for users to unblock their blocked network.

When a network is blocked, the Verify API returns with an error of status 7:

```
{
"status": "7",
"error_text": "The network you are trying to verify has been blocked due to possible fraudulent activity",
"network": "310260"
}
```

The `network` code provided in the error can be used to unblock the network via the Network Unblock API.

## Account Setup

The Network Unblock API is available for use with both Verify V1 and Verify V2. In order to use the API, you need to have the account capability: `verify-allow-network-unblock`. Once you have that capability assigned, you are able to use the API to unblock your blocked network.

## Making a Request

The endpoint URL for your Network Unblock request will be different depending on which version of the Verify API you are using:

* Verify V1: `https://api.nexmo.com/verify/network-unblock`
* Verify V2: `https://api.nexmo.com/v2/verify/network-unblock`

Your request should contain the following parameters:

```
{
  "network": "23410",
  "unblock_duration": "3600"
}
```

* `network` contains the network code provided in the original error.
* `unblock_duration` is an optional parameter. It ranges from 0 seconds to 86,400 seconds (24 hours).

When `unblock_duration` is used, it simply means that the network will be unblocked until the time specified. In the above example, network 32526 will be unblocked until 60 minutes. However, post 60 minutes, the network remains unblocked unless another block is issued by Velocity Rules due to fraudulent activity.

If successful, you will receive a 200 response indicating how long the network will be unblocked for:

```
{
  "network": "23410",
  "unblocked_until": "2024-04-22T08:34:58Z"
}
```

> Further information, including error responses, can be found in the [API Specification](/api/verify#networkUnblock).
