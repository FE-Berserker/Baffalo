function obj = AddMat(obj,Mat,varargin)
% Get material properties
% Author : Xie Yu
p=inputParser;
addParameter(p,'unit',1);
parse(p,varargin{:});
opt=p.Results;

switch opt.unit
    case 1 % tonne mm s ℃ mA mN mV
        adjust1=1e-12;
        adjust2=1;

    case 2 % kg m s ℃ A N V
        adjust1=1;
        adjust2=1e6;
end

S=obj.Sheet;
Num=size(S,1);
Mat.No=Num+1;
NewMat=[];
switch obj.SheetName
    case 'Basic'

    case 'Composite'
        NewMat.No=Mat.No;
        NewMat.Name=Mat.Name;
        NewMat.Type=Mat.Type;
        NewMat.Vf=Mat.Vf;
        NewMat.DataSource=Mat.DataSource;
        NewMat.Density=Mat.Dens/adjust1;
        NewMat.E1=Mat.E1/adjust2;
        NewMat.E2=Mat.E2/adjust2;
        NewMat.E3=Mat.E3/adjust2;
        NewMat.v12=Mat.v12;
        NewMat.v23=Mat.v23;
        NewMat.v13=Mat.v13;
        NewMat.G12=Mat.G12/adjust2;
        NewMat.G23=Mat.G23/adjust2;
        NewMat.G13=Mat.G13/adjust2;
        NewMat.a1=Mat.a1/1e-6;
        NewMat.a2=Mat.a1/1e-6;

        NewMat.F1t=Mat.allowables.F1t/adjust2;
        NewMat.F2t=Mat.allowables.F2t/adjust2;
        NewMat.F3t=Mat.allowables.F3t/adjust2;
        NewMat.F1c=Mat.allowables.F1c/adjust2;
        NewMat.F2c=Mat.allowables.F2c/adjust2;
        NewMat.F3c=Mat.allowables.F3c/adjust2;
        NewMat.F4=Mat.allowables.F4/adjust2;
        NewMat.F6=Mat.allowables.F6/adjust2;

    case 'FEA'
        Mat.Density=Mat.Density/adjust1;
        Mat.E=Mat.E/adjust2;
        Mat.a=Mat.a*1e6;
        NewMat=Mat;
    case 'Magnetic'


end
Mat=[S;struct2table(NewMat)];
obj.Sheet=Mat;
%% Save
% Get main directory
rootDir = RoTA.whereami;
save(strcat(rootDir,'\dep\framework\@RMaterial\private\',obj.SheetName,'.mat'),"Mat")

%% Print
if obj.Echo
    fprintf('Successfully add material .\n');
end

end

