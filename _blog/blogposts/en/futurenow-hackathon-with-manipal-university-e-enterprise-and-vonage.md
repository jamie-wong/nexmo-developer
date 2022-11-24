---
title: FutureNow Hackathon With Manipal University, e& enterprise, and Vonage
description: A recap of the 2022 hackathon at Manipal University with a demo of
  AI Studio, a Low Code tool from Vonage.
thumbnail: /content/blog/futurenow-hackathon-with-manipal-university-e-enterprise-and-vonage/futurenow-hackathon.png
author: benjamin-aronov
published: true
published_at: 2022-11-24T12:03:17.217Z
updated_at: 2022-11-24T12:03:18.252Z
category: event
tags:
  - ai-studio
  - hackathon
comments: true
spotlight: false
redirect: ""
canonical: ""
outdated: false
replacement_url: ""
---
![FutureNow Hackathon participants and staff](/content/blog/futurenow-hackathon-with-manipal-university-e-enterprise-and-vonage/manipal-hackathon.jpeg "FutureNow Hackathon participants and staff")

## About the Hackathon

On November 5th and 6th, Vonage partnered with [e& enterprise](https://www.eandenterprise.com/) and [Manipal Academy](https://www.manipaldubai.com/) of Higher Education (MAHE), Dubai Campus for the FutureNow Hackathon. The hackathon invited students from MAHE’s Computer Science program to compete in a 24-hour technical competition.

The hackathon kicked off with a workshop by Vonage Developer Advocate Benjamin Aronov. He gave an overview of Vonage APIs and then did a hands-on demo, building a WhatsApp agent using the [AI Studio ](https://studio.docs.ai.vonage.com/)platform. Students learned about AI Studio’s drag-and-drop interface, powerful NLU engine, and how it can connect with outside services with API calls.

The students were then challenged to leverage AI-driven Communication APIs to help organizations improve their customer relationships. Nine teams submitted solutions using the Vonage AI Studio platform. The winning team was quadKernals, made up of Brandon Savio Rodrigues, Jaison Thomas, Saina Ejaz, and Shreesh Chaturvedi.

We asked the team more about their project and aspirations for a future working in technology.

## A﻿n Interview with quadKernals

### What were the different roles in the team? Who did what?

**Jaison:** “Shreesh and I created the APIs calls to interact with the Vonage AI agents. We learned how to interact with the HTTP AI agent. So that is: creating the session, then accessing the session, and sending messages back and forth. We also created the event access management system that is on the AI agent side.”

**Saina:** “Brandon and I created the sync between the video and audio of GIFs. I created the GIFs, and then we had to basically sync the GIFS with the audio along with the mapping of the keywords to the GIF. So depending on which keyword comes in, it maps it to a particular action. So we basically had four GIFs and we had to map it to that.”

**Brandon:** “I made the text-to-speech interface work. It used to loop and loop and go on, and I fixed that. Another thing that Sonia did was design each of the states for Domino, so the artwork was custom.”

### What is your dream job after you finish your Computer Science degree?

**Shreesh:** “Well, I would like to be a software engineer, but I would like to be more independent, like creating my own projects for myself. A little bit of a freelancer. I think I would like to be a full stack developer, but mainly my focus would be on the back-end.”

**Jaison:** “The job that pays the most. But in all seriousness, I got into CS to build solutions that impact a lot of people, because you could do that with computers, which you basically couldn't do with many other fields. People have been building applications that billions of people use. So being someone who can scale applications at that level, that's what I want to do. So system architecture. I enjoyed our Networking course.”

**Saina:** “So I'm really interested in AI and ML. We have just started our minors in that, and I want to do my masters in artificial intelligence and machine learning. So that's the next step because I want to get a deeper understanding of all the neural networks and contribute some of my own products to it. We see the research papers and the articles that come out, and it all seems really interesting to me.”

**Brandon:** “My dream is to become a cybersecurity specialist. I'm hoping to deepen my knowledge of cybersecurity and one day be a specialist. To defend, not attack.”

### W﻿hat did you build for the hackathon?

We built a project called Domino. It’s a video interface for your chat application. We created a bot that was a bunch of GIFs and we mapped text to various outputs and actions. So according to what kind of text you would say, it would do the related action. So a “hi” would be a wave. When you’re talking, the bot would look like it was listening. When it was speaking, it would use the talking GIF. And if it didn’t understand something it would have a confused face.

<youtube id="Dai2ZxVOm7s"></youtube>

### What problem does Domino solve?

We went for event assistance as a use case. When [GITEX](https://www.gitex.com/) was in Dubai, it was a huge event with a lot of workshops and stalls. Often we found ourselves lost in the layout. We had to look for a person working the event to ask where we were or where a particular session was being held or what time a session would start. So instead of that, we thought, what if we just had a chatbot to query “what time is so and so event?” and it gives you the answer. So it’s much faster and easier navigation through the whole event. And these kind of things can be handled by a chatbot to greatly improve user experience.

And that’s just one use. But by building the interface of interacting with an animated character instead of just using text it improves the customer experience. So instead of trying to avoid speaking to the chatbot, they will enjoy the experience by talking to the character.

### What did you learn while building Domino?

**Shreesh:** “I learned a lot of web development which wasn’t really my specialty. I learned how to deal with REST API requests and responses and how we can use data to build new requests dynamically, because the user text is not limited as the NLU allows them to enter answers naturally.” 

**Jaison:** “What I had to do this time was go through the documentation very well. I couldn’t just copy an existing tutorial. Going through the documentation and figuring out how the APIs work. That was a new experience for me. Usually, I don’t spend so long to understand how an API works. I enjoyed doing that. 

And it was really easy to create the chatbot. Normally when you read about creating Python chatbots, there’s a lot of ML involved for the NLP layer and then dealing with your dictionaries, and then your cases and all that. But here, you could just plug and play; put what you need and it would give you your output. And the Intents feature was so useful. Like you put some statements and then it continues suggesting other statements, you don’t have to build any of that. It’s already there! So being able to build something that complete and that quickly was really cool.”

**Saina:** “This was the first time I delved into animation, and it was a very interesting experience. After that, it was the syncing of the animation to the audio. When I got it working, the output was really nice. It felt good to somehow have managed to make it work after the numerous times it broke in different ways, in different instances. So that was the fun part.”

### What was the technical implementation of the project?

We wanted to create a SQL database but because of time constraints we used [my-json-server](https://my-json-server.typicode.com/) to create a JSON object as a database and put it on GitHub and then use my-json-server to serve up that data. 

Our front-end was HTML and Vanilla JS. And with JavaScript we called the APIs, got back the JSON responses and then showed it in the front-end. So the entire flow would be:

1. User sends a message
2. Message is sent to AI Studio, which would process it through an HTTP agent and decide what the response should be 
3. Pass the response to our Text-To-Speech function to speak
4. Tell the talking bot which action to perform according to what was said

### Any specific feature in AI Studio surprised you?

**Jaison:** “Just how good the intents were. I had the query of “what event am I at?” -so that’s for the location. So I added as the expression, “where is this location?” and you could instead ask another keyword for it, like “destination”. And it wouldn’t struggle for it. It would realize, “Oh yeah 'destination' is there and ‘where is’ is there” -so it must be another location intent. And it would be able to pull context like that which was really, really cool.”

**Saina:** “The suggestions for expressions were really accurate. After you put in one, you get a lot of suggestions that have somehow recognized what you are looking for. It’s really good.”

### What’s Next For You As A Group and Individually?

We have our [University Tech Fest](https://technovanzadxb.web.app/html/index.html) coming up in a couple of weeks and we wanted to make an interface for people to communicate over a plain WhatsApp bot. But now we can create an interactive way so people can find what they’re looking for at Tech Fest.

**Shreesh**: “I still have 3 years to go until graduation. Trying to participate in more activities to get real-world experience, like this hackathon. And maybe win a couple more!”

**Jaison:** “Only a few months left for me until graduation. And the job market doesn’t look so great. But I have to start the job hunt. I'm also applying for Masters programs in Machine Learning and Systems Engineering.”

**Saina:** "Definitely a Masters in Machine Learning and Artificial Intelligence. I’m also finishing in a few months with Jaison.”

> C﻿heck out [Jaison](https://www.linkedin.com/in/jaison-thomas-57734822b/) on LinkedIn if you're hiring software engineers!

![The quadKernals team accepting their victory trophy.](/content/blog/futurenow-hackathon-with-manipal-university-e-enterprise-and-vonage/img_4452.jpg "The quadKernals team accepting their victory trophy.")

## S﻿tay in the Loop

To find out which upcoming developer events the Vonage Developer Relations team will be at, check out our Developer Community [page](https://developer.vonage.com/community).

Looking for other Vonage developers? Join the conversation on our [Vonage Community Slack](https://developer.vonage.com/community/slack) or send us a message on [Twitter](https://twitter.com/VonageDev).
