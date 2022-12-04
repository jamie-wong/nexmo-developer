---
title: Install the Vonage Node Server SDK
description: Install the Vonage Node Server SDK to get the latest functionality.
---

If you are planning to use JavaScript to develop your application, you'll need to install (or update) the Vonage Node Server SDK.

### Installation

The Node Server SDK can be installed using:

``` bash
$ npm install @vonage/server-sdk
```

If you already have the Server SDK installed the above command will upgrade your Server SDK to the latest version.

### Usage

If you decide to use the Server SDK you will need the following information:

|Key | Description|
|-- | --|
|`VONAGE_API_KEY` | The Vonage API key which you can obtain from your [Dashboard](https://dashboard.nexmo.com).|
|`VONAGE_API_SECRET` | The Vonage API secret which you can obtain from your [Dashboard](https://dashboard.nexmo.com).|
|`VONAGE_APPLICATION_ID` | The Vonage Application ID for your Vonage Application which can be obtained from your [Dashboard](https://dashboard.nexmo.com).|
|`VONAGE_APPLICATION_PRIVATE_KEY_PATH` | The path to the `private.key` file that was generated when you created your Vonage Application.|

These variables can then be replaced with actual values in the Server SDK example code.
