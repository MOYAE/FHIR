// Canonical & local URI aliases used across Moyae IG profiles.
// See packages/api/services/fhirObservations/* for source paths these mirror.

Alias: $SCT                  = http://snomed.info/sct
// Legacy: the SNOMED International website URL was used as a system URI on some Moyae
// emissions. Reads tolerate it; see relationships.html for where it still appears on write.
// No profile or example references it.
Alias: $SCT-LEGACY           = https://www.snomed.org/
Alias: $OBS-CATEGORY         = http://terminology.hl7.org/CodeSystem/observation-category
Alias: $UCUM                 = http://unitsofmeasure.org
Alias: $LATERALITY-EXT       = http://hl7.org/fhir/uv/ophthalmology/StructureDefinition/laterality
Alias: $VP-PRODUCT           = http://terminology.hl7.org/CodeSystem/ex-visionprescriptionproduct

// Moyae-defined / Moyae-emitted URIs (these are URLs we use today; some do not
// currently resolve to a CodeSystem and are flagged in the narrative).
Alias: $MOYAE-CC-CS          = https://moyae.com/is-cc
Alias: $MOYAE-VP-IDENT-SYS   = https://moyae.com/vision-prescription-status
