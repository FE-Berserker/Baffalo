function obj=OutputAss1(obj)
% Ouput assembly of bearing
% Author : Xie Yu
Ass=Assembly(obj.params.Name,'Echo',0);
t = (0:2*pi/obj.input.Z:2*pi-2*pi/obj.input.Z)'...
    +obj.params.ROTX;
position=[obj.input.T/2,0,0,0,0,0];
% Roller
for i=1:obj.params.N_Slice
    x1=repmat(obj.output.Roller_point.x1(:,i),obj.input.Z,1);
    y1=obj.output.Roller_point.y1(:,i).*cos(t);
    z1=obj.output.Roller_point.y1(:,i).*sin(t);
    x2=repmat(obj.output.Roller_point.x2(:,i),obj.input.Z,1);
    y2=obj.output.Roller_point.y2(:,i).*cos(t);
    z2=obj.output.Roller_point.y2(:,i).*sin(t);
    coor=[x1 y1 z1;x2 y2 z2];
    meshoutput.nodes=coor;
    Temp1=(1:obj.input.Z)';
    Temp2=(obj.input.Z+1:obj.input.Z*2)';
    meshoutput.elements=[Temp1 Temp2];
    meshoutput.faces=[];
    meshoutput.order=1;
    meshoutput.facesBoundary=[];
    meshoutput.boundaryMarker=[Temp1;Temp2];
    meshoutput.elementMaterialID=ones(obj.input.Z,1);
    meshoutput.faceMaterialID=[];
    Ass=AddPart(Ass,meshoutput,'position',position);
end
% Master
start=ceil(obj.params.N_Slice/2);
gap=obj.params.N_Slice;
for i=start:gap:obj.params.N_Slice
    for j=1:obj.input.Z*2
        Ass=AddMaster(Ass,i,j);
    end
end
% Slaver
for j=1:obj.input.Z*2
    for i=1:obj.params.N_Slice
        if mod(i-start,gap)==0
            continue
        end
        Ass=AddSlaver(Ass,i,'node',j);
    end
end
% Connection
for i=1:1:obj.input.Z*2
    for j=1:obj.params.N_Slice-1
        Ass=SetRbe2(Ass,i,(obj.params.N_Slice-1)*(i-1)+j);
    end
