---
title: Build an ASP.NET MVC App to Send SMS Messages
description: Learn how to use the Vonage SMS API with a real-world application
  using ASP.NET MVC Application and .NET 6.0.
thumbnail: /content/blog/build-an-asp-net-mvc-app-to-send-sms-messages/asp-net_mvc-app.png
author: michael-crump
published: true
published_at: 2022-09-06T09:07:03.688Z
updated_at: 2022-09-06T09:07:04.673Z
category: tutorial
tags:
  - csharp
  - sms-api
comments: true
spotlight: false
redirect: ""
canonical: ""
outdated: false
replacement_url: ""
---
## Intro

Hi everyone! Michael Crump here, and what excites me about learning a new technology is understanding a potential scenario that an end-user would use it for and how to go about building the solution as a developer.

I believe that real-world scenarios are important in understanding how to work with a product (or API in our case) is that they can demonstrate the complexity and unpredictability of real issues that we face to stimulate critical thinking about how we might solve them.

With that in mind, I decided to build a web application that simulates an end-user finding a house they are interested in and submitted a form that a real estate agent would receive an SMS with the details. A simple user interface of the application is shown below:

![The demo app that we will build](/content/blog/build-an-asp-net-mvc-app-to-send-sms-messages/demo.png)

OK, let's get started building the app!

