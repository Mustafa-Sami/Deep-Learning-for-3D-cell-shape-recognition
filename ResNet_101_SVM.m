%*********************** ResNet-101-SVM ***********************************

%Go to this folder
%L:\My Publications\AI_Paper\AI_Paper_SoftWare\T25_BrightSignatures


% The training code of SIM images at T25 (one vs rest of all cells in T25 only)


Testing_Time_Point = 25;

Number_of_Signatures = 8; %(number of SIM images)

Starting_Traj = 1;

Number_of_Traj = 62;

%**************************************************************************

Root = pwd;

%******************************************************************
files = dir(Root);

Starting_Traj = Starting_Traj + 2; % because "files" strats from 3
Number_of_Traj = Number_of_Traj + 2; % because "files" strats from 3
%******************************************************************


net = resnet101();  %ResNet-101  (downloaded via Matlab Add-Ons)


inputSize = net.Layers(1).InputSize; %input image 224x224x3



for all_Traj = Starting_Traj:Number_of_Traj
    Traj_Directory = {files(all_Traj).name};
    Traj_Address = strcat(Root, '\', Traj_Directory);
    Traj_Address = cell2mat(Traj_Address)
    
    S = dir(Traj_Address);
    number_of_Subfolders = sum([S(~ismember({S.name},{'.','..'})).isdir]);
    
    Experiment_Address = strcat(Root, '\', Traj_Directory);
    Experiment_Address = cell2mat(Experiment_Address);
    cd (Experiment_Address)  % go to the experiment address
  
    All_Results = [];
  
    try
        
        %*******************************************************
        %                  Start CNN training
        %*******************************************************
        %                 layers(23) = fullyConnectedLayer(number_of_Subfolders);
        %                 layers(25) = classificationLayer;
        
        Traj_Dir = cell2mat(Traj_Directory);
        
        imdsTrain = imageDatastore('Group_A','IncludeSubfolders',true,'LabelSource','foldernames');
        imdsTest = imageDatastore('Group_B','IncludeSubfolders',true,'LabelSource','foldernames');
          
        numTrainImages = numel(imdsTrain.Labels);
        idx = randperm(numTrainImages,16);

        augimdsTrain = augmentedImageDatastore(inputSize(1:2),imdsTrain);
        augimdsTest = augmentedImageDatastore(inputSize(1:2),imdsTest);

        layer = 'res4b4_branch2a';  % Founded significant location in ResNet-101 for SVM insertion

        %%
        
        featuresTrain = activations(net,augimdsTrain,layer,'OutputAs','rows');
        featuresTest = activations(net,augimdsTest,layer,'OutputAs','rows');
        
        %
        YTrain = imdsTrain.Labels;
        YTest = imdsTest.Labels;
        %
    
        t = templateSVM('Standardize',true);
        %t = templateSVM('BoxConstraint', 1, 'KernelFunction', 'rbf');
        
        rng(1) % for reproducibility Dec 2019
        
        classifier = fitcecoc(featuresTrain,YTrain,'Learners',t);
  
        % tree  ---> far + noisy answer
        % naivebayes  took very long time
        % knn ---> far + noisy answer
        % linear ---> same to SVM for traj 5
        % kernel took very long time
   
        clc
        
        YPred = predict(classifier,featuresTest);

        idx = 1:Number_of_Signatures;
        
        for i = 1:numel(idx)
            
            label = char(YPred(idx(i)));
            
            Best_Match =  str2num(label(end-3:end));
            
            All_labels(i,1) = Best_Match
        end
        
        %%
        Head_Tag = vertcat({['AllDegreeSignature_of'   Traj_Dir]});
        
        Res = num2cell(All_labels);
        New_Results = [Head_Tag; Res];
        
        %     % Save to Excel file
        cd (Experiment_Address)
        xlswrite(['T' num2str(Testing_Time_Point) '_all_matching_possibilities_for' Traj_Dir], New_Results, 1)
        
        %**********************************************************
        %**********************************************************
        
        Current_Root =  pwd;
        %
        [filepathX, nameX, extX] = fileparts(Current_Root);
        %%
        Testing_Traj = sscanf(nameX, 'Experimenting_TrjctID_%d');
        %
        From_Array = repmat(Testing_Traj,Number_of_Signatures,1);
        %%
        From_To_Connection_Matrix = [All_labels, From_Array];
        
        xlswrite(['From_To_Connection_T' num2str(Testing_Time_Point) '_Percent_' Traj_Dir], From_To_Connection_Matrix, 1)
        
    end
    
    clear From_To_Connection_Matrix
    clear New_Results
    clear All_labels
    cd (Root)
    
end


%**************************************************************************

%% template = templateSVM('Standardize',true)
% 'BoxConstraint' — 1 (default) 
% 'CacheSize' — 1000 (default) 
% 'ClipAlphas' — true (default) 
% 'DeltaGradientTolerance' — 0 if the solver is ISDA (for example, you set 'Solver','ISDA')
% 'GapTolerance' -0 (default) 
% 'IterationLimit' — 1e6 (default) 
% 'KernelFunction' — 'linear'	Linear kernel, default for two-class learning	
% 'KernelOffset' -0.1 if the solver is ISDA (that is, you set 'Solver','ISDA')
% 'KernelScale' — 1 (default) 
% 'KKTTolerance' — Karush-Kuhn-Tucker complementarity conditions violation tolerance
% 1e-3 if the solver is ISDA (for example, you set 'Solver','ISDA')
% 'NumPrint' — 1000 (default) 
% 'OutlierFraction' —0 (default) 
% 'SaveSupportVectors' —true (default)  Store support vectors, their labels, and the estimated α coefficients
% 'ShrinkagePeriod' — 0 (default) 
% 'Solver' — The default value is 'ISDA' 
% 'Standardize' — false (default) 
% 'Verbose' — 0 (default) 














