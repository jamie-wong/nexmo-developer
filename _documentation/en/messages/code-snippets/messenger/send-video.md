---
title: Send a Video Message
meta_title: Send a Video message with Facebook Messenger
---

# Send a Video Message

In this code snippet you learn how to send a video message through Facebook Messenger using the Messages API.

For a step-by-step guide to this topic, you can read our tutorial [Sending Facebook Messenger messages with the Messages API](/tutorials/sending-facebook-messenger-messages-with-messages-api).

## Example

Find the description for all variables used in each code snippet below:

```snippet_variables
- VONAGE_APPLICATION_ID
- VONAGE_APPLICATION_PRIVATE_KEY_PATH
- VONAGE_PRIVATE_KEY_PATH
- BASE_URL.MESSAGES
- MESSAGES_API_URL
- FB_SENDER_ID.MESSAGES
- VONAGE_FB_SENDER_ID
- FROM_ID
- FB_RECIPIENT_ID
- TO_ID
- VIDEO_URL.MESSENGER.MESSAGES
```

```code_snippets
source: '_examples/messages/messenger/send-video'
application:
  type: messages
  name: 'Send a video message'
```

## Try it out

When you run the code a video message is sent to the Messenger recipient.
