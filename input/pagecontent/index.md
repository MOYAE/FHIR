## Moyae Ophthalmology FHIR Implementation Guide

**Version 0.1.0** — first cut of profiles for the four resources Moyae emits today.

### What v0.1.0 covers

| Profile | Source file in Moyae | Purpose |
|---|---|---|
| [MoyaeIntraocularPressure](StructureDefinition-moyae-intraocular-pressure.html) | `packages/api/services/fhirObservations/iop.ts` | One Observation per eye for IOP measurements. |
| [MoyaeVisualAcuity](StructureDefinition-moyae-visual-acuity.html) | `packages/api/services/fhirObservations/visualAcuityHelpers/formatObservation.ts` | Distance / intermediate / near VA per eye, with pinhole and binocular variants. |
| [MoyaeRefraction](StructureDefinition-moyae-refraction.html) | Same file, `typeOfExam = "refraction"` path | A refraction event. Shares structure with MoyaeVisualAcuity but `code` is SNOMED Refraction; `focus` always references the companion VisionPrescription. |
| [MoyaeVisionPrescription](StructureDefinition-moyae-vision-prescription.html) | `packages/api/services/fhirObservations/visualAcuityHelpers/formatVisionPrescription.ts` | Used twice in the lifecycle: `status="draft"` as the in-exam measurement carrier, `status="active"` as the signed Rx. |

### Important characteristics of the current implementation

These are the items partners and validators most often ask about. Each is documented honestly here, and where Moyae's current emission deviates from "ideal FHIR" or from peer IGs (e.g. the HL7 Eye Care IG), the [Relationships and caveats](relationships.html) page calls out the rationale and the v0.1.x migration plan.

* **One Observation per eye for IOP.** Each IOP exam produces two Observation resources. Eye is identified via a `laterality` extension and (redundantly) via a `component` entry.
* **Visual acuity and refraction share an Observation shape.** They are distinguished by `Observation.code` (corrected vs. uncorrected vs. refraction vs. retina VA) and by component method flags.
* **Refraction values live on VisionPrescription, not Observation.** The Observation references the VisionPrescription via `Observation.focus`. See the caveat below.
* **VisionPrescription is dual-purpose.** `status="draft"` carries measurements during the exam; `status="active"` is the signed Rx.
* **All measurement values are `valueString` today.** This includes IOP pressure and VA notation. v0.1.x migrates to `valueQuantity` with UCUM where the unit is well-defined (mm[Hg] for IOP, LogMAR / decimal for VA).

### Partner customization

Moyae operates a translation layer between the canonical shapes documented here and partner-specific profiles. **Customized endpoints, mappings, and per-partner derivations can be requested via the partnership program** at [moyae.com/build-with-moyae](https://moyae.com/build-with-moyae). The translation layer is permanent infrastructure; we don't expect every partner to consume the canonical shape directly.

### Tooling

Authored in [FHIR Shorthand](https://fshschool.org/) and built with [SUSHI](https://fshschool.org/docs/sushi/) + the [HL7 IG Publisher](https://github.com/HL7/fhir-ig-publisher). Source repo: [github.com/MOYAE/FHIR](https://github.com/MOYAE/FHIR).

### Acknowledgments

Thanks to **David Flade** and **Tero Lipponen** for reviewing early drafts of this Implementation Guide. Their review is ongoing, and not all of their suggestions are reflected in the current version — revisions are being incorporated across upcoming releases.

### Contact

Implementation feedback, partner inquiries: [partnerships@moyae.com](mailto:partnerships@moyae.com) or book at [calendar.app.google/joEV8YqqYastTaNf6](https://calendar.app.google/joEV8YqqYastTaNf6).
