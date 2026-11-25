[![Abcdspec-compliant](https://img.shields.io/badge/ABCD_Spec-v1.1-green.svg)](https://github.com/brain-life/abcd-spec)
[![Run on Brainlife.io](https://img.shields.io/badge/Brainlife-bl.app.99-blue.svg)](https://doi.org/10.25663/bl.app.99)

# app-hcp-acpc-alignment

<!-- brainlife-app:begin (generated from the App manifest; edit the manifest, not this block) -->

**Aligns a T1-weighted image to the ACPC plane with a 6-DOF rigid FSL alignment (flirt, aff2rigid) to the MNI152 T1 1mm template, following the HCP pipelines, with optional reorientation, cropping and template masking.**

Optionally reorients (fslreorient2std) and crops the neck (robustfov), estimates an affine registration to the template (MNI152 or NIHPD) with flirt, reduces it to a rigid-body (6 DOF) transform with aff2rigid and resamples the T1w with spline interpolation. Use it to put a T1w image in a standard ACPC orientation before FreeSurfer or other anatomical processing; it does not warp the brain to the template shape. Set mask to true for skull-stripped inputs so the template is masked too.

Run it on brainlife.io: [https://doi.org/10.25663/brainlife.app.800](https://doi.org/10.25663/brainlife.app.800)

| Input | Datatype | Required | Description |
|---|---|---|---|
| `t1` | `neuro/anat/t1w` | yes | The path to the anat/t1w datatype to be aligned |

| Output | Datatype | Description |
|---|---|---|
| `output` | `neuro/anat/t1w` | The ACPC aligned anat/t1w datatype |
| `transform` | `neuro/transform/nifti` | Rigid (6 DOF) affine matrix (affine.txt) mapping the input T1w to the ACPC-aligned template space. |

| Parameter | Type | Default | Description |
|---|---|---|---|
| `type` | string | `T1` | This controls whether the datatype of the app is T1 or T2. Not to be changed, used in order to keep the code same between T1 and T2 |
| `template` | enum | `MNI152_1mm` | This template is used to align the input image to standard MNI orientation (acpc aligned). For adult brain, MNI152 should work fine, however, if you have pediatric images please select a template with correct age group in order to ensure that your input image will better align with the template. Otherwise, flirt will fail to correctly align your image. Options: `MNI152_1mm`, `nihpd_asym_04.5-08.5`, `nihpd_asym_04.5-18.5`, `nihpd_asym_07.0-11.0`, `nihpd_asym_07.5-13.5`, `nihpd_asym_10.0-14.0`, `nihpd_asym_13.0-18.5`. |
| `reorient` | boolean | `false` | If true, will reorient image to FSL standard using fslreorient2std |
| `crop` | boolean | `false` | If true, will crop using FSL robustfov |
| `mask` | boolean | `false` | if input data is already brain masked, set this to true to mask out the template |
| `cleanup` | boolean | `false` | Remove templates to save space |

Runtime: container `brainlife/fsl:6.0.4-patched`; 1 CPUs; 0.42 h walltime.

<!-- brainlife-app:end -->

This app will align a T1w image to the ACPC plane. More specifically, it will align the T1w volume to the MNI152_T1_1mm template using a 6 DOF alignment via FSL commands. This protocol was adapted from the [HCP Preprocessing Pipeline](https://github.com/Washington-University/HCPpipelines). First, the FOV is cropped using FSL's robustfov command. Next, the FOV matrix is inverted using FSL's convert_xfm command. Then, the cropped image is registered to the MNI152_T1_1mm template provided by FSL using FSL's flirt command. Following this, the transformation matrices are concatenated using FSL's convert_xfm command and the cropped image is aligned to the ACPC plane using FSL's aff2rigid. Finally, the original T1 is resampled to ACPC space using FSL's applywarp command.

### Authors
- Brad Caron (bacaron@iu.edu)

### Contributors
- Soichi Hayashi (hayashi@iu.edu)
- Franco Pestilli (franpest@indiana.edu)

### Funding
[![NSF-BCS-1734853](https://img.shields.io/badge/NSF_BCS-1734853-blue.svg)](https://nsf.gov/awardsearch/showAward?AWD_ID=1734853)
[![NSF-BCS-1636893](https://img.shields.io/badge/NSF_BCS-1636893-blue.svg)](https://nsf.gov/awardsearch/showAward?AWD_ID=1636893)

### References 
[Glasser et al. (2013) Neuroimage.](https://doi.org/10.1016/j.neuroimage.2013.04.127)

## Running the App 

### On Brainlife.io

You can submit this App online at [https://doi.org/10.25663/bl.app.99](https://doi.org/10.25663/bl.app.99) via the "Execute" tab.

### Running Locally (on your machine)

1. git clone this repo.
2. Inside the cloned directory, create `config.json` with something like the following content with paths to your input files.

```json
{
        "t1": "./input/t1/t1.nii.gz"
}
```

### Sample Datasets

You can download sample datasets from Brainlife using [Brainlife CLI](https://github.com/brain-life/cli).

```
npm install -g brainlife
bl login
mkdir input
bl dataset download 5b96bbbf059cf900271924f2 && mv 5b96bbbf059cf900271924f2 input/t1
```


3. Launch the App by executing `main`

```bash
./main
```

## Output

The main output of this App is an ACPC-aligned t1.nii.gz.

#### Product.json
The secondary output of this app is `product.json`. This file allows web interfaces, DB and API calls on the results of the processing. 

### Dependencies

This App requires the following libraries when run locally.

  - singularity: https://singularity.lbl.gov/
  - FSL: https://hub.docker.com/r/brainlife/fsl/tags/5.0.9
