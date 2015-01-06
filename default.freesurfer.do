#!/bin/bash -e

source util.sh

[ ! -d "$1" ] || { echo "'$1' already exists and is out of date, delete it if you would like to recompute/update it"; exit 0; }
case=${2##*/}
checkset_local_SetUpData fs_t1
redo_ifchange_vars fs_t1

log "Run freesurfer for case '$case' to make '$1'"
if [ -n "$fs_mask" ]; then
    redo_ifchange_vars fs_mask
    run fs.sh -f -i "$fs_t1" -m "$fs_mask" -o $3 
else
    skullstripflag=""
    if [[ -n "$fs_skullstrip" && "$fs_skullstrip" ]]; then
        skullstripflag="-s"
    fi
    run fs.sh -f $skullstripflag -i "$fs_t1" -o $3
fi
log_success "Made '$1'"
