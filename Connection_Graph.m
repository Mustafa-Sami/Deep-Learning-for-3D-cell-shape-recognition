%Connection Graph
% This file will read the generated result of SIM similarity saved in the
% excel files

%**************************************************************************
Selected_Rotations = 3;  % Select strengency level between 1 to 8. 
%                        (8 = 8/8) (1 = 1/8) and so on
%**************************************************************************



Starting_Traj = 1;

Testing_Time = 25;

Number_of_Traj = 62;

Root_Main = pwd;
files_New = dir(Root_Main)

Number_of_Traj = Number_of_Traj+2;
Starting_Traj = Starting_Traj+2;


To_Best_Match_Traj   = []
From_Best_Match_Traj = []




for T = Starting_Traj:Number_of_Traj
    Traj_Directory = {files_New(T).name}
    Experiment_Address_New = strcat(Root_Main, '\', Traj_Directory);
    Experiment_Address_New = cell2mat(Experiment_Address_New);
    cd (Experiment_Address_New)  % go to the experiment address
    
    
    current_Traj = pwd;
    [filepathX, nameX, extX] = fileparts(current_Traj);
    Current_Traj = nameX(end-3:end);
    
    
    Excel_Name_B = ['From_To_Connection_T',num2str(Testing_Time),'_Percent_Experimenting_TrjctID_',Current_Traj];
    
    Full_Excel_Name = [Excel_Name_B];
    Excel_File_Data = xlsread([Full_Excel_Name, '.xls'])
    
    %Percentage = (Per/100)*15   %15 is number of repetitions
    
    
    Selected_Rotations = Selected_Rotations;   % give the direct value instead of percentage  XXXXXXXXXXXXXXX
    %%
    %Excel_File_Data_Sorted = sort(Excel_File_Data)
    
    %%
    %     From_Traj = Excel_File_Data_Sorted(1,2)
    From_Traj = Excel_File_Data(1,2)
    
    %     To_Traj = Excel_File_Data_Sorted(:,1)
    To_Traj = Excel_File_Data(:,1)
    %% 
    
    To_Best_Match_Traj = []
    
    
    for Rep = 1: Number_of_Traj  % total number of Trajs in T3
        [a_1 b_1] = mode(To_Traj)  % find most repated Traj with more or equal to Percentage
        if b_1 >=Selected_Rotations  % or define your threshold
            To_Traj(To_Traj == a_1) = []
            
            To_Best_Match_Traj(Rep, :) = (a_1)
            From_Best_Match_Traj(Rep, :) = (From_Traj)
            
        else
            To_Traj(To_Traj == a_1) = []
            
        end
        
    end
    
    if ~isempty(To_Best_Match_Traj)
        
        Cum_To_Best_Match_Traj{T} = To_Best_Match_Traj'
        Cum_From_Best_Match_Traj{T} = From_Best_Match_Traj'
        
        Excel_File_Data = []
        Excel_File_Data_Sorted = []
        To_Best_Match_Traj = []
        From_Best_Match_Traj = []
        
        cd (Root_Main)
        
        continue
        
        
    else   % connect to itself if couldn't find a best match
        
        
        Cum_To_Best_Match_Traj{T} = From_Traj'   % select self if empty
        Cum_From_Best_Match_Traj{T} = From_Traj' % select self if empty
        
        Excel_File_Data = []
        Excel_File_Data_Sorted = []
        To_Best_Match_Traj = []
        From_Best_Match_Traj = []
        
        
        cd (Root_Main)
    end
    
    
    
end


To_Mat_Cum_To_Best_Match_Traj = cell2mat(Cum_To_Best_Match_Traj(~cellfun('isempty',Cum_To_Best_Match_Traj)))  %remove empty cells then change to matrix

From_Mat_Cum_To_Best_Match_Traj = cell2mat(Cum_From_Best_Match_Traj(~cellfun('isempty',Cum_From_Best_Match_Traj)))  %remove empty cells then change to matrix


%**************************************************************************
%*** Remove zeros from the array and also in its correspondence in the another array

[~, inx] = find(To_Mat_Cum_To_Best_Match_Traj==0);  %find the index where we had zeros in To_Mat_Cum_To_Best_Match_Traj
NO_Zero_To_Mat_Cum_To_Best_Match_Traj =  To_Mat_Cum_To_Best_Match_Traj(To_Mat_Cum_To_Best_Match_Traj~=0)  %remove zeros from To_Mat_Cum_To_Best_Match_Traj

From_Mat_Cum_To_Best_Match_Traj(inx) = []; % from those trajectories located at inx
New_From_Mat_Cum_To_Best_Match_Traj = From_Mat_Cum_To_Best_Match_Traj;
%**************************************************************************




t = NO_Zero_To_Mat_Cum_To_Best_Match_Traj;

s = New_From_Mat_Cum_To_Best_Match_Traj;


[Ht Wt] = size(t);
[Hs Ws] = size(s);



To_Tag = [];
for N = 1:Ws
    To_Name = (['Cell_', num2str(s(N))]);
    To_Tag{N,1} = To_Name ;
end



From_Tag = [];
for N = 1:Wt
    From_Name = (['Cell_', num2str(t(N))]);
    From_Tag{N,1} = From_Name ;
end


G = graph(To_Tag, From_Tag);

deg = degree(G);



G = digraph(To_Tag, From_Tag);

nSizes = 10*sqrt(deg-min(deg)+1);
nColors = deg;
%plot(G,'layout','layered')

% figure
% plot(G,'MarkerSize', ...
%     nSizes,'NodeCData',...
%     nColors,'EdgeAlpha',0.9,...
%     'EdgeColor','r', ...
%     'LineWidth',2,...
%     'Interpreter', 'none', ...
%     'Layout','force')


figure
plot(G,'MarkerSize',...
    nSizes,'NodeCData',...
    nColors,'EdgeAlpha',0.9,...
    'EdgeColor','r', ...
    'LineWidth',2,...
    'Interpreter', 'none', ...
    'Layout','force')






colormap jet
colorbar


