---
title: Node
language: node
---

```js
const Vonage = require('@vonage/server-sdk');

const options = {
  apiHost: 'api-ap-3.vonage.com',
  restHost: 'rest-ap-3.vonage.com'
}

const vonage = new Vonage({
    apiKey: API_KEY,
    apiSecret: API_SECRET,
    applicationId: APP_ID,
    privateKey: PRIVATE_KEY_PATH,
    signatureSecret: SIGNATURE_SECRET,
    signatureMethod: SIGNATURE_METHOD
  }, options);
```
