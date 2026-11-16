// Source of truth: packages/api/services/fhirObservations/visualAcuityHelpers/formatVisionPrescription.ts
//
// Moyae uses VisionPrescription as a DUAL-PURPOSE resource:
//   - status = "draft"  : in-progress measurement (refraction-in-progress, lensometer reading).
//                          Referenced from a MoyaeVisualAcuity or MoyaeRefraction Observation.focus.
//   - status = "active" : the signed, finalized prescription handed to the patient or optical lab.
//                          Since September 2026 (MOYAE-3433) signing CREATES a new active resource
//                          and leaves the draft untouched; the two have distinct ids.
// Both carry the source-observation extension back to the exam Observation, the lens-material
// and balance-lens extensions per lensSpecification where applicable, and application provenance
// stamps. This is a deliberate alternative to the pattern some peer IGs use, where the measurement
// is an Observation and VisionPrescription is reserved for the signed prescription.

Profile:        MoyaeVisionPrescription
Parent:         VisionPrescription
Id:             moyae-vision-prescription
Title:          "Moyae Vision Prescription (current shape)"
Description:    """
A VisionPrescription as currently emitted by Moyae. This single profile covers two uses, distinguished by `status`:

* **`status = "draft"`** — refractive *measurement* captured during an exam. Companion to a [MoyaeVisualAcuity](StructureDefinition-moyae-visual-acuity.html) or [MoyaeRefraction](StructureDefinition-moyae-refraction.html) Observation via the Observation's `focus` reference.
* **`status = "active"`** — signed, finalized prescription, issued as a **separate resource** from the draft (signing no longer flips the draft's status). Carries the same `lensSpecification` shape; the prescriber field is required.

Every VisionPrescription names its exam Observation through the [source-observation extension](StructureDefinition-vision-prescription-source-observation.html). Each `lensSpecification` may carry a [lens material](StructureDefinition-lens-material.html) and a [balance lens](StructureDefinition-balance-lens.html) marker, both mirrored into `note` for base-R4 readers.

`lensSpecification` is a two-entry array, one per eye, each with eye-specific sphere / cylinder / axis / add / prism / brand / color / backCurve / diameter. Prism is always serialized as a 2-element array (vertical at index 0, horizontal at index 1) using placeholder `0` amounts when not clinically present.
"""

* extension contains VisionPrescriptionSourceObservation named sourceObservation 0..1
* lensSpecification.extension contains
    LensMaterial named lensMaterial 0..1 and
    BalanceLens named balanceLens 0..1

* ^status = #draft

* identifier 0..*
// Where present, Moyae emits a custom identifier today:
//   { system: "https://moyae.com/vision-prescription-status", value: "active" }
// Flagged in the narrative — this identifier carries STATE rather than identity and should be retired in v0.1.x.
* identifier.system = $MOYAE-VP-IDENT-SYS

* status from VisionPrescriptionStatus (required)

* patient 1..1
* patient only Reference(Patient)
* encounter 1..1
* encounter only Reference(Encounter)
* created 1..1
* dateWritten 1..1
* prescriber 1..1
* prescriber only Reference(Practitioner)

* lensSpecification 1..*
* lensSpecification.product.coding.system = $VP-PRODUCT (exactly)
* lensSpecification.product.coding.code from VisionPrescriptionProductVS (required)
* lensSpecification.eye 1..1
* lensSpecification.eye from VisionEyes (required)

// Numeric refractive values - all 0..1, all Moyae-emitted as decimals.
* lensSpecification.sphere 0..1
* lensSpecification.cylinder 0..1
* lensSpecification.axis 0..1
* lensSpecification.add 0..1
* lensSpecification.backCurve 0..1
* lensSpecification.diameter 0..1
* lensSpecification.duration 0..1
* lensSpecification.power 0..1

// Brand and color are free text. Color may include a "||"-delimited multifocal-power suffix.
* lensSpecification.brand 0..1
* lensSpecification.color 0..1

* lensSpecification.prism 0..2
* lensSpecification.prism.amount 1..1
* lensSpecification.prism.base 1..1
* lensSpecification.prism.base from VisionBase (required)
