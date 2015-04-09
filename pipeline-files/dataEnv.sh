diff=$base/$case/diff
strct=$base/$case/strct

# Atlas mask
# Inputs
atlas_target=$t1align
atlas_trainingstructs=${base}/config/trainingt1s.txt
atlas_traininglabels=${base}/config/trainingmasks.txt
# Output
t1atlasmask=$strct/$case.t1atlasmask.nrrd

# Freesurfer
# Inputs
fs_t1=$t1align
fs_mask=$t1atlasmask
# Output
fs=$strct/$case.freesurfer

# DWI preprocessing
# Inputs:
dwied_dwi=$dwiraw
# Output
dwied=$diff/$case.dwi-Ed.nrrd  

# DWI mask
# Inputs:
dwibetmask_dwi=$dwied
# Output
dwibetmask=$diff/$case.dwibetmask.nrrd  

if $EPICORRECTION; then
    # DWI epi correction
    # Inputs
    dwiepi_dwi=$dwied
    dwiepi_dwimask=$dwibetmask
    dwiepi_t2=$t2
    # Output
    dwiepi=$diff/$case.dwi-epi.nrrd

    # DWI epi mask (for ukftractography seed map)
    # Input
    dwiepimask_dwi=$dwiepi
    # Output
    dwiepimask=$diff/$case.dwi-epi-mask.nrrd

    # UKF
    # Inputs
    ukf_dwi=$dwiepi
    ukf_dwimask=$dwiepimask
    # Output
    ukf=$diff/$case.ukf_2T.vtk.gz
else
    dwiepi="" # remove it from status_vars below
    # UKF
    # Inputs
    ukf_dwi=$dwied
    ukf_dwimask=$dwibetmask
    # Output
    ukf=$diff/$case.ukf_2T.vtk.gz
fi

# Freesurfer to DWI registration
# Inputs
fsindwi_dwi=$dwiepi
fsindwi_dwimask=$dwiepimask
fsindwi_fssubjectdir=$fs
# Output
fsindwi=$diff/$case.fsindwi.nrrd

# WMQL
# Inputs
wmqltracts_tractography=$ukf
wmqltracts_wmparc=$fsindwi
wmqltracts_query=pipeline-files/wmql_query.txt
# Output
wmqltracts=$diff/$case.wmqltracts

# WMQL tract measures
# Inputs
tractmeasures_tracts=$wmqltracts
# Output
tractmeasures=$diff/$case.tractmeasures.csv

# WMQL tract volumes
# Inputs
tractvols_tracts=$wmqltracts
# Output
tractvols=$diff/$case.tractvols.csv

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
