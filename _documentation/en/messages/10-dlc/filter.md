---
title: Filtering 10 DLC results
meta_title: 10 DLC Filtering Results 
description: Provides and in-depth explanation on how to filter and fetch results containing specific keyword combinations. 
navigation_weight: 3
---

# Overview

All 10 DLC GET [API endpoints](/api/10dlc) allow you to narrow down your results using filters.

For example, instead of getting the list of all brands, you might be interested in brands within the **REAL_ESTATE** vertical. In this case, you can apply a filter to return **REAL_ESTATE** related brands only. 

## Request Structure
Filters are passed to the endpoint as query parameters. In your query, you will use the keyword `filter` as the key followed by the query in the form of a JSON object.

Here is an example:

```sh
https://api-eu.vonage.com/v1/10dlc/brands/:brand_id/campaigns?filter=[[{"field":"vertical","type":"==","value":"REAL_ESTATE"}]]
```

### Filter Object 
A filter object is a JSON object containing a filter query. A filter object contains three key/value pairs:

```json
[
   [
      {
         "field":"vertical",
         "type":"==",
         "value":"REAL_ESTATE"
      }
   ]
]
```

**Field**: is the name of the field whose value you will like to filter by.

**Type**: is the matching condition you will like to apply in the filter search. Visit the [filter conditions](#filter-conditions) section to see the available conditions.

**Value**: is the value you will like to filter by. 

### Filter Conditions

- `regexp`: **Regex** - Returns records that match the filter value based on the provided regular expression.
- `==`: **Equal To** - Returns records that match the filter value exactly.
- `=` : **Equal Fold** - Matches records without case-sensitivity (This applies to UTF-8 characters).
- `^=`: **Starts With** - Matches records starting with the filter value.
- `=$`: **Ends With** - Matches records ending with the filter value.
- `~=`: **Contains** - Matches records containing the filter value.
- `<`: **Less Than** - matches records less than the filter value.
- `<=`: **Less Than or Equals To** - matches records less than or equal to the filter value.
- `>`: **Greater Than** - matches records greater than the specified filter value.
- `>=`: **Greater Than or Equal To** - matches records greater than or equal to the filter value.

> You can fetch opposing records by negating any of the above conditions by prefixing the condition with the `!` symbol. For example, `!==` is equivalent to **Not Equal**.

### Filtering Rules
You can have a maximum of **three [filter objects](#filter-object)** in a query. This means you can find results that match a maximum of three fields. Filter objects can also be paired up in different ways.

For example, you can fetch results that match one filter object **OR** another. Also, results that match one filter object **AND** another.


Let's take the case where we will like to fetch brands where the `vertical` is either *REAL_ESTATE* **OR** *NGO* **AND** where the id of the reseller(`reseller_id`) is **12345**.

We can express this as a logical statement: `( (vertical == REAL_ESTATE OR vertical == NGO) AND (reseller_id == 12345) )`

Filter queries involving **OR** expressions are represented using the square bracket `[]`. 
For example the following expression`(vertical == REAL_ESTATE OR vertical == NGO)` becomes `[ [{filter object 1}, {filter object 2}] ]`.

The inner square bracket denotes that you will like to fetch results matching either *filter object 1* **OR** *filter object 2*.

> The outer square bracket marks the start of a filter query and is mandatory and required for all filter queries.

### Examples of filter rules
1. Match ***filter object 1***; `[ [{filter object 1}] ]`.
2. Match ***filter object 1*** **AND** ***filter object 2***; `[ [{filter object 1}], [{filter object 2}] ]`
3. Match ***filter object 1*** **OR** ***filter object 2***;  `[ [{filter object 1},{filter object 2}] ]`
4. Match (***filter object 1*** **OR** ***filter object 2***) **AND** ***filter object 3*** ; `[ [{filter object 1},{filter object 2}], [{filter object 3}] ]`.

> **NB:** Filter objects should always be within a square bracket even if it's a single object. A good example is the ***filter object 3*** in example 4 above.

Also, further expanding the filter objects in example 4. we get the following filter query:

```json
[
   [
      {
         "field":"vertical",
         "type":"==",
         "value":"REAL_ESTATE"
      },
      {
         "field":"vertical",
         "type":"==",
         "value":"NGO"
      }
   ],
   [{
      "field":"reseller_id",
      "type":"==",
      "value":"12345"
   }]
]
```