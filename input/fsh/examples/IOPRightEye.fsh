// Example: IOP right eye, 14 mmHg, Goldmann applanation tonometer.
// Mirrors exactly what packages/api/services/fhirObservations/iop.ts emits (right eye half of the pair).

Instance:    Example-MoyaeIOP-RightEye
InstanceOf:  MoyaeIntraocularPressure
Usage:       #example
Title:       "Example: Moyae IOP, right eye"
Description: "Right eye, 14 mmHg, Goldmann applanation tonometer, with the per-pair pattern Moyae emits today (laterality on extension + redundantly on a component)."

* identifier.value = "intraocular-pressure"
* status = #final
* category[+].coding[+].system = $OBS-CATEGORY
* category[=].coding[=].code   = #exam
* category[=].coding[=].display = "Exam"
* code.coding[+].system = $SCT
* code.coding[=].code   = #41633001
* subject.reference   = "Patient/example"
* encounter.reference = "Encounter/example"
* effectiveDateTime   = "2026-05-31T14:30:00-05:00"

* extension[$LATERALITY-EXT].valueCodeableConcept.coding[+].system  = $SCT
* extension[$LATERALITY-EXT].valueCodeableConcept.coding[=].code    = #419465000
* extension[$LATERALITY-EXT].valueCodeableConcept.coding[=].display = "Unilateral right"

* component[+].code.coding[+].system  = $SCT
* component[=].code.coding[=].code    = #41633001
* component[=].code.coding[=].display = "Intraocular pressure (observable entity)"
* component[=].valueString = "14"

* component[+].code.coding[+].system  = $SCT
* component[=].code.coding[=].code    = #391939000
* component[=].code.coding[=].display = "Goldmann applanation tonometer"
* component[=].valueString = "Goldmann applanation tonometer"

* component[+].code.coding[+].system  = $SCT
* component[=].code.coding[=].code    = #18944008
* component[=].code.coding[=].display = "Right Eye"
* component[=].valueString = "Right Eye"
