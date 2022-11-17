---
version: '7.1.1'
release: '16 Nov 2022'
---
# [Vonage Java SDK](https://github.com/Vonage/vonage-java-sdk)

---

## 7.1.1
### 16 Nov 2022
- Bumped `com.fasterxml.jackson` dependency version to 2.14.0

## 7.1.0
### 25 Aug 2022
- Added convenience method to `MessagesClient` for using the Messages Sandbox endpoint
- Added `network` field to `VerifyResponse`
- Added missing documentation and validation to requests and responses in Verify API
- Added `estimated_price_messages_sent` to `CheckResponse` and `VerifyDetails`
- Updated `VerifyStatus` enum values
- Fixed `MessageResponseException` deserialization when response body is empty
- Fixed incorrect `Content-Type` header for `verify` and `check` endpoints
- Deprecated `request_type` in `VerifyRequest`
- Deprecated `ip_address` in `CheckRequest`

---

## 7.0.0
### 11 Aug 2022
- Removed SMS Search API
- Deprecated Redact client
- Use `vonage-jwt-jdk:1.0.2` library instead of `nexmo-jwt-jdk:1.0.1`
- Ensure `User-Agent` is set in request headers
- Allow alphanumeric characters for SMS and MMS sender fields in Messages API
- `WhatsappRequest` sender must now be an E164 number
- Fixed incorrect restrictions on `WhatsappTemplateRequest` 
  - Policy is now optional
  - Default locale is now `en`
  - Locale is now an enum rather than String
  - `parameters` is now `List<String>`
- Removed dependency on `commons-io` and `commons-lang3`
- Ensured User-Agent is set in request headers
- Added Premium text-to-speech flag in `TalkAction` NCCO
- Removed support for legacy `voiceName` parameter
- Updated SMS error status codes
- Added support for voice payments using NCCO action
- Updated NCCO classes
  - Fixed Action deserialization (issue #373)
  - Permit Object values for `WebSocketEndpoint` headers
  - Removed varargs `headers` method in `WebSocketEndpoint.Builder`
  - Made Builder constructors package-private
  - Added `headers` field to `SipEndpoint`
  - Use `java.net.URI` instead of String for URI fields
- Updated Number Insight to be consistent with API specification
  - Deprecated IP Address
  - Added missing `InsightStatus` codes
  - Added documentation to Insight Response fields
  - Moved AdvancedInsight enums to separate files
  - Added `real_time_data` to AdvancedInsightResponse

---

## 6.5.0
### 20 Jun 2022
- Added Messages v1 API implementation
- Added `get-full-pricing` endpoint
- Added `Content-Type` and `Accept` headers in requests where applicable
- Substantial internal refactoring

---

## 6.4.2
### 14 Apr 2022
- Added `call_uuid` to webhook call event.
- Bumped dependency versions

---

## 6.4.0
### 28 May 2021

- Adding Random From Number Feature for the Voice API, if set to `true`, the from number will be randomly selected from the pool of numbers available to the application making the call.
- adjusting operator used to check json payloads
- Adding extra parsing for top level Roaming Status in Advanced Number Insights

---

## 6.3.0
### 20 May 2021

Adding Inbound SMS message validation for JSON based POST requests

---

## 6.2.0
### 11 Mar 2021

- Adding `entityId` and `contentId` fields to SMS messages for India's DLT compliance
- Adding detail and detailEnum fields to call events, this will provide a switchable way for folks to view the newly minted details coming off of calls