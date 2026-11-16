## Moyae Ophthalmology FHIR Implementation Guide

**Version 0.1.1** — profiles and extensions for the resources Moyae emits today, plus the shape they are moving to.

This guide documents what the Moyae EMR actually writes to its FHIR store, not an aspirational model. Where the current emission differs from idiomatic FHIR R4 or from peer ophthalmology guides, the [Relationships and caveats](relationships.html) page says so and gives the migration plan. The [History](history.html) page lists what changed in each release.

### What v0.1.1 covers

| Profile | Source file in Moyae | Purpose |
|---|---|---|
| [MoyaeIntraocularPressure](StructureDefinition-moyae-intraocular-pressure.html) | `packages/api/services/fhirObservations/iopBuilder.ts` | One Observation per eye for IOP measurements. Documents the target shape (bodySite laterality, `valueQuantity` in mm[Hg], method). |
| [MoyaeVisualAcuity](StructureDefinition-moyae-visual-acuity.html) | `packages/api/services/fhirObservations/visualAcuityHelpers/formatObservation.ts` | Distance / intermediate / near VA per eye, with pinhole and binocular variants. |
| [MoyaeRefraction](StructureDefinition-moyae-refraction.html) | Same file, `typeOfExam = "refraction"` path | A refraction event. Shares structure with MoyaeVisualAcuity but `code` is SNOMED Refraction with subjective / objective discriminators; `focus` references the companion VisionPrescription. |
| [MoyaeVisionPrescription](StructureDefinition-moyae-vision-prescription.html) | `packages/api/services/fhirObservations/visualAcuityHelpers/formatVisionPrescription.ts` | `status="draft"` as the in-exam measurement carrier; `status="active"` as a separately issued, signed Rx. |

| Extension | On | Purpose |
|---|---|---|
| [VisionPrescriptionSourceObservation](StructureDefinition-vision-prescription-source-observation.html) | VisionPrescription | The exam Observation a draft or signed prescription was built from. The durable link; `Observation.focus` is the transitional one. |
| [LensMaterial](StructureDefinition-lens-material.html) | VisionPrescription.lensSpecification | Glasses lens material (CR-39, polycarbonate, Trivex, high-index, glass) from the [LensMaterial code system](CodeSystem-moyae-lens-material-cs.html). |
| [SubscriptionFilterByProfile](StructureDefinition-filter-by-profile.html) | Subscription.channel | Draft. Related resources (as a search string) to add to a notification. See [Subscriptions](subscriptions.html). |
| [SubscriptionFilterByResourceType](StructureDefinition-filter-by-resource-type.html) | Subscription.channel | Draft. A resource type to add to a notification for the same patient. |
| [BalanceLens](StructureDefinition-balance-lens.html) | VisionPrescription.lensSpecification | Marks an eye prescribed a balance lens, which base R4 cannot express because `sphere` is a decimal. |

### Important characteristics of the current implementation

These are the items partners and validators most often ask about.

* **One Observation per eye for IOP.** Each IOP exam produces two Observation resources. Laterality is on `Observation.bodySite` using the active SNOMED eye-structure concepts (`1290032005` right, `1290031003` left, `40638003` both). The legacy laterality extension and eye component are still written alongside for older readers.
* **bodySite on every Observation.** Since July 2026 the central write path appends `bodySite` to any Observation whose code or components imply a side, and inactive SNOMED eye codes (`18944008`, `8966001`) are normalized to the active concepts on read and in a one-time migration.
* **Visual acuity and refraction share an Observation shape.** They are distinguished by `Observation.code` and by component method flags. Refraction Observations also carry the SNOMED subjective (`397277005`) or objective (`397276001`) refraction coding, matching the discriminators used by device-vendor profiles.
* **Refraction values live on VisionPrescription, not Observation.** The Observation references the VisionPrescription via `Observation.focus`; the VisionPrescription references the Observation back through the source-observation extension. The reverse link is the one that stays.
* **A signed prescription is its own resource.** Signing creates a new `status="active"` VisionPrescription; the exam draft is left untouched, so the measurement and the issued Rx have distinct ids and both carry signature records.
* **Provenance stamps.** VA, refraction and VisionPrescription resources carry application-name and application-version extensions so a consumer can tell which system wrote them without a translation step.
* **Imports are marked.** A VA or refraction copied forward from history carries `derivedFrom` pointing at the original Observation.
* **Measurement values are still `valueString`.** IOP pressure and VA notation are strings in production. The IOP profile in this guide documents the `valueQuantity` target; the writer has not been migrated yet.

### Reading Moyae data as a partner

Moyae exposes a SMART on FHIR R4 API for partners at `/fhir` on each environment, with discovery at `/.well-known/smart-configuration` and a CapabilityStatement at `/metadata`.

* **System apps** use SMART Backend Services (`client_credentials`) with `system/<Type>.read` scopes, and may create rest-hook `Subscription` resources to be notified of changes. See [Subscriptions](subscriptions.html) for how they work today and the draft connectathon profile.
* **Patient apps** use the SMART standalone launch with `patient/<Type>.read` scopes; access is scoped to the patient compartment.
* **Practice-management feeds** may write `Patient`, `Appointment` and `Location`, upserting by their own identifier.
* Nineteen resource types are readable, including `Observation`, `VisionPrescription`, `Condition`, `Procedure`, `DiagnosticReport`, `DocumentReference`, `Encounter` and `Appointment`.

Resources are served in the shapes documented here. Per-partner mappings and derived endpoints can be arranged through the partnership program at [moyae.com/build-with-moyae](https://moyae.com/build-with-moyae).

### Tooling

Authored in [FHIR Shorthand](https://fshschool.org/) and built with [SUSHI](https://fshschool.org/docs/sushi/) + the [HL7 IG Publisher](https://github.com/HL7/fhir-ig-publisher). Source repo: [github.com/MOYAE/FHIR](https://github.com/MOYAE/FHIR).

### Acknowledgments

Early drafts were reviewed by colleagues in the ophthalmic device and interoperability community. Not every suggestion is reflected yet; revisions continue to land in point releases. Moyae participates in the CCOI Interoperability and Standards working group and intends to contribute to the HL7 Eye Care IG refresh.

### Contact

Implementation feedback, partner inquiries: [partnerships@moyae.com](mailto:partnerships@moyae.com) or book at [calendar.app.google/joEV8YqqYastTaNf6](https://calendar.app.google/joEV8YqqYastTaNf6).
