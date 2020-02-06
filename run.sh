#!/bin/bash

## This app will align a T1/T2w image to the ACPC plane (specifically, the MNI152_T1/2_1mm template from
## FSL using a 6 DOF alignment via FSL commands. This protocol was adapted from the HCP Preprocessing
## Pipeline (https://github.com/Washington-University/HCPpipelines.git). Requires a T1w image input
## and outputs an acpc_aligned T1w image.

set -x
set -e

input=`jq -r '.input' config.json`
template=`jq -r '.template' config.json`
type=`jq -r '.type' config.json` #T1 or T2

product=""

#we use space from
#https://bids-specification.readthedocs.io/en/stable/99-appendices/08-coordinate-systems.html#template-based-coordinate-systems


case $template in
nihpd_asym*)
    space="NIHPD"
    [ $type == "T1" ] && template=templates/${template}_t1w.nii
    [ $type == "T2" ] && template=templates/${template}_t2w.nii
    ;;
*)
    space="MNI152NLin6Asym"
    [ $type == "T1" ] && template=templates/MNI152_T1_1mm
    [ $type == "T2" ] && template=templates/MNI152_T2_1mm
    ;;
esac

case $type in
T1)
    output=output/t1.nii.gz
    ;;
T2)
    output=output/t2.nii.gz
    ;;
esac

robustfov -i $input -m roi2full.mat -r input_robustfov.nii.gz
convert_xfm -omat full2roi.mat -inverse roi2full.mat
flirt -interp spline -in input_robustfov.nii.gz -ref $template -omat roi2std.mat -out acpc_mni.nii.gz
convert_xfm -omat full2std.mat -concat roi2std.mat full2roi.mat
aff2rigid full2std.mat outputmatrix

mkdir -p output
applywarp --rel --interp=spline -i $input -r $template --premat=outputmatrix -o $output

# make png
slicer $output -x 0.5 out_aligncheck.png

# create product.json
cat << EOF > product.json
{
    "output": { "meta": { "Space": "$space" }, "tags": [ "space-$space"] },
    "brainlife": [
        { 
            "type": "image/png", 
            "name": "Alignment Check (-x 0.5)",
            "base64": "$(base64 -w 0 out_aligncheck.png)"
        }
    ]
}
EOF
echo "all done!"
