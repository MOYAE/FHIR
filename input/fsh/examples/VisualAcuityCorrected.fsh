// Example: corrected (cc) visual acuity, OD distance 20/20, OS distance 20/25.
// Mirrors packages/api/services/fhirObservations/visualAcuityHelpers/formatObservation.ts.
// .focus is populated downstream by createVisualAcuityObservationWithPrescriptions when the
// companion draft VisionPrescription is created.

Instance:    Example-MoyaeVisualAcuity-Corrected
InstanceOf:  MoyaeVisualAcuity
Usage:       #example
Title:       "Example: Moyae VA, corrected, both eyes (distance)"
Description: "Distance visual acuity corrected (cc), OD 20/20, OS 20/25, vertex 14, referencing the companion draft VisionPrescription via Observation.focus."

* identifier.value = "visual_acuity"
* status = #final
* category[+].coding[+].system  = $OBS-CATEGORY
* category[=].coding[=].code    = #exam
* category[=].coding[=].display = "Exam"

* code.coding[+].system  = $SCT
* code.coding[=].code    = #397536007
* code.coding[=].display = "Corrected visual acuity (observable entity)"

* subject.reference     = "Patient/example"
* encounter.reference   = "Encounter/example"
* effectiveDateTime     = "2026-05-31T14:30:00-05:00"

* focus[+].reference    = "VisionPrescription/example-draft"

// `with correction` boolean flag — Moyae-defined URI, NOT a SNOMED code.
* component[+].code.coding[+].system  = $MOYAE-CC-CS
* component[=].code.coding[=].code    = #cc
* component[=].code.coding[=].display = "with correction"
* component[=].valueBoolean = true

// Right eye distance VA
* component[+].code.coding[+].system  = $SCT
* component[=].code.coding[=].code    = #386714003
* component[=].code.coding[=].display = "Distance visual acuity - right eye (observable entity)"
* component[=].valueString = "20/20"

// Left eye distance VA
* component[+].code.coding[+].system  = $SCT
* component[=].code.coding[=].code    = #386716001
* component[=].code.coding[=].display = "Distance visual acuity - left eye (observable entity)"
* component[=].valueString = "20/25"

// Per-eye vertex distance (always emitted by Moyae today).
* component[+].code.coding[+].system  = $SCT
* component[=].code.coding[=].code    = #415813002
* component[=].code.coding[=].display = "Vertex distance (observable entity)"
* component[=].code.coding[+].system  = $SCT
* component[=].code.coding[=].code    = #386709002
* component[=].code.coding[=].display = "Visual acuity - right eye (observable entity)"
* component[=].valueString = "14"

* component[+].code.coding[+].system  = $SCT
* component[=].code.coding[=].code    = #415813002
* component[=].code.coding[=].display = "Vertex distance (observable entity)"
* component[=].code.coding[+].system  = $SCT
* component[=].code.coding[=].code    = #386708005
* component[=].code.coding[=].display = "Visual acuity - left eye (observable entity)"
* component[=].valueString = "14"
