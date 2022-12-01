---
version: '3.2.0b0'
release: '11 Nov 2022'
---
# [Vonage Python SDK](https://github.com/Vonage/vonage-python-sdk)

---

## 3.2.0b0
### 11 Nov 2022

- Beta release including Vonage Video API support for sessions, signalling, moderation and archiving
- This branch will be kept separately from the main codebase for now and can be installed with `pip install --pre vonage`

## 3.1.0
### 26 Oct 2022

- Supporting Python 3.11
- Upgrading some old dependencies

## 3.0.2
### 25 Oct 2022

- Bugfix in messages.py where authentication method was not being checked for correctly, throwing an error when using header auth.

## 3.0.1
### 4 Oct 2022

- Fixed bug where a JWT was created globally and could expire. Now a new JWT is generated when a request is made.
- Fixed bug where timeout was not passed to session object.

## 3.0.0
### 27 Jul 2022

Breaking changes:
- Removed deprecated methods from `client.py` that are now available in specific modules related to each of the available Vonage APIs. E.g. to call the number insight API, the methods are now called in this way: `client.number_insight.get_basic_number_insight(...)`, or by instantiating the `NumberInsight` class directly: `ni = vonage.NumberInsight(client)`, `ni.get_basic_number_insight(...)` etc.
- Removed automatic client creation when instantiating an `sms`, `voice` or `verify` object. You can now use these APIs from a client instance you create (e.g. `client.sms.send_message()`) or pass in a client to the API class to create it (e.g. `sms = vonage.Sms(client)`), as has been the case since v2.7.0 of the SDK.
- Removed methods to call the Message Search API, which has been retired by Vonage.
- Removed deprecated voice and number insight methods from `voice.py` (`initiate_call, initiate_tts_call and initiate_tts_prompt_call`) and `number_insight.py` (`request_number_insight`).
- Renamed the `Account.delete_secret()` method to `revoke_secret()` to bring it in line with what is described in our documentation.

Deprecations:
- Deprecated the ApplicationV2 class and created an Application class with the same methods to bring the naming in line with other classes. This can be called from the client object with `client.application.create_application(...)` etc. or directly with `application = vonage.Application(client)`, `application.create_application(...)` etc.
- Deprecated old Pricing API methods `get_sms_pricing` and `get_voice_pricing`.
- Deprecated Redact class as it's a dev preview product that's unsupported in the SDK and will be removed in a later release.

Enhancements:
- Added `get_all_countries_pricing` method to `Account` object.
- Added a `type` parameter for pricing calls, so `sms` or `voice` pricing can now be chosen.
- Added `max_retries`, `timeout`, `pool_connections` and `pool_maxsize` optional keyword arguments to the `Client` class, which can now be specified on instantiation and used in the API calls made with the client.

---

## 2.8.0
### 30 Jun 2022

- Added Messages API v1.0 support. Messages API can now be used by calling the `client.messages.send_message()` method.

---

## 2.7.0
### 26 May 2022

- Moved some client methods into their own classes: `account.py, application.py, 
message_search.py, number_insight.py, numbers.py, short_codes.py, ussd.py`
- Deprecated the corresponding client methods. These will be removed in a major release that's coming soon.
- Client now instantiates a class object for each API when it is created, e.g. `vonage.Client(key="mykey", secret="mysecret")`
instantiates instances of `Account`, `Sms`, `NumberInsight` etc. These instances can now be called directly from `Client`.

---

## 2.6.4
### 27 Apr 2022

- Dropped support for Python 3.6 and below
- Now supporting currently supported stable versions of Python, i.e. Python 3.7-3.10
- Internal refactoring and enhancements
- Adding default max_retries option to the BasicAuthenticationServer constructor, specifying optional parameters

---

## 2.5.5
### 5 Jan 2021

- Patched issues with PyJWT >1.8 (TypeError: can't concat str to bytes)
- This patch ensures all versions of PyJWT are supported.

---

## 2.5.3
### 14 Sept 2020

- Minor patches to reflect Vonage namespace changes

---

## 2.5.2
### 27 Aug 2020

- Support for Independent SMS, Voice and Verify APIs with tests as well as current client methods
- Getters/Setters to extract/rewrite custom attributes
- PSD2 Verification support
- Dropping support for Python 2.7
- Roadmap to better error handling
- Supporting Python 3.8