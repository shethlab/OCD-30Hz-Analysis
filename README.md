## Analysis Code for Manuscript Titled "High beta power in the ventrolateral prefrontal cortex indexes human approach behavior: a case study"

The code in this repository can be used to generate all statistics and figures presented in the above manuscript. Instructions for use follow

# System Requirements
## Hardware requirements
This package requires only a standard computer with enough RAM to support the in-memory operations. Estimated code execution times were determined on a system with a MacBook Pro Apple M2 Chip (16GB Memory) running MacOS Ventura 13.0.

## Software requirements
## OS Requirements
This package is supported for MacOS 13.0. The package has been tested on the following systems:
+ MacOS 13.0

## Python Dependencies
```
numpy == 1.24.3
pandas == 2.2.0
pytorch == 2.2.0
matlabengine == 23.2.1
scikit-learn == 1.4.0
statsmodels == 0.14.1
matplotlib == 3.8.2
plotly == 5.14.1
kaleido == 0.1.0
```

## MATLAB Dependencies
```
System requirements:
All MATLAB code run on version 2023a using MacOS 13.0
[Mac Requirements: https://www.mathworks.com/content/dam/mathworks/mathworks-dot-com/support/sysreq/files/system-requirements-release-2023a-mac.pdf
](https://www.mathworks.com/content/dam/mathworks/mathworks-dot-com/support/sysreq/files/system-requirements-release-2023a-macintosh.pdf)

Installation guide:
Mathworks MATLAB 2023a: https://www.mathworks.com/downloads
    ~30 minute installation
Respective version of the Signal Processing Toolbox: https://www.mathworks.com/products/signal.html
    ~5 minute installation
```

# Code Demo
Demo datasets and and a script to generate demo outputs are located in the DEMO folder. Run the demo script section-by-section to view how each step of analysis is conducted. For all figures, axis and other aesthetic adjustments were completed on Adobe Illustrator. 


## 1. Data Preparation
Run amplitude_analysis.m in the PreProcessing sub-folder to generate amplitude task analysis files. Instructions for input into MATLAB command window are output into the command window as the code runs. When prompted, you will have to enter the "clinical amplitudes" for the left and right hemisphere. A small figure will appear showing amplitude for each hemisphere. Select the last value of amplitude that appears in the plot (the clinical amplitude is defined to be the amplitude at the end of the experiment, regardless of what changes occur during the experiment).

Run amplitude_psds.m to generate power spectral density data.

Data from all experiments are segmented using "method 1: amplitude" except for data from Expt1 on 2023/02/27.

    -Estimated runtime: 5-10s per date depending on data quantity for amplitude_analysis
    -Estimated runtime: 5s per date depending for amplitude_psds

## 2. Analysis
Run both mainFunc.m and mainFuncVCVS.m in the Analysis sub-folder to generate the 1/f corrected datasets. Ensure the file paths and directories are set appropriately. The meaning of various inputs is commented into the code, should you wish to change them. Currently this code is set up to accomodate only the number of dates in our study. However the initial sections of these scripts can be modified to accomodate more or less dates for analysis.

    - Estimated runtime: several minutes, as this code loops through all the patients worth of data


# Figures and Tables

## Figures
Each figure script in the Figures sub-folder (Fig1, Fig2, Fig3, and Fig1supp.m) can be run independently once Step 2 is completed. When prompted to adjust the scaling in Fig2.m, enter 1, as the scaling has been optimized for the example data. If you would like to scale, you may enter 0 and adjust the color bar limits for the spectrogram in the subsequent prompt. 

    - Estimated runtime: 3-5 seconds per figure.


 
## Tables
quickStats and quickCorrs.m in the Statistics folder can generate all the statistical outputs in supplementary tables 2-4. peakFreqs.m can generate an estimate of the center frequency of the peaks for each spectrum, the results of which are reported in table 1. Acoustic parameter statistics can be identifyied using _____.

    - Estimated runtime: 3-5 seconds per script.

