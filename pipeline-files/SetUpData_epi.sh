source SetUpData_inputs.sh

# Atlas mask
# Inputs
atlas_target=$t1align
atlas_trainingstructs=trainingt1s.txt
atlas_traininglabels=trainingmasks.txt
# Output
t1atlasmask=$case/strct/$case.t1atlasmask.nrrd

# Freesurfer
# Inputs
fs_t1=$t1align
fs_mask=$t1atlasmask
# Output
fs=$case/strct/$case.freesurfer

# DWI preprocessing
# Inputs:
dwied_dwi=$dwiraw
# Output
dwied=$case/diff/$case.dwi-Ed.nrrd  

# DWI mask
# Inputs:
dwibetmask_dwi=$dwied
# Output
dwibetmask=$case/diff/$case.dwibetmask.nrrd  

# DWI epi correction
# Inputs
dwiepi_dwi=$dwied
dwiepi_dwimask=$dwibetmask
dwiepi_t2=$t2
# Output
dwiepi=$case/diff/$case.dwi-epi.nrrd

# DWI epi mask (for ukftractography seed map)
# Input
dwiepimask_dwi=$dwiepi
# Output
dwiepimask=$case/diff/$case.dwi-epi-mask.nrrd

# UKF
# Inputs
ukf_dwi=$dwiepi
ukf_dwimask=$dwiepimask
# Output
ukf=$case/diff/$case.ukf_2T.vtk.gz

# Freesurfer to DWI registration
# Inputs
fsindwi_dwi=$dwiepi
fsindwi_t2=$t2
fsindwi_dwimask=$dwiepimask
fsindwi_fssubjectdir=$fs
# Output
fsindwi=$case/diff/$case.fs-in-dwi.nrrd

# WMQL
# Inputs
wmqltracts_tractography=$ukf
wmqltracts_wmparc=$fsindwi
wmqltracts_query=pipeline-files/wmql_query.txt
# Output
wmqltracts=$case/diff/$case.wmqltracts

# WMQL tract measures
# Inputs
tractmeasures_tracts=$wmqltracts
# Output
tractmeasures=$case/diff/$case.tractmeasures.csv

# WMQL tract volumes
# Inputs
tractvols_tracts=$wmqltracts
# Output
tractvols=$case/diff/$case.tractvols.csv

status_vars="\
    t1align \
    t2 \
    dwiraw \
    t1atlasmask \
    fs \
    dwibetmask \
    dwied \
    dwiepi \
    ukf \
    fsindwi \
    wmqltracts \
    tractmeasures \
    tractvols \
    "
