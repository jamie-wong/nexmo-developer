---
title: Create a Static Site using VitePress for Beautiful Help Documentation
description: Learn how to use VitePress to create beautiful help documentation!
  No server required!
thumbnail: /content/blog/create-a-static-site-using-vitepress-for-beautiful-help-documentation/vitepress.png
author: michael-crump
published: true
published_at: 2022-11-10T11:05:14.883Z
updated_at: 2022-11-10T11:05:15.700Z
category: inspiration
tags:
  - apis
  - staticsite
  - vitepress
comments: true
spotlight: false
redirect: ""
canonical: ""
outdated: false
replacement_url: ""
---
## Introduction

I've always been a fan of static site generators as a way to create an HTML website based on text (typically in Markdown) with community-theming support. This allows you to spend more time writing content than managing the infrastructure for a content management system (CMS) like WordPress, which requires a database and a front-end UI to enter content. If I could sum up my three reasons why I like static site generators, it would be: 

* Performance (pages are pre-rendered)
* The ability to have themes
* They don't require code to run on the server side 

Let's jump into a popular one called, [VitePress](https://vitepress.vuejs.org/). 

![VitePress Home Page](/content/blog/create-a-static-site-using-vitepress-for-beautiful-help-documentation/vitepressmain.png "vitepressmain.png")

## A Primer on VitePress

