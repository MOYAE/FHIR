## Moyae Ophthalmology FHIR Implementation Guide

**Version 0.1.0 — In progress (pre-alpha)**

This is the canonical Implementation Guide for ophthalmology FHIR resources published by [Moyae, Inc.](https://moyae.com). The guide is in active development and **profiles are not yet stable**.

### Scope (v0.1.0)

- **Visual Acuity** — Observation profile with body-site-based laterality
- **Intraocular Pressure** — Observation profile per eye, body-site-based laterality, valueQuantity with UCUM
- **Refraction** — Subjective / Objective / Auto Observation profiles, deferring to [ZEISS Eyecare Concepts IG](https://zeiss.github.io/eyecare-concepts/) conventions

### Relationship to existing work

This IG is published independently and is designed to compose with:

- **ZEISS Eyecare Concepts IG** — Moyae adopts ZEISS's atomic Observation profile structure and the `bodySite`-based laterality convention. A side-by-side mapping document will be published in v0.1.1.
- **TOPCON FHIR Exchange for Numeric Ocular Device Data** — Moyae adopts TOPCON's compositional pattern (transaction Bundle per device submission, DiagnosticReport per modality, grouper Observation per eye, `DocumentReference` for source payload preservation, `Provenance` for transformation lineage) as guidance for vendors emitting numeric device data into Moyae endpoints.
- **HL7 FHIR Eye Care IG** — Moyae intends to align with the HL7 Eye Care WG over the v0.1.x release cycle.

### Status

Profiles authoring is in progress. The `input/fsh/` directory will be populated over the v0.1.0 development cycle. See the [project repository](https://github.com/MOYAE/FHIR) for source.

### Contact

[partnerships@moyae.com](mailto:partnerships@moyae.com) or book at [calendar.app.google/joEV8YqqYastTaNf6](https://calendar.app.google/joEV8YqqYastTaNf6).
