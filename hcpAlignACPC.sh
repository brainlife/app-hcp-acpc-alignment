#!/bin/bash

## This app will align a T1w image to the ACPC plane (specifically, the MNI152_T1_1mm template from
## FSL using a 6 DOF alignment via FSL commands. This protocol was adapted from the HCP Preprocessing
## Pipeline (https://github.com/Washington-University/HCPpipelines.git). Requires a T1w image input
## and outputs an acpc_aligned T1w image.

echo "Grabbing input T1w image"
# Grab the config.json inputs
t1=`jq -r '.t1' config.json`;
echo "Files loaded"

# Crop FOV
if [ -f "t1_robustfov.nii.gz" ];then
	echo "File exists. Skipping"
else
	echo "Cropping FOV"
	robustfov -i ${t1} \
	-m roi2full.mat \
	-r t1_robustfov.nii.gz;

	ret=$?
	if [ ! $ret -eq 0 ]; then
		echo "Cropping failed"
		echo $ret > finished
		exit $ret
	fi
fi

# Invert matrix
if [ -f "full2roi.mat" ];then
	echo "File exists. Skipping"
else
	echo "Inverting matrix (full FOV to ROI)"
	convert_xfm -omat full2roi.mat \
	-inverse roi2full.mat;

	ret=$?
	if [ ! $ret -eq 0 ]; then
		echo "Matrix inversion failed"
		echo $ret > finished
		exit $ret
	fi
fi

# Register cropped image to MNI152 (12 DOF)
if [ -f "t1_acpc_mni.nii.gz" ];then
	echo "File exists. Skipping"
else
	echo "Registering image to MNI152 (12 DOF)"
	flirt -interp spline \
	-in t1_robustfov.nii.gz \
	-ref ${FSLDIR}/data/standard/MNI152_T1_1mm \
	-omat roi2std.mat \
	-out t1_acpc_mni.nii.gz;

	ret=$?
	if [ ! $ret -eq 0 ]; then
		echo "12 DOF Registration failed"
		echo $ret > finished
		exit $ret
	fi
fi

# Concatenate matrices to get full FOV to MNI
if [ -f "full2std.mat" ];then
	echo "File exists. Skipping"
else
	echo "Concatenate matrices to get full FOV to MNI"
	convert_xfm -omat full2std.mat \
	-concat roi2std.mat full2roi.mat;

	ret=$?
	if [ ! $ret -eq 0 ]; then
		echo "Matrix concatenation failed"
		echo $ret > finished
		exit $ret
	fi
fi

# Get 6 DOF approximation ACPC alignment
if [ -f "outputmatrix" ];then
	echo "File exists. Skipping"
else
	echo "ACPC Alignment"
	aff2rigid full2std.mat \
	outputmatrix;

	ret=$?
	if [ ! $ret -eq 0 ]; then
		echo "ACPC alignment failed"
		echo $ret > finished
		exit $ret
	fi
fi

# Resample ACPC aligned image
if [ -f "t1.nii.gz" ];then
	echo "File exists. Skipping"
else
	echo "Resampling"
	applywarp --rel \
	--interp=spline \
	-i ${t1} \
	-r ${FSLDIR}/data/standard/MNI152_T1_1mm \
	--premat=outputmatrix \
	-o t1.nii.gz;

	ret=$?
	if [ ! $ret -eq 0 ]; then
		echo "Resampling failed"
		echo $ret > finished
		exit $ret
	fi
fi

echo "ACPC Alignment Pipeline complete"
