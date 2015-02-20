## Summary

This an implementation of the PNL's INTRuST pipeline.  It is a top down
composition of component pipelines, and the system used to execute (evaluate)
it is the build system `redo`.  For a visual description of the pipeline, see
`doc/IntrustPipeline.pdf`.  For a visual description of the `redo` algorithm,
see `doc/RedoAlogrithm.pdf`.


## Software Requirements

The intrust pipeline will assume that you have the following software installed
on your system.  

* redo (https://github.com/mildred/redo)
* Freesurfer (http://surfer.nmr.mgh.harvard.edu/fswiki/DownloadAndInstall)
* skullstripping (https://github.com/pnlbwh/skullstripping-ants)
* tract-querier (https://github.com/pnlbwh/tract_querier)
* measureTracts.py (https://github.com/pnlbwh/measuretracts)
* Python
* ConvertBetweenFileFormats (https://github.com/BRAINSia/BRAINSTools)
* unu (http://teem.sourceforge.net/unrrdu/)
* ukftractography (https://github.com/pnlbwh/ukftractography)

The last four are provided by `NAMIcExternalProjects`, so starting from
scratch means you'll only need to install five software packages.  
Here are the steps:

1. Redo

    ```
    git clone https://github.com/mildred/redo
    cd redo && redo install
    ```

2. Freesurfer

    ```
    Follow the instructions at http://surfer.nmr.mgh.harvard.edu/fswiki/DownloadAndInstall
    ```

3. Python, ConvertBetweenFileFormats and DWIConvert (BRAINSTools), unu (teem), UKFTractography

    ```
    git clone https://github.com/BRAINSia/NAMICExternalProjects.git
    mkdir NAMICExternalProjects-build && cd NAMICExternalProjects-build 
    cmake ../NAMICExternalProjects
    make
    ```

4. tract-querier

    ```
    git clone https://github.com/pnlbwh/tract_querier
    cd tract_querier && python setup.py install
    ```

5. Skullstripping-ants

    Replace `$NEP` below with the path to your `NAMICExternalProjects-build`:

    ```
    git clone skullstripping https://github.com/pnlbwh/skullstripping-ants
    mkdir skullstripping-ants-build && cd skullstripping-ants-build
    cmake .. -DITK_DIR=$NEP/ANTS-build/ITKv4-build/ -DANTS_BUILD=$NEP/ANTS-build -DANTS_SRC=$NEP/ANTs
    make
    ```

## Setup

Once all the prerequiste software is installed, we are now ready to run the
pipeline.  First, make an instance of the pipeline by cloning this repo and
and its submodules (the component pipelines): 

    git clone --recursive https://github.com/pnlbwh/intrust-pipeline/

Second, create a `config` folder inside the repo.  

    cd intrust-pipeline && mkdir config

This folder will be your pipeline's configuration that tells the pipeline where
to find it's input, and what cases to process.  You will need to save the following
files to your config folder:

* `MASKS` - n line text file with your list of n training masks that will be used for the mask generation
* `T1s`   - n line text file with your list of n training T1's that will be used for the mask generation
* `FREESURFER` - one line text file containing path to your Freesurfer installation path
* `T1_FILEPATTERN` - one line text file containing the path to your T1's, using
    `$case` to represent the case id, e.g. /path/to/T1s/$case-T1.nrrd
* `caselist` - n line text file containing your list of n case id's that you'd like processed

Your folder structure should then look like this:

- intrust-pipeline/
    - config/
        - MASKS
        - T1S
        - FREESURFER
        - T1_FILEPATTERN
        - CASELIST
    - freesurfer-stats-pipeline/
    - freesurfer-pipline/
    - masking-pipeline/
    - all.do


Now you are ready to execute your pipeline.  To do this, simply run `redo`
in your pipeline folder:

    cd intrust-pipeline/
    redo


If you have mulitple cores, it's highly recommended to run it in parallel 
for faster execution.  To do that, use the `-j` flag:

    redo -j8  # this will use up to 8 cores
