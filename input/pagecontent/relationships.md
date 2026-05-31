## Relationships and caveats

This page documents the deliberate and inherited characteristics of Moyae's current FHIR emissions that differ from idiomatic FHIR R4 or from peer IGs.

### Why `Observation.focus` references VisionPrescription
{: #focus }

When `typeOfExam` is `corrected` or `refraction`, MoyaeVisualAcuity and MoyaeRefraction Observations populate `Observation.focus` with a reference to the companion VisionPrescription. This is **deliberate but unusual**.

**Background.** FHIR R4 defines `Observation.focus` as: *"The actual focus of an observation when it is not the patient of record representing something or someone associated with the patient such as a spouse, parent, fetus, or donor."* The canonical examples are a fetus during pregnancy or a relative being characterized.

**Moyae's use.** The Observation is *about* the patient's eyes, and the refractive numbers (sphere / cylinder / axis / add / prism) live on the companion VisionPrescription. `focus` carries the reference so queries that fetch the VA can co-resolve the refractive measurement in one round trip.

**Why not `Observation.derivedFrom`?** Semantically `derivedFrom` is closer: a VA reading taken at a corrected refraction is, in a sense, derived from the refraction. The current code uses `focus`; v0.1.x will evaluate moving to `derivedFrom` once partners weigh in.

**Why not `Observation.basedOn` or `Observation.partOf`?** These reference Request resources or Procedure / Encounter shaped resources respectively. Neither matches the measurement-to-prescription relationship cleanly.

**Comparison to peer IGs.** The HL7 Eye Care IG and ZEISS Eyecare Concepts IG treat refractive measurements as their own Observation profiles (subjective / objective / habitual lens prescription as an Observation profile). Moyae's pattern of using VisionPrescription as the measurement carrier is a Moyae-specific design choice that preserves the measurement → signed-prescription audit trail on a single resource. The trade-off is the unusual `focus` reference and the dual-status overload on VisionPrescription.

### Two SNOMED system URIs are emitted
{: #snomed-uris }

Today's Moyae code uses two different system URIs for SNOMED codes:

* `http://snomed.info/sct` — canonical FHIR SNOMED system URI. Used for the IOP code, the laterality extension, refraction method procedure codes, and most VA component codes.
* `https://www.snomed.org/` — non-canonical, legacy URL. Used today for the instrument component and the eye component in `MoyaeIntraocularPressure`.

The latter is **not a valid SNOMED system URI** for FHIR validation. The profiles document this faithfully (see `$SCT-LEGACY` in `aliases.fsh`). **v0.1.x will canonicalize to `$SCT` across the board**, which requires a small change in `packages/api/services/fhirObservations/iop.ts`.

### The `is-cc` boolean uses a Moyae URI, not SNOMED
{: #is-cc }

The "with correction" component on MoyaeVisualAcuity is emitted with `code.coding.system = https://moyae.com/is-cc` and `code.coding.code = "cc"`. This is a Moyae-defined URI that does not currently resolve to a CodeSystem.

There is a SNOMED concept for *"with correction"* (`419775003` is BCVA which is related but not identical). v0.1.x will either (a) mint a Moyae CodeSystem at this URL and publish it as part of the IG, or (b) replace the flag with an idiomatic SNOMED procedure code.

### Identifier patterns lack a system
{: #identifier-system }

* `MoyaeIntraocularPressure.identifier` is emitted as `{ value: "intraocular-pressure" }` with no system.
* `MoyaeVisualAcuity.identifier` is emitted as `{ value: "visual_acuity" }` with no system (and note the underscore, while IOP uses a hyphen).
* `MoyaeVisionPrescription.identifier` is emitted as `{ system: "https://moyae.com/vision-prescription-status", value: "active" }`. The system URI suggests state, not identity.

These are documentary artifacts of the current code and should be normalized in v0.1.x to either a single canonical Moyae identifier system or removed where they don't carry external meaning.

### VisionPrescription is dual-purpose
{: #vp-dual-purpose }

Moyae uses `VisionPrescription.status = "draft"` as the in-exam **measurement** carrier and `status = "active"` as the signed **prescription**. The same resource type covers both lifecycle states.

* **Pro:** A single resource preserves the measurement → prescription audit trail. The prescriber signature transitions status from draft to active. Partners querying for "the refraction taken at this encounter" don't need to look at two different resource types.
* **Con:** ZEISS Eyecare Concepts IG argues VisionPrescription is fundamentally a Request resource (for prescribing) and that measurements should be Observations (their `HabitualLensPrescription` Observation profile). Tools that expect VisionPrescription to mean "signed Rx" can misinterpret draft instances.

Moyae's pattern stays in v0.1.0. The narrative documents it so partners can plan accordingly. Both patterns are valid; this is a design choice, not a bug.

### Refraction is not a separate Observation type
{: #refraction-not-separate }

There is no distinct "Refraction" resource type in Moyae's code. A refraction is a Visual Acuity Observation with:

* `Observation.code` set to SNOMED `251794006` ("Refraction") instead of the corrected-VA code.
* `Observation.focus` always populated with the companion VisionPrescription.
* Method flags (manifest, autorefraction, cycloplegic, overrefraction) on boolean components.

`MoyaeRefraction` exists in this IG to give partners a distinct, queryable profile identity, but it is structurally a slice of the same Observation path.

### Partner customization is permanent infrastructure

The Moyae API includes a translation layer between the canonical shapes documented here and partner-specific profiles. **This layer is permanent** — Moyae does not plan to deprecate it. Partners can request customized endpoints, mappings, and per-partner derivations as part of the partnership program.

This means partners do not need to consume the canonical shapes documented in this IG. The canonical shapes are the **reference point**; the translation layer adapts them to whatever a given partner needs.

### Compatibility with HL7 Eye Care and ZEISS Eyecare Concepts IGs

Moyae aligns with the per-Observation profile structure published by the ZEISS Eyecare Concepts IG (separate profiles for refraction sub-types, body-site-based laterality, valueQuantity with UCUM). Reaching parity with that structure is the goal of v0.1.x. See the [Moyae IG ↔ ZEISS Eyecare Concepts mapping](https://fhir.moyae.com/ig/v0.1/mapping-zeiss.html) (published with v0.1.1).
