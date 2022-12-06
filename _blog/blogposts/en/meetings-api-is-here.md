---
title: Meetings API Is Here!
description: The Vonage Meetings API is here! Here are some advantages, code
  samples, and other reasons to give it a try.
thumbnail: /content/blog/meetings-api-is-here/meetings_api.png
author: benjamin-aronov
published: true
published_at: 2022-12-06T11:10:44.215Z
updated_at: 2022-12-06T11:10:44.259Z
category: announcement
tags:
  - meetings-api
comments: true
spotlight: false
redirect: ""
canonical: ""
outdated: false
replacement_url: ""
---
## Meetings API is now in GA!

Vonage Unified Communications Applications like Vonage Business Communications (VBC) and Vonage Contact Center (VCC) are already built on the Meetings API so you can trust the API to be completely stable and rigorously tested. Find pricing for Meetings API [here](https://developer.vonage.com/meetings/overview#pricing).

## Another Video API, But Why?

Remember a not-so-distant past, in which video calls were cumbersome and awkward? Remember the need for external webcams? Remember when the promise of business calls amounted to one boardroom of people in suits talking to another boardroom of people in suits? Those days are over. Not only are folks having video calls with friends, family, and colleagues, but they're also preferring to meet businesses through video. According to Vonage's 2022 [Global Customer Engagement Report](https://www.vonage.com/resources/publications/global-customer-engagement-report/), daily video chat use for business communications will double this year. And consumers are increasingly using businesses' own applications to do this. People are expecting a seamless, connected customer experience that includes video conferencing in a company’s toolbelt. 

![Example of a Meetings API Room ](/content/blog/meetings-api-is-here/video-menu.png "Example of a Meetings API Room")

We built the Meetings API to meet this need. Just as video conferencing used to be cumbersome for users, it was even more painful for companies to integrate with their software. WebRTC is complicated. It's been around quite a while but it's still not easy to get going or scale for growth. Vonage APIs help abstract the complicated parts of WebRTC without sacrificing performance or functionality. In contrast to Vonage's other in-app Video products ([Video API](https://tokbox.com/developer/guides/basics/) and [Video Express](https://tokbox.com/developer/video-express/)), Meetings API started out as a full-featured video conference application–Vonage Meetings, part of the Vonage Business Communications ([VBC](https://www.vonage.co.uk/unified-communications)) suite–and became an API. This means that businesses have a simplified, Low-Code option, packed with all the conferencing capabilities of a complete application. It’s for companies who want an easier way to own their video experience, something in between an off-the-shelf application and a full API.

Simply put, Meetings API was built around experience. Customers now expect a video experience. Developers now expect a simple experience. Meetings API meets both these expectations.

> Did you know?
>
> Meetings API drives visual engagement for over 4,000 brands and 100,000 daily participants as part of Vonage Business Communications (VBC) UC application

## Video Meeting Capabilities

The Meetings API powers the VBC application and thus is capable of handling all standard video conferencing functionality.

* Meetings framework:

  * Intuitive room and user management  
  * End-to-end UX & UI: error messages, loading pages, waiting rooms, full audio/video selection
* Engagement tools:

  * Screen sharing
  * Active speaker detection
  * Built-in chat
  * Session recording
  * Phone dial-in
  * Collaboration: whiteboard, watch together, roundtable, raise hand, emoji reactions
* Moderation tools:

  * Participant video and/or audio muting
  * Participant blocking
* Security features:

  * Lock meeting: denying new participants from joining
  * Waiting room for participants who join early
* Client optimization:

  * Room size: 200 participants, 25 presenters
  * Performance and UX for web, native or PSTN;
  * App Store compliant
* Customization capabilities:

  * Add your brand color and logo to allow seamless integration with your website or app
  * Internationalization Coming Soon: User Interface will be available in 5+ languages (French, Italian, Spanish and more)
* HIPAA compliant:

  * Healthcare applications can securely use Meetings API and assure HIPAA compliance

![Preview of Meetings API With Spanish Internationalization](/content/blog/meetings-api-is-here/screen-shot-2022-11-14-at-17.49.50.png "Preview of Meetings API With Spanish Internationalization")

## Code Simplicity

The Meetings API allows developers to "drop-in" a full video experience into their application. Just send the right request to the API and it will return the information about the room it has created.

To use the API, you need to authorize the request with a JSON Web Token (JWT). Use the [JWT Generator](https://developer.vonage.com/jwt) to create a JWT using the Application ID and Private Key of your application. This can be found in your Vonage [Developer Dashboard](https://dashboard.nexmo.com/) ﻿by navigating to the application you are building.

For further details about JWTs, please see [Vonage Authentication](https://developer.vonage.com/concepts/guides/authentication).

### Creating A Room

The API allows the creation of two types of rooms:

1. An Instant Room (or the default room) is created for meetings happening right now. It is active for ten minutes until the first participant joins the room and for ten minutes after the last participant leaves.

Sample request to create an instant room:

```
curl -X POST 'https://api-eu.vonage.com/beta/meetings/rooms'
-H 'Authorization: Bearer $YOUR_JWT_GOES_HERE'
-H 'content-type: application/json'
-d '{ "display_name":"New Meeting Room" }'
```

2. A Long Term Room, which remains alive until the specified expiration date (the maximum is one year). This room is typically linked to a recurring meeting, person, or resource.

Sample request to create a long term room:

```
curl -X POST 'https://api-eu.vonage.com/beta/meetings/rooms'
-H 'Authorization: Bearer $YOUR_JWT_GOES_HERE'
-H 'content-type: application/json'
-d '{ "display_name":"New Meeting Room", "type": "long_term", "expires_at": "2022-04-28T14:20:20.462Z", }'
```

#### Recording Configuration

Rooms are configurable by passing the additional `recording_options` object. You can decide if the session will be recorded with the `auto_record` boolean. Additionally, you can choose to only record the video of the room's owner (host) with the `record_only_owner` boolean.

An example of how to pass these options:

```
curl -X POST 'https://api-eu.vonage.com/beta/meetings/rooms'
-H 'Authorization: Bearer $YOUR_JWT_GOES_HERE'
-H 'Content-Type: application/json' 
-d '{
      "display_name":"New Meeting Room",
      "recording_options": {
        "auto_record": true,
        "record_only_owner": true
      }
    }'
```

### Successful Room Response

After successfully creating a Meeting Room, the API will return a response. The response contains the important _links object which holds both the host_url and the guest_url. These will be the links to send your users to the meeting, appropriately. Additionally, the response contains is_available which will be true unless the room has expired. The theme_id will be null until a theme is set.

An example of an instant room response:

```javascript
{
  "id": "ec1021f3-df34-4153-b7cb-aedd0f974405",
  "display_name": "My New Room",
  "metadata": null,
  "type": "instant",
  "expires_at": "2022-03-29T08:01:18.513Z",
  "recording_options": {
    "auto_record": false
  },
  "meeting_code": "641766519",
  "_links": {
    "host_url": {
      "href": "https://meetings.vonage.com/?room_token=641766519&participant_token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IjA3YTA5MmFmLTE5YWUtNDg5Ny05NzQ1LWI2YjJkNjk5N2YyMSJ9.eyJwYXJ0aWNpcGFudElkIjoiZWU0ZjRkMmQtMzEwMy00YjVmLThhYzgtYTY2NjgxMmU4ZGViIiwiaWF0IjoxNjQ4NTQwMjc4fQ.AhrsWT1tSWEjoN0xDAMjVrEMRmvBMcwUWyhsa4yLCrg"
    },
    "guest_url": {
      "href": "https://meetings.vonage.com/641766519"
    }
  },
  "created_at": "2022-03-29T07:51:18.514Z",
  "is_available": true,
  "expire_after_use": false,
  "theme_id": null,
  "initial_join_options": {
    "microphone_state": "default"
  }
}
```

### Website Embed

A meeting created through the API can be embedded into your website or application. To do this, generate the meeting link and create an iFrame using that link:

`<iframe src="Meeting link goes here" title="Embedded Meeting" allow="camera;microphone"></iframe>`

This is currently supported for both desktop and mobile applications using the following:

* Desktop - Supported on Firefox and Chrome based browsers.
* iOS 14+ - Supported on Safari, Edge or Firefox.

  * Embed Meetings in native iOS with [WKWebView](https://developer.apple.com/documentation/webkit/wkwebview)
* Android - Supported on Chrome or Samsung browser v14+.

Feature functionality depends on display sizes. See full functionality [here](https://developer.vonage.com/meetings/overview#website-and-app-embed).

You will also need to send an [email request to the Meetings API team](mailto:meetings-api@vonage.com) to whitelabel the domain of the website the iFrame is used in.

## Advanced Capabilities

![Demonstration of Custom Theme Management](/content/blog/meetings-api-is-here/meetings_api_demo.gif "Demonstration of Custom Theme Management")

### Custom Theme Management

With Meetings API, you can let your brand shine! Add custom colors, logos, or texts. Themes can be applied to one room, a few rooms, or all the meeting rooms in the application.

> Note: The endpoint for working with Themes is different than Rooms.
>
> https://api-eu.vonage.com/beta/meetings/themes

To learn how to use themes and logos visit the [Theme Management for Meeting Rooms](https://developer.vonage.com/meetings/code-snippets/theme-management).

### Callbacks

In the [Vonage API Developer Dashboard](https://dashboard.nexmo.com/applications/new), you can configure webhooks in your application to listen for events. Find the following form when creating your [new Vonage application](https://dashboard.nexmo.com/applications/new): 

![Meetings API Capability Webhooks Toggle ](/content/blog/meetings-api-is-here/screen-shot-2022-11-15-at-13.25.14.png "Meetings API Capability Webhooks Toggle ")

The Meetings API allows you to receive about session events, participant activity, recording details, and room expiration:

* Participant: participant:joined
* Recording: recording:started, recording:ended, recording:uploaded
* Room: room:expired
* Session: session:started, session:ended, session:participant:left

Example payload for a new meeting joiner:

```javascript
{
  "event": "session:participant:joined",
  "participant_id": "b424e1c4-e988-4ce2-8ab9-e3efea7de542",
  "session_id": "2_MX40NjMzOTg5Mn5-MTYzNTg2ODQwODY4NH41cXIzMDdSa1BZa05BUDFpYnhxcTV4MCt-fg",
  "room_id": "b307d837-c0ce-4619-8c5c-70e418ef9693",
  "name": "New Joiner",
  "type": "Guest",
  "is_host": true
}
```

## Join the Conversation

Are you excited to get started with the Meetings API? Still unsure? Let us know what you're building and how we can help! Come join the conversation on our [Vonage Community Slack](https://developer.vonage.com/community/slack) or send us a message on [Twitter](https://twitter.com/VonageDev).
