%********** Rearrange the SIM folder (Parent_Folder) to be one-vs-rest ***************

%The name of the folder should be "Parent_Folder"

Exper_Name = imageDatastore('Parent_Folder', 'IncludeSubfolders', true, 'LabelSource', 'foldernames');

A_Traj = [Exper_Name.Labels(1,:)]

CC = categories(A_Traj)

[H W] = size(CC)


h = waitbar(0,'Please wait...');

for k = 1:H
    
    T_Traj = CC{k,1}
    
    Parent_Folder = pwd
    
    %Experiment_Name = 'Experiment_X'
    
    Experiment_Name = strcat('Experimenting', '_', T_Traj)
    
    %copyfile Traj* Experiment_Name
    
    copyfile('Parent_Folder', Experiment_Name);
    
    % go to the current experiment folder
    
    s = strcat(Parent_Folder, '\', Experiment_Name)
    
    % list the name of all folders in this directory
    allImages = imageDatastore(Experiment_Name, 'IncludeSubfolders', true, 'LabelSource', 'foldernames');
    
    cd (s)
    
    All_Traj = [allImages.Labels(1,:)]
    C = categories(All_Traj)
    
    
    Testing_Traj = C{k,1}
    
    mkdir Group_B
    
    movefile (Testing_Traj, 'Group_B')
    
    
    movefile Tr* Group_A  % movefile Traj* Group_A
    
    cd (Parent_Folder)
    
    
    waitbar(k / H)
    
end

close(h)
