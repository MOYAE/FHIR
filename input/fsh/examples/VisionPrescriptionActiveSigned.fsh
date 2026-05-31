// Example: active VisionPrescription — the signed, finalized prescription.

Instance:    Example-MoyaeVisionPrescription-Active
InstanceOf:  MoyaeVisionPrescription
Usage:       #example
Title:       "Example: Moyae VisionPrescription, status=active (signed Rx)"
Description: "Status promoted from draft to active by the prescribing doctor's signature. Same lensSpecification shape; same patient and encounter."

* identifier.system = $MOYAE-VP-IDENT-SYS
* identifier.value  = "active"
* status            = #active
* created           = "2026-05-31T14:30:00-05:00"
* dateWritten       = "2026-05-31T14:45:00-05:00"
* patient.reference   = "Patient/example"
* encounter.reference = "Encounter/example"
* prescriber.reference = "Practitioner/example-doctor"
* prescriber.display   = "Dr. Example"

* lensSpecification[+].eye      = #right
* lensSpecification[=].product.coding.system = $VP-PRODUCT
* lensSpecification[=].product.coding.code   = #lens
* lensSpecification[=].sphere   = -2.25
* lensSpecification[=].cylinder = -0.50
* lensSpecification[=].axis     = 90
* lensSpecification[=].add      = 1.50
* lensSpecification[=].prism[+].amount = 0
* lensSpecification[=].prism[=].base = #up
* lensSpecification[=].prism[+].amount = 0
* lensSpecification[=].prism[=].base = #in

* lensSpecification[+].eye      = #left
* lensSpecification[=].product.coding.system = $VP-PRODUCT
* lensSpecification[=].product.coding.code   = #lens
* lensSpecification[=].sphere   = -2.50
* lensSpecification[=].cylinder = -0.75
* lensSpecification[=].axis     = 85
* lensSpecification[=].add      = 1.50
* lensSpecification[=].prism[+].amount = 0
* lensSpecification[=].prism[=].base = #up
* lensSpecification[=].prism[+].amount = 0
* lensSpecification[=].prism[=].base = #in
