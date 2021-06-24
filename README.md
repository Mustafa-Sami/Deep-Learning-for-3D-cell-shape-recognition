# Deep-Learning-for-3D-cell-shape-recognition

Step by step guide
All CPU, no GPU
Tested on Windows 10, MATLAB 2020b. Older versions of MATLAB are expected to run normally.
Required MATLAB Toolboxes:
-Image processing Toolbox
-Deep learning Toolbox

Download all the components to run the provided examples, and classification used in our manuscript.


*************************************************************************************
Binarized_DataSet.zip
This folder contains the contour polygonal 2D shapes of the 62 cells used in this study (x-y-z-t).
*************************************************************************************
Polygon_to_3D.m
This code is used to reconstruct and visualize a 3D cell from its segmented 2D x-y images over Z and T. Example image set is provided in the folder name “TrjctID_0005_MS” that contains 4D (X,Y,Z,T) binarized polygonal images that represent a single cell (cell#5). This cell was tracked over 23 time points (T3 to T25), and for each time point the number of Z planes might be different because of difficulties during time-laps live imaging, by which deeper Z planes were sometime difficult to be recorded. 
*************************************************************************************
SIM_Generator.m 
This code generates a 2D Signature Intensity Map (SIM) image from the binarized boundary images of a cell. Image dataset found in folder name “TrjctID_0005_MS” can be used and this will transform them into their 360 rotations of SIM images, RGB, of size 224×224.

*************************************************************************************
Find_Significant_Locations.zip
A robust cell (here for example cell ID 5) was tested over 33 locations for SVM insertion over ResNet-101. Group_A contains 8 SIM images of each cell in T25. Group_B contains 8 SIM images of cell ID5 in T24 only.  Locations that could produce the answer 5 for all 8 SIM images (8/8) are considered to be significant locations for SVM insertions. Results are shown in excel file: RESULT_T24_all_matching_possibilities_forExperimenting_TrjctID_0005
*************************************************************************************
*************************************************************************************
One_vs_All_Cells_in_T25.zip
First apply One_vs_Rest_of_folders.m for the folders found in Parent_Folder. This will arrange folder in one vs all fashion (Group_A for training set, and Group_B testing set) to train our ResNet-101. 
Major_SIM.m Used to select the desired SIM images from all 360 SIM images.

ResNet_101_SVM.m use B12 as insertion location for SVM over ResNet-101
*************************************************************************************
Connection_Graph.m will generate the connection map between cells at the desired stringency level.






 






