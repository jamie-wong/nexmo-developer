---
title: Kotlin
language: kotlin
---

```kotlin
val nexmoClient = NexmoClient.Builder()
    .restEnvironmentHost("https://api-eu-3.vonage.com")
    .environmentHost("https://ws-eu-3.vonage.com")
    .imageProcessingServiceUrl("https://api-eu-3.vonage.com/v1/image")
    .build(context)
```
