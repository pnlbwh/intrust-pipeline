#!/bin/bash -eu

# Set this, then run `./setup.sh`
pnlutil=/projects/pnl/software/pnlutil/


dofiles="\
default.dwi-Ed.nrrd.do         \
default.dwibetmask.nrrd.do     \
default.freesurfer.do          \
default.ukf_2T.vtk.gz.do       \
default.wmparc_in_dwi.nrrd.do  \
default.tracts.do \
"

for dofile in $dofiles; do
    [ -e "$dofile" ] || cp $pnlutil/$dofile .
done

[ -e default.t1atlasmask.nrrd.do ] || cp $pnlutil/default.atlaslabelmap.nrrd.do default.t1atlasmask.nrrd.do   
