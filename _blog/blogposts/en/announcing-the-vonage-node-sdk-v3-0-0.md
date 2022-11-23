---
title: Announcing the Vonage Node SDK v3.0.0
description: v3.0. of the NodeJS SDK, brings new improvements and long "await"ed features
thumbnail: /content/blog/announcing-the-vonage-node-sdk-v3-0-0/node_sdk-updates.png
author: chuck-reeves
published: true
published_at: 2022-11-23T10:10:48.204Z
updated_at: 2022-11-23T10:10:49.976Z
category: announcement
tags:
  - node
comments: true
spotlight: false
redirect: ""
canonical: ""
outdated: false
replacement_url: ""
---
That's right, [v3](https://github.com/Vonage/vonage-node-sdk/releases/tag/%40vonage%2Fserver-sdk%403.0.0) of the node SDK is now fully promised. A long-asked-for feature has been released, along with breaking out the SDK into smaller components, which will help the team release new features more quickly.

## Breaking Changes

### Promises

All function callbacks have been removed. In the future, you will need to use `async/await` or `.then/.catch`. This should make your code cleaner by avoiding callback hell. For example:

```js
const Vonage = require('@vonage/server-sdk')

const vonage = new Vonage({
    apiKey: VONAGE_API_KEY,
    apiSecret: VONAGE_API_SECRET,
})

const from = VONAGE_BRAND_NAME;
const to = TO_NUMBER;
const text = 'A text message sent using the Vonage SMS API'

vonage.message.sendSms(from, to, text, (err, responseData) => {
    if (err) {
        console.log(err);
        return;
    }

    if(responseData.messages[0]['status'] === "0") {
        console.log("Message sent successfully.");
        return;
    } 
    
    console.log(`Message failed with error: ${responseData.messages[0]['error-text']}`);
})
```

It can now be written as:

```js
const { Vonage } = require('@vonage/server-sdk')

const vonage = new Vonage({
    apiKey: VONAGE_API_KEY,
    apiSecret: VONAGE_API_SECRET,
})

const from = VONAGE_BRAND_NAME;
const to = TO_NUMBER;
const text = 'A text message sent using the Vonage SMS API';

const sendSMS = async () {
    try {
        const response = await vonage.sms.send({to, from, text});
        console.log(response);
    } catch (err) {
        console.log('There was an error sending the messages.'); 
        console.error(err);
    }
};
```

Parameter Updates

Functions have also been updated to use parameter objects instead of function arguments. This will help keep functions with many optional parameters more manageable. We have published a migration document for each package that will describe which functions have been updated in more detail.

##### Migration guide

You can find migration guides for each package here:

* [Accounts](https://github.com/Vonage/vonage-node-sdk/blob/3.x/packages/accounts/v2_TO_v3_MIGRATION_GUIDE.md)
* [Applications](https://github.com/Vonage/vonage-node-sdk/blob/3.x/packages/applications/v2_TO_v3_MIGRATION_GUIDE.md)
* [Messages](https://github.com/Vonage/vonage-node-sdk/blob/3.x/packages/messages/v2_TO_v3_MIGRATION_GUIDE.md)
* [Number Insights](https://github.com/Vonage/vonage-node-sdk/blob/3.x/packages/number-insights/v2_TO_v3_MIGRATION_GUIDE.md)
* [Numbers](https://github.com/Vonage/vonage-node-sdk/blob/3.x/packages/numbers/v2_TO_v3_MIGRATION_GUIDE.md)
* [Pricing](https://github.com/Vonage/vonage-node-sdk/blob/3.x/packages/pricing/v2_TO_v3_MIGRATION_GUIDE.md)
* [SMS](https://github.com/Vonage/vonage-node-sdk/blob/3.x/packages/sms/v2_TO_v3_MIGRATION_GUIDE.md)
* [Verify](https://github.com/Vonage/vonage-node-sdk/blob/3.x/packages/verify/v2_TO_v3_MIGRATION_GUIDE.md)
* [Voice](https://github.com/Vonage/vonage-node-sdk/blob/3.x/packages/voice/v2_TO_v3_MIGRATION_GUIDE.md)

## Smaller Packages and Typescript

Version 3 uses [Typescript](https://www.typescriptlang.org/) to help with code completion in your preferred IDE. But an even bigger improvement is the use of [monorepos](https://github.com/Vonage/vonage-node-sdk/blob/3.x/packages/voice/v2_TO_v3_MIGRATION_GUIDE.md). A monorepo breaks up the code base into smaller packages while keeping the dependancies tree intact. Now you can use specific package(s) in your application rather than including the entire suite of products. We made this change strategically to allow us to release beta features and fixes without holding up the main development branch. One example of this is the new Video API package (which in the past was part of the [OpenTok SDK](https://github.com/opentok/opentok-node)):

```js
import { Auth } from '@vonage/auth';
import { Video } from '@vonage/video';

const credentials = new Auth({
    apiKey: VONAGE_API_KEY,
    apiSecret: VONAGE_API_SECRET,
});

const video = new Video(credentials);

const getVideoSession = async () => {
    try {
        const session = await video.createSession({ mediaMode: 'routed' });
        console.log('Session created', session);
        return session;
    } catch (error) {
        console.log('Failed to create session');
        console.error(error);
        throw error;
    }
}
```

Now you can use a beta SDK package and keep the stable packages.

## Support

Following [our support](https://github.com/Nexmo/server-sdk-specification/blob/main/SPECIFICATION.md#sdk-support) document, we will continue to support version 2 for another six months bringing us to around May of 2023. We will not be adding new features, just fixes.

For more detailed information, please visit the SDK documentation or look at the code snippets. You can reach out to us on the Vonage Developer [Slack](https://developer.vonage.com/community/slack) and stay in the loop by following [VonageDev](https://twitter.com/VonageDev) on Twitter.
