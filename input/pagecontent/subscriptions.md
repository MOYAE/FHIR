## Subscriptions

How a partner system is told that something changed in Moyae, without polling for it.

Moyae implements the core FHIR R4 [`Subscription`](https://hl7.org/fhir/R4/subscription.html) resource with a `rest-hook` channel. It does not use R5 topics or the Subscriptions Backport guide. Two Moyae extensions on `Subscription.channel` let the subscriber say which related resources it wants delivered with the triggering one, so a single notification is enough to show a result.

This page has two parts and keeps them apart:

* [What the API does today](#today) is in production.
* [The connectathon profile](#connectathon) is a **draft** agreed with partners for the January 2027 FHIR connectathon. It is not implemented yet and may still change.

### The flow
{: #flow }

<img src="subscription-flow.svg" alt="Sequence diagram of the subscription flow, steps 1 to 12 as listed in the table below" style="max-width:100%"/>

| Step | Who | What happens |
|---|---|---|
| 1 | Subscriber to Moyae | The subscriber's backend service gets a token with SMART Backend Services and creates a `Subscription` for finished Encounters (created or updated). |
| 2 | Moyae | Front desk stores the Patient and the Appointment in the EMR. |
| 3 | Subscriber to Moyae | The subscriber periodically searches today's Appointments with the Patient included: `GET /fhir/Appointment?date=<today>&_include=Appointment:patient`. |
| 4 | Subscriber | Matches the Patient against its own FHIR server (`Patient/$match`) and creates the record if there is none. |
| 5 | Viewer | Retrieves and displays the Patient. |
| 6 | Moyae | During the exam, refraction and visual acuity are stored. |
| 7 | Moyae | The Encounter for the visit is created and later finished. |
| 8 | Moyae to subscriber | Moyae POSTs a notification Bundle to the subscription endpoint. |
| 9 | Subscriber | Matches the Patient again if it is not known yet. |
| 10 | Subscriber | Validates the Bundle against the requested profiles. |
| 11 | Subscriber | POSTs the transaction Bundle to its own FHIR server. |
| 12 | Viewer | Retrieves and displays the measurements. |

Steps 3 to 5 are plain search and work without any subscription. They give the subscriber the day's patients before any result exists. Steps 8 to 12 are the subscription.

### What the API does today
{: #today }

**Who may subscribe.** System apps only: a SMART Backend Services client (`client_credentials`) holding `system/Subscription.write` plus a read scope for the resource type in the criteria. A subscription belongs to the app that created it and covers one practice.

**Create.** `POST /fhir/Subscription`

```json
{
  "resourceType": "Subscription",
  "status": "requested",
  "reason": "Get notified of appointments",
  "criteria": "Appointment",
  "channel": {
    "type": "rest-hook",
    "endpoint": "https://partner.example/moyae-hooks/123",
    "payload": "application/fhir+json",
    "header": ["X-Subscription-Secret: <your secret>"]
  }
}
```

* `channel.type` must be `rest-hook` and `channel.endpoint` must be `https`.
* `criteria` must start with a resource type the app can read.
* If no `X-Subscription-Secret` header is supplied, Moyae creates one and returns it once, in the `channel.header` of the created resource.
* `GET /fhir/Subscription`, `GET /fhir/Subscription/{id}` and `DELETE /fhir/Subscription/{id}` manage the app's own subscriptions.

**Notification.** On every create or update of a resource of the subscribed type in that practice, Moyae POSTs the current version of that one resource to the endpoint:

```
POST <endpoint>
Content-Type: application/fhir+json
X-Subscription-Id: <Subscription.id>
X-Subscription-Secret: <secret>

{ "resourceType": "Appointment", "id": "...", ... }
```

**Limits to plan for today.**

* Only the resource type in `criteria` is applied. Search parameters after the `?` are stored but not evaluated, so the receiver gets every write of that type and filters for itself.
* The body is the single resource, not a Bundle.
* Deletes are not notified. Reconcile with a search.
* Only `X-Subscription-Secret` is kept from `channel.header`. Other headers are not replayed.

**Delivery.** At least once, so receivers must be idempotent (key on resource id and `meta.versionId`). Any 2xx answer within 15 seconds is success. A failed delivery is retried up to 8 times with exponential backoff starting at 5 seconds. After 20 failed deliveries in a row the subscription moves to `status = error` with the last failure in `Subscription.error`; delete it, create a new one and catch up with a search.

### The connectathon profile (draft)
{: #connectathon }

Target: January 2027 FHIR connectathon, with Moyae as the server. Everything in this section is the agreed design, not shipped behaviour.

The subscriber creates one subscription per trigger. The two agreed triggers:

| Trigger | `criteria` | Fires when |
|---|---|---|
| Patient arrived | `Appointment?status=arrived` | An Appointment is checked in. |
| Visit finished | `Encounter?status=finished` | An Encounter is created or updated with status `finished`. |

```json
{
  "resourceType": "Subscription",
  "status": "requested",
  "reason": "Get notified of finalized encounters",
  "criteria": "Encounter?status=finished",
  "extension": [
    {
      "url": "<extension defined by the requested guide>",
      "valueCanonical": "<ImplementationGuide canonical>|<version>"
    }
  ],
  "channel": {
    "type": "rest-hook",
    "endpoint": "https://partner.example/moyae-hooks/123",
    "payload": "application/fhir+json",
    "header": ["Authorization: Bearer <token>"],
    "extension": [
      {
        "url": "https://moyae.com/StructureDefinition/filter-by-profile",
        "valueString": "Observation?code=http://snomed.info/sct|251794006"
      },
      {
        "url": "https://moyae.com/StructureDefinition/filter-by-profile",
        "valueString": "Observation?code=http://snomed.info/sct|363983007"
      },
      {
        "url": "https://moyae.com/StructureDefinition/filter-by-resource-type",
        "valueString": "Patient"
      }
    ]
  }
}
```

**What each part asks for.**

| Element | Meaning |
|---|---|
| `criteria` | The trigger. Unlike today, the search parameters are evaluated: only resources that match fire a notification. |
| `Subscription.extension` (requested guide) | A canonical reference to the implementation guide whose shapes the subscriber wants. Moyae converts its stored resources to that guide's profiles before sending. The extension is defined by the requested guide, not by Moyae. Without it, resources are sent in the shapes documented in this guide. |
| [`filter-by-profile`](StructureDefinition-filter-by-profile.html) | Repeatable. A search string naming related resources to add to the notification. In the example: refraction (`251794006`) and visual acuity (`363983007`) Observations. |
| [`filter-by-resource-type`](StructureDefinition-filter-by-resource-type.html) | Repeatable. A resource type to add for the same patient. In the example: the `Patient`. |
| `channel.header` | Every header is stored and sent with each notification, so the subscriber can protect its endpoint with its own `Authorization` value. |

**Notification.** One `POST` to the endpoint whose body is a `Bundle` of type `transaction`, so the receiver can validate it and forward it to its own FHIR server unchanged. It contains:

1. the resource that matched `criteria` (the Encounter or Appointment),
2. the resources selected by each `filter-by-resource-type`,
3. the resources selected by each `filter-by-profile`.

All entries are for the patient of the triggering resource and are in the shape of the requested guide.

**Open points.** These are not settled and will be decided before the connectathon:

* Which Observations a `filter-by-profile` returns: only those recorded in the triggering Encounter, or the patient's history as well. At check-in there is usually no measurement from the current visit yet.
* The `request` method on each Bundle entry (`PUT` by id is proposed, so a repeated delivery overwrites and does not duplicate).
* Which endpoint origins a system app may register.

Feedback on this draft: [partnerships@moyae.com](mailto:partnerships@moyae.com).