VitePress is [VuePress'](https://vuepress.vuejs.org/) little brother, and it is powered by   [Vite](https://vitejs.dev/) and [Vue.js](https://vuejs.org/). For those that don't know, Vite is a build tool that aims to provide a faster and leaner development experience for modern web projects, so it might make sense to pair it with a static site generator such as VitePress. Vue.js is a progressive JavaScript framework for building web user interfaces. One of the original problems with VuePress was that it was a Webpack app, and it took a lot of time to spin up a dev server for just a simple doc. VitePress solves these problems with a nearly instant server start, an on-demand compilation that only compiles the page being served, and lightning-fast HMR. Let's get started!

## Starting From Zero to a Working Static Site

First, create a folder where you'll be developing your static site. 

```shell
mkdir static-starter
cd static-starter
```

Then, initialize it with [Yarn](https://classic.yarnpkg.com/) or [NPM](https://www.npmjs.com/). For this example, we'll be using Yarn. If you don't have Yarn installed, you can install it on the  [downloads page](https://classic.yarnpkg.com/lang/en/docs/install/). For those using NPM, the VitePress documentation is located [here](https://www.npmjs.com/package/vitepress).

```shell
yarn init
```

You will be asked a series of questions, and you can either fill in the details here or leave them blank, as I did.

```
yarn init
yarn init v1.22.19
question name (static-starter):
question version (1.0.0):
question description:
question entry point (index.js):
question repository url:
question author:
question license (MIT):
question private:
success Saved package.json
Done in 26.93s.
```

> Note: You can always fill these in later when configuring the site. 

At this point, you'll only have a single `package.json` file. You now should add VitePress and Vue as dev dependencies for the project.

```
yarn add --dev vitepress vue
```

Now we need a place to store the documents we will create and add a sample document. 

```
mkdir docs 
cd docs
touch index.md
```

Edit the contents of `index.md` to include the following text:

`# Hello VitePress`.

You should have the following files and folders now:

```
docs 
├── index.md
node_modules 
package.json 
yarn.lock 
```

We need to add the following `scripts` section to our `package.json`.

```
{
  "name": "static-starter",
  "version": "1.0.0",
  "main": "index.js",
  "license": "MIT",
  "devDependencies": {
    "vitepress": "^1.0.0-alpha.21",
    "vue": "^3.2.41"
  },
    "scripts": {
      "docs:dev": "vitepress dev docs",
      "docs:build": "vitepress build docs",
      "docs:serve": "vitepress serve docs"
  }
}
```

That will allow us to have different profiles depending on the situation.

You can deploy the server by running `yarn docs:dev` as shown below. 

```text
yarn docs:dev
yarn run v1.22.19
$ vitepress dev docs
vitepress v1.0.0-alpha.21

  ➜  Local:   http://localhost:5173/
  ➜  Network: use --host to expose
```

> VitePress supports "hot-reloading," which means that after you save a file in the project, you won't have to rebuild the site to see your changes.

You should now have a server running, and it typically runs on the following location: `http://localhost:5173`.

![First Launch of VitePress](/content/blog/create-a-static-site-using-vitepress-for-beautiful-help-documentation/helloworld.gif "helloworld.gif")

Congrats! Our app is running now, and you can already notice some of the features and functionality we received using VitePress, such as:


* Responsive site with animations
* Build using the 'Mobile-first' philosophy
* Built-in dark and light mode

## Adding More Pages and Understanding the File Structure

Let's add another page the end user can navigate to once the site loads. First, create a file named `another-page.md` inside the `docs` folder. Add the following text to the contents of the file `# Another Page`. 

Now your `docs` folder should look like this.

```
docs
├── index.md
├── another-page.md
```

You will not find it if you try to navigate to `another page.md` inside your web browser. You can access the page manually by following the URL: `http://localhost:5173/another-page`.

> Note: Notice that the directory structure corresponds with the URL path.

So how can we fix this? 

## Adding Navigation

We have the basics of a website, but it lacks navigation capabilities to find the other pages. Typically, the sidebar menu is used for documentation sites. To add them, we need to do a few things first.

To customize and add navigation to your site, let's first create a `.vitepress` directory inside your `docs` directory. Once completed, add another file called `config.js`. This folder is where all VitePress-specific configuration files will be placed. Your project structure should look like the following:

```
docs
├── index.md
├── another-page.md
└── .vitepress
    └── config.js
```

Open your `vitepress/config.js` and add the code below:

```javascript
export default {
  title: 'VitePress',
  description: 'Vonage Loves Developers.'
}
```

This will provide a default title and description for the site, which search engines will index.

Next, we'll configure our top-level navigation bar to have two additional items for our **Roadmap** and ways for our users to **Feedback**. Add the following to your `vitepress/config.js` file after the `description` field.

```javascript
themeConfig: {
 nav: [
  { text: 'Roadmap', link: '/roadmap' },
  { text: 'Feedback', link: '/feedback' }
]
```

![Top Level Navigation in VitePress](/content/blog/create-a-static-site-using-vitepress-for-beautiful-help-documentation/toplevelnavigation.png "toplevelnavigation.png")

Great! Our site is taking shape! Now, let's add our **Sidebar** underneath the `nav` element we just created. 

```javascript
export default {
  title: 'VitePress',
  description: 'Vonage Loves Developers.',
  themeConfig: {
    nav: [
      { text: 'Roadmap', link: '/roadmap' },
      { text: 'Feedback', link: '/feedback' }
    ],
    sidebar: [
      {
        text: 'Guide',
        items: [
          { text: 'Introduction', link: '/introduction' },
          { text: 'Getting Started', link: '/getting-started' },
        ]
      }
    ]
  }
}
```

Now our site is starting to take shape! We have a top-level and sidebar navigation added. We also have a **Next page** button that will go to the **Introduction** page (once we create it).

![Side bar Navigation in VitePress](/content/blog/create-a-static-site-using-vitepress-for-beautiful-help-documentation/sidelevelnavigation.png "sidelevelnavigation.png")

Let's go ahead and add in all the pages that we just created: 

Create the following files called `roadmap.md`, `feedback.md`, `introduction.md` and `getting-started.md` in the `docs` folder and give them a header with the same name. 

For example, `# Roadmap` would be entered inside the `roadmap.md` file. Do that for all the files. 

Once everything has been saved, return to your site to test that all the links now work as intended. 

![site Working with Navigation](/content/blog/create-a-static-site-using-vitepress-for-beautiful-help-documentation/navigationadded.gif "navigationadded.gif")

## Other Notable Features

### GitHub or GitLab edit links

You can create a link automatically on each page to let your readers help contribute to the accuracy of the page through Git management services such as GitHub or GitLab. To enable it, add `themeConfig.editLink` options to your config as shown below:

```javascript
export default {
  themeConfig: {
    editLink: {
      pattern: 'https://github.com/vuejs/vitepress/edit/main/docs/:path',
      text: 'Edit this page on GitHub'
    }
  }
}
```

Now, each rendered page will have a link back to GitHub (or GitLab) for the user to perform a pull request.

![GitHub or GitLab edit links](/content/blog/create-a-static-site-using-vitepress-for-beautiful-help-documentation/editpage.png "editpage.png")

### Custom Containers

There is built-in support for custom containers when you want to call out something to a reader, for example, info, tip, warning box, etc.

```javascript
::: info
This is an info box.
:::

::: tip
This is a tip.
:::

::: warning
This is a warning.
:::

::: danger
This is a dangerous warning.
:::

::: details
This is a details block.
:::
```

This renders as: 

![Custom Containers](/content/blog/create-a-static-site-using-vitepress-for-beautiful-help-documentation/tipbox.png "tipbox.png")

### Syntax Highlighting in Code Blocks

Syntax Highlighting in Code Blocks is supported in a variety of ways. See this example of how you can highlight a line in a code block:

```js{4}
export default {
  data () {
    return {
      msg: 'Highlighted!'
    }
  }
}
```

![Syntax Highlighting in Code Blocks](/content/blog/create-a-static-site-using-vitepress-for-beautiful-help-documentation/syntaxhighlighting.png "syntaxhighlighting.png")

## Deploying Your App

Now that we've developed our static site, and added pages to it along with a rich navigation bar, let's deploy our app. You can do so by running the following command `yarn docs:build`.

If everything works properly, then you'll see the following:

```
yarn docs:build
yarn run v1.22.19
$ vitepress build docs
vitepress v1.0.0-alpha.21
✓ building client + server bundles...
⠋ rendering pages...(node:3164) ExperimentalWarning: The Fetch API is an experimental feature. This feature could change at any time
(Use `node --trace-warnings ...` to show where the warning was created)
✓ rendering pages...
build complete in 8.29s.
Done in 8.97s.

```

The rendered files will default go to your project page under   `dist`. For example, my files were rendered here: `C:\Users\mbcru\source\static-starter\docs\.vitepress\dist`

![Deploying Your App](/content/blog/create-a-static-site-using-vitepress-for-beautiful-help-documentation/fileexplorer.png "fileexplorer.png")

## Wrap-up

Now that your static site is running, you could add specific communication features that [Vonage](https://developer.vonage.com) offers, such as the [Video](https://tokbox.com/developer/guides/basics/), or [Messaging](https://www.vonage.com/communications-apis/messages/), etc. capabilities! 

If you have questions or feedback, join us on the [Vonage Developer Slack](https://developer.vonage.com/community/slack) or send me a Tweet on [Twitter](https://twitter.com/mbcrump), and I will get back to you. Thanks again for reading, and I will catch you on the next one!
