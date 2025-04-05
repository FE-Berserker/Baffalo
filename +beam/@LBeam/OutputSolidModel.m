function obj=OutputSolidModel(obj)
% Output solid model of CBeam
% Author : Xie Yu

d1=obj.input.d(1);
d2=obj.input.d(2);
b1=obj.input.b(1);
b2=obj.input.b(2);


if isempty(obj.input.Meshsize)
    obj.input.Meshsize=min(obj.input.d)/3;
end

l=obj.input.l;

m1=Mesh2D('Temp','Echo',0);
m1=AddSurface(m1,obj.output.Surface);
m1=SetSize(m1,obj.input.Meshsize);
m1=Mesh(m1);

mm=Mesh('Mesh1','Echo',0);
if isempty(obj.input.Stiffner)
    mm=Extrude2Solid(mm,m1,l,ceil(l/obj.input.b(2)*10));
    Vm=PatchCenter(mm);
    Cb=mm.Cb;
    Cb(Vm(:,1)==b1,:)=101;
    Cb(Vm(:,2)==d1,:)=102;
    Cb(Vm(:,1)==d2,:)=103;
    Cb(Vm(:,2)==b2,:)=104;
    Cb(Vm(:,2)==0,:)=105;
    Cb(Vm(:,1)==0,:)=106;

    mm.Meshoutput.boundaryMarker=Cb;
    mm.Cb=Cb;

else
    m2=Mesh2D('Temp','Echo',0);
    m2=AddSurface(m2,obj.output.Stiffner_Surface);
    m2=SetSize(m2,obj.input.Meshsize);
    m2=Mesh(m2);

    Num1=size(m1.Vert,1);
   
    m2.Vert=[m1.Vert;m2.Vert];
    m2.Face=[m1.Face;m2.Face+Num1];
    m2.Cb=ones(size(m2.Face,1),1);
    m2=MergeNode(m2);

    Num3=size(m2.Vert,1)-Num1;

    m2.Meshoutput.nodes=m2.Vert;
    m2.Meshoutput.facesBoundary=m2.Boundary;
    m2.Meshoutput.boundaryMarker=ones(size(m2.Boundary,1),1);
    m2.Meshoutput.elements=m2.Face;
    m2.Meshoutput.elementMaterialID=m2.Cb;

    Stiff=obj.input.Stiffner;
    Pos=Stiff(1,1);
    T=Stiff(1,2);
    l=Pos-T/2;
    mm=Extrude2Solid(mm,m1,l,ceil(l/obj.input.b(2)*10));


    for i=1:size(Stiff,1)
        Pos1=Stiff(i,1);
        T1=Stiff(i,2);
           
        mm2=Mesh('Mesh2','Echo',0);
        mm2=Extrude2Solid(mm2,m2,T1,3);
        mm=CombineMesh1(mm,mm2,Num1,Pos1,T1);

        if i~=size(Stiff,1)
            Pos2=Stiff(i+1,1);
            T2=Stiff(i+1,2);
            l=(Pos2-T2/2)-(Pos1+T1/2);  
        else
            l=obj.input.l-(Pos1+T1/2);
        end

        
        mm3=Mesh('Mesh3','Echo',0);
        mm3=Extrude2Solid(mm3,m1,l,ceil(l/obj.input.b(2)*10));
        mm=CombineMesh2(mm,mm3,Num1,Num3,Pos1,T1);
    end
    %Convert elements to faces
    [mm.Meshoutput.faces,~]=element2patch(mm.Meshoutput.elements,[],'hex8');
    %Find boundary faces
    [indFree]=freeBoundaryPatch(mm.Meshoutput.faces);
    mm.Meshoutput.facesBoundary=mm.Meshoutput.faces(indFree,:);

    %Create faceBoundaryMarkers based on normals
    %N.B. Change of convention changes meaning of front, top etc.
    [N]=patchNormal(mm.Meshoutput.facesBoundary,mm.Meshoutput.nodes);
    faceBoundaryMarker=zeros(size(mm.Meshoutput.facesBoundary,1),1)+1;

    faceBoundaryMarker(abs(N(:,3)+1)<1e-5)=2; %Bottom
    faceBoundaryMarker(abs(N(:,3)-1)<1e-5)=3; %Top
    faceBoundaryMarker(abs(N(:,1)+1)<1e-5)=4; 
    faceBoundaryMarker(abs(N(:,1)-1)<1e-5)=5;
    faceBoundaryMarker(abs(N(:,2)+1)<1e-5)=6; 
    faceBoundaryMarker(abs(N(:,2)-1)<1e-5)=7; 


    mm.Meshoutput.boundaryMarker=faceBoundaryMarker;
    mm.Meshoutput.elementMaterialID=ones(size(mm.Meshoutput.elements,1),1);
    mm.Meshoutput.faceMaterialID=ones(size(mm.Meshoutput.faces,1),1);
    mm.Meshoutput.order=1;

    mm.Face=mm.Meshoutput.facesBoundary; %The boundary faces
    mm.Cb=mm.Meshoutput.boundaryMarker; %The "colors" or labels for the boundary faces

    Vm=PatchCenter(mm);
    Cb=mm.Cb;
    % Beam Cb
    Cb(and(Cb==5,Vm(:,2)<d1),:)=101;
    Cb(Cb==5,:)=103;
    Cb(Cb==4,:)=108;
    Cb(and(and(Cb==7,Vm(:,1)>0),Vm(:,2)==d1),:)=102;
    Cb(and(Cb==6,Vm(:,1)>=0),:)=111;
    Cb(Cb==7,:)=112;
    Pos2=0;
    Pos3=Stiff(1,1)-Stiff(1,2)/2;
    Cb(and(Vm(:,3)>Pos2,Vm(:,3)<Pos3),:)=Cb(and(Vm(:,3)>Pos2,Vm(:,3)<Pos3),:)+20;
    for i=1:size(Stiff,1)
        Pos=Stiff(i,1);
        T=Stiff(i,2);
        Pos1=Pos-T/2;
        Pos2=Pos+T/2;
        Cb(and(Vm(:,1)>0,Vm(:,3)==Pos1),:)=1000+2*i-1;
        Cb(and(Vm(:,1)>0,Vm(:,3)==Pos2),:)=1000+2*i;

        if i==size(Stiff,1)
            Pos3=obj.input.l;
        else
            Pos3=Stiff(i+1,1)-Stiff(i+1,2)/2;
        end
        Cb(and(Vm(:,3)>Pos2,Vm(:,3)<Pos3),:)=Cb(and(Vm(:,3)>Pos2,Vm(:,3)<Pos3),:)+20*(i+1);
    end
    mm.Meshoutput.boundaryMarker=Cb;
    mm.Cb=Cb;
