---
title: Overview
meta_title: List, Create,and Delete WhatsApp templates with the WhatsApp Template Management API. 
description: The WhatsApp Template Management API allows you to list existing WhatsApp templates, create new templates, delete templates, and upload files for use in templates.
navigation_weight: 1
---

# WhatsApp Template Management API Overview

The WhatsApp Template Management API allows you to list existing WhatsApp templates, create new templates, delete templates, and upload media for use in templates. Although WhatsApp templates can be managed manually via the [WhatsApp Business Manager](https://business.facebook.com/wa/manage/message-templates/) UI, the Vonage WhatsApp Template Management API now lets you manage your templates programmatically through the WhatsApp Business API.

The WhatsApp Template Management API currently lets you perform the following operations:

* [Get a List of Templates](#getting-a-list-of-templates)
* [Create a Template](#creating-a-template)
* [Delete a Template](#deleting-a-template)
* [Upload Media](#uploading-media)

Currently, templates cannot be updated.

> WhatsApp currently doesn’t support sending Contacts & Locations within a message template. These messages can only be sent in response to an incoming message.

## Getting a List of Templates

Using the WhatsApp Template Management API, you can get a list of templates owned by the specified WhatsApp Business Account. The API provides some pagination and filtering functionality. For example, you can filter requests by template `status`, `language`, and `name_or_content`.

## Creating a Template

You can create templates of various types and categories, as well as creating multiple language variations of a template. When creating templates with multiple language versions, make sure to be consistent with translations across the versions.

> Make sure that your templates follow [WhatsApp Message Template Guidelines](https://developers.facebook.com/docs/whatsapp/message-templates/guidelines). Not correctly following the guidelines can impact on templates being [approved](#approval-process).

### Approval Process

Templates need to be approved by Meta before they can be used in a WhatsApp message. When created, templates initially have a `status` of `PENDING`. Once approved, they will have a `status` of `APPROVED`, and can then be used.

### Media Message Templates

When creating Media Message Templates, you must first upload the media to be used to the WhatsApp platform (see [Uploading Media](#uploading-media)). Uploaded media will have a unique handle which can be specified when creating a template.

> Note: each WhatsApp business account can have a maximum of 250 message templates, though each template can have multiple language versions. For example, a message template called `hello_world` translated into two languages counts as a single message template in regards to this limit.
>
> A WhatsApp Business Account can create a maximum of 100 message templates per hour.

## Deleting a Template

You can delete a template associated with a specific WhatsApp Business Account by specifying the template by name. If a particular template has multiple language versions for the same name, **all** versions for that template name will be deleted.

Once deleted, the name of the (approved) template cannot be used again for 30 days.

> Messages sent for a deleted template may still be delivered *within* 30 days if they have been sent but not yet delivered.

## Uploading Media

You can upload media such as images, video, and PDF files, to the WhatsApp platform for use in Media Message Templates. Media needs to be uploaded before it can be used in a Media Message template.

> Note: a timeout may occur if you attempt to upload large media files (e.g. above 25MB). In such cases we recommend instead using the WhatsApp Business Manager UI to upload the files.