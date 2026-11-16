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

* code.coding[refraction].system  = $SCT
* code.coding[refraction].code    = #251794006
* code.coding[refraction].display = "Refraction"
* code.coding[subjective].system  = $SCT
* code.coding[subjective].code    = #397277005
* code.coding[subjective].display = "Subjective refraction"

* subject.reference   = "Patient/example-patient"
* encounter.reference = "Encounter/example-encounter"
* effectiveDateTime   = "2026-05-31T14:30:00-05:00"

* focus[+].reference  = "VisionPrescription/Example-MoyaeVisionPrescription-Draft"

// with-correction flag (false during a manifest refraction)
* component[+].code.coding[+].system  = $MOYAE-CC-CS
* component[=].code.coding[=].code    = #cc
* component[=].valueBoolean = false

// subjective / manifest refraction method flag
* component[+].code.coding[+].system  = $SCT
* component[=].code.coding[=].code    = #397277005
* component[=].code.coding[=].display = "Subjective / Manifest refraction (procedure)"
* component[=].valueBoolean = true
