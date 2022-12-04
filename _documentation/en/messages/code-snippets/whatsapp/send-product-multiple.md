---
title: Send a Multiple Item Product Message
meta_title: Send a Product message containing multiple items on WhatsApp using the Messages API
---

# Send a Multiple Item Product Message

In this code snippet you learn how to send a product message containing multiple product items to WhatsApp chat using the Messages API. You can read more about [Product Messages](/messages/concepts/whatsapp-product-messages) for additional context on using this code snippet.

This message type uses Vonage's [Custom object](/messages/concepts/custom-objects) feature. Further information on the specific message format can be found in the WhatsApp developer [Product Messages](https://developers.facebook.com/docs/whatsapp/guides/commerce-guides/share-products-with-customers) documentation.

## Example

Find the description for all variables used in each code snippet below:

```snippet_variables
- VONAGE_APPLICATION_ID
- VONAGE_APPLICATION_PRIVATE_KEY_PATH
- VONAGE_PRIVATE_KEY_PATH
- BASE_URL.MESSAGES
- MESSAGES_API_URL
- WHATSAPP_NUMBER
- VONAGE_WHATSAPP_NUMBER
- VONAGE_NUMBER.WHATSAPP
- TO_NUMBER.MESSAGES
```

> **NOTE:** Don't use a leading `+` or `00` when entering a phone number, start with the country code, for example, 447700900000.

```code_snippets
source: '_examples/messages/whatsapp/send-product-multiple'
application:
  type: messages
  name: 'Send a multi-product message to WhatsApp'
```

## Try it out

When you run the code a WhatsApp multi-product message is sent to the destination number.

## Further information

* [Custom objects](/messages/concepts/custom-objects)
* [Product Messages](/messages/concepts/whatsapp-product-messages)
* [WhatsApp documentation for Product Messages](https://developers.facebook.com/docs/whatsapp/guides/commerce-guides/share-products-with-customers)
