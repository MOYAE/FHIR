// Example: manifest refraction (typeOfExam = "refraction" in code, isManifest = true).
// Same Observation path as Visual Acuity; differs by Observation.code and by always populating .focus.

Instance:    Example-MoyaeRefraction-Manifest
InstanceOf:  MoyaeRefraction
Usage:       #example
Title:       "Example: Moyae manifest (subjective) refraction"
Description: "A subjective / manifest refraction Observation referencing the draft VisionPrescription that carries sphere, cylinder, axis, add, and prism."

* identifier.value = "visual_acuity"
* status = #final
* category[+].coding[+].system  = $OBS-CATEGORY
* category[=].coding[=].code    = #exam
* category[=].coding[=].display = "Exam"

* code.coding[+].system  = $SCT
* code.coding[=].code    = #251794006
* code.coding[=].display = "Refraction"

* subject.reference   = "Patient/example"
* encounter.reference = "Encounter/example"
* effectiveDateTime   = "2026-05-31T14:30:00-05:00"

* focus[+].reference  = "VisionPrescription/example-draft"

// with-correction flag (false during a manifest refraction)
* component[+].code.coding[+].system  = $MOYAE-CC-CS
* component[=].code.coding[=].code    = #cc
* component[=].valueBoolean = false

// subjective / manifest refraction method flag
* component[+].code.coding[+].system  = $SCT
* component[=].code.coding[=].code    = #397277005
* component[=].code.coding[=].display = "Subjective / Manifest refraction (procedure)"
* component[=].valueBoolean = true
