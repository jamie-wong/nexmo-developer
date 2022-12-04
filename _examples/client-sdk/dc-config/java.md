---
title: Java
language: java
---

``` java
NexmoClient nexmoClient = new NexmoClient.Builder()
    .restEnvironmentHost("https://api-eu-3.vonage.com")
    .environmentHost("https://ws-eu-3.vonage.com")
    .imageProcessingServiceUrl("https://api-eu-3.vonage.com/v1/image")
    .build(this);
```