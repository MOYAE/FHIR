---
title: Moyae Ophthalmology FHIR Implementation Guide
---

# Moyae Ophthalmology FHIR Implementation Guide

**Version 0.1.0 — In progress (pre-alpha)**

This is the canonical Implementation Guide for ophthalmology FHIR resources published by [Moyae, Inc.](https://moyae.com). The guide is in active development and **profiles are not yet stable**.

## Scope (v0.1.0)

- **Visual Acuity** — Observation profile with body-site-based laterality
- **Intraocular Pressure** — Observation profile per eye, body-site-based laterality, valueQuantity with UCUM
- **Refraction** — Subjective / Objective / Auto Observation profiles using `bodySite`-based laterality and `valueQuantity` with UCUM

## Relationship to existing work

This IG is published independently and is designed to compose with the broader ophthalmology FHIR ecosystem:

- **Atomic per-Observation profiles** — Moyae uses an atomic Observation profile structure (separate refraction profiles, single VA profile, single IOP profile) with `bodySite`-based laterality, in line with modern ophthalmology FHIR conventions.
- **Compositional device-submission pattern** — for vendors emitting numeric device data into Moyae endpoints, Moyae supports a compositional pattern (transaction Bundle per device submission, DiagnosticReport per modality, grouper Observation per eye, `DocumentReference` for source payload preservation, `Provenance` for transformation lineage).
- **HL7 FHIR Eye Care IG** — Moyae intends to align with the HL7 Eye Care WG over the v0.1.x release cycle and may file profiles as candidate contributions.

## Where to read it

Currently you're looking at the placeholder home page. The published IG (Structure Definitions, value sets, examples) will live at:

- `https://fhir.moyae.com/ig/v0/` — current draft (v0.1.0)
- `https://fhir.moyae.com/ig/v0.1/` — post-pilot revision (v0.1.1)
- `https://fhir.moyae.com/StructureDefinition/{ProfileName}` — canonical resource URLs

## Source

Authoring tooling: [SUSHI](https://fshschool.org/docs/sushi/) (FHIR Shorthand) + [HL7 IG Publisher](https://github.com/HL7/fhir-ig-publisher).

Source repo: [github.com/MOYAE/FHIR](https://github.com/MOYAE/FHIR)

## Contact

Implementation feedback, partner inquiries, and questions: [partnerships @ moyae.com](mailto:partnerships@moyae.com) or book at [calendar.app.google/joEV8YqqYastTaNf6](https://calendar.app.google/joEV8YqqYastTaNf6).

---

*This page is a placeholder pending the first profile publication. Updates land here as authoring proceeds.*
