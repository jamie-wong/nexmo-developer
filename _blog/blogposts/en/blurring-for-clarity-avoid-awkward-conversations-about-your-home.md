---
title: "Blurring for Clarity: Avoid Awkward Conversations About Your Home"
description: Learn how to apply background blur & replace in your Vonage Video applications
thumbnail: /content/blog/blurring-for-clarity-avoid-awkward-conversations-about-your-home/background-blur.png
author: sina-madani
published: true
published_at: 2023-01-03T10:56:58.636Z
updated_at: 2023-01-03T10:56:58.657Z
category: tutorial
tags:
  - javascript
  - video-api
---
Virtual meetings have a different vibe from in-person meetings. One of the many reasons for this is the need for a shared environment. Since everyone's location (and thus, what's going on in their background) is different, it can distract participants. Moreover, participants may want to protect their privacy during video calls without relocating, which may only sometimes be practical.

One solution is to blur the background of participants so that their face is in focus. Doing so retains their natural background environment while reducing the detail to make it less distracting. Another solution is to replace the background with another image, which can then be applied to some or all participants. The advantage of this approach is that an appropriate background setting can be used depending on the tone and nature of the meeting. For example, if a video call is a meeting between people from different organizations, a logo or standardized background can be applied to each organization’s representatives for clarity.

Both of these solutions can be easily applied to your Vonage video application by adding just a few lines of code. This article will walk you through how to apply these filters with a step-by-step guide using a minimal example.

## Prerequisites

