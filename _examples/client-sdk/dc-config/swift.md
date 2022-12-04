---
title: Swift
language: swift
---

``` swift
let config = NXMClientConfig()
config.apiUrl = "https://api-eu-3.vonage.com/"
config.websocketUrl = "wss://ws-eu-3.vonage.com/"
config.ipsUrl = "https://api-eu-3.vonage.com/v1/image/"
NXMClient.setConfiguration(config)
let nexmoClient = NXMClient.shared
```
