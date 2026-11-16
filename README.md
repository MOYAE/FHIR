# Moyae Ophthalmology FHIR Implementation Guide

Source for the Moyae Ophthalmology FHIR Implementation Guide, published at **[fhir.moyae.com](https://fhir.moyae.com)**.

## Status

**Draft (v0.1.1).** Profiles document what the Moyae EMR emits today and the shape it is converging on. See the History page in the published guide for what changed per release.

## Scope

- Visual Acuity (Observation profile)
- Intraocular Pressure (Observation profile, target shape)
- Refraction (Observation profile with subjective / objective codings)
- VisionPrescription (profile) plus the source-observation, lens-material and balance-lens extensions

## Tooling

This IG is authored in [FHIR Shorthand (FSH)](https://fshschool.org/) and built with:

- [SUSHI](https://fshschool.org/docs/sushi/) — FSH compiler
- [HL7 IG Publisher](https://github.com/HL7/fhir-ig-publisher) — IG renderer

## Local build

```bash
# install sushi
npm install -g fsh-sushi

# from repo root: FSH -> fsh-generated/
sushi .

# IG Publisher (Java 17; downloads dependency packages on first run)
mkdir -p input-cache
curl -L https://github.com/HL7/fhir-ig-publisher/releases/latest/download/publisher.jar -o input-cache/publisher.jar
java -Xmx4g -jar input-cache/publisher.jar -ig . -no-sushi
```

Build artifacts land in `output/` and are gitignored. Every push to `main` runs `.github/workflows/build-ig.yml`, which builds and deploys to GitHub Pages with a `CNAME` pointing at `fhir.moyae.com`.

## Repository layout

```
.
├── index.md                  # Repo landing page only; the IG Publisher output replaces it on deploy
├── CNAME                     # fhir.moyae.com
├── sushi-config.yaml         # SUSHI / IG metadata
├── ig.ini                    # IG Publisher config
├── input/
│   ├── pagecontent/          # IG narrative pages (index, relationships, history)
│   └── fsh/
│       ├── profiles/         # StructureDefinitions (profiles and extensions)
│       ├── valuesets/        # ValueSets
│       ├── codesystems/      # CodeSystems
│       └── examples/         # Example instances
└── README.md
```

## Related work

- [HL7 FHIR Eye Care IG](https://build.fhir.org/ig/HL7/fhir-eye-care-ig/)

## License

CC0-1.0.

## Contact

- Implementation feedback / partner inquiries: [partnerships@moyae.com](mailto:partnerships@moyae.com)
- Book a call: [calendar.app.google/joEV8YqqYastTaNf6](https://calendar.app.google/joEV8YqqYastTaNf6)
- Partner program: [moyae.com/build-with-moyae](https://moyae.com/build-with-moyae)
