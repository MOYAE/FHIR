## Relationships and caveats

This page documents the deliberate and inherited characteristics of Moyae's current FHIR emissions that differ from idiomatic FHIR R4 or from peer IGs.

### Why `Observation.focus` references VisionPrescription
{: #focus }

When `typeOfExam` is `corrected` or `refraction`, MoyaeVisualAcuity and MoyaeRefraction Observations populate `Observation.focus` with a reference to the companion VisionPrescription.

**This is non-standard, and we know it.** FHIR R4 defines `Observation.focus` as: *"The actual focus of an observation when it is not the patient of record representing something or someone associated with the patient such as a spouse, parent, fetus, or donor."* The canonical examples are a fetus during pregnancy or a relative being characterized. Using it for a measurement-to-prescription relationship is **not the pattern FHIR intends**, and validators that enforce the description strictly may flag it.

**Why Moyae uses it today.** The Observation is *about* the patient's eyes, and the refractive numbers (sphere / cylinder / axis / add / prism) live on the companion VisionPrescription. `focus` carries the reference so queries that fetch the VA can co-resolve the refractive measurement in one round trip. This was a pragmatic choice early in Moyae's FHIR adoption and has stayed in production.

**Planned migration to an extension.** v0.1.x will retire the `Observation.focus` use and replace it with a Moyae-defined extension at `https://fhir.moyae.com/StructureDefinition/measurement-prescription` carrying a `Reference(VisionPrescription)`. The semantics are clearer, the validator profile lookup is unambiguous, and the migration leaves `Observation.focus` available for its intended canonical use if Moyae ever needs it (e.g., a child VA exam performed in front of a parent).

The migration plan:

1. **v0.1.x (code change in `packages/api`):** start dual-writing — emit both the existing `focus` and the new `measurement-prescription` extension. Reads tolerate either.
2. **v0.2.0:** flip the reads to prefer the extension.
3. **v0.2.x backfill:** rewrite legacy Observations to add the extension. After completion, stop emitting `focus`.

**Note on R5.** The Observation resource in FHIR R5 keeps `focus` with the same definition, but the broader R5 design pattern leans on extensions for relationships that don't fit the canonical FHIR R4 reference slots. Moving to an extension aligns Moyae with where the standard is heading.

**Comparison to peer IGs.** Some peer IGs (e.g. the HL7 Eye Care IG) treat refractive measurements as their own Observation profiles, separate from any prescription resource. Moyae's pattern of using VisionPrescription as the measurement carrier is a Moyae-specific design choice that preserves the measurement → signed-prescription audit trail on a single resource. The trade-off is the unusual `focus` reference (to be replaced) and the dual-status overload on VisionPrescription.

### Two SNOMED system URIs — FIXED in v0.1.0
{: #snomed-uris }

**Status: FIXED.** Prior to Moyae commit [`c4bf7d5f3`](https://github.com/MOYAE/Moyae/commit/c4bf7d5f3), `iop.ts` emitted the instrument and eye components with `system = "https://www.snomed.org/"`. That URL is the SNOMED International company website, **not** the canonical FHIR SNOMED system URI (`http://snomed.info/sct`), and FHIR validators correctly reject codings under it.

The fix:

- All `splitEyes()`, `formatReturnObject()`, and `fetchIOPHistory()` emission paths now use `http://snomed.info/sct`.
- `fetchIOP()` was refactored to match the left/right eye component by SNOMED code only, so existing legacy data in HealthLake (which still has the old URI) continues to read correctly without a backfill.

This profile and the IOP example are now consistent with the canonical URI.

### `is-cc` CodeSystem published — FIXED in v0.1.0
{: #is-cc }

**Status: FIXED.** The "with correction" boolean component on MoyaeVisualAcuity and MoyaeRefraction uses `code.coding.system = https://moyae.com/is-cc`. Previously this URL did not resolve to a CodeSystem. As of v0.1.0, Moyae publishes the [MoyaeIsCcCS](CodeSystem-moyae-is-cc-cs.html) CodeSystem at exactly that URL with the single concept `cc` ("with correction"). The URL now resolves and validators can look up the concept.

### Identifier patterns lack a system (accepted as-is for v0.1.0)
{: #identifier-system }

* `MoyaeIntraocularPressure.identifier` is emitted as `{ value: "intraocular-pressure" }` with no system.
* `MoyaeVisualAcuity.identifier` is emitted as `{ value: "visual_acuity" }` with no system (and note the underscore, while IOP uses a hyphen).
* `MoyaeVisionPrescription.identifier` is emitted as `{ system: "https://moyae.com/vision-prescription-status", value: "active" }`. The system URI suggests state, not identity.

**Decision:** retained as-is for v0.1.0. Identifiers are not load-bearing for partner interoperability today, and rewriting the values would invalidate every existing reference in HealthLake. v1.0 may revisit if there is partner pressure.

### VisionPrescription is dual-purpose
{: #vp-dual-purpose }

Moyae uses `VisionPrescription.status = "draft"` as the in-exam **measurement** carrier and `status = "active"` as the signed **prescription**. The same resource type covers both lifecycle states.

* **Pro:** A single resource preserves the measurement → prescription audit trail. The prescriber signature transitions status from draft to active. Partners querying for "the refraction taken at this encounter" don't need to look at two different resource types.
* **Con:** One school of thought holds that VisionPrescription is fundamentally a prescribing (request) resource and that measurements belong on Observations. Tools that expect VisionPrescription to mean "signed Rx" can misinterpret draft instances.

Moyae's pattern stays in v0.1.0. The narrative documents it so partners can plan accordingly. Both patterns are valid; this is a design choice, not a bug.

### Refraction is not a separate Observation type
{: #refraction-not-separate }

There is no distinct "Refraction" resource type in Moyae's code. A refraction is a Visual Acuity Observation with:

* `Observation.code` set to SNOMED `251794006` ("Refraction") instead of the corrected-VA code.
* `Observation.focus` always populated with the companion VisionPrescription (to migrate to an extension — see [focus](#focus) above).
* Method flags (manifest, autorefraction, cycloplegic, overrefraction) on boolean components.

`MoyaeRefraction` exists in this IG to give partners a distinct, queryable profile identity, but it is structurally a slice of the same Observation path.

### Partner customization is permanent infrastructure

The Moyae API includes a translation layer between the canonical shapes documented here and partner-specific profiles. **This layer is permanent** — Moyae does not plan to deprecate it. Partners can request customized endpoints, mappings, and per-partner derivations as part of the partnership program.

This means partners do not need to consume the canonical shapes documented in this IG. The canonical shapes are the **reference point**; the translation layer adapts them to whatever a given partner needs.

### Alignment with industry conventions

Moyae is moving toward the per-Observation profile structure common in modern ophthalmology FHIR work: separate profiles for refraction sub-types, `bodySite`-based laterality, and `valueQuantity` with UCUM. Reaching parity with that structure is the goal of v0.1.x.
