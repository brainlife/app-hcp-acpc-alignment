#!/bin/bash

## This app will align a mp2rage image to the ACPC plane (specifically, the MNI152_T1m template from
## FSL using a 6 DOF alignment via FSL commands. This protocol was adapted from the HCP Preprocessing
## Pipeline (https://github.com/Washington-University/HCPpipelines.git). Requires a mp2rage image input
## and outputs an acpc_aligned T1w image.

set -x
set -e

mag_inv1=`jq -r '.mag_inv1' config.json`
mag_inv2=`jq -r '.mag_inv2' config.json`
phase_inv1=`jq -r '.phase_inv1' config.json`
phase_inv2=`jq -r '.phase_inv2' config.json`
unit1=`jq -r '.unit1' config.json`
template=`jq -r '.template' config.json`
resample=`jq -r '.resample' config.json`

product=""

#we use space from
#https://bids-specification.readthedocs.io/en/stable/99-appendices/08-coordinate-systems.html#template-based-coordinate-systems


case $template in
nihpd_asym*)
    space="NIHPD"
    template=templates/${template}_t1w.nii
    ;;
*)
    space="MNI152NLin6Asym"
    template=templates/MNI152_T1_1mm
    ;;
esac

# identify the volumes in mp2rage datatype
echo "identifying mp2rage volumes"
volumes=""
potential_volumes="mag_inv1 mag_inv2 phase_inv1 phase_inv2 unit1"
for i in ${potential_volumes}
do
    test_vol=$(eval "echo \$${i}")
    if [ -f ${test_vol} ]; then
        volumes=${volumes}" ${i}"
    fi
done

# crop data
robustfov -i ${unit1} -m roi2full.mat -r unit1.cropped.nii.gz
convert_xfm -omat full2roi.mat -inverse roi2full.mat
if [[ ${resample} == true; then
    flirt -interp spline -in unit1.cropped.nii.gz -ref $template -omat roi2std.mat -out acpc_mni.nii.gz
else
    flirt -interp spline -noresample -in unit1.cropped.nii.gz -ref $template -omat roi2std.mat -out acpc_mni.nii.gz
fi
convert_xfm -omat full2std.mat -concat roi2std.mat full2roi.mat
aff2rigid full2std.mat outputmatrix

mkdir -p output
for i in ${volumes}
do
    input=$(eval "echo \$${i}")
    outname=`echo ${i/_/.}`
    applywarp --rel --interp=spline -i $input -r $template --premat=outputmatrix -o ./output/${outname}.nii.gz
done

# make png
slicer ./output/mag.inv1.nii.gz -x 0.5 out_aligncheck.png

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
