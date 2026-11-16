## Relationships and caveats

This page documents the deliberate and inherited characteristics of Moyae's current FHIR emissions that differ from idiomatic FHIR R4 or from peer IGs.

### Why `Observation.focus` references VisionPrescription
{: #focus }

When `typeOfExam` is `corrected` or `refraction`, MoyaeVisualAcuity and MoyaeRefraction Observations populate `Observation.focus` with a reference to the companion VisionPrescription.

**This is non-standard, and we know it.** FHIR R4 defines `Observation.focus` as: *"The actual focus of an observation when it is not the patient of record representing something or someone associated with the patient such as a spouse, parent, fetus, or donor."* The canonical examples are a fetus during pregnancy or a relative being characterized. Using it for a measurement-to-prescription relationship is **not the pattern FHIR intends**, and validators that enforce the description strictly may flag it.

**Why Moyae uses it today.** The Observation is *about* the patient's eyes, and the refractive numbers (sphere / cylinder / axis / add / prism) live on the companion VisionPrescription. `focus` carries the reference so queries that fetch the VA can co-resolve the refractive measurement in one round trip. This was a pragmatic choice early in Moyae's FHIR adoption and has stayed in production.

**What shipped instead (September 2026).** 0.1.0 planned a forward extension on the Observation. On reflection the link belongs on the other side: no R4 Observation field (`derivedFrom`, `basedOn`, `partOf`) may legally reference a VisionPrescription, while a VisionPrescription naming the exam it came from is plain provenance. The API now writes the [source-observation extension](StructureDefinition-vision-prescription-source-observation.html) (`https://moyae.com/fhir/StructureDefinition/vision-prescription-source-observation`, a `Reference(Observation)`) on every draft and every signed VisionPrescription. The value is server-owned so a client round-tripping the resource cannot detach it. The peer device-vendor profile for refraction forbids `focus` outright (0..0), which this migration also satisfies once `focus` stops being written.

Migration state:

1. **Done:** dual-write. Every VisionPrescription carries the reverse link; Observations still carry `focus`.
2. **In progress:** readers move to the VisionPrescription side. New code reads the extension; older readers still follow `focus`.
3. **Next:** stop emitting `focus` once no reader depends on it. Legacy Observations keep their `focus` until a backfill removes it; the reverse link already exists on their prescriptions.

**Note on R5.** The Observation resource in FHIR R5 keeps `focus` with the same definition, but the broader R5 design pattern leans on extensions for relationships that don't fit the canonical FHIR R4 reference slots. Moving to an extension aligns Moyae with where the standard is heading.

**Comparison to peer IGs.** Some peer IGs (e.g. the HL7 Eye Care IG) treat refractive measurements as their own Observation profiles, separate from any prescription resource. Moyae's pattern of using VisionPrescription as the measurement carrier is a Moyae-specific design choice that preserves the measurement → signed-prescription audit trail on a single resource. The trade-off is the unusual `focus` reference (to be replaced) and the dual-status overload on VisionPrescription.

### Two SNOMED system URIs — partly fixed
{: #snomed-uris }

Early IOP emissions used `system = "https://www.snomed.org/"` on the instrument and eye components. That URL is the SNOMED International website, **not** the canonical FHIR SNOMED system URI (`http://snomed.info/sct`), and FHIR validators correctly reject codings under it.

State as of October 2026:

- Reads match the eye component by SNOMED code only, so legacy data with the old URI continues to read correctly without a backfill.
- The top-level `code`, the pressure component and the correction component are written with `http://snomed.info/sct`.
- The default instrument component and the eye component in the IOP builder still carry the legacy URI on write. This is queued; until it lands, validators will flag those two components. The `bodySite` written on the same resource uses the canonical URI and is the field new readers should use for laterality.

No profile or example in this guide uses the legacy URI.

### Laterality: bodySite on every Observation
{: #body-site }

Since July 2026 the central Observation write path appends `bodySite` to any Observation whose `code` or `component` entries imply a side, using the active SNOMED eye-structure concepts `1290032005` (right), `1290031003` (left) and `40638003` (both). Eye-structure codes such as cornea or lens map back to the whole-eye concept. An existing `bodySite` is never overwritten. The inactive concepts `18944008` and `8966001` found in older resources are normalized to the active ones on read and were migrated in place.

0.1.0 of this guide listed `1290030002` in the body-site value set as "Right eye". That concept is *Disorder of left eye proper*. The value set and the IOP example now carry the codes the API writes.

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

Since September 2026 signing **creates a new active resource** and leaves the draft untouched, so the measurement and the issued Rx have distinct ids, each with its own signature record and each pointing back at the exam Observation. Before that, signing flipped the draft's status in place, which lost the measurement as it was taken.

* **Pro:** The measurement → prescription audit trail is preserved on two resources of the same type linked to one exam. Partners querying for "the refraction taken at this encounter" look at one resource type.
* **Con:** One school of thought holds that VisionPrescription is fundamentally a prescribing (request) resource and that measurements belong on Observations. Tools that expect VisionPrescription to mean "signed Rx" must filter on `status`.

Moyae's pattern stays. The narrative documents it so partners can plan accordingly. Both patterns are valid; this is a design choice, not a bug.

### Lens material and balance lens
{: #lens-extensions }

Two things the prescription editor records have no home in base R4 `lensSpecification`: the lens material, and a balance lens (an eye prescribed no correction, conventionally written "BAL" where the sphere goes, which cannot be a decimal). Both are carried as Moyae extensions on `lensSpecification` ([LensMaterial](StructureDefinition-lens-material.html), [BalanceLens](StructureDefinition-balance-lens.html)) and mirrored as a human-readable `note` so a base-R4 consumer that ignores extensions still sees them on a printed or rendered Rx.

### Refraction is not a separate Observation type
{: #refraction-not-separate }

There is no distinct "Refraction" resource type in Moyae's code. A refraction is a Visual Acuity Observation with:

* `Observation.code` set to SNOMED `251794006` ("Refraction") instead of the corrected-VA code, followed by `397277005` (subjective refraction) for a manifest refraction or `397276001` (objective refraction) for an autorefraction or retinoscopy. The second coding is the same discriminator the device-vendor refraction profiles use, so a consumer built for those can tell the two apart without reading Moyae's boolean flags.
* `Observation.focus` always populated with the companion VisionPrescription (transitional; see [focus](#focus) above).
* Method flags (manifest, autorefraction, retinoscopy, cycloplegic, overrefraction) on boolean components.
* `derivedFrom` pointing at the original Observation when the exam was imported from a prior visit.

`MoyaeRefraction` exists in this IG to give partners a distinct, queryable profile identity, but it is structurally a slice of the same Observation path.

### Provenance stamps
{: #provenance }

VA, refraction and VisionPrescription writes carry two string extensions, application-name and application-version, so a consumer can tell which system produced a resource without a translation step. The URLs are the ones a device-vendor eyecare profile defines for the same purpose, used as-is rather than redefined. The version is stamped only when the deployment provides one, so a resource never asserts a version that is not real.

### Partner customization

The partner FHIR API serves resources in the canonical shapes documented here. Per-partner mappings, derived endpoints and profile translations are offered through the partnership program as they are needed; they are built on top of the canonical shapes, which remain the reference point.

### Alignment with industry conventions

Moyae is converging on the per-Observation profile structure used in current ophthalmology FHIR work: one Observation per eye and measurement, `bodySite`-based laterality with active SNOMED eye-structure concepts, `valueQuantity` with pinned UCUM units, method on `method`, and refraction components in diopters and degrees. Laterality and the refraction discriminators are in production; typed values and method are the remaining gap. Moyae participates in the CCOI Interoperability and Standards working group and intends to adopt whatever unit and code bindings that group settles on for the HL7 Eye Care IG refresh.
