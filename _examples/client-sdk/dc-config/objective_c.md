---
title: Objective-C
language: objective_c
---

```objective_c
NXMClientConfig *config = [[NXMClientConfig alloc] init];
config.apiUrl = @"https://api-eu-3.vonage.com/";
config.websocketUrl = @"wss://ws-eu-3.vonage.com/";
config.ipsUrl = "https://api-eu-3.vonage.com/v1/image/";
[NXMClient setConfiguration:config];
NXMClient *client = NXMClient.shared;
```
