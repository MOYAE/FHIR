// Source of truth: packages/api/services/fhirObservations/iopBuilder.ts (splitEyes -> formatObservation)
// Status: TARGET shape. Laterality on Observation.bodySite (shipped July 2026: the write path
// appends bodySite with the active SNOMED eye-structure concepts) and the pressure as a
// valueQuantity in UCUM mm[Hg] (NOT shipped: production still writes the pressure as a
// valueString component and the tonometer as a component rather than method).
//
// The legacy laterality extension (http://hl7.org/fhir/uv/ophthalmology/StructureDefinition/laterality)
// and the eyeCode component are still written alongside bodySite for older readers. The
// [Relationships](relationships.html) page documents the legacy shape and the migration state.

Profile:        MoyaeIntraocularPressure
Parent:         Observation
Id:             moyae-intraocular-pressure
Title:          "Moyae Intraocular Pressure Observation (target shape)"
Description:    """
An Intraocular Pressure (IOP) Observation emitted by the Moyae API.

**One Observation is created per eye** — a single IOP exam in Moyae produces two Observation resources, one for the right eye and one for the left, each with its own `id`. Laterality is carried on `Observation.bodySite` using the active SNOMED eye-structure concepts; the pressure value is a `valueQuantity` in UCUM `mm[Hg]`; the tonometer is on `method`.

**Migration state (October 2026).** The `bodySite` half of this profile is in production. The `valueQuantity` and `method` halves are not: the writer still emits the pressure as a `valueString` component (SNOMED `41633001`) and the instrument as a component, and also writes the legacy laterality extension and eye component for older readers. Resources read from the store today therefore carry both the new `bodySite` and the legacy fields. See the [Relationships](relationships.html) page.
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

* code.coding 1..*
* code.coding.system = $SCT (exactly)
* code.coding.code   = #41633001 (exactly)

* subject 1..1
* subject only Reference(Patient)
* encounter 1..1
* encounter only Reference(Encounter)
* effectiveDateTime 1..1
* performer 0..*

// Laterality: one Observation per eye, carried on bodySite (replaces the legacy laterality
// extension + redundant eyeCode component). NOTE: the exact SNOMED bodySite code set is still
// pending final confirmation (roadmap "items to confirm").
* bodySite 1..1
* bodySite.coding.system = $SCT (exactly)
* bodySite.coding.code from MoyaeBodySiteEyeVS (required)

// The pressure reading itself, in mm[Hg] (replaces the legacy component[pressure].valueString).
* value[x] only Quantity
* valueQuantity 1..1
* valueQuantity.system = $UCUM (exactly)
* valueQuantity.code   = #mm[Hg] (exactly)

// The measurement device / technique (e.g. Goldmann applanation tonometer) on method,
// replacing the legacy free-text instrument component.
* method 0..1
* method.coding.system = $SCT (exactly)

// Optional supporting detail. The redundant eyeCode component is intentionally gone
// (laterality now lives on bodySite); only the correction flag remains as a component.
* component 0..*
* component ^slicing.discriminator.type = #pattern
* component ^slicing.discriminator.path = "code"
* component ^slicing.rules = #open
* component contains correction 0..1

* component[correction].code.coding.system  = $SCT (exactly)
* component[correction].code.coding.code    = #410616005 (exactly)
* component[correction].value[x] only string
