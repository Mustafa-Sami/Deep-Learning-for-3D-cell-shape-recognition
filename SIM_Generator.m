%**************************************************************************
%**************************************************************************
%******************************** SIM Generator ***************************


%Generating Signature Intensity Map (SIM)image of a 3D cell.
%This code generates a Signature Intensity Map (SIM) images from images found in  "TrjctID_0005_MS" folder

%Example of a cell (cell#5) presented in a binarized polygonal 2D images over the
%depth 20 Z and time.

%x-y-z-t Images found in folder name "TrjctID_0005_MS"  for serial time points from T3 to T25


% T3 is 1st time point: from (trjID5_T3_cID84_Z5) to   (trjID5_T3_cID84_Z24)
% T4 is 2nd time point: from (trjID5_T4_cID5_Z5)  to   (trjID5_T4_cID5_Z24)
%  :
%  :
%  :
% T25 is 25th time point: from (trjID5_T25_cID76_Z5)  to   (trjID5_T25_cID76_Z24)


%**************************************************************************
%**************************************************************************

%Set your MATLAB path to the downloaded folder

Deep_L_Cell_Class_Software = pwd   % Main downloaded folder name"XXXX"

%%

pathName = strcat(Deep_L_Cell_Class_Software, '\TrjctID_0005_MS');
%%
cd (pathName)

%% ************************************************************************
%**************************************************************************



Signature_Depth_Z = 20;
Signature_Time_Point_T = 3;


NewSize_H = 224;    %required image size for ResNet-101
NewSize_W = 224;


pathName = pwd;
pathName = [pathName '\']
AllNames = getAllFiles(pathName);


Binarized_Z_Images =[pathName];

cd (Binarized_Z_Images)


%**************************************************************************
%******************** File Names Arrangment *******************************

%[fileName,pathName] = uigetfile('*.tif')

pathName2 = pwd;
pathName2 = [pathName2 '\']
AllNames2 = getAllFiles(pathName2);
%%
[filepath,name,ext] = fileparts(AllNames{1,1})

fileName = [name,ext];


dname       = fullfile(pathName2,fileName)
filelist = dir([fileparts(dname) filesep '*.tif']);
fileNames = {filelist.name}';
num_frames = (numel(filelist));
I = imread(fullfile(pathName2, fileNames{1}));
%imshow(I,[]);




for n = 1:num_frames
    for nn = 1:100
        FF_Name = fileNames(n);
        FF_Name = cell2mat(FF_Name);
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
    B = ~isempty(Time2) && all(ismember(Time2,'0123456789'));
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
%figure


for C = Signature_Time_Point_T   % Time Point analyize. Example T3
    Current_Column = New_F_Name(:,C);
    Current_Column =  Current_Column(~cellfun('isempty',Current_Column)); % remove empty cells
    
    [CH, ~] = size (Current_Column);
    
    %*********** Added September 4, 2017 **********************************
    %     if CH >=Signature_Depth_Z
    %         CH =Signature_Depth_Z;     % 1:CH to take all, but we want to take the commen Z
    %     else
    %        figure, msgbox('Number of Z frames less than 20');
    %        break
    %
    %     end
    %**********************************************************************
    
    
% x1 = XCenter{1}
% x2 = XCenter{2}
% 
% y1 = YCenter{1}
% y2 = YCenter{2}
% 
% radius = sqrt( (y2-y1)^2 + (x2-x1)^2 )
% 
% theta = atan2d( y2-y1, x2-x1 )
% Obj_BW1 = imread(fullfile(pathName, Current_Column{1}));
% Obj_BW2 = imread(fullfile(pathName, Current_Column{2}));
% 

    
    
    
    for T = 1:Signature_Depth_Z
        if ~isempty(Current_Column{T}) %if not empty
            Obj_BW = imread(fullfile(pathName2, Current_Column{T}));
            
            Obj_BW = Obj_BW(:,:,1);
            Obj_BW = im2bw(Obj_BW);
            %imshow(Obj_BW);
            
            s  = regionprops(Obj_BW, 'centroid');
            XCenter{T} = s.Centroid(1);
            YCenter{T} = s.Centroid(2);
            
            bSq = bwboundaries(Obj_BW, 'noholes');
            [distSq, angleSq] = Full_signature(bSq{1});
            
            % *************************************************************
            % ************* Visualization of the processes ****************
            % *************************************************************
            subplot(1,4,2)
            title('2D Shape Signature');
            grid on
            plot(angleSq, distSq)
            axis ([0 500 0 100]);
            drawnow
            hold on
            M(T) = getframe;
            %subplot(1,4,1)
            %imshow(Obj_BW,[]);
            %             title(['Cell Tracking_', Current_Column{T}], 'Interpreter','none');
            %             hold on
            %             plot(XCenter{T}, YCenter{T}, 'r*')
            %             text('String',['Frame # ',num2str(T)],...
            %                 'Position',[XCenter{T}-10 YCenter{T}-30 1],'color','red');
            %             hold off
            %             drawnow
            %             hold off
            %***************** Idea # 2 ***********************
            x = angleSq';
            v = distSq';
            xq = 1:1:360;             % Theta (idealy it should be 360)
            vq = interp1(x,v,xq);     % find the interpolations
            ThreeD_image2(T,:) = vq;
            data (:,:,T) = Obj_BW;
            
            
            % subplot(1,4,3)
            % imshow(ThreeD_image,[],'InitialMagnification','fit')
            
            subplot(1,4,3)
            imshow(ThreeD_image2,[],'InitialMagnification','fit')
            title('2D Image that represents the shape of 3D volume of a single cell');
            
            
            ALL_Signatures{C,1} = ThreeD_image2;
        end
        
    end
    
    
    
end

% Now make one big image of all signatures
Old_a = ALL_Signatures{1,1};
%
[M N] = size(ALL_Signatures);

for k = 1:M
    New_a = ALL_Signatures{k,1};
    New_a = vertcat(New_a,Old_a);
    
    Old_a = New_a;
    
end

%figure, imshow(New_a,[])
%

%**************************************************************************
%******************************** 360 shiffted images**********************

ThreeD_image2 = New_a;

%go to every raw and shift array once
[Row Col] = size(ThreeD_image2);
NEW_ThreeD_image2 = zeros(size(ThreeD_image2));
%


%creat new folder
% mkdir('Full_Round_ThreeD');
% cd('Full_Round_ThreeD');  %go to the new folder before saving the images

%delete *.tif                 %% Delete all of the binary images before making the signature images in this folder

if C ==3
    try
        rmdir(pathName2,'s')
    end
end

for c = 1:Col
    for k = 1:Row
        R_1 = ThreeD_image2(k,:);
        R_1 = shiftLeft(R_1);
        NEW_ThreeD_image2(k,:) = R_1;
    end
    %save the image
    Strng_Signature_Time_Point_T = num2str(Signature_Time_Point_T);
    if ((c > 0) & (c < 10))
        
        FileName_A = ['T', Strng_Signature_Time_Point_T, '_000'];
        
    elseif ((c >= 10) & (c < 100))
        FileName_A = ['T', Strng_Signature_Time_Point_T, '_00'];
        
        
    elseif ((c >= 100) & (c < 1000))
        FileName_A = ['T', Strng_Signature_Time_Point_T, '_0'];
    end
    %go to the saving folding
    FileName_B = num2str(c);
    FileName_C = '.tif';
    fullName = [FileName_A,FileName_B,FileName_C];
    t = Tiff(fullName, 'w');
    
    
    
    
    
    %***************************************************************
    %************ Enhance Signature Intensity **********************
    
    
    % To convert double to gray you have two choices
%     if Adjust_Signature == 1 %Choice 1  direct convert to gray image
%         
%         ThreeD_image2 = uint8(ThreeD_image2);
%         
%         %OR Choice 2  this rescale gray intensities from 0 to 255
%     else
        ThreeD_image2 = uint8( (double(ThreeD_image2) - double(min(ThreeD_image2(:)))) /(double(max(ThreeD_image2(:))) - double(min(ThreeD_image2(:)))) * 255 );
        
%     end
    
    %****************************************************************
    
    
    
    
    
    %*****************************************************
    %************ RGB Signature **********************
    
%     if RGB_Signature ==1
        ThreeD_image2 = cat(3, ThreeD_image2,ThreeD_image2,ThreeD_image2);
        
%     elseif RGB_Signature ==0
%         ThreeD_image2 = ThreeD_image2;
%     end
%     
    %********************************************************

    
    
    %************ Resizing Signature **********************
    
%     if Resize_Signature == 1
        ThreeD_image2 = imresize(ThreeD_image2,[NewSize_H, NewSize_W]);  % Resize
        
%     elseif Resize_Signature == 0
%         ThreeD_image2 = ThreeD_image2;
%     end
    %**********************************************************
    
    
    
    imwrite(ThreeD_image2, fullName);
    
    
    %*******************************************
    ThreeD_image2 = NEW_ThreeD_image2;
    
    
end




clear all;
%close all;
clc

























