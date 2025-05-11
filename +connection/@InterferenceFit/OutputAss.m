function obj=OutputAss(obj,varargin)
% Output Assembly of InterferenceFit
% Author : Xie Yu
p=inputParser;
addParameter(p,'U','Umin');% Umin Umax Umean
parse(p,varargin{:});
opt=p.Results;

Ass=Assembly(obj.params.Name,'T_Ref',obj.params.T_Ref,'Echo',0);
% Create Shaft
inputshaft.Length = [2*obj.input.LF;3*obj.input.LF;5*obj.input.LF];
inputshaft.ID = [[obj.input.Dil,obj.input.Dil];[obj.input.Dil,obj.input.Dil];[obj.input.Dil,obj.input.Dil]];
inputshaft.OD = [[obj.input.DF,obj.input.DF];[obj.input.DF,obj.input.DF];[obj.input.DF,obj.input.DF]];
paramsshaft.Echo = 0;
obj1 = shaft.Commonshaft(paramsshaft, inputshaft);
obj1 = obj1.solve();
% Create Hub
inputshaft.Length = obj.input.LF;
inputshaft.ID = [obj.input.DF,obj.input.DF];
inputshaft.OD = [obj.input.DaA,obj.input.DaA];
obj2 = shaft.Commonshaft(paramsshaft, inputshaft);
obj2 = obj2.solve();

position=[-2.5*obj.input.LF,0,0,0,0,0];
Ass=AddPart(Ass,obj1.output.SolidMesh.Meshoutput,'position',position);
position=[-0.5*obj.input.LF,0,0,0,0,0];
Ass=AddPart(Ass,obj2.output.SolidMesh.Meshoutput,'position',position);

%ET
ET1.name='185';ET1.opt=[];ET1.R=[];
AddET(Ass,ET1);
ET2.name='173';ET2.opt=[10,2];ET2.R=[];
AddET(Ass,ET2);
ET3.name='170';ET3.opt=[];ET3.R=[];
Ass=AddET(Ass,ET3);
Ass=SetET(Ass,1,1);
Ass=SetET(Ass,2,1);
%  Material
%  Shaft
mat1.name=obj.input.Shaft_Mat.Name;
mat1.table=["DENS",obj.input.Shaft_Mat.Dens;"EX",obj.input.Shaft_Mat.E;...
    "NUXY",obj.input.Shaft_Mat.v;"ALPX",obj.input.Shaft_Mat.a];
Ass=AddMaterial(Ass,mat1);
% Hub
mat2.name=obj.input.Hub_Mat.Name;
mat2.table=["DENS",obj.input.Hub_Mat.Dens;"EX",obj.input.Hub_Mat.E;...
    "NUXY",obj.input.Hub_Mat.v;"ALPX",obj.input.Hub_Mat.a];
Ass=AddMaterial(Ass,mat2);
% Fric
mat3.table=["Mu",obj.params.uf];
Ass=AddMaterial(Ass,mat3);
Ass=SetMaterial(Ass,1,1);
Ass=SetMaterial(Ass,2,2);
%% Define contacts
Ass=AddCon(Ass,1,102);
Ass=AddTar(Ass,1,2,201);
Ass=SetConMaterial(Ass,1,3);
switch opt.U
    case "Umin"
        option=[10,obj.output.Uwmin/2];
    case "Umax"
        option=[10,obj.output.Uwmax/2];
    case "Umean"
        option=[10,(obj.output.Uwmax+obj.output.Uwmin)/4];
end
Ass=SetConRealConstants(Ass,1,option);
Ass=SetConET(Ass,1,2);
Ass=SetTarET(Ass,1,3);
% Temperature
Ass=AddTemperature(Ass,1,obj.params.Temperature(1,1));
Ass=AddTemperature(Ass,1,obj.params.Temperature(1,2));
% Boundary
Bound1=[1,1,1,0,0,0];
Ass=AddBoundary(Ass,1,'No',301);
Ass=SetBoundaryType(Ass,1,Bound1);
if obj.input.Dil~=0
    Ass=AddBoundary(Ass,1,'No',304);
else
    Ass=AddBoundary(Ass,1,'No',302);
end
Ass=SetBoundaryType(Ass,2,Bound1);
opt.ANTYPE=0;
Ass=AddSolu(Ass,opt);
obj.output.Assembly=Ass;

% Print
if obj.params.Echo
    fprintf('Successfully ouput assembly.\n');
end
end


