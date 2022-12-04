## Errors

Vonage uses error codes to report back when an issue was encountered. Below you can find a full table to error codes:

Error | Details | Resolution
-- | -- | --
`brand-conflict` | A conflict when a brand is being created or edited and there is an issue with a 3rd party vendor. | Ensure all required fields have values and there are no errors in those values. If the error persists, contact [support@vonage.com](support@vonage.com).
`brand-parameters` | There are errors in the brand data submitted. | Ensure all required fields have values included and correct any errors to values in the specified fields.
`invalid-usecase-data` | There are errors in the data submitted for use case qualification. | Ensure all required fields have values included and correct any errors to values in the specified fields.
`use-case-denied` | The use case requested has been denied for this brand. | Ensure your use case does not require additional brand vetting or pre/post Mobile Network Operator approval.
`vetting-conflict` | A conflict during the brand vetting request has occurred. | If the error persists, contact [support@vonage.com](support@vonage.com).
`invalid-vetting-data` | There are errors in the vetting request data submitted. | Ensure all required fields have values and correct any errors to values in the specified fields.
`invalid-json` | Your request cannot be parsed. | Ensure there are no invalid characters or values in your request.
`brand-not-qualified` | A conflict when a campaign is being created under a brand that hasn't qualified for the specified use case. | Verify the brand use case qualifies before submitting the campaign.
`invalid-campaign-data` | There are errors in the campaign data submitted. | Ensure all required fields have values and correct any errors to values in the specified fields.
`numbers-already linked` | The number you are attempting to link is already linked to another campaign. | You must link a unique number to a campaign. Link a different number to this campaign.
`invalid-number-data` | There are errors in the number data submitted. | Ensure all required fields have values and correct any errors to values in the specified fields.
`illegal-sender-address` | The number you are trying to send from is not a US-approved long number or a Vonage number. | Check to ensure the number matches the one from your Vonage dashboard.
`submission-throttled` | Submission Control throttled due to max volume reached for this period.
| Once the number of requests drops from its current high, the quota per period will be restored.
`daily-submission-throttled` | Daily Limit Surpassed - Submission Control throttled due to max volume reached for this period
 | Once the number of requests drops from its current high, the quota per period will be restored.
