[![Abcdspec-compliant](https://img.shields.io/badge/ABCD_Spec-v1.1-green.svg)](https://github.com/brain-life/abcd-spec)
[![Run on Brainlife.io](https://img.shields.io/badge/Brainlife-bl.app.99-blue.svg)](https://doi.org/10.25663/bl.app.99)

# app-hcp-acpc-alignment
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

The two main output of this App is an ACPC-aligned t1.nii.gz.

#### Product.json
The secondary output of this app is `product.json`. This file allows web interfaces, DB and API calls on the results of the processing. 

### Dependencies

This App requires the following libraries when run locally.

  - singularity: https://singularity.lbl.gov/
  - FSL: https://hub.docker.com/r/brainlife/fsl/tags/5.0.9
