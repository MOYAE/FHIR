// Source of truth: packages/api/services/fhirObservations/visualAcuityHelpers/formatObservation.ts
// Moyae-defined CodeSystem for the "with correction" boolean flag on Visual Acuity Observations.
// SNOMED CT does not have an exact match for this (419775003 is BCVA, which is related but specific
// to best-corrected acuity rather than "made while wearing correction"), so Moyae publishes its own.

CodeSystem:  MoyaeIsCcCS
Id:          moyae-is-cc-cs
Title:       "Moyae 'with correction' Code System"
Description: """
Moyae-defined CodeSystem carrying the single concept `cc` ("with correction"). Used on `Observation.component.code` in MoyaeVisualAcuity and MoyaeRefraction to indicate whether the patient was wearing their habitual correction (glasses or contacts) when the measurement was taken.

SNOMED CT's `419775003` (Best Corrected Visual Acuity) was considered but is more specific than what Moyae needs — `cc=true` should also apply when a non-best correction was worn.
"""

* ^url           = "https://moyae.com/is-cc"
* ^status        = #active
* ^content       = #complete
* ^experimental  = false
* ^caseSensitive = true

* #cc "with correction" "The observation was made while the patient was wearing their habitual correction (glasses or contact lenses)."
