# ----------------------------------------------------------------------------
# == Software ==
export FREESURFER_HOME=/projects/schiz/ra/eli/freesurfer5.3
export ANTSSRC=/projects/schiz/software/ANTS-git/
export ANTSPATH=/projects/schiz/software/ANTS-git-build2/bin/
export ANTSPATH_epi=/projects/schiz/software/deprecated/ANTs-1.9.y-Linux/bin/
pnlutil=/projects/pnl/software/pnlutil/  # path to your 'pnlutil'

# == EPI correction ==`
EPICORRECTION=true
#EPICORRECTION=false

# == Source data ==
# --Required--
#caselist=caselist.txt  # case list text file, one case per line
#base=/projects/schiz/ra/azhu/Shanghai/
#dwiraw=${base}$case/raw/$case-dwi-B3000.nrrd
#t1align=${base}$case/strct/align-space/$case-t1w-realign.nhdr

# --Optional-- (needed for dwi epi correction)
#t2=${base}$case/raw/$case-t2w.nhdr
 
# --Alternate-- (if you have the variables set in another bash script)
source $threet/SetUpData.sh
t2=$t2masked 

# == Root Folder ==
base=/projects/schiz/pi/reckbo/intrust-pipeline-3tepi/ # path to your pipeline folder
# ----------------------------------------------------------------------------

# don't change this
source $base/pipeline-files/dataEnv.sh
