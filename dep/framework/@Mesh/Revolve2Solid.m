function obj=Revolve2Solid(obj,mesh2D,varargin)
% Axis x or y, type=1 Axis x,Type=2 Axis y
% Author : Xie Yu
%% Default value
p=inputParser;
addParameter(p,'Slice',36);
addParameter(p,'Type',1)
addParameter(p,'Degree',360)
addParameter(p,'Gap',[])
parse(p,varargin{:});

opt=p.Results;
Slice=opt.Slice;
Degree=opt.Degree;
Type=opt.Type;

V=mesh2D.Vert(:,1:2);
F=mesh2D.Face;
Num_node_2D=size(V,1);

if ~isempty(opt.Gap)
    Slice=size(opt.Gap,1);
end


if Degree==360
    V=repmat(V,Slice,1);
    if isempty(opt.Gap)
        deg=0:Degree/Slice:Degree-Degree/Slice;
    else
        % Check gap
        if sum(opt.Gap)~=360
            error('Gap is node match with the degree !')
        else
            deg=tril(ones(size(opt.Gap,1)))*opt.Gap;
            deg=[0,deg(1:end-1,1)'];
        end
    end
else
    V=repmat(V,Slice+1,1);
    if isempty(opt.Gap)
        deg=0:Degree/Slice:Degree-Degree/Slice;
    else
        deg=tril(ones(size(opt.Gap,1)))*opt.Gap;
        deg=[0,deg(1:end,1)'];
    end
end

Temp=repmat(deg,Num_node_2D,1);
if Degree==360
    Temp=[V,reshape(Temp,Slice*Num_node_2D,1)];
else
    Temp=[V,reshape(Temp,(Slice+1)*Num_node_2D,1)];
end
switch Type
    case 1
        x=Temp(:,1);
        y=Temp(:,2).*cos(Temp(:,3)/180*pi);
        z=Temp(:,2).*sin(Temp(:,3)/180*pi);
    case 2
        x=Temp(:,1).*cos(Temp(:,3)/180*pi);
        y=Temp(:,2);
        z=Temp(:,1).*sin(Temp(:,3)/180*pi);
end
obj.Meshoutput.nodes=[x,y,z];

% Degree=360 merge vert
Temp=cell(Slice,1);
if Degree==360
    if size(F,2)==3
        for i=1:Slice-1
            Temp{i,1}=[F+(i-1)*Num_node_2D,F(:,3)+(i-1)*Num_node_2D,...
                F+Num_node_2D*i,F(:,3)+Num_node_2D*i];
        end
        Temp{Slice,1}=[F+(Slice-1)*Num_node_2D,F(:,3)+(Slice-1)*Num_node_2D,...
            F,F(:,3)];
    elseif size(F,2)==4
        for i=1:Slice-1
            Temp{i,1}=[F+(i-1)*Num_node_2D,...
                F+Num_node_2D*i];
        end
        Temp{Slice,1}=[F+(Slice-1)*Num_node_2D,...
            F];
    end
else
    if size(F,2)==3
        for i=1:Slice
            Temp{i,1}=[F+(i-1)*Num_node_2D,F(:,3)+(i-1)*Num_node_2D,...
                F+Num_node_2D*i,F(:,3)+Num_node_2D*i];
        end
    elseif size(F,2)==4
        for i=1:Slice
            Temp{i,1}=[F+(i-1)*Num_node_2D,...
                F+Num_node_2D*i];
        end
    end
end



obj.Meshoutput.elements=cell2mat(Temp);
%Convert elements to faces
[obj.Meshoutput.faces,~]=element2patch(obj.Meshoutput.elements,...
    (1:1:size(obj.Meshoutput.elements,1))','hex8');
[indFree]=freeBoundaryPatch(obj.Meshoutput.faces);
obj.Meshoutput.facesBoundary=obj.Meshoutput.faces(indFree,:);
Temp=obj.Meshoutput.facesBoundary;
obj.Meshoutput.facesBoundary=obj.Meshoutput.facesBoundary(Temp(:,1)~=Temp(:,2),:);

%Create faceBoundaryMarkers based on normals
%N.B. Change of convention changes meaning of front, top etc.
[N]=patchNormal(obj.Meshoutput.facesBoundary,obj.Meshoutput.nodes);
faceBoundaryMarker=zeros(size(obj.Meshoutput.facesBoundary,1),1)+1;

if opt.Type==1
faceBoundaryMarker(N(:,1)==1)=2; %vector x1
faceBoundaryMarker(N(:,1)==-1)=3; %vector x2
end

if opt.Type==2
faceBoundaryMarker(N(:,2)==1)=2; %vector y1
faceBoundaryMarker(N(:,2)==-1)=3; %vector y2
end

%% Parse
obj.Meshoutput.boundaryMarker=faceBoundaryMarker;
obj.Meshoutput.elementMaterialID=ones(size(obj.Meshoutput.elements,1),1);
obj.Meshoutput.faceMaterialID=ones(size(obj.Meshoutput.faces,1),1);
obj.Meshoutput.order=1;

obj.Vert=obj.Meshoutput.nodes;
obj.El=obj.Meshoutput.elements; %The elements
obj.Face=obj.Meshoutput.facesBoundary; %The boundary faces
obj.Cb=obj.Meshoutput.boundaryMarker; %The "colors" or labels for the boundary faces

%% Print
if obj.Echo
    fprintf('Successfully revolve to solid mesh .\n');
end
end