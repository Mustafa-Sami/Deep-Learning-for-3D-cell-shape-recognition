%Set your MATLAB path to the downloaded folder "XXX"

Deep_L_Cell_Class_Software = pwd   % Main downloaded folder name"XXXX"

%%

pathName = strcat(Deep_L_Cell_Class_Software, '\TrjctID_0005_MS');
%%
cd (pathName)

%%

%%*************************************************************************
%****************************** Inputs ************************************
Start_Z = 1; % Start from this top apical plane


End_Z = 20;  % number of Z planes to take for cell height


Traj_Cell = 3; % Time point (From T3 to T25, and found in the serial names
%of our polygonal images)


Cell_ID = 5; % Each cell has an ID number. Folder "TrjctID_0005_MS" is for
%cell number 5 and found in the serial names of our polygonal images)

%**************************************************************************
%%


Show_Apical_Plane = 0;

Start_Z = Start_Z;
End_Z = End_Z;
Traj_Cell = Traj_Cell;


[~, W] = size (Cell_ID)


for Current_Cell = 1:W
    
    Traj_Folder = Cell_ID (Current_Cell)
    Str_Traj_Folder = char(string(Traj_Folder));
    
    if Traj_Folder <10
        Traj_Folder_Name = ['TrjctID_000',Str_Traj_Folder]
        
    elseif Traj_Folder >=10 && Traj_Folder < 100
        Traj_Folder_Name = ['TrjctID_00',Str_Traj_Folder]
        
    elseif Traj_Folder >=100
        Traj_Folder_Name = ['TrjctID_0',Str_Traj_Folder]
        
    end
    

    
    % [fileName,pathName] = uigetfile('*.tif')
    % dname       = fullfile(pathName,fileName)
    % filelist = dir([fileparts(dname) filesep '*.tif']);
    % fileNames = {filelist.name}';
    %
    %
    % fileNames2 = getAllFiles2(Targeted_Cell_Folder);
    
    dirData = dir(pathName);      %# Get the data for the current directory
    dirIndex = [dirData.isdir];  %# Find the index for directories
    fileNames = {dirData(~dirIndex).name}';  %'# Get a list of the files
    
    
    
    
    
    num_frames = (numel(fileNames));
    %I = imread(fullfile(pathName, fileNames{1}));
    %imshow(I,[]);
    

    for n = 1:num_frames
        for nn = 1:100
            
            FF_Name = fileNames(n);
            FF_Name = cell2mat(FF_Name)
            %get the frame number two values just before .tif
            kk = strfind(FF_Name,'.');
            
            vv = kk(1);
            
            Frame1 = FF_Name(vv-1);
            Frame2 = FF_Name(vv-2);
            AA = ~isempty(Frame1) && all(ismember(Frame1,'0123456789'));
            if AA ==1
                Current_Frame(1) = str2num(Frame1);
            end
            
            BB = ~isempty(Frame2) && all(ismember(Frame2,'0123456789'));
            if BB ==1
                Current_Frame(2) = str2num(Frame2);
                
                Current_Frame = flip(Current_Frame);
                Current_Frame = strcat(num2str(Current_Frame(1)),num2str(Current_Frame(2)));
                Current_Frame = str2num(Current_Frame);
                break
                
            elseif BB ==0
                Current_Frame = flip(Current_Frame);
                Current_Frame = strcat(num2str(Current_Frame(1)));
                Current_Frame = str2num(Current_Frame);
                break
                %******************************************************************
                %******************************************************************
            end
        end
        
        
        %start reading the file names
        F_Name = fileNames(n);
        F_Name = cell2mat(F_Name);
        %what is the two values before the second under score
        T = strfind(F_Name,'_')
        v = T(2);
        Time1 = F_Name(v-1);
        Time2 = F_Name(v-2);
        A = ~isempty(Time1) && all(ismember(Time1,'0123456789'));
        if A ==1
            Current_Time(1) = str2num(Time1);
        end
        B = ~isempty(Time2) && all(ismember(Time2,'0123456789'))
        if B ==1
            Current_Time(2) = str2num(Time2);
            
            Current_Time = flip(Current_Time);
            Current_Time = strcat(num2str(Current_Time(1)),num2str(Current_Time(2)));
            Current_Time = str2num(Current_Time);
            
            
        elseif B ==0
            Current_Time = flip(Current_Time);
            Current_Time = strcat(num2str(Current_Time(1)));
            Current_Time = str2num(Current_Time);
            
        end
        
        %save the names in order
        
        New_F_Name{Current_Frame, Current_Time} = F_Name;
        
    end
    
    
    
    
    %******************************* END of File Names Arrangment *************
    %**************************************************************************
    
    %% Now find the signature of each colomn of New_F_Name
    
    [FRow FColumn] = size(New_F_Name);

    
    for C = Traj_Cell   
        Current_Column = New_F_Name(:,C);
        Current_Column =  Current_Column(~cellfun('isempty',Current_Column)); % remove empty cells
        
        [CH, ~] = size (Current_Column);
        
        %*********** **********************************
        if CH >= End_Z
            CH = End_Z;     
        else
            figure, msgbox('Number of frames is fewer than 20');
            break
            
        end
        %**********************************************************************
        
       % try
        for T = Start_Z:CH
            if ~isempty(Current_Column{T}) %if not empty
                Obj_BW = imread(fullfile(pathName, Current_Column{T}));
                
                Obj_BW_array(:,:,T) = Obj_BW;
     
            end
        end
%         catch
%             x = 1
            
   % end
    
    A_3D{:,:,Current_Cell} = Obj_BW_array;
    
    clear New_F_Name
    
    end

end
%*********** Add all of them to the first one **********
All = A_3D{1};
for k = 2:W
    All = imadd(double(A_3D{k}), double(All));
end
%*******************************************************

figure
set(gca,'ydir','reverse') 
rng(9,'twister')
data = All;


if Traj_Cell < 10 && Show_Apical_Plane ==1
    string_Traj_Cell = string(Traj_Cell);
    char_string_Traj_Cell = char(string_Traj_Cell);
    
memb = imread(['C:\MY_GUI\MY_GUI_ver-0\Model_images\Trachea_Planes\', 'All_T_000',char_string_Traj_Cell, '.tif']);
data(:,:,1) = memb;


elseif Traj_Cell >= 10 && Show_Apical_Plane ==1
    string_Traj_Cell = string(Traj_Cell);
    char_string_Traj_Cell = char(string_Traj_Cell);
    
memb = imread(['C:\MY_GUI\MY_GUI_ver-0\Model_images\Trachea_Planes\', 'All_T_00',char_string_Traj_Cell, '.tif']);
data(:,:,1) = memb;

end


%data(:,:,1) = memb;


data = smooth3(data,'box',1);
patch(isocaps(data,.5),...
    'FaceColor','interp','EdgeColor','none');
A1 = patch(isosurface(data,.1),...
    'FaceColor','red','EdgeColor','none');

alpha(A1, 0.5);
set(gcf, 'Renderer', 'OpenGL')


% 
view(3); 
axis vis3d normal
camlight left
colormap('jet');
lighting gouraud
