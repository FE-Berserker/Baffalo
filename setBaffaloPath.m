function setBaffaloPath
% Setup Baffalo path
% Author : Xie Yu

% Add main directory
rootDir = Baffalo.whereami;
addpath( rootDir );

% Add dependencies
addpath( fullfile( rootDir, 'dep') );
addpath( fullfile( rootDir, 'dep', 'framework' ) );
addpath( fullfile( rootDir, 'dep', 'framework','function') );
addpath( fullfile( rootDir, 'dep', 'framework','external') );

% Add abravibe toolbox
addpath( fullfile( rootDir, 'dep','framework','external','abravibe' ));

% SetFEMMPath
% First install FEMM in 'c:/femm42/bin/' 
% FEMM中的一些函数路径写死了，更改安装路径可能会有一些问题
addpath( fullfile( rootDir, 'dep', 'framework','femm42','mfiles' ) );

% Set ANSYS Path
ANSYS_Path='C:\Program Files\ANSYS Inc\v201\ansys\bin\winx64\ANSYS201.exe';
fileID = fopen(fullfile( rootDir, 'dep', 'framework','ANSYSPath.txt'),'w');
fwrite(fileID,ANSYS_Path);
fclose(fileID);

% SetParaViewPath
ParaViewDir="D:\005_Lib\ParaView\bin";
fileID = fopen(fullfile( rootDir, 'dep', 'framework','ParaViewPath.txt'),'w');
fwrite(fileID,strcat(ParaViewDir,'\paraview.exe'));
fclose(fileID);

% SetSimpackPath
Simpack_Path='D:\SimPack\run\bin\win64';
fileID = fopen(fullfile( rootDir, 'dep', 'framework','SimpackPath.txt'),'w');
fwrite(fileID,Simpack_Path);
fclose(fileID);

end