function obj=LoftLinear(obj,start,last,varargin)
% Create a loft between the two input curves

%% Parse input
p=inputParser;
addParameter(p,'numSteps',[]);
addParameter(p,'closeLoopOpt',0);
addParameter(p,'patchType','tri');
addParameter(p,'untwistOpt',0);
parse(p,varargin{:});
opt=p.Results;


untwistOpt=opt.untwistOpt;
Vc_start=obj.Points{start,1}.P;
Vc_end=obj.Points{last,1}.P;


if isfield(opt,'numSteps')
    numSteps=opt.numSteps;
else
    numSteps=[];
end

if ~isfield(opt,'closeLoopOpt')
    opt.closeLoopOpt=1;
end

if ~isfield(opt,'patchType')
    opt.patchType='tri';
end
%Derive numSteps from point spacings if missing (empty)
if isempty(numSteps)
    d1=sqrt(sum(diff(Vc_start,1,1).^2,2));
    d2=sqrt(sum(diff(Vc_end,1,1).^2,2));
    d=mean([d1(:);d2(:)]);
    dd=mean(sqrt(sum((Vc_start-Vc_end).^2,2)));
    numSteps=ceil(dd./d);
    numSteps=numSteps+iseven(numSteps);
end

%Cope with single step, i.e. force at least 2
if numSteps==1
    numSteps=2;
end

%% Remove twist
if untwistOpt
    [Vc_end,~,~]=minPolyTwist(Vc_start,Vc_end);
end

%% Create coordinate matrices
X=linspacen(Vc_start(:,1),Vc_end(:,1),numSteps)';
Y=linspacen(Vc_start(:,2),Vc_end(:,2),numSteps)';
Z=linspacen(Vc_start(:,3),Vc_end(:,3),numSteps)';

%% Create patch data
c=(1:1:size(Z,1))';
C=c(:,ones(1,size(Z,2)));

%Create quad patch data
[F,V,C] = surf2patch(X,Y,Z,C);

%Get start and end curves
indStart=1:numSteps:size(V,1);
indEnd=numSteps:numSteps:size(V,1);

%Check if indices are consistent with edges
Eb=patchBoundary(F); %Patch edges
e=indStart(1:2);
logicFlip= ~any((Eb(:,1)==e(1)) & (Eb(:,2)==e(2)));
if logicFlip
    indStart=flip(indStart); %#ok<NASGU> 
end
e=indEnd(1:2);
logicFlip= ~any((Eb(:,1)==e(1)) & (Eb(:,2)==e(2)));
if logicFlip
    indEnd=flip(indEnd); %#ok<NASGU> 
end

%% Close patch if required
if opt.closeLoopOpt
    [F,V,C]=patchCylSurfClose(X,Y,Z,C);
else
    [C]=vertexToFaceMeasure(F,C);
end
C=round(C);

%% Change mesh type if required

switch opt.patchType
        
    case 'tri_slash' %Convert quads to triangles by slashing        
        [F]=quad2tri(F,V,'a');
    case 'tri' %Convert quads to approximate equilateral triangles
        
        logicSlashType=repmat(iseven(C),2,1);
        
        Xi=X;
        x=X(1,:);
        dx=diff(x)/2;
        dx(end+1)=(x(1)-x(end))/2;
        for q=2:2:size(X,1)
            X(q,:)=X(q,:)+dx;
        end
        if ~opt.closeLoopOpt
            X(:,1)=Xi(:,1);
            X(:,end)=Xi(:,end);
        end
        
        Yi=Y;
        y=Y(1,:);
        dy=diff(y)/2;
        dy(end+1)=(y(1)-y(end))/2;
        for q=2:2:size(Y,1)
            Y(q,:)=Y(q,:)+dy;
        end
        if ~opt.closeLoopOpt
            Y(:,1)=Yi(:,1);
            Y(:,end)=Yi(:,end);
        end
        
        Zi=Z;
        z=Z(1,:);
        dz=diff(z)/2;
        dz(end+1)=(z(1)-z(end))/2;
        for q=2:2:size(Z,1)
            Z(q,:)=Z(q,:)+dz;
        end
        if ~opt.closeLoopOpt
            Z(:,1)=Zi(:,1);
            Z(:,end)=Zi(:,end);
        end
        
        V=[X(:) Y(:) Z(:)];
        
        %Ensure end curve is unaltered if numSteps is even
        if iseven(numSteps)
            indBottom=numSteps:numSteps:size(V,1);
            V(indBottom,:)=Vc_end;
        end
        
        F1=[F(:,1) F(:,3) F(:,2); F(:,1) F(:,4) F(:,3)];
        F2=[F(:,1) F(:,4) F(:,2); F(:,2) F(:,4) F(:,3)];
        F=fliplr([F1(~logicSlashType,:);F2(logicSlashType,:)]);
        
    otherwise
        error([opt.patchType,' is not a valid patch type, use quad, tri_slash, or tri instead'])
        
end

%% Parse
Num=GetNMeshes(obj);
obj.Meshes{Num+1,1}.Face=F;
obj.Meshes{Num+1,1}.Vert=V;
obj.Meshes{Num+1,1}.Cb=(Num+1)*ones(size(F,1),1);
[Eb,~,~]=patchBoundary(F);
obj.Meshes{Num+1,1}.Boundary=Eb;
obj.Summary.TotalMesh=GetNMeshes(obj);
%% Print
if obj.Echo
    fprintf('Successfully loft linear mesh .\n');
end
end

