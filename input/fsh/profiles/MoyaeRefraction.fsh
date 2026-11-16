// Source of truth: packages/api/services/fhirObservations/visualAcuityHelpers/formatObservation.ts
// (typeOfExam = "refraction" path). Documents CURRENT shape (v0.1.0).
//
// IMPORTANT: Moyae does NOT emit a distinct "Refraction" resource type. A refraction is the same
// Observation shape as MoyaeVisualAcuity, but with Observation.code = SNOMED 251794006 (Refraction)
// rather than a visual-acuity SNOMED. The actual refractive numbers (sphere / cylinder / axis / add /
// prism / etc.) live on the companion VisionPrescription referenced via Observation.focus.
//
// This profile exists to give partners a distinct, queryable identity for refraction events while
// being honest about the shared backing implementation.

Profile:        MoyaeRefraction
Parent:         Observation
Id:             moyae-refraction
Title:          "Moyae Refraction Observation (current shape)"
Description:    """
A Refraction Observation as currently emitted by Moyae. Structurally identical to [MoyaeVisualAcuity](StructureDefinition-moyae-visual-acuity.html) — same Observation resource, same component shape — with two distinguishing characteristics:

1. `Observation.code` is the SNOMED **Refraction** concept (`251794006`), not a visual-acuity code. A manifest refraction also carries the SNOMED **Subjective refraction** coding (`397277005`); an autorefraction or retinoscopy carries **Objective refraction** (`397276001`). These are appended after the Refraction coding and match the discriminators used by device-vendor refraction profiles.
2. The refractive measurement values (sphere / cylinder / axis / add / prism) are carried on the companion VisionPrescription referenced by `Observation.focus`, with `VisionPrescription.status = "draft"`. The VisionPrescription points back through the source-observation extension.

Refraction method (subjective / autorefraction / retinoscopy / cycloplegic / overrefraction) is also captured as boolean component flags using SNOMED procedure codes. See [Caveats](relationships.html#focus) for why `.focus` rather than `.derivedFrom` is used today.
"""

* ^status = #draft

* identifier 1..*
* identifier.value = "visual_acuity" (exactly)

* status = #final (exactly)

* category 1..*
* category.coding.system = $OBS-CATEGORY (exactly)
* category.coding.code   = #exam (exactly)

// coding[0] is always Refraction; a subjective (397277005) or objective (397276001)
// refraction coding follows it. Readers key off index 0.
* code.coding 1..*
* code.coding ^slicing.discriminator.type = #pattern
* code.coding ^slicing.discriminator.path = "$this"
* code.coding ^slicing.rules = #open
* code.coding contains
    refraction 1..1 and
    subjective 0..1 and
    objective 0..1
* code.coding[refraction] = $SCT#251794006
* code.coding[subjective] = $SCT#397277005
* code.coding[objective]  = $SCT#397276001

* subject 1..1
* subject only Reference(Patient)
* encounter 1..1
* encounter only Reference(Encounter)
* performer 0..*

// Always populated for refraction Observations.
* focus 1..*
* focus only Reference(VisionPrescription)

* component 0..*
* component ^short = "Method flags (subjective, autorefraction, cycloplegic, overrefraction, with-correction) plus per-eye distance/intermediate/near valueString measurements when also captured during the refraction visit."
