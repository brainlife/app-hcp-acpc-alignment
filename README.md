[![Abcdspec-compliant](https://img.shields.io/badge/ABCD_Spec-v1.1-green.svg)](https://github.com/brain-life/abcd-spec)
[![Run on Brainlife.io](https://img.shields.io/badge/Brainlife-brainlife.app.116-blue.svg)](https://doi.org/10.25663/brainlife.app.116)

# Align mp2rage data to ACPC Plane (HCP-based) 

This app will align mp2rage images to the ACPC plane (specifically, the MNI152_T1_1mm template) from FSL using a 6 DOF alignment via FSL commands. This protocol was adapted from the HCP Preprocessing Pipeline (https://github.com/Washington-University/HCPpipelines.git). Requires mp2rage images input and outputs an MNI_aligned ('ACPC aligned') mp2rage images. 

### Authors 

- Brad Caron (bacaron@iu.edu) 

### Contributors 

- Soichi Hayashi (hayashis@iu.edu
- Franco Pestilli (franpest@iu.edu) 
- Sophia Vinci-Booher (svincibo@iu.edu)

### Funding 

[![NSF-BCS-1734853](https://img.shields.io/badge/NSF_BCS-1734853-blue.svg)](https://nsf.gov/awardsearch/showAward?AWD_ID=1734853)
[![NSF-BCS-1636893](https://img.shields.io/badge/NSF_BCS-1636893-blue.svg)](https://nsf.gov/awardsearch/showAward?AWD_ID=1636893)
[![NSF-ACI-1916518](https://img.shields.io/badge/NSF_ACI-1916518-blue.svg)](https://nsf.gov/awardsearch/showAward?AWD_ID=1916518)
[![NSF-IIS-1912270](https://img.shields.io/badge/NSF_IIS-1912270-blue.svg)](https://nsf.gov/awardsearch/showAward?AWD_ID=1912270)
[![NIH-NIBIB-R01EB029272](https://img.shields.io/badge/NIH_NIBIB-R01EB029272-green.svg)](https://grantome.com/grant/NIH/R01-EB029272-01)

### Citations 

Please cite the following articles when publishing papers that used data, code or other resources created by the brainlife.io community. 

1. Matthew F. Glasser, Stamatios N. Sotiropoulos, J. Anthony Wilson, Timothy S. Coalson, Bruce Fischl, Jesper L. Andersson, Junqian Xu, Saad Jbabdi, Matthew Webster, Jonathan R. Polimeni, David C. Van Essen, Mark Jenkinson, The minimal preprocessing pipelines for the Human Connectome Project, NeuroImage, Volume 80, 2013, Pages 105-124, ISSN 1053-8119, https://doi.org/10.1016/j.neuroimage.2013.04.127. (http://www.sciencedirect.com/science/article/pii/S1053811913005053) 

## Running the App 

### On Brainlife.io 

You can submit this App online at [https://doi.org/10.25663/brainlife.app.116](https://doi.org/10.25663/brainlife.app.116) via the 'Execute' tab. 

### Running Locally (on your machine) 

1. git clone this repo 

2. Inside the cloned directory, create `config.json` with something like the following content with paths to your input files. 

```json 
{
    "mag_inv1": "./test/mag.inv1.nii.gz",
    "mag_inv2": "./test/mag.inv2.nii.gz",
    "unit1":    "./test/unit1.nii.gz",
    "phase_inv1":   "./test/phase.inv1.nii.gz",
    "phase_inv2":   "./test/phase.inv2.nii.gz",
    "template": "MNI_1mm"
}
``` 

### Sample Datasets 

You can download sample datasets from Brainlife using [Brainlife CLI](https://github.com/brain-life/cli). 

```
npm install -g brainlife 
bl login 
mkdir input 
bl dataset download 
``` 

3. Launch the App by executing 'main' 

```bash 
./main 
``` 

## Output 

The main output of this App is is a MNI_aligned ('ACPC aligned') mp2rage images. 

#### Product.json 

The secondary output of this app is `product.json`. This file allows web interfaces, DB and API calls on the results of the processing. 

### Dependencies 

This App requires the following libraries when run locally. 

- singularity: https://singularity.lbl.gov/quickstart
- FSL: https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/FslInstallation
- jsonlab: https://github.com/fangq/jsonlab
