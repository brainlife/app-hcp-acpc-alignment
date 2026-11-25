<h1 align="center">ACPC alignment (HCP-based)</h1>

<p align="center">
  A T1w, T2w or MP2RAGE image rigidly aligned to the ACPC plane of a standard template, with its 6-DOF transform, following the HCP preprocessing pipelines.
</p>

<p align="center">
  <a href="https://github.com/brainlife/abcd-spec"><img src="https://img.shields.io/badge/ABCD_Spec-v1.1-green.svg" alt="ABCD Spec v1.1"></a>
  <a href="https://doi.org/10.25663/brainlife.app.800"><img src="https://img.shields.io/badge/Brainlife-brainlife.app.800-blue.svg" alt="Run on brainlife.io"></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/License-MIT-lightgrey.svg" alt="MIT license"></a>
</p>

> **This branch, `1.5`, is the brainlife.io App Align T1 to ACPC Plane (HCP-based)** ([doi:10.25663/brainlife.app.800](https://doi.org/10.25663/brainlife.app.800)). The other Apps in this repository are listed under **Versions on brainlife.io** below.

## At a glance

<!-- brainlife-app:begin (generated from the App manifest; edit the manifest, not this block) -->

> **Aligns a T1-weighted image to the ACPC plane with a 6-DOF rigid FSL alignment (flirt, aff2rigid) to the MNI152 T1 1mm template, following the HCP pipelines, with optional reorientation, cropping and template masking.**

Optionally reorients (fslreorient2std) and crops the neck (robustfov), estimates an affine registration to the template (MNI152 or NIHPD) with flirt, reduces it to a rigid-body (6 DOF) transform with aff2rigid and resamples the T1w with spline interpolation. Use it to put a T1w image in a standard ACPC orientation before FreeSurfer or other anatomical processing; it does not warp the brain to the template shape. Set mask to true for skull-stripped inputs so the template is masked too.

| | |
|---|---|
| **Inputs** | `neuro/anat/t1w` |
| **Outputs** | `neuro/anat/t1w` · `neuro/transform/nifti` |
| **Container** | `brainlife/fsl:6.0.4-patched` |
| **Resources** | 1 CPUs · 0.42 h walltime |
| **Run it** | [doi.org/10.25663/brainlife.app.800](https://doi.org/10.25663/brainlife.app.800) |

#### Inputs

| Input | Datatype | Required | Description |
|---|---|---|---|
| `t1` | `neuro/anat/t1w` | yes | The path to the anat/t1w datatype to be aligned |

#### Outputs

| Output | Datatype | Description |
|---|---|---|
| `output` | `neuro/anat/t1w` | The ACPC aligned anat/t1w datatype |
| `transform` | `neuro/transform/nifti` | Rigid (6 DOF) affine matrix (affine.txt) mapping the input T1w to the ACPC-aligned template space. |

<details>
<summary><b>Parameters</b> (6)</summary>

| Parameter | Type | Default | Description |
|---|---|---|---|
| `type` | string | `T1` | This controls whether the datatype of the app is T1 or T2. Not to be changed, used in order to keep the code same between T1 and T2 |
| `template` | enum | `MNI152_1mm` | This template is used to align the input image to standard MNI orientation (acpc aligned). For adult brain, MNI152 should work fine, however, if you have pediatric images please select a template with correct age group in order to ensure that your input image will better align with the template. Otherwise, flirt will fail to correctly align your image. Options: `MNI152_1mm`, `nihpd_asym_04.5-08.5`, `nihpd_asym_04.5-18.5`, `nihpd_asym_07.0-11.0`, `nihpd_asym_07.5-13.5`, `nihpd_asym_10.0-14.0`, `nihpd_asym_13.0-18.5`. |
| `reorient` | boolean | `false` | If true, will reorient image to FSL standard using fslreorient2std |
| `crop` | boolean | `false` | If true, will crop using FSL robustfov |
| `mask` | boolean | `false` | if input data is already brain masked, set this to true to mask out the template |
| `cleanup` | boolean | `false` | Remove templates to save space |

</details>

<!-- brainlife-app:end -->

## About

These Apps put an anatomical image in a standard ACPC orientation before FreeSurfer or other anatomical processing. The protocol was adapted from the [HCP Preprocessing Pipelines](https://github.com/Washington-University/HCPpipelines): the field of view is cropped with FSL `robustfov`, the cropped image is registered to the template with `flirt`, the transforms are concatenated with `convert_xfm` and reduced to a rigid-body (6 DOF) transform with `aff2rigid`, and the original image is resampled into ACPC space with `applywarp`. The brain is rotated and translated, not warped to the shape of the template.

The default template is FSL's MNI152 1 mm (T1 or T2). For paediatric data, choose one of the NIHPD asymmetric templates for the matching age range (`nihpd_asym_04.5-08.5`, `nihpd_asym_04.5-18.5`, `nihpd_asym_07.0-11.0`, `nihpd_asym_07.5-13.5`, `nihpd_asym_10.0-14.0`, `nihpd_asym_13.0-18.5`); otherwise `flirt` may fail to align the image correctly.

## Versions on brainlife.io

Each App is built from its own branch of this repository.

| App | Input | FSL | Branch | Run it | Status |
|---|---|---|---|---|---|
| **Align T1 to ACPC Plane (HCP-based)** (this branch) | T1w | 6.0.4 | [`1.5`](https://github.com/brainlife/app-hcp-acpc-alignment/tree/1.5) | [doi:10.25663/brainlife.app.800](https://doi.org/10.25663/brainlife.app.800) | current |
| Align T2 to ACPC Plane (HCP-based) | T2w | 5.0.9 | [`1.4`](https://github.com/brainlife/app-hcp-acpc-alignment/tree/1.4) | [doi:10.25663/brainlife.app.116](https://doi.org/10.25663/brainlife.app.116) | current |
| Align mp2rage to ACPC Plane (HCP-based) | MP2RAGE | 5.0.9 | [`mp2rage-v1.5`](https://github.com/brainlife/app-hcp-acpc-alignment/tree/mp2rage-v1.5) | [doi:10.25663/brainlife.app.511](https://doi.org/10.25663/brainlife.app.511) | current |
| Align T1 to ACPC Plane (HCP-based) - deprecated | T1w | 5.0.9 | [`1.4`](https://github.com/brainlife/app-hcp-acpc-alignment/tree/1.4) | [doi:10.25663/bl.app.99](https://doi.org/10.25663/bl.app.99) | deprecated |

## Running the App

### On brainlife.io

Open the App for your image type from the table above, choose the image from your project, set the options and press **Execute**. The aligned image is written to your project tagged `acpc_aligned` (and `preprocessed` for T1w and T2w), together with the rigid transform for the T1w and T2w Apps. Each run also shows an alignment-check image (a sagittal slice) on brainlife.io.

Options of the T1w App (`1.5`):

- **`template`**: the template to align to (see above).
- **`reorient`** (default `false`): reorient the image to the FSL standard orientation with `fslreorient2std` first.
- **`crop`** (default `false`): crop the field of view (for example the neck) with `robustfov` before registration.
- **`mask`** (default `false`): set this when the input is already skull-stripped, so the MNI template is brain-masked too.
- **`cleanup`** (default `false`): remove the templates after the run to save space.

The T2w App (`1.4`) always crops with `robustfov` and does not use `reorient`. The MP2RAGE App estimates the alignment from the UNI (`unit1`) image and applies it to every MP2RAGE volume present (magnitude and phase of both inversions, and UNI); it can align to a T1w of the same subject instead of a template, and has `resample` (default `true`) and `interp` (`nearestneighbour` by default; `trilinear`, `spline` or `sinc`) options.

### Locally

You need [Singularity/Apptainer](https://apptainer.org/) and [`jq`](https://jqlang.github.io/jq/). The templates are stored in the `templates/` directory of each App branch.

1. Clone this repository and check out the App you want (for example `git checkout 1.5`).
2. Create `config.json`. For the T1w App:

   ```json
   {
       "input": "./input/t1/t1.nii.gz",
       "type": "T1",
       "template": "MNI152_1mm",
       "reorient": false,
       "crop": false,
       "mask": false,
       "cleanup": false
   }
   ```

   For the T2w App, set `"type": "T2"` and point `input` to the T2w image. For the MP2RAGE App, give the `mag_inv1`, `phase_inv1`, `mag_inv2`, `phase_inv2` and `unit1` images (and their `*_json` sidecars), plus `template`, `resample`, `interp` and, optionally, `anat`.

3. Run the App:

   ```bash
   ./main
   ```

### Sample data

Download a T1-weighted sample from brainlife.io with the [brainlife CLI](https://github.com/brainlife/cli):

```bash
npm install -g brainlife
bl login
mkdir input
bl dataset download 5b96bbbf059cf900271924f2 && mv 5b96bbbf059cf900271924f2 input/t1
```

## Outputs

```text
output/
└── t1.nii.gz          ACPC-aligned image (t2.nii.gz for the T2w App;
                       mag.inv1, mag.inv2, phase.inv1, phase.inv2, unit1 .nii.gz and their JSON for MP2RAGE)
transform/
└── affine.txt         rigid (6 DOF) matrix from the input image to ACPC template space (T1w and T2w Apps)
```

The space of the output (`MNI152NLin6Asym` or `NIHPD`) is recorded in the dataset metadata.

## Troubleshooting

- **Paediatric images are badly aligned**: choose the NIHPD template for the subject's age range instead of `MNI152_1mm`.
- **Skull-stripped input is badly aligned**: set `mask` (T1w App) so the template is brain-masked as well.
- **Large neck or unusual field of view**: set `crop` (T1w App) to crop with `robustfov` before registration.

## Citing

> [!TIP]
> If you use this App in your work, please cite the App, the software it builds on and brainlife.io (below). GitHub's **Cite this repository** button gives the App citation in APA and BibTeX.

- Glasser MF, et al. The minimal preprocessing pipelines for the Human Connectome Project. *NeuroImage* 80:105–124 (2013). [doi:10.1016/j.neuroimage.2013.04.127](https://doi.org/10.1016/j.neuroimage.2013.04.127)
- Align T1 to ACPC Plane (HCP-based). brainlife.io App. [doi:10.25663/brainlife.app.800](https://doi.org/10.25663/brainlife.app.800)
- Fischl. FreeSurfer. *NeuroImage* 62:774-781 (2012). [doi:10.1016/j.neuroimage.2012.01.021](https://doi.org/10.1016/j.neuroimage.2012.01.021)
- Jenkinson et al. FSL. *NeuroImage* 62:782-790 (2012). [doi:10.1016/j.neuroimage.2011.09.015](https://doi.org/10.1016/j.neuroimage.2011.09.015)
- Hayashi S, Caron BA, Heinsfeld AS, et al. brainlife.io: a decentralized and open-source cloud platform to support neuroscience research. *Nature Methods* 21:809–813 (2024). [doi:10.1038/s41592-024-02237-2](https://doi.org/10.1038/s41592-024-02237-2)
- Avesani P, McPherson B, Hayashi S, et al. The open diffusion data derivatives, brain data upcycling via integrated publishing of derivatives and reproducible open cloud services. *Scientific Data* 6:69 (2019). [doi:10.1038/s41597-019-0073-y](https://doi.org/10.1038/s41597-019-0073-y)

## Authors

- Brad Caron
- Franco Pestilli (project director)

**Contributors:** Soichi Hayashi

## Funding

[![Wellcome-226486/Z/22/Z](https://img.shields.io/badge/Wellcome-226486%2FZ%2F22%2FZ-purple.svg)](https://wellcome.org/)
[![NIH-NINDS-U24NS140384](https://img.shields.io/badge/NIH_NINDS-U24NS140384-green.svg)](https://reporter.nih.gov/project-details/11261037)
[![NIH-NINDS-UM1NS132207](https://img.shields.io/badge/NIH_NINDS-UM1NS132207-green.svg)](https://reporter.nih.gov/project-details/11411328)
[![NIH-NIBIB-R01EB029272](https://img.shields.io/badge/NIH_NIBIB-R01EB029272-green.svg)](https://reporter.nih.gov/project-details/10262925)
[![NIH-NIBIB-R01EB030896](https://img.shields.io/badge/NIH_NIBIB-R01EB030896-green.svg)](https://reporter.nih.gov/project-details/10428625)
[![NIH-NIMH-R01MH126699](https://img.shields.io/badge/NIH_NIMH-R01MH126699-green.svg)](https://reporter.nih.gov/project-details/10460628)
[![NIH-NIDCD-R01DC020088](https://img.shields.io/badge/NIH_NIDCD-R01DC020088-green.svg)](https://reporter.nih.gov/project-details/11140284)
[![NSF-BCS-1734853](https://img.shields.io/badge/NSF_BCS-1734853-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1734853)
[![NSF-BCS-2203524](https://img.shields.io/badge/NSF_BCS-2203524-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=2203524)
[![NSF-IIS-1636893](https://img.shields.io/badge/NSF_IIS-1636893-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1636893)
[![NSF-OAC-2148729](https://img.shields.io/badge/NSF_OAC-2148729-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=2148729)
[![NSF-IIS-1912270](https://img.shields.io/badge/NSF_IIS-1912270-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1912270)
[![NSF-IIS-2148700](https://img.shields.io/badge/NSF_IIS-2148700-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=2148700)
[![NSF-OAC-1916518](https://img.shields.io/badge/NSF_OAC-1916518-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1916518)

<sub>brainlife.io is publicly funded, and acknowledging that support helps keep it running. This App was developed with support from Wellcome, the U.S. National Institutes of Health (including the BRAIN Initiative BRAIN CONNECTS program: The Axonal Projectome EXchange, U24NS140384, and the Center for Mesoscale Connectomics, UM1NS132207) and the U.S. National Science Foundation.</sub>

## License

[MIT](LICENSE). FSL is distributed under its own [license](https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/Licence).