end
% ET
for i=1:obj.params.N_Slice
ET.name='39';ET.opt=[4,1];
ET.R=reshape(obj.output.Spring_Stiffness2{1,i}',[],1)';
Ass=AddET(Ass,ET);
Ass=SetET(Ass,i,i);
end
 %Material
mat.name=obj.params.Material.Name;
mat.table=["DENS",obj.params.Material.Dens;"EX",obj.params.Material.E;...
    "NUXY",obj.params.Material.v;"ALPX",obj.params.Material.a];
Ass=AddMaterial(Ass,mat);
% Ring
position=[0,0,0,0,0,0];
if and(obj.params.isInnerRing==1,obj.params.isOuterRing==1)
    ET.name='185';ET.opt=[];ET.R=[];
    AddET(Ass,ET);
    % Innerring
    mesh=obj.output.Surface.Meshes{3,1};
    m=Mesh2D('InnerRing section','Echo',0);
    m.Vert=mesh.Vert(:,1:2);
    m.Face=mesh.Face;
    mm=Mesh('Inner Ring','Echo',0);
    mm=Revolve2Solid(mm,m,'Slice',obj.input.Z*3);
    Vm = PatchCenter(mm);
    r=sqrt(Vm(:,2).^2+Vm(:,3).^2);
    mm.Cb(Vm(:,1)==0,:)=301;
    mm.Cb(Vm(:,1)==obj.input.B,:)=302;
    mm.Cb(r<=obj.input.Di/2,:)=201;
    Temp_D=obj.input.Dpw-obj.input.Dw;
    mm.Cb(and(abs(Vm(:,1)-obj.input.T/2)<=obj.output.Lwe/2,r>=0.99*Temp_D/2),:)=101;
    mm.Meshoutput.boundaryMarker=mm.Cb;
    Ass=AddPart(Ass,mm.Meshoutput,'position',position);
    Ass=SetET(Ass,obj.params.N_Slice+1,obj.params.N_Slice+1);
    % Find nodes
    nodes=unique(mm.Face(mm.Cb==101,:));
    coor=mm.Vert(nodes,:);
    for ang = obj.params.ROTX:2*pi/obj.input.Z:2*pi-2*pi/obj.input.Z+obj.params.ROTX
        yy=Temp_D/2*cos(ang);
        zz=Temp_D/2*sin(ang);
        dis=sqrt((coor(:,2)-repmat(yy,size(coor,1),1)).^2+(coor(:,3)-repmat(zz,size(coor,1),1)).^2);
        NN=nodes(dis<=0.01,:);
        Ass=AddSlaver(Ass,obj.params.N_Slice+1,'node',NN);
    end
    for i=1:1:obj.input.Z
        Ass=SetRbe2(Ass,i,(obj.params.N_Slice-1)*obj.input.Z*2+i);
    end
    Ass=SetMaterial(Ass,obj.params.N_Slice+1,1);

    % Outerring
    mesh=obj.output.Surface.Meshes{2,1};
    m=Mesh2D('OuterRing section','Echo',0);
    m.Vert=mesh.Vert(:,1:2);
    m.Face=mesh.Face;
    mm=Mesh('Outer Ring','Echo',0);
    mm=Revolve2Solid(mm,m,'Slice',obj.input.Z*3);
    Vm = PatchCenter(mm);
    r=sqrt(Vm(:,2).^2+Vm(:,3).^2);
    mm.Cb(Vm(:,1)==obj.input.T-obj.input.C,:)=301;
    mm.Cb(Vm(:,1)==obj.input.T,:)=302;
    mm.Cb(r>=0.99*obj.input.Do/2,:)=101;
    Temp_D=obj.input.Dpw+obj.input.Dw;
    mm.Cb(and(abs(Vm(:,1)-obj.input.T/2)<=obj.output.Lwe/2,r<=Temp_D/2),:)=201;
    mm.Meshoutput.boundaryMarker=mm.Cb;
    Ass=AddPart(Ass,mm.Meshoutput,'position',position);
    Ass=SetET(Ass,obj.params.N_Slice+2,obj.params.N_Slice+1);
    % Find nodes
    nodes=unique(mm.Face(mm.Cb==201,:));
    coor=mm.Vert(nodes,:);
    for ang = obj.params.ROTX:2*pi/obj.input.Z:2*pi-2*pi/obj.input.Z+obj.params.ROTX
        yy=Temp_D/2*cos(ang);
        zz=Temp_D/2*sin(ang);
        dis=sqrt((coor(:,2)-repmat(yy,size(coor,1),1)).^2+(coor(:,3)-repmat(zz,size(coor,1),1)).^2);
        NN=nodes(dis<=0.01,:);
        Ass=AddSlaver(Ass,obj.params.N_Slice+2,'node',NN);
    end
    for i=obj.input.Z+1:1:obj.input.Z*2
        Ass=SetRbe2(Ass,i,(obj.params.N_Slice-1)*obj.input.Z*2+i);
    end
    Ass=SetMaterial(Ass,obj.params.N_Slice+2,1);

elseif and(obj.params.isInnerRing==0,obj.params.isOuterRing==1)
    ET.name='185';ET.opt=[];ET.R=[];
    Ass=AddET(Ass,ET);
        % Outerring
    mesh=obj.output.Surface.Meshes{2,1};
    m=Mesh2D('OuterRing section','Echo',0);
    m.Vert=mesh.Vert(:,1:2);
    m.Face=mesh.Face;
    mm=Mesh('Outer Ring','Echo',0);
    mm=Revolve2Solid(mm,m,'Slice',obj.input.Z*3);
    Vm = PatchCenter(mm);
    r=sqrt(Vm(:,2).^2+Vm(:,3).^2);
    mm.Cb(Vm(:,1)==obj.input.T-obj.input.C,:)=301;
    mm.Cb(Vm(:,1)==obj.input.T,:)=302;
    mm.Cb(r>=0.99*obj.input.Do/2,:)=101;
    Temp_D=obj.input.Dpw+obj.input.Dw;
    mm.Cb(and(abs(Vm(:,1)-obj.input.T/2)<=obj.output.Lwe/2,r<=Temp_D/2),:)=201;
    mm.Meshoutput.boundaryMarker=mm.Cb;
    Ass=AddPart(Ass,mm.Meshoutput,'position',position);
    Ass=SetET(Ass,obj.params.N_Slice+1,obj.params.N_Slice+1);
    % Find nodes
    nodes=unique(mm.Face(mm.Cb==201,:));
    coor=mm.Vert(nodes,:);
    for ang = obj.params.ROTX:2*pi/obj.input.Z:2*pi-2*pi/obj.input.Z+obj.params.ROTX
        yy=Temp_D/2*cos(ang);
        zz=Temp_D/2*sin(ang);
        dis=sqrt((coor(:,2)-repmat(yy,size(coor,1),1)).^2+(coor(:,3)-repmat(zz,size(coor,1),1)).^2);
        NN=nodes(dis<=0.01,:);
        Ass=AddSlaver(Ass,obj.params.N_Slice+1,'node',NN);
    end
    for i=obj.input.Z+1:1:obj.input.Z*2
        Ass=SetRbe2(Ass,i,(obj.params.N_Slice-1)*obj.input.Z*2-obj.input.Z+i);
    end
    Ass=SetMaterial(Ass,obj.params.N_Slice+1,1);

elseif and(obj.params.isInnerRing==1,obj.params.isOuterRing==0)
    ET.name='185';ET.opt=[];ET.R=[];
    Ass=AddET(Ass,ET);
    % Innerring
    mesh=obj.output.Surface.Meshes{2,1};
    m=Mesh2D('InnerRing section','Echo',0);
    m.Vert=mesh.Vert(:,1:2);
    m.Face=mesh.Face;
    mm=Mesh('Inner Ring','Echo',0);
    mm=Revolve2Solid(mm,m,'Slice',obj.input.Z*3);
    Vm = PatchCenter(mm);
    r=sqrt(Vm(:,2).^2+Vm(:,3).^2);
    mm.Cb(Vm(:,1)==0,:)=301;
    mm.Cb(Vm(:,1)==obj.input.B,:)=302;
    mm.Cb(r<=obj.input.Di/2,:)=201;
    Temp_D=obj.input.Dpw-obj.input.Dw;
    mm.Cb(and(abs(Vm(:,1)-obj.input.T/2)<=obj.output.Lwe/2,r>=0.99*Temp_D/2),:)=101;
    mm.Meshoutput.boundaryMarker=mm.Cb;
    Ass=AddPart(Ass,mm.Meshoutput,'position',position);
    Ass=SetET(Ass,obj.params.N_Slice+1,obj.params.N_Slice+1);
    % Find nodes
    nodes=unique(mm.Face(mm.Cb==101,:));
    coor=mm.Vert(nodes,:);
    for ang = obj.params.ROTX:2*pi/obj.input.Z:2*pi-2*pi/obj.input.Z+obj.params.ROTX
        yy=Temp_D/2*cos(ang);
        zz=Temp_D/2*sin(ang);
        dis=sqrt((coor(:,2)-repmat(yy,size(coor,1),1)).^2+(coor(:,3)-repmat(zz,size(coor,1),1)).^2);
        NN=nodes(dis<=0.01,:);
        Ass=AddSlaver(Ass,obj.params.N_Slice+1,'node',NN);
    end
    for i=1:1:obj.input.Z
        Ass=SetRbe2(Ass,i,(obj.params.N_Slice-1)*obj.input.Z*2+i);
    end
    Ass=SetMaterial(Ass,obj.params.N_Slice+1,1);
end

obj.output.Assembly=Ass;

%% Print
if obj.params.Echo
    fprintf('Successfully output assembly .\n');
end

end

