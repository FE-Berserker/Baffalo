function obj=Extrude2Face(obj,nn,depth,varargin)
p=inputParser;
addParameter(p,'numSteps',[]);
addParameter(p,'pointSpacing',[]);
addParameter(p,'patchType','quad');
addParameter(p,'dir',1);
addParameter(p,'closeLoopOpt',1);
parse(p,varargin{:});
opt=p.Results;

if ~isempty(opt.numSteps)
    controlParameterStruct.numSteps=opt.numSteps;
end
if ~isempty(opt.pointSpacing)
    controlParameterStruct.pointSpacing=opt.pointSpacing;
end
controlParameterStruct.depth=depth;
controlParameterStruct.patchType=opt.patchType;
controlParameterStruct.dir=opt.dir;
controlParameterStruct.closeLoopOpt=opt.closeLoopOpt;

%% COMPUTE CURVE LENGTH
Vc=obj.Points{nn,1}.P;
D=max(pathLength(Vc)); %Compute curve length for point sampling
numPoints=size(Vc,1);
%% Parse input

%Check what mode
if isfield(controlParameterStruct,'pointSpacing') && isfield(controlParameterStruct,'numSteps')
    error('Either specify pointSpacing or numSteps, not both.');
end

%Check extrudeMode, numSteps and pointSpacing settings
if isfield(controlParameterStruct,'numSteps')
    extrudeMode=1;
    controlParameterStruct.numSteps=controlParameterStruct.numSteps+1;
else
    extrudeMode=0;
    if ~isfield(controlParameterStruct,'pointSpacing')
        controlParameterStruct.pointSpacing=[]; %Default is average point spacing
    end
    if isempty(controlParameterStruct.pointSpacing)
        controlParameterStruct.pointSpacing=D/numPoints; %Default is average point spacing
    end
end

%Check depth
if ~isfield(controlParameterStruct,'depth')
    error('cPar.depth was not specified.');
end

%Check dir
if ~isfield(controlParameterStruct,'dir')
    controlParameterStruct.dir=0; %Default symmetric
end

%Check patchType
if ~isfield(controlParameterStruct,'patchType')
    controlParameterStruct.patchType='tri'; %Default triangles
end

%Check direction vector
if ~isfield(controlParameterStruct,'n')    
    [R_fit]=pointSetPrincipalDir(Vc);
    nDir=R_fit(:,3);
    if dot(nDir,[0 0 1])<0 %Make the z direction the default upward direction
        nDir=-nDir;        
    end
    controlParameterStruct.n=nDir; %Default normal direction to polygon
end
controlParameterStruct.n=vecnormalize(controlParameterStruct.n);
controlParameterStruct.n=controlParameterStruct.n(:)';

%Check closeLoopOpt
if ~isfield(controlParameterStruct,'closeLoopOpt')
    controlParameterStruct.closeLoopOpt=0; %Default off
end

%% Prepare for extrude

switch extrudeMode
    case 0 %Resample curve and use pointSpacing
        %Set point spacing
        controlParameterStruct.numSteps=round(controlParameterStruct.depth./controlParameterStruct.pointSpacing);
        
        %Resampling sketch with desired spacing
        D=max(pathLength(Vc)); %Computer curve length for point sampling
        n=round(D./controlParameterStruct.pointSpacing); %Determine number of points based on curve length
        interpMethod='linear';
        [Vc]=evenlySampleCurve(Vc,n,interpMethod,controlParameterStruct.closeLoopOpt); %Resampling curve
    case 1 %Use number of points
        
end

%Create coordinates in extrusion direction
switch controlParameterStruct.dir
    case 0
        V_add=(controlParameterStruct.depth/2).*controlParameterStruct.n;
        Vc_start=Vc-V_add(ones(size(Vc,1),1),:);
        Vc_end=Vc+V_add(ones(size(Vc,1),1),:);
    case 1
        Vc_start=Vc;
        V_add=controlParameterStruct.depth.*controlParameterStruct.n;
        Vc_end=Vc+V_add(ones(size(Vc,1),1),:);
    case -1
        Vc_start=Vc;
        V_add=controlParameterStruct.depth.*controlParameterStruct.n;
        Vc_end=Vc-V_add(ones(size(Vc,1),1),:);
end

%% Extruding the skethed profile using polyLoftLinear

[F,V,~,~]=polyLoftLinear(Vc_start,Vc_end,controlParameterStruct);

Num=GetNMeshes(obj);
obj.Meshes{Num+1,1}.Face=F;
obj.Meshes{Num+1,1}.Vert=V;
obj.Meshes{Num+1,1}.Cb=(Num+1)*ones(size(F,1),1);
[Eb,~,~]=patchBoundary(F);
obj.Meshes{Num+1,1}.Boundary=Eb;

%% Print
if obj.Echo
    fprintf('Successfully extrude to face .\n');
end

end

