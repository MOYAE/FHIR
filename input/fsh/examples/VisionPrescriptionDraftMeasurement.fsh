// Example: draft VisionPrescription used as the measurement carrier during the refraction.
// Referenced by MoyaeVisualAcuity.focus and MoyaeRefraction.focus.

Instance:    Example-MoyaeVisionPrescription-Draft
InstanceOf:  MoyaeVisionPrescription
Usage:       #example
Title:       "Example: Moyae VisionPrescription, status=draft (in-exam measurement)"
Description: "A draft VisionPrescription carrying the in-progress refractive measurement. Two lensSpecification entries (right and left). Prism array always serialized with placeholders when no clinical prism is present."

* identifier.system = $MOYAE-VP-IDENT-SYS
* identifier.value  = "active"
* status            = #draft
* created           = "2026-05-31T14:30:00-05:00"
* dateWritten       = "2026-05-31T14:30:00-05:00"
* patient.reference   = "Patient/example"
* encounter.reference = "Encounter/example"
* prescriber.reference = "Practitioner/example-doctor"
* prescriber.display   = "Dr. Example"

// Right eye
* lensSpecification[+].eye      = #right
* lensSpecification[=].product.coding.system = $VP-PRODUCT
* lensSpecification[=].product.coding.code   = #lens
* lensSpecification[=].product.coding.display = "glasses"
* lensSpecification[=].sphere   = -2.25
* lensSpecification[=].cylinder = -0.50
* lensSpecification[=].axis     = 90
* lensSpecification[=].add      = 1.50
* lensSpecification[=].prism[+].amount = 0
* lensSpecification[=].prism[=].base = #up
* lensSpecification[=].prism[+].amount = 0
* lensSpecification[=].prism[=].base = #in

// Left eye
* lensSpecification[+].eye      = #left
* lensSpecification[=].product.coding.system = $VP-PRODUCT
* lensSpecification[=].product.coding.code   = #lens
* lensSpecification[=].product.coding.display = "glasses"
* lensSpecification[=].sphere   = -2.50
* lensSpecification[=].cylinder = -0.75
* lensSpecification[=].axis     = 85
* lensSpecification[=].add      = 1.50
* lensSpecification[=].prism[+].amount = 0
* lensSpecification[=].prism[=].base = #up
* lensSpecification[=].prism[+].amount = 0
* lensSpecification[=].prism[=].base = #in
