## History

### 0.1.1 (November 2026)

* Added the [Subscriptions](subscriptions.html) page: how rest-hook Subscriptions work today, and the draft connectathon profile with the two `Subscription.channel` extensions (`filter-by-profile`, `filter-by-resource-type`).
* Corrected the body-site value set. 0.1.0 listed `1290030002` as "Right eye"; that concept is *Disorder of left eye proper*. The value set now carries the structure concepts the API writes: `1290032005` right, `1290031003` left, `40638003` both.
* Added the three VisionPrescription extensions the API emits: source observation, lens material (with its code system), balance lens.
* Documented the September 2026 change that issues a signed prescription as a separate `active` VisionPrescription rather than flipping the draft.
* Documented bodySite appended on every lateralized Observation write and the migration of inactive SNOMED eye codes.
* Documented the subjective / objective refraction codings and the application provenance extensions.
* Replaced the `measurement-prescription` extension plan with what shipped: the reverse link from VisionPrescription to Observation.
* Added the partner API summary and this page. Removed a link to a private repository.

### 0.1.0 (June 2026)

* First cut: IOP, Visual Acuity, Refraction and VisionPrescription profiles, value sets, examples.
* Canonical SNOMED system URI on write; `is-cc` code system published.
* IOP profile moved to bodySite laterality and `valueQuantity` as the target shape.
