---
title: Install Server SDK
navigation_weight: 3
description: Server SDKs are used to help you rapidly develop your messaging applications.
---

# Server SDK

In addition to being able to use Messages via the REST APIs, Vonage also provides Server SDK support. The Server SDK provides a straightforward way to build your Messages applications. You can call the Server SDK to carry out tasks such as sending messages from your application.

## Installation

Vonage Server SDKs containing support for the Messages API, and are available for  various languages/environments:

- [Node](https://github.com/Vonage/vonage-node-sdk)
- [Dotnet](https://github.com/Vonage/vonage-dotnet-sdk)
- [Java](https://github.com/Vonage/vonage-java-sdk)
- [PHP](https://github.com/Vonage/vonage-php-sdk)
- [Python](https://github.com/Vonage/vonage-python-sdk)
- [Ruby](https://github.com/Vonage/vonage-ruby-sdk)

See the relevant `README` files for individual installation instructions. For example, the Node SDK can be installed using:

``` bash
$ npm install @vonage/server-sdk
```

If you already have the Node Server SDK installed the above command will upgrade your SDK to the latest version.

## Usage

If you decide to use the Server SDK you will need the following information:

Key | Description
-- | --
`VONAGE_API_KEY` | The API key which you can obtain from your [Vonage API Dashboard](https://dashboard.nexmo.com).
`VONAGE_API_SECRET` | The API secret which you can obtain from your [Vonage API Dashboard](https://dashboard.nexmo.com).
`VONAGE_APPLICATION_ID` | The Application ID for your Vonage API Application which can be obtained from your [Vonage API Dashboard](https://dashboard.nexmo.com).
`VONAGE_APPLICATION_PRIVATE_KEY_PATH` | The path to the `private.key` file that was generated when you created your application.

These variables can then be replaced with actual values in the Server SDK example code.

## Examples

See the code snippets section for further examples on how to use the Server SDK.
