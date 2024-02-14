## Analysis Code for Manuscript Titled "High beta power in the ventrolateral prefrontal cortex indexes human approach behavior: a case study"

The code in this repository can be used to generate all statistics and figures presented in the above manuscript. Instructions for use follow

## Step 0: Directory Organization

Download the available neural data from ____ and request the audio data from lead contact Dr. Sameer Sheth. Save these data to your local machine. 

## Step 1: PreProcessing

Run amplitude_analysis.m in the PreProcessing sub-folder to generate amplitude task analysis files. Instructions for input into MATLAB command window are output into the command window as the code runs. 

Notes: Data from all experiments are segmented using "method 1: amplitude" except for Expt1 on 2023/02/27, which uses experimental time. When asked to indicate the clinical amplitude on right and left hemisphere, refer to the top 2 subplots and enter the amplitude level corresponding to the relevant hemisphere at the end of the experiment. For further details please contact the lead contact.

Run amplitude_psds.m to generate power spectral density data.

## Step 2: Analysis

Run both mainFunc.m and mainFuncVCVS.m in the Analysis sub-folder to generate the 1/f corrected datasets.

## Step 3: Figures

Each figure script in the Figures sub-folder (Fig1, Fig2, Fig3, and Fig1supp.m) can be run independently once Step 2 is completed. When prompted to adjust the scaling in Fig2.m, enter 1, as the scaling has been optimized for the example data. If you would like to scale, you may enter 0 and adjust the color bar limits for the spectrogram in the subsequent prompt. 

## Step 4: Statistics

quickStats and quickCorrs.m in the Statistics folder can generate all the statistical outputs in supplementary tables 2-4. peakFreqs.m can generate an estimate of the center frequency of the peaks for each spectrum, the results of which are reported in table 1. Acoustic parameter statistics can be identifyied using _____.
