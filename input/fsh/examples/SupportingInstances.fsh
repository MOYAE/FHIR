// Minimal supporting example instances that the Observation and VisionPrescription
// examples reference (subject / encounter / prescriber targets). Without these, the
// IG Publisher reports the references as unresolved.

Instance:    example-patient
InstanceOf:  Patient
Usage:       #example
Title:       "Example: Patient"
Description: "Minimal example patient referenced by the Moyae example resources."
* name.family = "Example"
* name.given  = "Pat"
* gender      = #unknown

Instance:    example-encounter
InstanceOf:  Encounter
Usage:       #example
Title:       "Example: Encounter"
Description: "Minimal example ambulatory encounter referenced by the Moyae example resources."
* status        = #finished
* class.system  = "http://terminology.hl7.org/CodeSystem/v3-ActCode"
* class.code    = #AMB
* class.display = "ambulatory"
* subject.reference = "Patient/example-patient"

Instance:    example-doctor
InstanceOf:  Practitioner
Usage:       #example
Title:       "Example: Practitioner"
Description: "Minimal example practitioner referenced as the prescriber on VisionPrescription examples."
* name.family = "Example"
* name.prefix = "Dr."
