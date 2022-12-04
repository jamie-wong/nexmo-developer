---
title: Secure Inbound Media
navigation_weight: 6
description: When the Secure Inbound Media is enabled, you will need to use your Messages Application credentials (Authorisation Bearer JWT) to retrieve the media file for all channels.
---

# Secure Inbound Media

The Messages API now offers businesses the option to enhance security for protecting media files sent to them by their end users. Examples of end users' media files are images, videos, and PDFs. Depending on the use case, these could contain sensitive images or information that businesses and their customers would like to protect.

## Standard vs. Enhanced inbound media security

### Standard

Inbound Media files are uploaded to our centralized media servers with a unique URL. This unique URL is valid for 48 hours to allow the business time to download the file. There may be some minor risks associated with this. For example:

* A brute force attack could reveal the URL
* Anyone with possession of the URL could access the file without the requirement of any additional account credentials

### Enhanced

With Enhanced inbound media security, businesses can only access media files using a JWT (JSON Web Token) generated using their account credentials. Enabling this feature adds a layer of security when accessing media. To ensure backward compatibility, we have made this feature optional. 

## Setting up

To access this, they will need to:

1. Create a Vonage Application
2. Link their number to the application
3. Generate a JWT from the application
4. Turn on the Messages capability and switch on "Secure Inbound Media."

More information about applications is available [here](https://developer.vonage.com/application/overview).

## Accessing secured media

When an end user sends a message with a media file, the business receives a callback with a URL to the media file. Accessing the media will require a `GET` request to the URL with an `Authorization` header with a value set as a JWT generated using the Application ID and Private Key associated with the same Vonage application where the webhook which received the inbound message has been set up.

Here is an example cURL request with the token:

```
curl --location --request GET 'https://api-us.nexmo.com/v3/media/1b456509-974c-458b-aafa-45fc48a4d976' \
--header 'Authorization: Bearer '$JWT
```

If the request is successful, then you'll see a 200 code and the media file. If it is unsuccessful, then you'll see an unauthorized response. 