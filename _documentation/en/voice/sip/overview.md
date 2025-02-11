---
title: Overview
meta_title: Connect to Vonage using SIP
description: Use Vonage SIP to forward inbound and send outbound Voice calls that use the Session Initiation Protocol.
---

# SIP Overview

Vonage allows you to [forward inbound](#inbound-configuration) and [send outbound](#configuring-your-system-for-sip-forwarding) Voice calls using the [Session Initiation Protocol](https://en.wikipedia.org/wiki/Session_Initiation_Protocol).

This document explains the relevant setup options.

### Endpoint

You can send your [INVITE](https://en.wikipedia.org/wiki/List_of_SIP_request_methods) requests to the Vonage SIP endpoints, depending on your region: `sip-us.vonage.com` (AMER), `sip-eu.vonage.com` (EMEA), `sip-ap.vonage.com` (APAC).


### Authentication

Every INVITE request is authenticated with Digest authentication:

- `username` - your Vonage *key*
- `password` - your Vonage *secret*

### Service records

If your system is not enabled for [Service records](https://en.wikipedia.org/wiki/SRV_record) (SRV records), you should load balance between the two closest endpoints and set the remaining ones as backup. The Vonage SIP endpoints are:

- `sip-us-3.vonage.com` (Virginia)
  - Virginia Proxy 1:  `sip-us-3-1.vonage.com`
  - Virginia Proxy 2:  `sip-us-3-2.vonage.com`
- `sip-us-4.vonage.com` (Oregon)
  - Oregon Proxy 1:  `sip-us-4-1.vonage.com`
  - Oregon Proxy 2:  `sip-us-4-2.vonage.com`
- `sip-ap-3.vonage.com` (Singapore)
  - Singapore Proxy 1:  `sip-ap-3-1.vonage.com`
  - Singapore Proxy 2:  `sip-ap-3-2.vonage.com`
- `sip-ap-4.vonage.com` (Sydney)
  - Sydney Proxy 1:  `sip-ap-4-1.vonage.com`
  - Sydney Proxy 2:  `sip-ap-4-2.vonage.com`
- `sip-eu-3.vonage.com` (Dublin)
  - Dublin Proxy 1:  `sip-eu-3-1.vonage.com`
  - Dublin Proxy 2:  `sip-eu-3-2.vonage.com`
- `sip-eu-4.vonage.com` (Frankfurt)
  - Frankfurt Proxy 1:  `sip-eu-4-1.vonage.com`
  - Frankfurt Proxy 2:  `sip-eu-4-2.vonage.com`

### Recipient

Recipient numbers must be in [E.164](https://en.wikipedia.org/wiki/E.164) format.

### Caller ID

Set the Caller Line Identity (CLI) in the *From* header using [E.164](https://en.wikipedia.org/wiki/E.164). For example: `From: <sip:447700900000@sip-eu.vonage.com>`.

### Codecs

The following codecs are supported:

- PCMA (G711a)
- PCMU (G711u)
- iLBC
- g729 (without annexdb)
- g722
- Speex16

### Media traffic

Visit [the Vonage Knowledge Base](https://help.nexmo.com/hc/en-us/articles/115004859247-Which-IP-addresses-should-I-whitelist-in-order-to-receive-voice-traffic-from-Nexmo-) to obtain a list of the IP ranges to open traffic for on all ports.

### DTMF

Vonage supports out-of-band DTMF. For more information, see [RFC4733](https://www.ietf.org/rfc/rfc4733.txt).

### Health checks

Use the [OPTIONS](https://en.wikipedia.org/wiki/List_of_SIP_request_methods) method to run a health check on our SIP trunks.

### Protocols

You can use the following protocols:

- UDP on port 5060
- TCP on port 5060
- TLS on port 5061

[Transport Layer Security](https://en.wikipedia.org/wiki/Transport_Layer_Security) (TLS) is a cryptographic protocol designed to provide communications security to your SIP connection. You can use self-signed certificates on your user agent, Vonage does not validate the client certificate.

Connections using TLS 1.2 are accepted. Older protocols are disabled as they are considered insecure.

### Media Protocols

You can use either [Real-time Transport Protocol](https://en.wikipedia.org/wiki/Real-time_Transport_Protocol) (RTP) or [Secure Real-time Transport Protocol](https://en.wikipedia.org/wiki/Secure_Real-time_Transport_Protocol) (SRTP) for the media exchange with Vonage.
If there are security and privacy concerns, we highly recommend the use of SIP over TLS, so that the entire communication can be secured.

For outbound calls, your SIP endpoint must negotiate SRTP automatically in the standard way. For inbound calls, see configuration details below.

> **Note**: Vonage supports a single crypto suite **AES_CM_128_HMAC_SHA1_80**

### Session Timers

Vonage supports Session Timers [RFC 4028](https://tools.ietf.org/html/rfc4028); SIP customers that require Session Timers can negotiate them at the moment of establishing a session (INVITE).

## Inbound configuration

Calls to Vonage numbers can be forwarded to SIP endpoints.

This section tells you how to:

- [Configure your system for SIP forwarding](#configuring-your-system-for-sip-forwarding)
- [Configure example servers](#example-configurations)

## Configuring your system for SIP forwarding

To configure for SIP forwarding:

1. Sign into [Dashboard](https://dashboard.nexmo.com/sign-in).
2. In Dashboard, click *Numbers* > *Your Numbers*.
3. Scroll to the number to forward from, then click the Edit button under *Manage*.
4. Under *Voice*, select SIP from the dropdown.
5. Type a valid SIP URI and click *Update*. For example `sip:1234@example.com`.
  This field supports comma-separated entries for failover capabilities. For example: `sip:1234@example.com,sip:1234@example.net,sip:1234@example.org`. If you set more than one endpoint in *Forward to SIP* the call is initially forwarded to the first endpoint in the list. If this fails, the call is forwarded to the second endpoint in the list, and so on.
  Calls failover for the whole 5xx class of HTTP errors. The timeout is 486.
6. You can set up the following URI parameters to configure behavior you wish to see from Vonage's platform. Namely:
    - **TLS** - Vonage supports TLS for forwarded calls. To enable this, enter a valid URI in the format `sip:user@(IP|domain);transport=tls`. For example, `sip:1234@example.com;transport=tls`. By default, traffic is sent to port `5061`. To use a different port, add it at the end of your domain or IP address: `sip:1234@example.com:5062;transport=tls`.
    - **SRTP** - Vonage will also encrypt media using SRTP if necessary. To do that please add the following parameter to the URI: `media=srtp`. For example: `sip:1234@example.com;transport=tls;media=srtp`
    - **Timeouts** - Vonage will attempt to contact your SIP endpoints sequentially for a given time before attempting the next URI in the list. This is achieved with the `;timeout=xxxxx` parameter. For example: `sip:1234@example.com;timeout=2000,sip:1234@example.net` will attempt to forward to the first URI, and in case of no response within 2 seconds it will try the second one. Timeouts are expressed in milliseconds and can range from `2000` to `20000`. This is useful to quickly fail over when an endpoint is temporarily unavailable. The default value is `5000` ms.
7. Ensure that the traffic generated from Vonage IP addresses can pass your firewall. Visit [the Vonage Knowledge Base](https://help.nexmo.com/hc/en-us/articles/115004859247-Which-IP-addresses-should-I-whitelist-in-order-to-receive-voice-traffic-from-Nexmo-) to obtain the current list of IP addresses.

## Example configurations

We have provided examples for a number of different SIP capable systems:

* [Asterisk](/voice/sip/configure/asterisk)
* [Avaya SBCe](/voice/sip/configure/avaya-sbce)
* [Cisco CUCM/CUBE](/voice/sip/configure/cucm-cube)
* [FreePBX](/voice/sip/configure/freepbx)
* [FreeSWITCH](/voice/sip/configure/freeswitch)
* [MiTel MiVoice and MiTel Border Gateway](/voice/sip/configure/mitel-mivoice)
* [ShoreTel Director and InGate SIParator](/voice/sip/configure/shoretel)
* [Skype for Business with Oracle E-SBC](/voice/sip/configure/skypeforbusiness)
* [NEC SV9100](/voice/sip/configure/nec-sv9100)
