// Source of truth: packages/api/services/fhirObservations/visualAcuityHelpers/lensMaterial.ts
// Published at the URL the API writes, which is outside the IG canonical (see special-url).

CodeSystem:  MoyaeLensMaterialCS
Id:          moyae-lens-material-cs
Title:       "Moyae Lens Material Code System"
Description: "Glasses lens materials offered in the Moyae prescription editor. Used by the LensMaterial extension on VisionPrescription.lensSpecification."
* ^url           = "https://moyae.com/fhir/CodeSystem/lens-material"
* ^status        = #active
* ^content       = #complete
* ^experimental  = false
* ^caseSensitive = true

* #cr-39            "CR-39 Plastic"
* #polycarbonate    "Polycarbonate"
* #trivex           "Trivex"
* #high-index-1.60  "High-Index 1.60"
* #high-index-1.67  "High-Index 1.67"
* #high-index-1.74  "High-Index 1.74"
* #glass            "Glass"

ValueSet:   MoyaeLensMaterialVS
Id:         moyae-lens-material-vs
Title:      "Moyae Lens Materials"
Description: "All concepts from the Moyae Lens Material code system."
* ^status = #active
* include codes from system MoyaeLensMaterialCS
