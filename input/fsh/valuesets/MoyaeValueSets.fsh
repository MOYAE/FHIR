// Value sets referenced by Moyae IG profiles. All SNOMED unless noted.

ValueSet:   MoyaeLateralityVS
Id:         moyae-laterality-vs
Title:      "Moyae Laterality Codes"
Description: "SNOMED codes used by Moyae on the laterality extension. `419465000` = Unilateral right, `419161000` = Unilateral left."
* ^status = #draft
* $SCT#419465000 "Unilateral right"
* $SCT#419161000 "Unilateral left"

ValueSet:   MoyaeEyeCodeVS
Id:         moyae-eye-code-vs
Title:      "Moyae Eye Codes (component scope)"
Description: "SNOMED eye codes found on legacy Observation.component entries that carried laterality alongside the extension. `18944008` and `8966001` are inactive in current SNOMED releases; the API now writes the active structure concepts (`1290032005`, `1290031003`) and normalizes these on read."
* ^status = #draft
* $SCT#8966001  "Left Eye"
* $SCT#18944008 "Right Eye"
* $SCT#1290032005 "Structure of right eye proper"
* $SCT#1290031003 "Structure of left eye proper"

// Laterality on Observation.bodySite. These are the active SNOMED eye-structure concepts
// the API writes (packages/api/constants.ts rightEyeCode / leftEyeCode / bothEyesCode) and
// the same three the ZEISS Eyecare Concepts body-site value set accepts.
// 0.1.0 listed 1290030002 here by mistake; that concept is "Disorder of left eye proper".
ValueSet:   MoyaeBodySiteEyeVS
Id:         moyae-body-site-eye-vs
Title:      "Moyae Eye Laterality (bodySite)"
Description: "SNOMED eye-structure codes used on `Observation.bodySite` to carry laterality. `1290032005` = Structure of right eye proper, `1290031003` = Structure of left eye proper, `40638003` = Both eyes (binocular measurements)."
* ^status = #draft
* $SCT#1290032005 "Structure of right eye proper"
* $SCT#1290031003 "Structure of left eye proper"
* $SCT#40638003   "Both eyes"

ValueSet:   MoyaeVisualAcuityCodeVS
Id:         moyae-visual-acuity-code-vs
Title:      "Moyae Visual Acuity / Refraction Top-Level Observation Codes"
Description: "Codes used on `Observation.code` for the four typeOfExam values Moyae emits. Refraction (251794006) is profiled separately by MoyaeRefraction but lives on the same Observation path."
* ^status = #draft
* $SCT#397536007 "Corrected visual acuity (observable entity)"
* $SCT#420050001 "Uncorrected visual acuity"
* $SCT#251794006 "Refraction"
* $SCT#363983007 "Retina VA"

ValueSet:   MoyaeRefractionMethodVS
Id:         moyae-refraction-method-vs
Title:      "Moyae Refraction Method Boolean Flags"
Description: "SNOMED codes used as `Observation.component.code` for refraction method boolean flags (valueBoolean true means the technique was used). `with correction` is NOT in this value set because Moyae emits it under a non-SNOMED Moyae-defined URI (https://moyae.com/is-cc) which is flagged in the narrative."
* ^status = #draft
* $SCT#397277005 "Subjective / Manifest refraction (procedure)"
* $SCT#397250001 "Autorefractor"
* $SCT#397278000 "Cycloplegic refraction (procedure)"
* $SCT#419759001 "Overrefraction (procedure)"
* $SCT#419775003 "Best Corrected Visual Acuity"

ValueSet:   VisionPrescriptionStatus
Id:         vision-prescription-status-vs
Title:      "Vision Prescription Status (Moyae use)"
Description: "Subset of the FHIR VisionPrescription status code system Moyae emits today. `draft` is overloaded as the in-exam measurement carrier; `active` is the signed prescription."
* ^status = #draft
* http://hl7.org/fhir/fm-status#draft   "Draft (used for in-exam measurement)"
* http://hl7.org/fhir/fm-status#active  "Active (signed prescription)"
* http://hl7.org/fhir/fm-status#cancelled "Cancelled"
* http://hl7.org/fhir/fm-status#entered-in-error "Entered in error"

ValueSet:   VisionPrescriptionProductVS
Id:         vision-prescription-product-vs
Title:      "Vision Prescription Product (Moyae use)"
Description: "Subset of FHIR ex-visionprescriptionproduct CodeSystem used by Moyae."
* ^status = #draft
* $VP-PRODUCT#lens     "Glasses lens"
* $VP-PRODUCT#contact  "Contact lens"

ValueSet:   VisionEyes
Id:         vision-eyes-vs
Title:      "Eye (Vision)"
Description: "FHIR VisionPrescription lensSpecification.eye value set."
* ^status = #draft
* http://hl7.org/fhir/vision-eye-codes#right "Right Eye"
* http://hl7.org/fhir/vision-eye-codes#left  "Left Eye"

ValueSet:   VisionBase
Id:         vision-base-vs
Title:      "Vision Prism Base"
Description: "FHIR VisionPrescription prism.base value set."
* ^status = #draft
* http://hl7.org/fhir/vision-base-codes#up   "Up"
* http://hl7.org/fhir/vision-base-codes#down "Down"
* http://hl7.org/fhir/vision-base-codes#in   "In"
* http://hl7.org/fhir/vision-base-codes#out  "Out"