Note: The complete source code for this application can be found in our [Vonage Community repo](https://github.com/Vonage-Community/blog-sms-csharp-realestate).

# Getting Setup

## Creating the Project

Begin by launching [Visual Studio](https://visualstudio.microsoft.com/vs/) (Community Edition or higher) and selecting **Create a New Project**, and selecting **ASP.NET Core Web App (Model-View-Controller)** as shown below. I'll provide more information about what MVC is very shortly.

![Create a new project](/content/blog/build-an-asp-net-mvc-app-to-send-sms-messages/newproject.png)

Give your project a name (example: SalesLeads) and press **Next**. For Framework, ensure it is set to **.NET 6.0** and leave the other options as their default settings and press the **Create** button.

![Visual Studio - Additional Settings](/content/blog/build-an-asp-net-mvc-app-to-send-sms-messages/additionalinfo.png)

In **Solution Explorer**, right-click **Dependencies** and select **Manage NuGet Packages**. Now select the **Browse** tab and search for **Vonage**. You'll see [Vonage](https://www.nuget.org/packages/Vonage/) appear and press **Install** on the latest stable release (6.03 at the time of this writing). 

![Installing Vonage dependencies](/content/blog/build-an-asp-net-mvc-app-to-send-sms-messages/installvonage.png)

# What Is MVC, and Why Should We Use It?

Before we jump into code, I wanted to provide a basic overview of MVC where you can better understand why we use this pattern for web applications today. In short, MVC stands for model-view-controller, a design pattern that ensures applications are well architected and easy to test and maintain for future developers working in the code base.

**M**odels: Represent the data of the application.

**V**iews: Represent the displayed HTML (or what the end user sees) of the running application.

**C**ontrollers: Represent the Business Logic of the application.

With a basic understanding of the pattern, let's build our application. 

# Beginning With the Model (Data)

Right-click **Models** in Solution Explorer and **Add** a new **Class Library**. We'll give the name **Lead.cs** and press **Add**. 

We'll add in 4 pieces of information: The customer's name, phone number, the message they want to send as well as the result of submitting the form. This way, the end user knows if it was sent successfully or not.

```csharp
using System.ComponentModel.DataAnnotations;

namespace SalesLeads.Models
{
    public class Lead
    {
        [Display(Name = "Your Name")]
        public string Name { get; set; }
        [Display(Name = "Your Phone Number")]
        public string Phone { get; set; }
        [Display(Name = "How can we help?")]
        public string Message { get; set; }
        public string Result { get; set; }
    }
}
```

# Defining the View (UI)

We will define the page that is presented to the end user now.

Select **Views** -> **Home** -> and then **Index.cshtml**.

> What is cshtml? It is a C# HTML file that is used on the server side by Razor Markup engine to render the webpage files to the user's browser.

We'll begin by defining the data model the template page will use, as shown in line #1 below. Next, we'll create a couple of divs so that our page looks nice once rendered (along with some boilerplate text about the house). Then we'll use ASP.NET's [BeginForm](https://docs.microsoft.com/en-us/dotnet/api/system.web.mvc.html.formextensions.beginform?view=aspnet-mvc-5.2) Extension method to easily construct a form. Several features are baked in, including an easy way to add **Placeholder** text and mark the field as **required**.

```csharp
@model SalesLeads.Models.Lead

<div class="row">
    <div class="col-sm-8">
        <img src="~/Content/Images/house.jpg" class="img-responsive" alt="House" />
    </div>
    <div class="col-sm-2">
        <h4>Talk To A Real Estate Agent</h4>
        <p>
            A trained real estate professional is standing by to answer any
            questions you might have about this property. Fill out the form below
            with your contact information, and an agent will reach out soon.
        </p>
        @using (Html.BeginForm("Index", "Home"))
        {
            <div class="form-group">
                @Html.LabelFor(m => m.Name)
                @Html.TextBoxFor(m => m.Name, new { @class = "form-control", placeholder = "Michael Crump", required = "required" })
            </div>
            <div class="form-group">
                @Html.LabelFor(m => m.Phone)
                @Html.TextBoxFor(m => m.Phone, new { @class = "form-control", placeholder = "+14253331111", required = "required" })
            </div>
            <div class="form-group">
                @Html.LabelFor(m => m.Message)
                @Html.TextBoxFor(m => m.Message, new { @class = "form-control", required = "required" })
            </div>
            <button type="submit" class="btn btn-primary">Request Info</button>
        }

        <strong>@Html.DisplayFor(m => m.Result)</strong><br />
    </div>
</div>
```

We'll wrap up with a button to submit the data (via a POST request) as well as a place to output if the SMS message was sent successfully or not.

For bonus points: Add a sample image of your house in the following location at `~/Content/Images/house.jpg`. :)

# Adding the Controller (Business Logic)

We need to store our **API Key and API Secret** for our application to use when sending an SMS message. We'll place this inside a Domain Controller.

But first, you can get your current API Key and API Secret by visiting the [Vonage Developer Portal](https://developer.vonage.com) and copying and pasting the keys as shown below. 

![Installing Vonage dependencies](/content/blog/build-an-asp-net-mvc-app-to-send-sms-messages/apidashboard.png)

> Note: I added the secrets to this class for the ease of understanding the pattern. Please secure your secrets if you are publishing a production application using either environment variables or something such as Azure Key Vault. 

Right-click the Solution and add a new folder called **Domain**; inside that folder, create a new **Class Library** called **Credentials.cs** with the following content.

```csharp
namespace SalesLeads.Domain
{
     public class Credentials
    {
        public static string APIKey => "ENTER_API_KEY";
        public static string APISecret => "ENTER_API_SECRET";
    }
}
```

Next, we will write the logic that sends the SMS Message.

Select **Controllers** and then **HomeController.cs** and use the following code snippet. You'll need to update the `using SalesLeads.Models;` to whatever the name of your project is in order to pull in your **Model** data.

```csharp
using Microsoft.AspNetCore.Mvc;
using SalesLeads.Models;
using Vonage;
using Vonage.Request;

namespace SalesLeads.Controllers
{
    public class HomeController : Controller
    {
        public ActionResult Index()
        {
            return this.View();
        }

        [HttpPost]
        public ActionResult Index(Lead lead)
        {
            string name = lead.Name;
            string phone = lead.Phone;
            string message = lead.Message;

            var credentials = Credentials.FromApiKeyAndSecret(
            Domain.Credentials.APIKey,
            Domain.Credentials.APISecret
            );

            var VonageClient = new VonageClient(credentials);

            var response = VonageClient.SmsClient.SendAnSms(new Vonage.Messaging.SendSmsRequest()
            {
                To = "ENTER_A_PHONE_NUMBER",
                From = "ENTER_A_PHONE_NUMBER",
                Text = $"New lead acquired!\n\nName: {name}\nPhone: {phone}\nMessage: {message}"
            });

            if (response != null && Convert.ToInt32(response.MessageCount) > 0 && response.Messages[0].StatusCode.ToString() == "Success")
            {
                lead.Result = "Message sent successfully! An agent will contact you shortly.";
            }
            else
            {
                lead.Result = "Message Failure. Please try your request again. ";
            }
            
            return this.View(lead);
        }
    }
}
```

The last **If...then** statement checks to see if the SMS was sent successfully and reports back to the client the status. 

When you run the code above and enter a **Name, Phone Number and Message**, the text message will be sent to the mobile number you specified (which, in this case, would be hard coded to the realtor's cell phone).

Below is the result of the SMS sent successfully!

![Sample Message sent successful](/content/blog/build-an-asp-net-mvc-app-to-send-sms-messages/result.png)

## Conclusion

I hope this tutorial helped you get started with Vonage's SMS APIs. If you have questions or feedback about our SMS API, join us on the [Vonage Developer Slack](https://developer.vonage.com/community/slack) or send me a Tweet on [Twitter](https://twitter.com/mbcrump), and I'll get back to you. Again, the full source code for this application can be found in our [Vonage Community repo](https://github.com/Vonage-Community/blog-sms-csharp-realestate). Thanks again for reading, and I'll catch you on the next one!
