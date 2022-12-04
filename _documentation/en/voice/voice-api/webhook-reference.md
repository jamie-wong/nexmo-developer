---
title: Webhook Reference
description: Details of the webhooks that Vonage sends relating to voice calls.
api: "Voice API: Webhooks"
---

# Voice API Webhooks Reference

Vonage uses webhooks alongside its Voice API to enable your application to interact with the call. There are two required, and one optional, webhook endpoints:

* [Answer webhook](#answer-webhook) is sent when a call is answered. This is for both incoming and outgoing calls.
* [Event webhook](#event-webhook) is sent for all the events that occur during a call. Your application can log, react to or ignore each event type.
* [Fallback URL](#fallback-url) is used when either the Answer or Event webhook fails or returns an HTTP error status.
* [Errors](#errors) are also delivered to the event webhook endpoint if they occur.

For more general information, check out our [webhooks guide](/concepts/guides/webhooks).

## Signed Webhooks

Signed webhooks are a way to verify that the request is coming from Vonage and its payload has not been tampered with during transit. Voice API, as well as [Messages](/messages/overview) and [Dispatch](/dispatch/overview) APIs, support signed callbacks by default. See [Decoding signed webhooks](/concepts/guides/webhooks#decoding-signed-webhooks) to learn how to decode an incoming JWT signature.

## Answer Webhook

When an incoming call is answered, an HTTP request is sent to the `answer_url` you specified when setting up the application. For outgoing calls, specify the `answer_url` when you make the call.

By default, the answer webhook will be a `GET` request but this can be overridden to `POST` by setting the `answer_method` field. For incoming calls, you configure these values when you create the application. For outgoing calls, you specify these values when making a call.

### Answer webhook data fields

Field | Example | Description 
 -- | -- | --
`to` | `442079460000` | The number that answered the call. (This is the virtual number linked to in your [application](/application/overview).)
`from` | `447700900000` | The number that called `to`. (This could be a landline or mobile number, or another virtual number if the call was made programmatically.)
`uuid` | `aaaaaaaa-bbbb-cccc-dddd-0123456789ab` | A unique identifier for this call
`conversation_uuid` | `CON-aaaaaaaa-bbbb-cccc-dddd-0123456789ab` | A unique identifier for this conversation
`region_url` | `https://api-ap-3.vonage.com` | Regional API endpoint which should be used to control the call with [REST API](/api/voice#updateCall); see the full list of regions [here](/voice/voice-api/guides/troubleshooting/node#regions)
`custom_data` | `{ "key": "value" }` | A custom data object, optionally passed as parameter on the `callServer` method when a call is initiated from an application using the [Client SDK](/client-sdk/in-app-voice/guides/make-call/javascript#start-a-server-managed-call)

#### Transmitting additional data with SIP headers

In addition to the above fields, you can specify any additional headers you need when using SIP Connect. Any headers provided must start with `X-` and will be sent to your `answer_url` with a prefix of `SipHeader_`. For example, if you add a header of `X-UserId` with a value of `1938ND9`, Vonage will add `SipHeader_X-UserId=1938ND9` to the request made to your `answer_url`.

> **Warning:** Headers that start with `X-Nexmo` will not be sent to your `answer_url`

### Answer webhook data field examples

For a `GET` request, the variables will be in the URL, like this:

```
/answer.php?to=442079460000&from=447700900000&conversation_uuid=CON-aaaaaaaa-bbbb-cccc-dddd-0123456789ab&uuid=aaaaaaaa-bbbb-cccc-dddd-0123456789ab&SipHeader_X-UserId=1938ND9
```

If you set the `answer_method` to `POST` then you will receive the request with JSON format data in the body:

```
{
  "from": "442079460000",
  "to": "447700900000",
  "uuid": "aaaaaaaa-bbbb-cccc-dddd-0123456789ab",
  "conversation_uuid": "CON-aaaaaaaa-bbbb-cccc-dddd-0123456789ab",
  "SipHeader_X-UserId": "1938ND9"
}
```

### Responding to the answer webhook

Vonage expect you to return an [NCCO](/voice/voice-api/ncco-reference) in JSON format containing the actions to perform.

## Event webhook

HTTP requests will arrive at the event webhook endpoint when there is any status change for a call. The URL will be the `event_url` you specified when creating your application unless you override it by setting a specific `event_url` when starting a call.

By default the incoming requests are `POST` requests with a JSON body. You can override the method to `GET` by configuring the `event_method` in addition to the `event_url`.

The format of the data included depends on which event has occurred:

* [`started`](#started)
* [`ringing`](#ringing)
* [`answered`](#answered)
* [`busy`](#busy)
* [`cancelled`](#cancelled)
* [`unanswered`](#unanswered)
* [`disconnected`](#disconnected)
* [`rejected`](#rejected)
* [`failed`](#failed)
* [`human/machine`](#human-machine)
* [`timeout`](#timeout)
* [`completed`](#completed)
* [`record`](#record)
* [`input`](#input)
* [`transfer`](#transfer)
* [`payment`](#payment)

### Started

Indicates that the call has been created.

Field | Example | Description
 -- | -- | --
`from` | `442079460000` | The number the call came from
`to` | `447700900000` | The number the call was made to 
`uuid` | `aaaaaaaa-bbbb-cccc-dddd-0123456789ab` | The unique identifier for this call
`conversation_uuid` | `CON-aaaaaaaa-bbbb-cccc-dddd-0123456789ab` | The unique identifier for this conversation
`status` | `started` | Call status
`direction` | `outbound` | Call direction, can be either `inbound` or `outbound`
`timestamp` | `2020-01-01T12:00:00.000Z` | Timestamp (ISO 8601 format)

[Back to event webhooks list](#event-webhook)

### Ringing

The destination is reachable and ringing.

Field | Example | Description
 -- | -- | --
`from` | `442079460000` | The number the call came from
`to` | `447700900000` | The number the call was made to 
`uuid` | `aaaaaaaa-bbbb-cccc-dddd-0123456789ab` | The unique identifier for this call
`conversation_uuid` | `CON-aaaaaaaa-bbbb-cccc-dddd-0123456789ab` | The unique identifier for this conversation
`status` | `ringing` | Call status
`direction` | `outbound` | Call direction, can be either `inbound` or `outbound`
`timestamp` | `2020-01-01T12:00:00.000Z` | Timestamp (ISO 8601 format)

[Back to event webhooks list](#event-webhook)

### Answered

The call was answered.

Field | Example | Description
 -- | -- | --
`start_time` | - | *empty*
`rate` | - | *empty*
`from` | `442079460000` | The number the call came from
`to` | `447700900000` | The number the call was made to 
`uuid` | `aaaaaaaa-bbbb-cccc-dddd-0123456789ab` | The unique identifier for this call
`conversation_uuid` | `CON-aaaaaaaa-bbbb-cccc-dddd-0123456789ab` | The unique identifier for this conversation
`status` | `answered` | Call status
`direction` | `inbound` | Call direction, can be either `inbound` or `outbound`
`network` | - | *empty*
`timestamp` | `2020-01-01T12:00:00.000Z` | Timestamp (ISO 8601 format)

[Back to event webhooks list](#event-webhook)

### Busy

The destination is on the line with another caller.

Field | Example | Description
 -- | -- | --
`from` | `442079460000` | The number the call came from
`to` | `447700900000` | The number the call was made to 
`uuid` | `aaaaaaaa-bbbb-cccc-dddd-0123456789ab` | The unique identifier for this call
`conversation_uuid` | `CON-aaaaaaaa-bbbb-cccc-dddd-0123456789ab` | The unique identifier for this conversation
`status` | `busy` | Call status
`direction` | `outbound` | Call direction, this will be `outbound` in this context
`timestamp` | `2020-01-01T12:00:00.000Z` | Timestamp (ISO 8601 format)

[Back to event webhooks list](#event-webhook)

### Cancelled

An outgoing call is cancelled by the originator before being answered.

Field | Example | Description
 -- | -- | --
`from` | `442079460000` | The number the call came from
`to` | `447700900000` | The number the call was made to 
`uuid` | `aaaaaaaa-bbbb-cccc-dddd-0123456789ab` | The unique identifier for this call
`conversation_uuid` | `CON-aaaaaaaa-bbbb-cccc-dddd-0123456789ab` | The unique identifier for this conversation
`status` | `cancelled` | Call status
`direction` | `outbound` | Call direction, this will be `outbound` in this context
`timestamp` | `2020-01-01T12:00:00.000Z` | Timestamp (ISO 8601 format)

[Back to event webhooks list](#event-webhook)

### Unanswered

Either the recipient is unreachable or the recipient declined the call.

Field | Example | Description
 -- | -- | --
`from` | `442079460000` | The number the call came from
`to` | `447700900000` | The number the call was made to 
`uuid` | `aaaaaaaa-bbbb-cccc-dddd-0123456789ab` | The unique identifier for this call
`conversation_uuid` | `CON-aaaaaaaa-bbbb-cccc-dddd-0123456789ab` | The unique identifier for this conversation
`status` | `unanswered` | Call status
`detail` | `unavailable` | Indicates if the subscriber is temporarily unavailable (`unavailable`) or the carrier could not produce a response within a suitable amount of time (`timeout`)
`direction` | `outbound` | Call direction, this will be `outbound` in this context
`timestamp` | `2020-01-01T12:00:00.000Z` | Timestamp (ISO 8601 format)

[Back to event webhooks list](#event-webhook)

### Disconnected

If the WebSocket connection is terminated from the application side for any reason then the disconnected event callback will be sent, if the response contains an NCCO then this will be processed, if no NCCO is present then normal execution will continue.

Field | Example | Description
-- | -- | --
`from` | `442079460000` | The number the call came from
`to` | `447700900000` | The number the call was made to 
`uuid` | `aaaaaaaa-bbbb-cccc-dddd-0123456789ab` | The unique identifier for this call
`conversation_uuid` | `CON-aaaaaaaa-bbbb-cccc-dddd-0123456789ab` | The unique identifier for this conversation
`status` | `disconnected` | Call status
`timestamp` | `2020-01-01T12:00:00.000Z` | Timestamp (ISO 8601 format)

[Back to event webhooks list](#event-webhook)

### Rejected

The call was rejected by Vonage before it was connected.

Field | Example | Description
 -- | -- | --
`from` | `442079460000` | The number the call came from
`to` | `447700900000` | The number the call was made to 
`uuid` | `aaaaaaaa-bbbb-cccc-dddd-0123456789ab` | The unique identifier for this call
`conversation_uuid` | `CON-aaaaaaaa-bbbb-cccc-dddd-0123456789ab` | The unique identifier for this conversation
`status` | `rejected` | Call status
`detail` | `restricted` | Indicates if `to` or `from` numbers are invalid (`invalid_number`), the call rejected by carrier (`restricted`) or rejected by callee (`declined`)
`direction` | `outbound` | Call direction, this will be `outbound` in this context
`timestamp` | `2020-01-01T12:00:00.000Z` | Timestamp (ISO 8601 format)

[Back to event webhooks list](#event-webhook)

### Failed

The outgoing call could not be connected.

Field | Example | Description
 -- | -- | --
`from` | `442079460000` | The number the call came from
`to` | `447700900000` | The number the call was made to 
`uuid` | `aaaaaaaa-bbbb-cccc-dddd-0123456789ab` | The unique identifier for this call
`conversation_uuid` | `CON-aaaaaaaa-bbbb-cccc-dddd-0123456789ab` | The unique identifier for this conversation
`status` | `failed` | Call status
`detail` | `cannot_route` | Indicates the destination is not supported or blocked for the account (`cannot_route`), the number is not available (`number_out_of_service`) or a server error occurred (`internal_error`)
`direction` | `outbound` | Call direction, this will be `outbound` in this context
`timestamp` | `2020-01-01T12:00:00.000Z` | Timestamp (ISO 8601 format)

[Back to event webhooks list](#event-webhook)

### Human / Machine

For an outbound call made programmatically, if the `machine_detection` option is set then an event with a status of `human` or `machine` will be sent depending whether a person answered the call or not.

Field | Example | Description
 -- | -- | --
`call_uuid` | `aaaaaaaa-bbbb-cccc-dddd-0123456789ab` | The unique identifier for this call (**Note** `call_uuid`, not `uuid` as in some other endpoints)
`from` | `442079460000` | The number the call came from
`to` | `447700900000` | The number the call was made to 
`status` | `human` | Call status, can be either `human` if a person answered or `machine` if the call was answered by voicemail or another automated service
`conversation_uuid` | `CON-aaaaaaaa-bbbb-cccc-dddd-0123456789ab` | The unique identifier for this conversation
`timestamp` | `2020-01-01T12:00:00.000Z` | Timestamp (ISO 8601 format)

[Back to event webhooks list](#event-webhook)

### Timeout

If the duration of the ringing phase exceeds the specified `ringing_timeout` duration, this event will be sent.

Field | Example | Description
 -- | -- | --
`from` | `442079460000` | The number the call came from
`to` | `447700900000` | The number the call was made to 
`uuid` | `aaaaaaaa-bbbb-cccc-dddd-0123456789ab` | The unique identifier for this call
`conversation_uuid` | `CON-aaaaaaaa-bbbb-cccc-dddd-0123456789ab` | The unique identifier for this conversation
`status` | `timeout` | Call status
`direction` | `outbound` | Call direction, this will be `outbound` in this context
`timestamp` | `2020-01-01T12:00:00.000Z` | Timestamp (ISO 8601 format)

[Back to event webhooks list](#event-webhook)

### Completed

The call is over, this event also includes summary data about the call.

Field | Example | Description
 -- | -- | --
`end_time` | `2020-01-01T12:00:00.000Z` | Timestamp (ISO 8601 format)
`uuid` | `aaaaaaaa-bbbb-cccc-dddd-0123456789ab` | The unique identifier for this call
`network` | `GB-FIXED` | The type of network that was used in the call
`duration` | `2` | Call length (in seconds)
`start_time` | `2020-01-01T12:00:00.000Z` | Timestamp (ISO 8601 format)
`rate` | `0.00450000` | Cost per minute of the call (EUR)
`price` | `0.00015000` | Total cost of the call (EUR)
`from` | `442079460000` | The number the call came from
`to` | `447700900000` | The number the call was made to 
`conversation_uuid` | `CON-aaaaaaaa-bbbb-cccc-dddd-0123456789ab` | The unique identifier for this conversation
`status` | `completed` | Call status
`direction` | inbound | Call direction, can be either `inbound` or `outbound`
`timestamp` | `2020-01-01T12:00:00.000Z` | Timestamp (ISO 8601 format)

[Back to event webhooks list](#event-webhook)

### Record

This webhook arrives when an NCCO with a "record" action has finished. When creating a record action, you can set a different `eventUrl` for this event to be sent to. This can be useful if you want to use separate code to handle this event type.

Field | Example | Description
 -- | -- | --
`start_time` | `2020-01-01T12:00:00.000Z` | Timestamp (ISO 8601 format)
`recording_url` | `https://api.nexmo.com/v1/files/bbbbbbbb-aaaa-cccc-dddd-0123456789ab` | Where to download the recording
`size` | 12222 | The size of the recording file (in bytes)
`recording_uuid` | `aaaaaaaa-bbbb-cccc-dddd-0123456789ab` | A unique identifier for this recording
`end_time` | `2020-01-01T12:00:00.000Z` | Timestamp (ISO 8601 format)
`conversation_uuid` | `CON-aaaaaaaa-bbbb-cccc-dddd-0123456789ab` | The unique identifier for this conversation
`timestamp` | `2020-01-01T12:00:00.000Z` | Timestamp (ISO 8601 format)

#### Transcription

Field | Example | Description
 -- | -- | --
`conversation_uuid` | `CON-aaaaaaaa-bbbb-cccc-dddd-0123456789ab` | The unique identifier for this conversation
`type` | `record` | The NCCO action of type record
`recording_uuid` | `aaaaaaaa-bbbb-cccc-dddd-0123456789ab` | A unique identifier for this recording
`status` | `transcribed` | Transcription status
`transcription_url` | `https://api.nexmo.com/v1/files/bbbbbbbb-aaaa-cccc-dddd-0123456789ab` | The URL to the file containing the recording's transcription


[Back to event webhooks list](#event-webhook)

### Input 

This webhook is sent by Vonage when an NCCO with an action of "input" has finished.

Field | Example | Description
 -- | -- | --
`from` | `447700900000` | The number the call came from
`to` | `447700900000` | The number the call was made to
`dtmf` | _see below_ | [DTMF capturing results](#dtmf-capturing-results)
`speech` | _see below_ | [Speech recognition results](#speech-recognition-results)
`uuid` | `aaaaaaaa-bbbb-cccc-dddd-0123456789ab` | The unique identifier for this call
`conversation_uuid` | `CON-aaaaaaaa-bbbb-cccc-dddd-0123456789ab` | The unique identifier for this conversation
`timestamp` | `2020-01-01T12:00:00.000Z` | Timestamp (ISO 8601 format)

#### DTMF Capturing Results

Field | Example | Description
 -- | -- | --
`digits` | `42` | The buttons pressed by the user 
`timed_out` | `true` | Whether the DTMF input timed out: `true` if it did, `false` if not

#### Speech Recognition Results

Field | Example | Description
-- | -- | --
`timeout_reason` | `end_on_silence_timeout` | Indicates if the input ended when user stopped speaking (`end_on_silence_timeout`), by max duration timeout (`max_duration`) or if the user didn't say anything (`start_timeout`)
`results` | _see below_ | Array of [recognized text objects](#transcript-text)
`error` | `ERR1: Failed to analyze audio` | Error message.
`recording_url` | `https://api-us.nexmo.com/v1/files/eeeeeee-ffff-0123-4567-0123456789ab` | Speech recording. Included if `saveAudio` flag is set to `true` in the `input` action. Requires JWT authorization for downloading, see [Download a recording](/voice/voice-api/code-snippets/download-a-recording).

##### Transcript text
Field | Example | Description
-- | -- | --
`text` | `sales` | Transcript text representing the words that the user spoke.
`confidence` | `0.9405097` | The confidence estimate between 0.0 and 1.0. A higher number indicates an estimated greater likelihood that the recognized words are correct.

See also complete example payload shown in [NCCO Reference](/voice/voice-api/ncco-reference#speech-recognition-settings)

[Back to event webhooks list](#event-webhook)

### Transfer

This webhook is sent by Vonage when a leg has been transferred from one conversation to another. This can be done using an NCCO or the [`transfer` action](/api/voice#updateCall)

Field | Example | Description
 -- | -- | --
`conversation_uuid_from` | `CON-aaaaaaaa-bbbb-cccc-dddd-0123456789ab` | The conversation ID that the leg was originally in
`conversation_uuid_to` | `CON-aaaaaaaa-bbbb-cccc-dddd-0123456789ab` | The conversation ID that the leg was transferred to
`uuid` | `aaaaaaaa-bbbb-cccc-dddd-0123456789ab` | The unique identifier for this call
`timestamp` | `2020-01-01T12:00:00.000Z` | Timestamp (ISO 8601 format)

[Back to event webhooks list](#event-webhook)

### Payment

This webhook is sent by Vonage when an NCCO with an action of "[pay](/voice/voice-api/ncco-reference#pay)" has finished.

Field | Example | Description
-- | -- | --
`from` | `447700900000` | The number the call came from
`to` | `447700900000` | The number the call was made to
`uuid` | `aaaaaaaa-bbbb-cccc-dddd-0123456789ab` | The unique identifier for this call
`conversation_uuid` | `CON-aaaaaaaa-bbbb-cccc-dddd-0123456789ab` | The unique identifier for this conversation
`status` | `success` | Payment operation status. Possible values: `success`, `failure`
`timestamp` | `2021-08-23T15:27:46.479Z` | Timestamp (ISO 8601 format)

[Back to event webhooks list](#event-webhook)

## Fallback URL

The fallback webhook is accessed when either the answer webhook or the event webhook, when the event is expected to respond with an NCCO, returns an HTTP error status or is unreachable. The data that is returned from the fallback URL is the same as would be received in the original answer URL or event URL, with the addition of two new parameters, `reason` and `original_request`:

```
{
  "reason": "Connection closed.",
  "original_request": {
    "url": "https://api.example.com/webhooks/event",
    "type": "event"
  }
}
```

If there was a connection closed or reset, timeout or an HTTP status code of `429`, `503` or `504` during the initial NCCO the `answer_url` is attempted twice, then:

1. Attempt to reach the `fallback_answer_url` twice
2. If no success, then the call is terminated

If there was a connection closed or reset, timeout or an HTTP status code of `429`, `503` or `504` during a call in progress the `event_url` for events that are expected to return an NCCO (e.g. return for an `input` or `notify` action) is attempted twice, then:

1. Attempt to reach the `fallback_answer_url` twice
2. If no success, continue the call flow

## Errors

The event endpoint will also receive webhooks in the event of an error. This can be useful when debugging your application.

Field | Example | Description
 -- | -- | --
`reason` | `Syntax error in NCCO. Invalid value type or action.` | Information about the nature of the error
`conversation_uuid` | `CON-aaaaaaaa-bbbb-cccc-dddd-0123456789ab` | The unique identifier for this conversation
`timestamp` | `2020-01-01T12:00:00.000Z` | Timestamp (ISO 8601 format)
