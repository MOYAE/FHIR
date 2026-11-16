// Moyae-defined extensions the API emits today. Their canonical URLs live under
// https://moyae.com/fhir/StructureDefinition/ (where the API writes them), not under
// the IG canonical, so each is whitelisted with special-url in sushi-config.yaml.
//
// Source of truth: packages/api/services/fhirObservations/visualAcuityHelpers/
//   sourceObservation.ts, lensMaterial.ts, balanceLens.ts

Extension:      VisionPrescriptionSourceObservation
Id:             vision-prescription-source-observation
Title:          "Vision Prescription Source Observation"
Description:    """
The exam Observation (a [MoyaeVisualAcuity](StructureDefinition-moyae-visual-acuity.html) or [MoyaeRefraction](StructureDefinition-moyae-refraction.html)) that a VisionPrescription was built from.

Every draft and every signed (`active`) VisionPrescription carries this link. It is the durable direction: `Observation.focus` pointing at the VisionPrescription is transitional and will be retired once every reader has moved. The value is server-owned; clients that round-trip whole resources cannot change it.
"""
* ^url = "https://moyae.com/fhir/StructureDefinition/vision-prescription-source-observation"
* ^status = #active
* ^context[+].type = #element
* ^context[=].expression = "VisionPrescription"
* value[x] only Reference(Observation)
* value[x] 1..1

Extension:      LensMaterial
Id:             lens-material
Title:          "Lens Material"
Description:    """
Glasses lens material for one `lensSpecification` entry. Coded from [MoyaeLensMaterialCS](CodeSystem-moyae-lens-material-cs.html) when the material is one of the known set; free text otherwise. A human-readable mirror is also written to `lensSpecification.note` for base-R4 consumers that ignore extensions.
"""
* ^url = "https://moyae.com/fhir/StructureDefinition/lens-material"
* ^status = #active
* ^context[+].type = #element
* ^context[=].expression = "VisionPrescription.lensSpecification"
* value[x] only CodeableConcept
* value[x] 1..1
* valueCodeableConcept from MoyaeLensMaterialVS (extensible)

Extension:      BalanceLens
Id:             balance-lens
Title:          "Balance Lens"
Description:    """
Marks a `lensSpecification` entry as a balance lens: no refractive correction, prescribed for an eye with no useful vision so the pair looks and weighs right. FHIR R4 types `lensSpecification.sphere` as a decimal, so the conventional "BAL" cannot be carried there. When present and true, `sphere` is omitted. A "Balance lens" note is mirrored to `lensSpecification.note`.
"""
* ^url = "https://moyae.com/fhir/StructureDefinition/balance-lens"
* ^status = #active
* ^context[+].type = #element
* ^context[=].expression = "VisionPrescription.lensSpecification"
* value[x] only boolean
* value[x] 1..1

// Subscription channel extensions (draft, January 2027 connectathon). Published at the
// URLs agreed with partners (no /fhir/ segment); see subscriptions.html.

Extension:      SubscriptionFilterByProfile
Id:             filter-by-profile
Title:          "Subscription Filter By Profile"
Description:    """
Names related resources to add to a Subscription notification. The value is a FHIR search string (resource type, `?`, search parameters), for example `Observation?code=http://snomed.info/sct|363983007`. Resources matching it for the patient of the triggering resource are added to the notification Bundle. Repeatable. Draft: see [Subscriptions](subscriptions.html).
"""
* ^url = "https://moyae.com/StructureDefinition/filter-by-profile"
* ^status = #draft
* ^context[+].type = #element
* ^context[=].expression = "Subscription.channel"
* value[x] only string
* value[x] 1..1

Extension:      SubscriptionFilterByResourceType
Id:             filter-by-resource-type
Title:          "Subscription Filter By Resource Type"
Description:    """
Names a resource type to add to a Subscription notification for the patient of the triggering resource, for example `Patient`. Repeatable. Draft: see [Subscriptions](subscriptions.html).
"""
* ^url = "https://moyae.com/StructureDefinition/filter-by-resource-type"
* ^status = #draft
* ^context[+].type = #element
* ^context[=].expression = "Subscription.channel"
* value[x] only string
* value[x] 1..1
