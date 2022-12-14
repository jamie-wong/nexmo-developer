---
title: Using WhatsApp Interactive with Verify V2
description: How to use WhatsApp Interactive with Verify V2
navigation_weight: 2
---

# Using WhatsApp Interactive with Verify V2

WhatsApp Interactive can be used with Verify V2 to provide a better user experience; rather than entering an OTP, the user presses YES or NO to authenticate:

![Example Verification message using WhatsApp Interactive](/images/verify-whatsapp-interactive-1.png)

## Configure Your Application

When the user selects YES or NO in WhatsApp, an Event callback is triggered to inform your application if the user has authenticated successfully. To configure your callbacks, navigate to your application in the [Vonage dashboard](https://dashboard.nexmo.com/applications). In the Application settings, find Capabilities and ensure that Verify V2 is enabled and enter your callback URL:

![Application Capabilities Dashboard](/images/verify-whatsapp-interactive-2.png)

### Generate a JWT

Verify V2 uses JWTs to authenticate your requests for your application; you can generate a JWT using the [Vonage Online Tool](/jwt), or through the [Vonage Server SDKs](/conversation/guides/jwt-acl). For more information, see the guide on [Authentication](/getting-started/concepts/authentication).

## Make the Request

An example request using WhatsApp Interactive can be found below; set the `channel` parameter to `whatsapp_interactive`:

```

POST - /v2/verify
Content-Type: application/json
 
{
  "brand": "InteractiveWa",
  "workflow": [
    {
      "channel": "whatsapp_interactive",
      "to": "447700900000"
    }
  ]
}
```

If delivery is successful, the user will receive the verification message and will be able to select YES or NO to authenticate:

![Example Event Callback](/images/verify-whatsapp-interactive-3.png)

## Callback Responses


Once the request is complete you will receive an event callback which informs your application of the outcome; if the user has selected YES, you will see `status: completed`. If the user selects NO, you will see `status: user_rejected`. You can then take appropriate action using that response.

![Example Event Callback](/images/verify-whatsapp-interactive-4.png)

You may also see the following in your event callbacks:

* `status: failed` - this means that Verify V2 was unable to deliver the WhatsApp message to the end user. If another channel was specified in the request, it will then move to the next action and attempt to send again to the user. For more information on this, see [Workflows](/verify/verify-v2/overview#workflows).
* `status: expired` - this is when the message was delivered, but the user never selected YES or NO before the timeout was reached.
