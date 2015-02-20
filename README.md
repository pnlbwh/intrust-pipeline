## Summary

This an implementation of the PNL's INTRuST pipeline using the lightweight
build system [`redo`](https://github.com/mildred/redo).  To run the pipeline,
you specify the file paths of your T1's and DWI's, and then ask the pipeline to
generate the target output you are interested in.

## Software Requirements

The intrust pipeline requires the following software be installed on your on
your system.  

### System Software 

These should already be installed on standard linux/mac distributions. 

* Bash
* Python

### Software Packages
* redo (https://github.com/mildred/redo)
* pnlutil (https://github.com/pnlbwh/pnlutil)
* Freesurfer (http://surfer.nmr.mgh.harvard.edu/fswiki/DownloadAndInstall)
* skullstripping (https://github.com/pnlbwh/skullstripping-ants)
* tract-querier (https://github.com/pnlbwh/tract_querier)
* measureTracts.py (https://github.com/pnlbwh/measuretracts)
* FSL bet (http://fsl.fmrib.ox.ac.uk/fsl/fslwiki/FSL)
* ConvertBetweenFileFormats (https://github.com/BRAINSia/BRAINSTools)
* TEEM unu (http://teem.sourceforge.net/unrrdu/)
* ukftractography (https://github.com/pnlbwh/ukftractography)

The last three are provided by
[NAMICExternalProjects](https://github.com/BRAINSia/NAMICExternalProjects.git),
so starting from scratch means you'll need to install eight software packages.
Here are the install instructions for each one.

1. Redo

    ```
    git clone https://github.com/mildred/redo
    cd redo 
    redo install
    ```

2. pnlutil

    ```
    git clone https://github.com/pnlbwh/pnlutil
    # Add 'pnlutil' directory to your PATH
    ```

3. Freesurfer

    ```
    # Follow the instructions at http://surfer.nmr.mgh.harvard.edu/fswiki/DownloadAndInstall
    ```

4. Python, ConvertBetweenFileFormats (BRAINSTools), unu (teem), bet, UKFTractography

    ```
    git clone https://github.com/BRAINSia/NAMICExternalProjects.git
    mkdir NAMICExternalProjects-build && cd NAMICExternalProjects-build 
    cmake ../NAMICExternalProjects
    make
    ```

5. Skullstripping-ants

    Replace `$NEP` below with the path to your `NAMICExternalProjects-build`:

    ```
    git clone skullstripping https://github.com/pnlbwh/skullstripping-ants
    mkdir skullstripping-ants-build && cd skullstripping-ants-build
    cmake .. -DITK_DIR=$NEP/ANTS-build/ITKv4-build/ -DANTS_BUILD=$NEP/ANTS-build -DANTS_SRC=$NEP/ANTs
    make
    ```

6. tract-querier

    ```
    git clone https://github.com/pnlbwh/tract_querier
    cd tract_querier 
    python setup.py install
    ```

7. measureTracts

    ```
    git clone https://github.com/pnlbwh/measuretracts
    # Add 'measuretracts' directory to your PATH
    ```

8. FSL bet

    ```
    # Follow install instructions at
    # http://fsl.fmrib.ox.ac.uk/fsl/fslwiki/FSL
    ```


## Setup

Once all the prerequiste software is installed you're ready to make an instance
of the pipeline for your project.  First, clone this repo:

    git clone https://github.com/pnlbwh/intrust-pipeline

Second, edit line 4 of `setup.sh` to replace the filepath with the one where
you you nstalled `pnlutil` above, and then run the script.  This copies the
necessary pipeline .do scripts from `pnlutil` to the pipeline repo.

    # edit setup.sh with e.g. pnlutil=~/software/pnlutil
    ./setup.sh

Next, create the text files `trainingt1s.txt` and `trainingmasks.txt`, with
each line being the absolute file path to your t1's and masks that you'd like
to use to generate the rest of your t1 masks.  I suggest 10 or 20 cases.

Finally, create your own `SetUpData_inputs.sh`.  This defines the input T1's,
DWI's, (and optionally T2's) and software specific to your project and system.
Use `SetUpData_inputs.sh.example` as a guide.

    cp SetUpData_inputs.sh.example SetUpData_inputs.sh
    # edit SetUpData_inputs.sh


## Run

Now you are ready to execute the pipeline.  You are free to run the complete pipeline or just parts of
it on your whole caselist or subsets of your caselist.

Examples:

    missing t1atlasmask  # Print a list of the atlas masks not yet generated
    redo `missing t1atlasmask`  # Generate all the missing atlas masks for your caselist 
    completed t1atlasmask  # Print a list of the completed t1 atlas masks
    redo `missing fs | head -n 2`  # Run freesurfer for the first 2 cases not yet run
    redo `missing dwi_ed` # Generate eddy current corrected DWI's
    redo `missing dwibetmask`  # Generated DWI masks
    redo `missing ukf` # Generate whole brain tractography 
    redo `missing fsindwi`  # Generate freesurfer labelmap in DWI space
    redo `missing wmql` # Generate wmql tracts (uses the queries in wmql_query.txt)

You don't need to run these separately, any missing dependencies will be
generated automatically.  For example, running 

    redo `missing wmql` 

without any of the preceding commands will first generate `fsindwi` and `ukf`,
which in turn will first generate `dwi_ed`, `dwibetmask`, and `fs`, which in
turn will first generate `t1atlasmask`.  So this runs the whole pipeline.

More Examples:

    all -f caselist_qc_ukf.txt ukf  # Print a list of tractography files for cases in 'caselist_qc_ukf.txt'
    redo `all -f caselist_qc_ukf.txt ukf` # Generate tractography files for cases only in 'caselist_qc_ukf.txt'
    all dwi_ed 001 002 003  # Print a list of DWI's for cases 001, 002, 003
    redo `all dwi_ed 001 002 003`  # Generate DWI's for cases 001, 002, 003

To log the progress of the pipeline:

    logstatus  # saves status to 'statuslog.csv'

To show the last logged entry in `statuslog.csv`:

    showstatus

To visually inspect the results and save the cases that pass quality control to `caselist_qcpass_<var>`:

    qc dwi_ed fsindwi  # Loads each case's DWI and freesurfer map into Slicer, one case at a time
    qc -l "001 002" t1align fs  # Load t1 and freesurfer map for cases 001 and 002
    qc -f caselist_notchecked_wmql dwi_ed wmql  # Load DWI's and wmql tracts for cases in 'caselist_notchecked_wmql'

Finally, to generate a montage of image slices with a labelmap overlay:

    qclabels t1align t1atlasmask t1atlasmask.png
    qclabels dwi_ed fsindwi fsindwi.png
    # see 'qclabels -h' on how to adjust the slice axis and dimension size
