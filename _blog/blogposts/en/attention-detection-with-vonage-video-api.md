---
title: Attention Detection with Vonage Video API
description: A Node tutorial showing how to integrate the Vonage Video API with
  TensorFlow's MediaPipe face detection model to detect attention detection,
  using javascript.
thumbnail: /content/blog/attention-detection-with-vonage-video-api/attention-detection_videoapi.png
author: hamza-nasir
published: true
published_at: 2022-11-30T10:25:46.738Z
updated_at: 2022-11-30T10:25:46.775Z
category: tutorial
tags:
  - "#video-api"
  - "#javascript"
  - "#node"
comments: true
spotlight: false
redirect: ""
canonical: ""
outdated: false
replacement_url: ""
---
*This article was written in collaboration with [Talha Hasan](https://developer.vonage.com/blog/authors/talha-hasan)*

## Introduction

In today’s world more and more of our interactions are going online. Over the past few years, online classes and meetings have become a normal part of life. While this transition has had numerous benefits, it has also created interesting issues to be tackled. One such issue is ensuring user attention.

Using attention detection technology can have a big impact in areas like the education field or online meetings. It can allow presenters to understand how participant interest fluctuates over certain parts of their meetings or lectures. It can also be used to help teachers ensure that students are paying attention.

Today we’ll be building a Video Conferencing application with Vonage Video API that leverages Face Landmark detection to calculate a participant's attention score.

## **Prerequisites**

* Vonage API Key and Secret
* [Node](https://nodejs.org/en/) 8.6.2+
* Node Package Manager ([npm](https://www.npmjs.com/))

To setup the app on your machine first clone the repo:

`git clone https://github.com/hamzanasir/attention-detection.git`

Great!  Now move into the repository and install the associated packages via:

`npm install`

Now we need to setup our Vonage API Key and Secret. Let’s start off by copying the env template:

`cp .envcopy .env`

Now all you need to do is replace the `TOKBOX_API_KEY` and `TOKBOX_SECRET` in the .env file to your credentials. You can find your API Key and Secret on the project page of your Vonage Video API [Account](https://tokbox.com/account).

```
# enter your TokBox api key after the '=' sign below
TOKBOX_API_KEY=your_api_key

# enter your TokBox api secret after the '=' sign below
TOKBOX_SECRET=your_project_secret
```

You can start the app with:

`npm start`

> All of the code we talk about in this blog can be found in the \`public/js/app.js\` file.

## How Attention Detection Works

To calculate the attention of the user, we will first have to obtain the face landmarks of the user in 3-dimensional space. Once we have obtained these, we can calculate the pose of the user’s face in 3-dimension, specifically, we can calculate the yaw, pitch, and roll (see diagram below) of the user’s face using some trigonometry. For simplicity, we will only be interested in the yaw and pitch.

![The yaw, pitch and roll angles in the human head motion.](/content/blog/attention-detection-with-vonage-video-api/46a877a98c1af6eae4a547a5248a315f.png "The yaw, pitch and roll angles in the human head motion")

\
Based on these two angles, we can provide the users with an overall attention score.

## Obtaining the Face Landmarks

We’ll be using TensorFlow’s MediaPipe [face detection mode](https://google.github.io/mediapipe/solutions/face_mesh.html#models)l to obtain the face landmarks. The reason we use MediaPipe is that it provides 3-dimensional landmarks out of the box, using machine learning to infer the depth of the facial surface without the need for a depth sensor.

![Face landmarks visualization from MediaPipe](/content/blog/attention-detection-with-vonage-video-api/face_mesh_android_gpu-1-.gif "Face landmarks visualization from MediaPipe")

You can learn more about MediaPipe [here](https://google.github.io/mediapipe/solutions/face_mesh.html)

## Calculating the Pitch and Yaw

In order to calculate the pitch, we use the 468 facial landmarks (**[provided by the face mesh library](https://google.github.io/mediapipe/solutions/face_mesh.html#models)**) corresponding to the top and bottom of the user’s face in the y and z planes. Similarly, for yaw, we use landmarks corresponding to the outside corners of the user’s eyes in the x and z planes.

For both of these, we then calculate the middle point between these two points and calculate the angle relative to the user’s camera by using the [atan2](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Math/atan2#:~:text=Description-,The%20Math.,and%20the%20x%2Dcoordinate%20second.) (inverse tangent) function which calculates the counterclockwise angle between the x-axis and the point we’re interested in. You can see the example code below:

```javascript
const radians = (a1, a2, b1, b2) => Math.atan2(y: b2-a2, x: b1-a1);
const angle = {
  yaw: radians(mesh[33][0], mesh[33][2], mesh[263][0], mesh[263][2]),
  pitch: radians(mesh[10][1], mesh[10][2], mesh[152][1], mesh[152][2])
};
```

## Scoring User Attention

We now need to use the pitch and yaw that we calculated to assign some kind of an attention score to the user. The approach that we’ll use in our case is influenced by “[Attention Span Prediction Using Head-Pose Estimation With Deep Neural Networks](https://ieeexplore.ieee.org/stamp/stamp.jsp?arnumber=9570335)”, published in IEEE Access.

Essentially, we will assign a score from 0 - 2 (0 being a low attention score and 2 being a higher attention score) based on the computed value for each of the angles. We will assign a score with the following `getScore` function, based on the IEEE Access paper:

```javascript
const getScore = (degree) => {
  degree = Math.abs(radiansToDegrees(degree));
  if (degree < 10) {
    return 2;
  }
  if (degree < 30) {
    const adjust = (degree - 10) * 0.05;
    return 2.0 - adjust;
  }
  return 0;
};
```

\
We then take the product of the two scores to get the final attention scoring of the user. Once we have the overall attention score, we then categorize the attention to allow users to easily visualize their attention level. We break down this categorization into 4 different categories ranging from no concentration to high concentration. You can see the procedure to calculate the overall attention level:

![Pseudocode for our function to evaluate concentration level.](/content/blog/attention-detection-with-vonage-video-api/procedure-conc-level.png "Pseudocode for our function to evaluate concentration level.")

And the categories for attentiveness are below:

![Attention score categorization.](/content/blog/attention-detection-with-vonage-video-api/attention-span-score.png "Attention score categorization")

It’s important to note that these diagrams represent a theoretical algorithm to calculate the attention score. In reality, you may wish to tweak a few things such as the attention span score categories. One such change that we made in our application is that instead of adding the `yaw_score` and the `pitch_score` we chose to multiply them to get us a nice linear progression of attention score.

## Integrating with Vonage Video API

To save CPU/GPU of each participant, instead of having each participant run the face mesh analysis for each participant on their machine, let’s have everyone in the call be responsible for their own attention score metrics. So we’ll initialize the algorithm in the `session.publish` endpoint:

```javascript
session.publish(publisher, async (err) => {
  if (err) {
    console.log('Error', err);
  } else {
    const publisherElement = document.getElementById('publisher');
    streamId = publisher.stream.id;
    const webcam = publisherElement.querySelector('video');
    await runFacemesh(webcam);
  }
});
```

\
Let’s take a closer look at the `runFacemesh` method:

```javascript
const runFacemesh = async (webcamRef) => {
  const net = await faceLandmarksDetection.load(faceLandmarksDetection.SupportedPackages.mediapipeFacemesh, { maxFaces: 1 });

  setInterval(() => {
    detect(net, webcamRef);
  }, 500);
};
```

We use the detect function, which we'll need to build, but essentially the number of times we run this function we’ll get an attention score metric for the frame that is rendered by your camera. So the number of times we run this a second determines the frames per second of our attention metric analysis. Currently, it is set to run every 500 milliseconds so that means we’re effectively looking at a model FPS (Frames Per Second) of 2. This can be tinkered with depending on your use case.

Now let’s look at the meaty part of our algorithm that is responsible for generating a score and signaling the score to all other participants:

```javascript
// This runs face landmark model
const face = await net.estimateFaces({ input: video, predictIrises: true });

// Getting points from the model
const { mesh } = face[0];
const radians = (a1, a2, b1, b2) => Math.atan2(b2 - a2, b1 - a1);

// Generating angles between points and axis
const angle = {
  yaw: radians(mesh[33][0], mesh[33][2], mesh[263][0], mesh[263][2]),
  pitch: radians(mesh[10][1], mesh[10][2], mesh[152][1], mesh[152][2]),
};

// Calculating attention score
const score = getScore(angle.yaw) * getScore(angle.pitch);
const signalScore = { attention: score, streamId };


// Sending attention score to all other participants in call 
session.signal(
  {
    type: 'attentionScore',
    data: JSON.stringify(signalScore)
  },
  function(error) {
    if (error) {
      console.log("signal error ("+ error.name+ "): " + error.message);
    }
  }
);
```

This chunk of code may look intimidating but in reality, all we’re doing is running the facial landmark library on the current frame of the publisher, running our `getScore` algorithm on the angles between certain points on the detected face, and then broadcasting the attention score to all participants.

Once the attention score is signaled we need to make sure we’re handling it on the receiving end and do with it as we please. You could display it as a real-time UI (like we did in this project) or store it in a data store that can be used to map attention metrics over the duration of the call. The possibilities are endless!

## Conclusion

Attention is a key factor for gauging conversations, speeches, lectures, and just about any interaction between people. We have now learned how to estimate it using face mesh analysis and integrate it into our video calls. This estimate can be further improved via more data sources such as getting iris movement, multiple face recognition, etc.

*Find a fully working version of this app on [GitHub](https://github.com/hamzanasir/attention-detection)*

Let us know if you were able to get attention detection to work! Join us on the Vonage Developer [Slack Community](https://developer.vonage.com/community/slack) or tweet at us at [VonageDev](https://twitter.com/VonageDev).
