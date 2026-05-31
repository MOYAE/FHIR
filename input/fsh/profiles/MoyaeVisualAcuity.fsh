// Source of truth: packages/api/services/fhirObservations/visualAcuityHelpers/formatObservation.ts
// Status: documents CURRENT shape (v0.1.0). Two important Moyae-specific characteristics:
//   1. `focus` references the companion VisionPrescription (set when typeOfExam = corrected | refraction).
//   2. Method flags (manifest, cycloplegic, autorefraction, BCVA, overrefraction, with-correction) are
//      carried as Observation.component entries with valueBoolean. The "with correction" flag uses a
//      Moyae-defined URI (https://moyae.com/is-cc) rather than a SNOMED code.

Profile:        MoyaeVisualAcuity
Parent:         Observation
Id:             moyae-visual-acuity
Title:          "Moyae Visual Acuity Observation (current shape)"
Description:    """
A Visual Acuity Observation as currently emitted by Moyae. Captures distance / intermediate / near visual acuity for the right eye, left eye, and binocular contexts, optionally with pinhole, plus a vertex distance per eye. The exam type is encoded on `Observation.code` (corrected vs. uncorrected vs. retina VA); when the exam is corrected or a refraction, `Observation.focus` references the companion VisionPrescription that carries sphere / cylinder / axis / add / prism (see [Relationships](relationships.html)).

This is the canonical "VA Observation" path. The separate [MoyaeRefraction](StructureDefinition-moyae-refraction.html) profile documents the variant where `Observation.code` is the SNOMED Refraction concept.
"""

* ^status = #draft

// Moyae uses an UNDERSCORE here (visual_acuity) while IOP uses a HYPHEN (intraocular-pressure).
// Documented exactly as emitted; an inconsistency we'll normalize in v0.1.x.
* identifier 1..*
* identifier.value = "visual_acuity" (exactly)

* status = #final (exactly)

* category 1..*
* category.coding.system = $OBS-CATEGORY (exactly)
* category.coding.code   = #exam (exactly)

* code.coding.system = $SCT (exactly)
* code.coding.code from MoyaeVisualAcuityCodeVS (required)

* subject 1..1
* subject only Reference(Patient)
* encounter 1..1
* encounter only Reference(Encounter)
* performer 0..*

* effectiveDateTime 0..1

// MOYAE-SPECIFIC: focus references the companion VisionPrescription. Populated for
// typeOfExam in ("corrected", "refraction"). See packages/api/services/fhir.ts
// (createVisualAcuityObservationWithPrescriptions). FHIR R4 .focus is unusual here —
// see Caveats in narrative.
* focus 0..*
* focus only Reference(VisionPrescription)

* component 0..*
* component ^short = "Mixed: method-flag boolean components, per-eye distance/intermediate/near valueString measurements (incl. pinhole and binocular variants), and per-eye vertex distance."

// Note: component slicing is intentionally NOT enumerated here because Moyae emits
// a wide and conditionally-present set. The narrative documents each code; v0.1.x
// will add explicit slices once we lock the catalog.
