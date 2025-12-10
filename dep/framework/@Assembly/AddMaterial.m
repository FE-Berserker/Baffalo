function obj=AddMaterial(obj,opt)
% Add Material to Assembly
% Author : Xie Yu
num=GetNMaterial(obj)+1;

obj.Material{num,1}.Name=[];
obj.Material{num,1}.table=[];
obj.Material{num,1}.TBlab=[];
obj.Material{num,1}.TBtable=[];
obj.Material{num,1}.FC=[];
obj.Material{num,1}.FCType=[];

Num=size(opt,1);
for i=1:Num
    if isfield(opt,'Name')
        obj.Material{num,1}.Name=opt.Name;
    end

    if isfield(opt,'table')
        % Check missing values
        opt.table=opt.table(~ismissing(opt.table(:,2)),:);
        obj.Material{num,1}.table=opt.table;
    end

    if isfield(opt,'TBlab')
        obj.Material{num,1}.TBlab=opt.TBlab;
    end

    if isfield(opt,'TBtable')
        obj.Material{num,1}.TBtable=opt.TBtable;
    end

    if isfield(opt,'FC')
        obj.Material{num,1}.FC=opt.FC;
    end

    if isfield(opt,'FCType')
        obj.Material{num,1}.FCType=opt.FCType;
    end

end

%% Print
if obj.Echo
    fprintf('Successfully add Material . \n');
end

end