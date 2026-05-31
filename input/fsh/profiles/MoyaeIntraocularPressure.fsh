// Source of truth: packages/api/services/fhirObservations/iop.ts (storeIOP -> formatObservation)
// Status: documents CURRENT shape (v0.1.0). v0.1.x will normalize laterality to bodySite,
// migrate valueString -> valueQuantity (UCUM mm[Hg]), and canonicalize SNOMED system URI.

Profile:        MoyaeIntraocularPressure
Parent:         Observation
Id:             moyae-intraocular-pressure
Title:          "Moyae Intraocular Pressure Observation (current shape)"
Description:    """
An Intraocular Pressure (IOP) Observation as currently emitted by the Moyae API.

**One Observation is created per eye** — a single IOP exam in Moyae produces two Observation resources, one for the right eye and one for the left, each with its own `id`. Laterality is carried on a custom extension; the eye is also redundantly identified in a `component` entry. The pressure value is encoded as `valueString` rather than `valueQuantity`.

This profile documents reality; the [Relationships](relationships.html) page describes the v0.1.x migration plan to `bodySite` and `valueQuantity`.
"""

* ^status = #draft

* identifier 1..*
* identifier.value = "intraocular-pressure" (exactly)

* status = #final (exactly)

* category 1..*
* category.coding ^slicing.discriminator.type = #pattern
* category.coding ^slicing.discriminator.path = "code"
* category.coding ^slicing.rules = #open
* category.coding contains exam 1..1
* category.coding[exam].system = $OBS-CATEGORY (exactly)
* category.coding[exam].code   = #exam (exactly)

* extension contains $LATERALITY-EXT named laterality 0..1
* extension[laterality].valueCodeableConcept.coding.system = $SCT (exactly)
* extension[laterality].valueCodeableConcept.coding.code from MoyaeLateralityVS (required)

* code.coding 1..*
* code.coding.system = $SCT (exactly)
* code.coding.code   = #41633001 (exactly)

* subject 1..1
* subject only Reference(Patient)
* encounter 1..1
* encounter only Reference(Encounter)
* effectiveDateTime 1..1
* performer 0..*

* component 1..*

// component[0] : the pressure reading itself
* component ^slicing.discriminator.type = #pattern
* component ^slicing.discriminator.path = "code"
* component ^slicing.rules = #open
* component contains
    pressure       1..1 and
    instrument     0..1 and
    eyeCode        0..1 and
    correction     0..1

* component[pressure].code.coding.system  = $SCT (exactly)
* component[pressure].code.coding.code    = #41633001 (exactly)
* component[pressure].value[x] only string
* component[pressure].valueString 1..1

// PROBLEM: instrument & eye components in current code use the LEGACY SNOMED URI
// (https://www.snomed.org/) which is not the canonical FHIR SNOMED system URI.
// The profile documents this as it is. v0.1.x will canonicalize to $SCT.
* component[instrument].code.coding.system  = $SCT-LEGACY
* component[instrument].value[x] only string

* component[eyeCode].code.coding.system     = $SCT-LEGACY
* component[eyeCode].code.coding.code from MoyaeEyeCodeVS (required)
* component[eyeCode].value[x] only string

* component[correction].code.coding.system  = $SCT (exactly)
* component[correction].code.coding.code    = #410616005 (exactly)
* component[correction].value[x] only string