end

if obj.params.Order==2
    mm = Convert2Order2(mm);
end

%% Prase

obj.output.SolidMesh=mm;
%% Print
if obj.params.Echo
    fprintf('Successfully output solid model .\n');
end
end

function mm=CombineMesh1(mm,mm2,Num1,Pos,T)
Delta=Pos-T/2;
NN=size(mm.Vert,1);
mm.Vert=[mm.Vert;[mm2.Vert(Num1+1:end,1),mm2.Vert(Num1+1:end,2),mm2.Vert(Num1+1:end,3)+Delta]];
mm.El=[mm.El;mm2.El+NN-Num1];

mm.Meshoutput.nodes=mm.Vert;
mm.Meshoutput.elements=mm.El;
mm.Meshoutput.elementMaterialID=ones(size(mm.El,1));

end

function mm=CombineMesh2(mm,mm3,Num1,Num3,Pos,T)
Delta=Pos+T/2;
NN=size(mm.Vert,1);
mm.Vert=[mm.Vert;[mm3.Vert(Num1+1:end,1),mm3.Vert(Num1+1:end,2),mm3.Vert(Num1+1:end,3)+Delta]];
mm3.El(mm3.El<=Num1)=mm3.El(mm3.El<=Num1)-Num3;
mm.El=[mm.El;mm3.El+NN-Num1];

mm.Meshoutput.nodes=mm.Vert;
mm.Meshoutput.elements=mm.El;
mm.Meshoutput.elementMaterialID=ones(size(mm.El,1));

end