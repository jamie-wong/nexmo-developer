---
title: Event
description: Conversations are event-driven. Event objects are generated when key activities occur.
navigation_weight: 9
---

# Event

Conversations and other Vonage objects such as Members and Applications generate Events. When key activities occur an event is generated, which can be handled by the application. For example when a User joins a Conversation a `member:joined` event is fired. Other events include `app:knocking`, and `conversation:created`.
If a Vonage Application has `rtc` as a capability, it will receive the dispatched event on the `rtc` `event_url` webhook.

Event type | Description
----|----
_General_|
`app:knocking` | 
`app:knocking:cancel` | 
`leg:status:update` |
_Audio_|
`audio:dtmf` | DTMF tone is received into the Leg.
`audio:earmuff:off` | Leg is unearmuffed.
`audio:earmuff:on` | Leg is earmuffed.
`audio:mute:off` | Leg is unmuted.
`audio:mute:on` | Leg is muted.
`audio:play:stop` | Audio streamed into a Leg is stopped.
`audio:play:done` | Audio streamed into a Leg stops playing, that is the audio data finishes.
`audio:play` | Audio is streamed into a Leg.
`audio:record:stop` | 
`audio:record:done` | 
`audio:record` | Call is being recorded.
`audio:ringing:start` | 
`audio:ringing:stop` | 
`audio:asr:done` |
`audio:asr:record:done` |
`audio:say:stop` | 
`audio:say:done` | 
`audio:say` | 
`audio:speaking:on` | 
`audio:speaking:off` |
_Text_ |
`text:seen` | Text message is seen by the recipient.
`text:delivered` | Text message is delivered to the recipient.
`text` | new In App Text  message was created.
`text:update` | Text message was updated.
`text:typing:on` | Member is typing.
`text:typing:off` |  Member stops typing.
_Image_ |
`image:delivered` | Image is delivered.
`image:seen` | Image is viewed by the recipient.
`image` | Image is uploaded.
_Message_ |
`message:rejected` | Message has been rejected.
`message:submitted` | Message has been submitted.
`message:undeliverable` | Message can't be delivered.
`message:delivered` | Message has been delivered.
`message:seen` | Message has been seen.
_Conversation_ |
`conversation:created` | new Conversation is created.
`conversation:deleted` | Conversation object is deleted.
`conversation:updated` | Conversation object is updated.
_Member_ |
`member:invited` | Member is invited into a Conversation.
`member:joined` | Member joins a Conversation.
`member:left` | Member leaves a Conversation.
`member:media` |
_RTC_ |
`rtc:status` | 
`rtc:transfer` | 
`rtc:hangup` | 
`rtc:terminate` | 
`rtc:answered` | 
_SIP_ |
`sip:status` | 
`sip:answered` | SIP call is answered.
`sip:machine` | When the entity answering the SIP call is a machine.
`sip:hangup` | User on a SIP Call hangs up.
`sip:ringing` | SIP call starts ringing, such as when Vonage makes an Outbound Call.

## Handling Events

The following code snippet shows that code can be executed based on the event fired:

``` javascript
...
    events.forEach((value, key) => {
        if (conversation.members[value.from]) {
            const date = new Date(Date.parse(value.timestamp))
            switch (value.type) {
                case 'text:seen':
                    ...
                    break;
                case 'text:delivered':
                    ...
                    break;
                case 'text':
                    ...
                    break;
                case 'member:joined':
                    ...
                    break;
                case 'member:left':
                    ...
                    break;
                case 'member:invited':
                    ...
                    break;
                case 'member:media':
                    ...
                    break;
                default:
                ...
            }
        }
    })
...
```