Credentials will be needed for the demo application to work. Log into or create a [Vonage Video account](https://www.tokbox.com/account) and then click 'Projects' in the left menu. You can select a previous custom project or create a new one. Navigate to your project - the page will look something like this:

![OpenTok project page](/content/blog/blurring-for-clarity-avoid-awkward-conversations-about-your-home/opentok-project.jpeg)

Make a note of the Project API Key. Scroll down to the "Project Tools" section (near the bottom of the page), and click "Create Session ID". Copy this, and paste it into the next section to generate a token. For the role, select "Publisher", and the expiration time to 24 hours (or however long you need the session). You will need the Project API Key, Session ID, and Token for this exercise.

## Create a Skeleton App

Create a directory to work in and navigate to it. Then create the application files like so:

```sh
mkdir opentok-bg-filters
cd opentok-bg-filters
touch index.html index.js index.css
```

Now that we’ve created our project, let’s add some code to our `index.js` file. Of course, you should set the values of `apiKey`, `sessionId`, and `token` appropriately.

```javascript
const apiKey = '';
const sessionId = '';
const token = '';

function handleError(error) {
  if (error) {
    alert(error.message);
  }
}

const session = OT.initSession(apiKey, sessionId);

const subscriberOptions = {};

const publisherOptions = {
  insertMode: 'append',
  width: '100%',
  height: '100%',
  resolution: '1280x720'
};

const publisher = OT.initPublisher('publisher', publisherOptions, handleError);

session.on({
  streamCreated: event => session.subscribe(event.stream, 'subscriber', subscriberOptions, handleError),
  sessionConnected: event => session.publish(publisher)
});

session.connect(token, error => handleError(error));
```

In the code above, we’ve initialized [Session](https://tokbox.com/developer/sdks/js/reference/Session.html) and [Publisher](https://tokbox.com/developer/sdks/js/reference/Publisher.html) objects using `OT.initSession` and `OT.initPublisher` methods, respectively. We then proceed to set event listeners on the session object for `streamCreated` and `sessionConnected` where we subscribe to a stream when it’s created and publish our stream when we’re connected to the session. After setting the session event listeners, we attempt to connect to the session using an [OpenTok Token](https://tokbox.com/developer/guides/basics/#token).

Load the `index.js` and `index.css` files in `index.html` along with the [OpenTok.js SDK](https://tokbox.com/developer/sdks/js/):

```html
<html>
<head>
    <title>Vonage Video Background Filter demo</title>
    <link href="index.css" rel="stylesheet" type="text/css">
    <script src="https://static.opentok.com/v2/js/opentok.min.js"></script>
</head>
<body>
    <div id="videos">
        <div id="subscriber"></div>
        <div id="publisher"></div>
    </div>
    <script type="text/javascript" src="index.js"></script>
</body>
</html>
```

Add the following to your `index.css` file:

```css
body, html {
    background-color: gray;
    height: 100%;
}

#videos {
    position: relative;
    width: 100%;
    height: 100%;
    margin-left: auto;
    margin-right: auto;
}

#subscriber {
    position: absolute;
    left: 0;
    top: 0;
    width: 100%;
    height: 100%;
    z-index: 10;
}

#publisher {
    position: absolute;
    width: 640px;
    height: 480px;
    bottom: 10px;
    left: 10px;
    z-index: 100;
    border: 3px solid white;
    border-radius: 3px;
}
```

Now, if you open `index.html` with a browser and allow access to your webcam and microphone, you should see your camera video feed. Please check your code and Token / Session ID / API Key values if this is not the case. You can get more insight into the issue from the browser's developer console (usually accessed by pressing F12).

## Adding Video Effects

We can add filters to our video using the `videoFilter` option. This can be applied during or after initializing the publisher. Usually, it makes sense to do it right away. Note that this feature is not supported on all browsers (especially older ones). No need to worry - we can apply filters conditionally. For example, here is how you can blur the background by adding a filter to the `publisherOptions` object we created earlier:

```javascript
// Add background blur, if supported
if (OT.hasMediaProcessorSupport()) {
  publisherOptions.videoFilter = {
    type: 'backgroundBlur',
    blurStrength: 'low'
  };
}
```

If your application logic requires the filter to be applied at a later point (for example, in response to an event), you can achieve this like so:

```javascript
publisher.applyVideoFilter({
  type: 'backgroundBlur',
  blurStrength: 'high'
});
```

To remove the filter at some point, you can call `publisher.clearVideoFilter()`. Add the following to your `index.js` file to clear the effect after 8 seconds:

```javascript
setTimeout(() => publisher.clearVideoFilter(), 8000);
```

### Changing the background image

To change the background, use the following configuration for the `videoFilter`:

```javascript
if (OT.hasMediaProcessorSupport()) {
  publisherOptions.videoFilter = {
    type: 'backgroundReplacement',
    backgroundImgUrl: 'https://example.com/image.jpg'
  };
}
```

### Limitations and Troubleshooting

Note that you cannot use both image replacement and background blur together. If you encounter issues with the background image not being applied, this could be due to [CORS](https://developer.mozilla.org/en-US/docs/Web/HTTP/CORS). That is a server issue, so try an image from another website. Note that the image needs to be a BMP, PNG, JPEG, or GIF.

## Next Steps

Now that you have a working example, you can customize the appearance by editing `index.css` if you wish and build further logic into your application. For a production application, you will need to automate the acquisition of your API Key, Token, and Session ID from the server. Check out our [tutorials](https://tokbox.com/developer/tutorials/web/basic-video-chat/#next) for further reading.

For more information on using the Publisher and video filters, please see the API reference for [Publisher](https://tokbox.com/developer/sdks/js/reference/Publisher.html#applyVideoFilter). You can find the supported publisher option parameters in the `OT.initPublisher` method [documentation](https://tokbox.com/developer/sdks/js/reference/OT.html#initPublisher).

You can find the complete code sample used in this demo and try it yourself from [this Glitch application](https://glitch.com/edit/#!/opentok-background-filters). Then, all you need to do is paste in your API Key, Token and Session ID for it to work!

Please feel free to reach out to us on our [Community Slack](https://developer.vonage.com/community/slack) or [Twitter](https://twitter.com/VonageDev) if you have any questions or feedback!
