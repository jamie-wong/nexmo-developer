---
title: Create an Instant Room
navigation_weight: 2
description: Setting up an Instant Meeting Room
---

# Set up an Instant Meeting Room

How to set up an Instant (default) room using the Meetings API.

## Prerequisites

* **Vonage Developer Account**: If you do not already have one, sign-up for a free account on the [Vonage Developers Account](https://ui.idp.vonage.com/ui/auth/registration?icid=tryitfree_adpdocs_nexmodashbdfreetrialsignup_inpagelink).

* **Meetings API Activation**: To activate the Meetings API, you must register. Please send an email request to the [Meetings API Team](mailto:meetings-api@vonage.com).

* **Application ID and Secret**: Once you’re logged in to the [Vonage API Dashboard](https://dashboard.nexmo.com), click on Applications and create a new Application. Click  `Generate public and private key` and record the private key. You'll be using the private key with the Application ID to [Generate a JSON Web Token (JWT)](https://developer.vonage.com/jwt). For further details about JWTs, please see [Authentication](/concepts/guides/authentication).

## Set up POST Request

**POST Endpoint**: The endpoint for creating a meeting room is: ``https://api-eu.vonage.com/beta/meetings/rooms``.

**Required Headers**: You need to add the ``Content-Type`` to your headers: ``Content-Type: application/json``.

**Authorization**: Use the [JWT Generator](https://developer.vonage.com/jwt) to create a JWT from the Application ID and private key of the application. You'll use your JWT to create a [Token Authorization](/concepts/guides/authentication) string that is made up of ``Bearer`` and the JWT you created.

## Body Content

The following fields can be assigned values in the POST request:

Field | Required? | Description |
-- | -- | -- | --| -- |
``display_name`` | Yes | The name of the meeting room.
``metadata`` | No | Metadata that will be included in all callbacks.
``type``| No | The type of meeting which can be ``instant`` (the default) or ``long term``.
``recording_options`` | No | An object containing recording options for the meeting. For example:
| | | If ``auto_record``=``true``, the session will be recorded. If ``false``, the session will not be recorded.
| | | If ``record_only_owner``=``true``, all audio in the session will be recorded but only the video of the owner of the room will be recorded. If ``false``, all users in the session will be recorded.
``join_approval_level`` | No | The level of approval needed to join the meeting.  Must be one of the following:
| | | `after_owner_only` - Participants will join the meeting only after the host has joined.
| | | `explicit_approval` - Participants will join the waiting room, and the host will approve / deny them.
| | | `none` - No approval needed.

## Request

You can use the following code to start an instant room (default options):

``` curl

   curl -X POST 'https://api-eu.vonage.com/beta/meetings/rooms' \
   -H 'Authorization: Bearer XXXXX' \
   -H 'content-type: application/json' \
   -d '{
   "display_name":"New Meeting Room"
               }'
```

To create an instant room, automatically record and only record the owner of the room:

``` curl
   curl -X POST 'https://api-eu.vonage.com/beta/meetings/rooms' \
   -H 'Authorization: Bearer XXXXX' \
   -H 'Content-Type: application/json' \
   -d '{
   "display_name":"New Meeting Room",
   "recording_options": {
       "auto_record": true,
       "record_only_owner": true}
               }'
```

## Response

When an instant room is created the expiration date is set to 10 minutes.

As this room has not yet expired, ``is_available`` is set to true.

> If you set either ``auto_record`` or ``record_only_owner`` to ``true`` in your request, this option will be shown as ``true`` in the code below.

``` json
{
   "id":"a66e451f-794c-460a-b95a-cd60f5dbdc1a",
   "display_name":"New Meeting Room",
   "metadata":null,
   "type":"instant",
   "expires_at":"2021-10-19T17:54:17.219Z",
   "expire_after_use": false,
   "join_approval_level": "abc123",
   "recording_options":{
      "auto_record":true,
      "record_only_owner":true
   },
   "meeting_code":"982515622",
   "_links":{
      "host_url":{
         "href":"https://meetings.vonage.com/?room_token=982515622&participant_token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IjYyNjdkNGE5LTlmMTctNGVkYi05MzBmLTJlY2FmMThjODdj3BK7.eyJwYXJ0aWNpcGFudElkIjoiODNjNjQxNTQtYWJjOC00NTBkLTk1MmYtY2U4MWRmYWZiZDNkIiwiaWF0IjoxNjM0NjY1NDU3fQ.PmNtAWw5o4QtGiyQB0QVeq_qcl6fs0buGMx5t4Fy43c"
      },
      "guest_url":{
         "href":"https://meetings.vonage.com/982515622"
      }
   },
   "created_at":"2021-10-19T17:44:17.220Z",
   "is_available":true
}
```

> Your Instant Room has been created. Note the ``ID`` if you are going to further configure this room.
