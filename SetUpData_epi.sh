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
dwipipeline_dwi=$dwiraw
# Output
dwi_ed=$case/diff/$case.dwi-Ed.nrrd  

# DWI mask
# Inputs:
dwibetmask_dwi=$dwi_ed
# Output
dwibetmask=$case/diff/$case.dwibetmask.nrrd  

# DWI epi correction
# Inputs
epi_dwi=$dwi_ed
epi_dwimask=$dwibetmask
epi_t2=$t2
# Output
dwiepi=$case/diff/$case.dwi-epi.nrrd

# DWI epi mask (for ukftractography seed map)
# Input
dwiepimask_dwi=$epi
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
fs2dwi_dwi=$dwiepi
fs2dwi_t2=$t2
fs2dwi_dwimask=$dwiepimask
fs2dwi_fssubjectdir=$fs
# Output
fsindwi=$case/diff/$case.wmparc_in_dwi.nrrd

# WMQL
# Inputs
wmql_tractography=$ukf
wmql_wmparc=$fsindwi
wmql_query=wmql_query.txt
# Output
wmql=$case/diff/$case.tracts

# WMQL tract measures
# Inputs
tractmeasures_tracts=$wmql
# Output
tractmeasures=$case/diff/$case.tractmeasures.csv

# WMQL tract volumes
# Inputs
tractvols_tracts=$wmql
# Output
tractvols=$case/diff/$case.tractvolumes.csv

status_vars="\
    t1atlasmask \
    fs \
    dwibetmask \
    dwi_ed \
    ukf \
    fsindwi \
    wmql \
    tractmeasures \
    tractvols \
    "

