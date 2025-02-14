function [varargout]=patchcylinder(varargin)

%------------------------------------------------------------------------
% function [F,V,C]=patchcylinder(optionStruct)

% 2017/04/18 KMM: Added varargin style with defaults for missing parameters
% 2018/03/15 KMM: Updated input parsing based on default structure 
% 2018/03/15 KMM: Added option to output a closed cylinder
% 2018/03/15 KMM: Added varargout and color output
% 2021/07/09 KMM: Added default uneven number of points allong height if
% mesh type is tri
%------------------------------------------------------------------------

%% Parse input

%Create default structure
default.cylRadius=1;
default.numRadial=10;
default.cylHeight=2*default.cylRadius;
default.numHeight=[];
default.meshType='quad';
default.closeOpt=0;
switch nargin    
    case 1
        optionStruct=varargin{1};
    case 5
        optionStruct.cylRadius=varargin{1};
        optionStruct.numRadial=varargin{2};
        optionStruct.cylHeight=varargin{3};
        optionStruct.numHeight=varargin{4};
        optionStruct.meshType=varargin{5};        
    otherwise
        error('Wrong numer of input arguments');
end

%Complement/fix input with default
[optionStruct]=structComplete(optionStruct,default,1); %Complement provided with default if missing or empty

if isempty(optionStruct.numHeight)
    nh=ceil(optionStruct.cylHeight/((2*pi*optionStruct.cylRadius)/optionStruct.numRadial));    
    if strcmp(optionStruct.meshType,'tri') %Force uneven for tri type
        nh=nh+iseven(nh);
    end
    optionStruct.numHeight=nh;
end

%Access parameters
cylRadius=optionStruct.cylRadius;
numRadial=optionStruct.numRadial;
cylHeight=optionStruct.cylHeight;
numHeight=optionStruct.numHeight;
meshType=optionStruct.meshType;
closeOpt=optionStruct.closeOpt;

%% Create cylinder

t=linspace(0,2*pi,numRadial+1);
t=t(1:end-1);
x=cylRadius*cos(t);
y=cylRadius*sin(t);
Vc=[x(:) y(:)];
Vc(:,3)=0; 

cPar.numSteps=numHeight;
cPar.depth=cylHeight; 
cPar.patchType=meshType; 
cPar.dir=0;
cPar.closeLoopOpt=1; 

[F,V]=polyExtrude(Vc,cPar);

%% 

indTop=numHeight:numHeight:size(V,1);
indBottom=1:numHeight:size(V,1);

%% Cap ends if requested

if closeOpt==1
    if optionStruct.meshType=="tri"
        [Ft,Vt]=regionTriMesh2D({V(indTop,[1 2])},[],0);
        Vt(:,3)=mean(V(indTop,3));

        [Fb,Vb]=regionTriMesh2D({V(indBottom,[1 2])},[],0);
        Vb(:,3)=mean(V(indBottom,3));
        Fb=fliplr(Fb);

        [F,V,C]=joinElementSets({F,Ft,Fb},{V,Vt,Vb});

        [F,V,~,ind2]=mergeVertices(F,V);
        indTop=ind2(indTop);
        indBottom=ind2(indBottom);
    elseif optionStruct.meshType=="quad"
        m=Mesh2D('Cap','Echo',0);
        m=MeshQuadCircle(m,'n',numRadial/4,'r',cylRadius);
        m=SmoothFace(m,100);
        Ft=m.Face;Vt=[m.Vert,ones(size(m.Vert,1),1)*cylHeight/2];
        Fb=m.Face;Vb=[m.Vert,-ones(size(m.Vert,1),1)*cylHeight/2];

        [F,V,C]=joinElementSets({F,Ft,Fb},{V,Vt,Vb});
        [F,V,~,~]=mergeVertices(F,V);
        
    end
    else
    C=ones(size(F,1),1);
end

%% Collect output
varargout{1}=F;
varargout{2}=V;
varargout{3}=C;
varargout{4}=indTop;
varargout{5}=indBottom;

end
 