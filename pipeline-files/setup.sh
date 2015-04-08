#!/bin/bash -eu

SCRIPT=$(readlink -m $(type -p "$0"))
scriptdir=$(dirname $SCRIPT)
targetdir=$(dirname "$scriptdir")

setupdata="$targetdir/config/SetUpData.sh" 
#if [ ! -f "$setupdata" ]; then
    #echo "First create your '$setupdata'."
    #echo "(There's an example template in 'pipeline-files/', see README for details)"
    #exit 1
#fi
case=000 && source $setupdata
[ -e "$targetdir/SetUpData.sh" ] || ln -s $setupdata $targetdir

dofiles="\
default.dwi-Ed.nrrd.do         \
default.dwibetmask.nrrd.do     \
default.freesurfer.do          \
default.ukf_2T.vtk.gz.do       \
default.fsindwi.nrrd.do  \
default.wmqltracts.do \
default.tractmeasures.csv.do \
default.tractvols.csv.do \
"

for dofile in $dofiles; do
    [ -e "$targetdir/$dofile" ] || cp $pnlutil/$dofile $targetdir
done

[ -e $targetdir/default.t1atlasmask.nrrd.do ] || cp $pnlutil/default.atlaslabelmap.nrrd.do $targetdir/default.t1atlasmask.nrrd.do   

if $EPICORRECTION; then 
    [ -e $targetdir/default.dwi-epi.nrrd.do ] || cp $pnlutil/default.dwi-epi.nrrd.do $targetdir
    [ -e $targetdir/default.dwi-epi-mask.nrrd.do ] || cp $pnlutil/default.dwi-epi-mask.nrrd.do $targetdir
fi
