function obj = DeleteMat(obj,num)
% Delete material
% Author : Xie Yu

S=obj.Sheet;
Num=size(S,1);
Mat=S;
Mat(num,:)=[];
Mat.No=(1:Num-1)';
obj.Sheet=Mat;

%% Save
% Get main directory
rootDir = RoTA.whereami;
save(strcat(rootDir,'\dep\framework\@RMaterial\private\',obj.SheetName,'.mat'),"Mat")

%% Print
if obj.Echo
    fprintf('Successfully delete material .\n');
end

end

