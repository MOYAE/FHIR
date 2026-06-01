// Example: IOP right eye, 14 mmHg, Goldmann applanation tonometer.
// Mirrors the v0.1.x target shape emitted by packages/api/services/fhirObservations/iop.ts
// (right-eye half of the per-eye pair): laterality on bodySite, pressure as valueQuantity mm[Hg].

Instance:    Example-MoyaeIOP-RightEye
InstanceOf:  MoyaeIntraocularPressure
Usage:       #example
Title:       "Example: Moyae IOP, right eye"
Description: "Right eye, 14 mmHg, Goldmann applanation tonometer, in the v0.1.x target shape (laterality on bodySite, value as valueQuantity)."

* identifier.value = "intraocular-pressure"
* status = #final
* category.coding[exam].system  = $OBS-CATEGORY
* category.coding[exam].code    = #exam
* category.coding[exam].display = "Exam"
* code.coding[+].system  = $SCT
* code.coding[=].code    = #41633001
* code.coding[=].display = "Intraocular pressure (observable entity)"
* subject.reference   = "Patient/example"
* encounter.reference = "Encounter/example"
* effectiveDateTime   = "2026-05-31T14:30:00-05:00"

* bodySite.coding[+].system  = $SCT
* bodySite.coding[=].code    = #1290030002
* bodySite.coding[=].display = "Right eye"

* valueQuantity.value  = 14
* valueQuantity.system = $UCUM
* valueQuantity.code   = #mm[Hg]
* valueQuantity.unit   = "mmHg"

* component[+].code.coding[+].system  = $SCT
* component[=].code.coding[=].code    = #391939000
* component[=].code.coding[=].display = "Goldmann applanation tonometer"
* component[=].valueString = "Goldmann applanation tonometer"
