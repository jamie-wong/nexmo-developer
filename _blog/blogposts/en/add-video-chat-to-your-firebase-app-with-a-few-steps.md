---
title: Add Video Chat to Your Firebase App With a Few Steps
description: Learn how you can add multiparty video chats to your Firebase
  application using the Vonage Video Express extension.
thumbnail: /content/blog/add-video-chat-to-your-firebase-app-with-a-few-steps/videochat_firebaseapp.png
author: dwanehemmings
published: true
published_at: 2022-12-05T09:38:24.032Z
updated_at: 2022-12-05T09:38:24.913Z
category: announcement
tags:
  - video
  - firebase
  - extension
comments: true
spotlight: false
redirect: ""
canonical: ""
outdated: false
replacement_url: ""
---
# Video Express?

[Video Express](https://tokbox.com/developer/video-express/) was built on top of the Vonage Video API to help quickly create a multiparty video conference application. This JavaScript library abstracts some nitty-gritty details, such as keeping track of publishers and subscribers, and applies optimizations into a “room.”

# Firebase?

[Firebase](https://firebase.google.com/) is an application development platform that offers hosting, authentication, real-time databases, analytics, and many more services. It is backed by Google.

# Firebase x Vonage Video Express extension?

Firebase announced [Extensions](https://extensions.dev/) that help developers "build an app quickly and easily." Vonage Video Express also wants to shorten the time it takes to add video chat to an application. So we created and released an [extension](https://extensions.dev/extensions/vonage/firestore-vonage-video-express).

# How it works.

After installing the extension in a Firebase application, when a developer creates a room in Cloud Firestore, the extension will use Cloud Functions to generate the credentials needed to participate in the video chat via Vonage Video Express.

# Getting Started.

On the Vonage side, you’ll need to have an account and a project created as well as enable the Video Express add-on. For information on how to do this, please consult the [Video Express documentation](https://tokbox.com/developer/video-express/)

For Firebase, an account and project will also be required. In that project, both [Cloud Functions](https://console.firebase.google.com/project/_/functions) and [Cloud Firestore](https://console.firebase.google.com/project/_/firestore) must be enabled.

There are a couple of ways to start the installation of the [Vonage Video Express extension](https://extensions.dev/extensions/vonage/firestore-vonage-video-express).

Using the Firebase CLI in your Firebase project directory, run the following:

```
firebase ext:install vonage/firestore-vonage-video-express --project=projectId_or_alias
```

By following this link to the [Firebase Console](https://console.firebase.google.com/project/_/extensions/install?ref=vonage/firestore-vonage-video-express), you’ll be able to select the project you want to install the extension.

Next, you’ll enter some information (selecting deployment location, Vonage credentials, etc.) and accept some terms to set up the extension.

Then the extension will start installing into the project. That’s it!

# But wait... There’s more!

We also include a [sample application](https://github.com/Vonage/vonage-firebase-extensions/tree/main/demos) to demonstrate the extension in action. There’s a link under the “How this extension works” tab of the extension’s page to test it out in your project. Just enter the config object, and it’s up and running.

# Video

If you are more of a visual person, here is a video walkthrough of installing the Vonage Video Express extension into a Firebase application.

<youtube id="ZCLo47Toc40"></youtube>

# Giving it a try?

As always, we welcome any questions, comments, and feedback. We want to hear about your experience with the extension. Feel free to post in our [Community Slack Channel](https://developer.vonage.com/community/slack). If you are on Twitter, follow the [VonageDev](https://twitter.com/vonagedev) account to receive the latest updates.
