---
title: Configure your data center
description: This topic shows you how to configure the appropriate data centre to minimize network delays in your application.
navigation_weight: 1
---

# Configure your data center

You may need to configure the Client SDK to connect to your nearest data center. You can use this guide to help determine your best configuration.

> **NOTE:** This is an advanced optional step. You only need to do this if you determine your network performance needs to be enhanced. For most users this configuration is not required. This step can be done after [adding the SDK to your application](/client-sdk/setup/add-sdk-to-your-app).

## Why configure your data centers?

You only need to do this if you believe your application performance could be improved by connecting to a more local data center.

## URLs

It is possible to configure the following three URLs:

1. `nexmo_api_url`: the Conversation API URL.
2. `url`: the websocket URL.
3. `ips_url`: the IPS URL for image upload.

### `nexmo_api_url`

This is the Conversation API URL. This is the URL used when the Client SDK calls the API.

The default value is `https://api.nexmo.com`.

Data Center | URL
---|---
`Virginia` | `https://api-us-3.vonage.com`
`Oregon` | `https://api-us-4.vonage.com`
`Dublin` | `https://api-eu-3.vonage.com`
`Frankfurt` | `https://api-eu-4.vonage.com`
`Singapore` | `https://api-ap-3.vonage.com`
`Sydney` | `https://api-ap-4.vonage.com`

### `url`

This is the websocket URL: the URL that receives realtime events.

The default value is `wss://ws.nexmo.com`.

Data Center | URL
---|---
`Virginia` | `wss://ws-us-3.vonage.com`
`Oregon` | `wss://ws-us-4.vonage.com`
`Dublin` | `wss://ws-eu-3.vonage.com`
`Frankfurt` | `wss://ws-eu-4.vonage.com`
`Singapore` | `wss://ws-ap-3.vonage.com`
`Sydney` | `wss://ws-ap-4.vonage.com`

### `ips_url`

This is the IPS URL for image upload. This is the internal service used to store images being sent via in-app messages.

The default value is `https://api.nexmo.com/v1/image`.

Data Center | URL
---|---
`Virginia` | `https://api-us-3.vonage.com/v1/image`
`Oregon` | `https://api-us-4.vonage.com/v1/image`
`Dublin` | `https://api-eu-3.vonage.com/v1/image`
`Frankfurt` | `https://api-eu-4.vonage.com/v1/image`
`Singapore` | `https://api-ap-3.vonage.com/v1/image`
`Sydney` | `https://api-ap-4.vonage.com/v1/image`

## Configuration

You can specify your preferred URLs when you create the Client SDK `NexmoClient` object:

> **Note**: The iOS SDK expects a trailing `/` as shown in the code snippets below.

```tabbed_content
source: '/_examples/client-sdk/dc-config'
```

## See also

* [Add the SDK to your application](/client-sdk/setup/add-sdk-to-your-app)
