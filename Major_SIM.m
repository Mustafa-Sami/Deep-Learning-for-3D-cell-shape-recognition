% Determin the Major SIM  images that need to use from all 360 SIM images
%In our case we used only 8 of SIM images

Main_Rot = [1 45 90 135 180 225 270 315];  



pathName = pwd;
pathName = [pathName '\']
AllNames = getAllFiles(pathName);


All_360_SIM_Images =[pathName,'TrjctID_0005'];

cd (All_360_SIM_Images)

Current_Root = pwd;

dirName = Current_Root;

fileList = getAllFiles(dirName);
%

Main_Eight = [];

for i = 1:8
    iT = Main_Rot(i)
    Targ = string(fileList(iT));
    Main_Eight{iT} = imread(Targ);
end
%
which_dir = dirName;
dinfo = dir(which_dir);
dinfo([dinfo.isdir]) = [];   %skip directories
filenames = fullfile(which_dir, {dinfo.name});
delete( filenames{:} )

%


for ii = 1:8
    iiT = Main_Rot(ii)
    ImageName = dirName;
    [filepath,name,ext] = fileparts (fileList{iiT,1})
    
    file = fullfile(dirName,name);
    %imwrite(Main_Eight{1,1},file, 'tif');
    
    imwrite(Main_Eight{1,iiT},[name,'.tif']);
    
end
%end