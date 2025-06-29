#!/bin/bash

# This script is called by storescp on each received file

# Parameters passed by storescp
FILE="$1"  # Path to the received DICOM file

# Extract MRN (PatientID) and StudyDate using dcmtk's dcmdump
PATIENT_ID=$(dcmdump +P PatientID "$FILE" | cut -d'[' -f2 | cut -d']' -f1)
STUDY_DATE=$(dcmdump +P StudyDate "$FILE" | cut -d'[' -f2 | cut -d']' -f1)
SERIESUID=$(dcmdump +P SeriesInstanceUID "$FILE" | cut -d'[' -f2 | cut -d']' -f1)
SOP_UID=$(dcmdump +P SOPInstanceUID "$FILE" | cut -d'[' -f2 | cut -d']' -f1)

# Set base directory where files will be stored
BASE_DIR="/home/fuentes/wolfpacs/dicom"


# Create target directory
TARGET_DIR="${BASE_DIR}/${PATIENT_ID}/${STUDY_DATE}/$2/${SERIESUID}"

# Remove previous files in this directory (optional and destructive)
#echo rm -rf "$TARGET_DIR"

# Create directory
mkdir -p "$TARGET_DIR"

# Move received file to organized path
mv "$FILE" "${TARGET_DIR}/${SOP_UID}.dcm"

# nifti commmand 
PROCESSED_DIR="/home/fuentes/wolfpacs/processed/${PATIENT_ID}"
mkdir -p "${PROCESSED_DIR}" 
echo DicomSeriesReadImageWrite2 "${TARGET_DIR}" "${PROCESSED_DIR}/$2.nii.gz"  >  "${PROCESSED_DIR}/$2.cmd" 
