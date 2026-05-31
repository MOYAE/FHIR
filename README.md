# Moyae Ophthalmology FHIR Implementation Guide

Source for the Moyae Ophthalmology FHIR Implementation Guide, published at **[fhir.moyae.com](https://fhir.moyae.com)**.

## Status

**Pre-alpha (v0.1.0).** Profiles are in authoring. The published site is a placeholder pending the first profile cut.

## Scope (v0.1.0)

- Visual Acuity (Observation profile)
- Intraocular Pressure (Observation profile)
- Refraction — Subjective / Objective / Auto (3 Observation profiles)

## Tooling

This IG is authored in [FHIR Shorthand (FSH)](https://fshschool.org/) and built with:

- [SUSHI](https://fshschool.org/docs/sushi/) — FSH compiler
- [HL7 IG Publisher](https://github.com/HL7/fhir-ig-publisher) — IG renderer

## Local build

```bash
# install sushi
npm install -g fsh-sushi

# from repo root
sushi build

# IG Publisher (downloads on first run)
./_genonce.sh   # or _genonce.bat on Windows
```

Build artifacts land in `output/` and are gitignored. The published site is served from the `main` branch via GitHub Pages with a `CNAME` pointing at `fhir.moyae.com`.

## Repository layout

```
.
├── index.md                  # GitHub Pages landing page (rendered by Jekyll until IG Publisher output replaces it)
├── CNAME                     # fhir.moyae.com
├── sushi-config.yaml         # SUSHI / IG metadata
├── ig.ini                    # IG Publisher config
├── input/
│   ├── pagecontent/          # IG narrative pages
│   └── fsh/
│       ├── profiles/         # StructureDefinitions
│       ├── valuesets/        # ValueSets
│       ├── codesystems/      # CodeSystems (if any)
│       └── examples/         # Example instances
└── README.md
```

## Related work

- [ZEISS Eyecare Concepts IG](https://zeiss.github.io/eyecare-concepts/)
- TOPCON FHIR Exchange for Numeric Ocular Device Data (working draft)
- [HL7 FHIR Eye Care IG](https://build.fhir.org/ig/HL7/fhir-eye-care-ig/)

## License

CC0-1.0. See `LICENSE` (to be added).

## Contact

- Implementation feedback / partner inquiries: [partnerships@moyae.com](mailto:partnerships@moyae.com)
- Book a call: [calendar.app.google/joEV8YqqYastTaNf6](https://calendar.app.google/joEV8YqqYastTaNf6)
- Partner program: [moyae.com/build-with-moyae](https://moyae.com/build-with-moyae)
