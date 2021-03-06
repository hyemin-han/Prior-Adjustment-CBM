# Please cite these publications:

Han, H. (2020). BayesFactorFMRI: Implementing Bayesian second-level fMRI analysis with multiple comparison correction and Bayesian meta-analysis of fMRI images with multiprocessing. Journal of Open Research Software. http://doi.org/10.5334/jors.328 </p>
Han, H. (2021). A method to adjust a prior distribution in Bayesian second-level fMRI analysis. PeerJ, 9. https://doi.org/10.7717/peerj.10861

If you used image-based meta-analysis, please also cite:</p>
Han, H., & Park, J. (2019). Bayesian meta-analysis of fMRI image data. Cognitive Neuroscience, 10(2), 66–76. https://doi.org/10.1080/17588928.2019.1570103

# Testing different meta-analyses for prior determination in voxelwise Bayesian second-level fMRI analysis

To test voxelwise Bayesian second-level fMRI with a prior distribution determined by meta-analysis, run "run_meta_test.py"
Caution: before running the example run_meta_test.py listed below, modify "cores" variable according to the number of cores available on your system. For instance, if you intend to run the code with four cores (CPUs), then "cores = 4" <p></p><p></p>

1. Working memory  </p>
- DeYoung et al. (2009) </p>
    - prior determination with image-based meta-analysis </p>
./working_memory/IBM/DeYoung/ (for source code, refer to https://github.com/hyemin-han/Prior-Adjustment-BayesFactorFMRI/tree/master/Working_memory_fMRI/BayesFactorFMRI) </p> 
    - prior determination with BrainMap + Ginger ALE </p>
./working_memory/BrainMap/DeYoung/run_meta_test.py </p>
    - prior determination with NeuroQuery </p>
./working_memory/NeuroQuery/DeYoung/run_meta_test.py </p></p>

- Henson et al. (2002)</p>
    - prior determination with image-based meta-analysis</p>
./working_memory/IBM/Henson/ (for source code, refer to https://github.com/hyemin-han/Prior-Adjustment-BayesFactorFMRI/tree/master/Working_memory_fMRI_2/BayesFactorFMRI)</p>
    - prior determination with BrainMap + Ginger ALE</p>
./working_memory/BrainMap/Henson/run_meta_test.py</p>
    - prior determination with NeuroQuery</p>
./working_memory/NeuroQuery/HCP/run_meta_test.py</p></p>

- Pinho et al. (2020)</p>
    - prior determination with image-based meta-analysis</p>
./working_memory/IBM/HCP/run_meta_test.py</p>
    - prior determination with BrainMap + Ginger ALE</p>
./working_memory/BrainMap/HCP/run_meta_test.py</p>
    - prior determination with NeuroQuery</p>
./working_memory/NeuroQuery/HCP/run_meta_test.py</p></p>

2. Speech</p>
- prior determination with BrainMap + Ginger ALE</p>
./Speech/BrainMap/HCP/run_meta_test.py</p>
- prior determination with NeuroQuery</p>
./Speech/NeuroQuery/HCP/run_meta_test.py</p></p>

3. Face</p>
- prior determination with BrainMap + Ginger ALE</p>
./Face/BrainMap/Gordon/run_meta_test.py</p>
- prior determination with NeuroQuery</p>
./Face/NeuroQuery/Gordon/run_meta_test.py</p></p>

# Run your own analysis
Source code and required files are available ./src. First, copy all nii files (including mask.nii generated from frequentist analysis (e.g,. SPM)) into the same folder. Second, modify "./src/list.csv" to include names of all nii files to be analyzed. Third, modify C (mean contrast), N (noise strength; in this study, standard deviation of all analyzed voxels), R (proportion of significant voxels), cores values in ./src/run_meta_test.py. Fourth, run "run_meta_test.py"
