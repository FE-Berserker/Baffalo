function mm = CreateMesh3D4(obj,mm,r1,row)
% CreateMesh3D4 - 创建中间段实心的多段轴3D网格
% 适用于第一段为空心，中间某段为实心的轴
% Author: Xie Yu
%
% Inputs:
%   mm  - 网格对象
%   r1  - 实心段左侧的内半径
%   row - 实心段开始的索引
%
% Output:
%   mm  - 包含顶点、面和边界标记的网格对象

%% 计算旋转角度
deg=360/obj.params.E_Revolve;  % 每个分段的角度（度）

%% 从实心段左侧内表面开始
x1=obj.input.Length(row-1)*ones(obj.params.E_Revolve,1);
y1=cos((0:deg:360-deg)'/180*pi)*r1;
z1=sin((0:deg:360-deg)'/180*pi)*r1;
V1=[x1 y1 z1];

% 创建点对象
a=Point2D('Bottom Verts','Echo',0);
a=AddPoint(a,y1,z1);

% 创建Layer对象
l=Layer('Layer','Echo',0);
l=AddElement(l,a,'transform',[x1(1,1),0,0,0,90,0]);

Nmeshes=0;   % 网格层数计数
Nsec=301;    % 边界标记起始值
patchType='tri_slash';

%% 处理内表面（从实心段向左回溯）
for i=row:-1:2
    % 计算x坐标
    if i==2
        x2=zeros(obj.params.E_Revolve,1);  % 回到左端面
    else
        x2=repmat(obj.input.Length(i-2),obj.params.E_Revolve,1);
    end

    % 当前段起始处的内半径
    r2=obj.input.ID(i-1,1)/2;
    y2=cos((0:deg:360-deg)'/180*pi)*r2;
    z2=sin((0:deg:360-deg)'/180*pi)*r2;
    V2=[x2 y2 z2];

    % 计算网格分段数
    Temp=[ceil(abs(r2-r1)/obj.input.Meshsize);...
        ceil(abs(V1(1,1)-V2(1,1))/obj.input.Meshsize)];
    numSteps=max(Temp);

    a1=Point2D('Top Verts','Echo',0);
    a1=AddPoint(a1,y2,z2);

    % 使用线性放样创建内表面
    l=AddElement(l,a1,'transform',[x2(1,1),0,0,0,90,0]);
    l=LoftLinear(l,Nmeshes+1,Nmeshes+2,'patchType',patchType,'numSteps',numSteps,'closeLoopOpt',1);

    % 保存网格数据
    NN=size(mm.Vert,1);
    Nmeshes=Nmeshes+1;
    mm.Vert=[mm.Vert;l.Meshes{Nmeshes,1}.Vert];
    mm.Face=[mm.Face;l.Meshes{Nmeshes,1}.Face+NN];
    mm.Cb=[mm.Cb;l.Meshes{Nmeshes,1}.Cb];
    % 更新边界标记（200+i-1表示第i-1段内表面）
    mm.Cb=mm.Cb*(200+i-1)./Nmeshes.*(mm.Cb==Nmeshes)+mm.Cb.*(mm.Cb~=Nmeshes);

    V1=V2;r1=r2;

    % 到达左端面，停止
    if i==2
        break
    % 如果下一段内径相同，跳过
    elseif obj.input.ID(i-2,2)/2==r2
        continue
    end

    % 处理内径阶梯面
    r2=obj.input.ID(i-2,2)/2;
    y2=cos((0:deg:360-deg)'/180*pi)*r2;
    z2=sin((0:deg:360-deg)'/180*pi)*r2;
    V2=[x2 y2 z2];

    Temp=[ceil(abs(r2-r1)/obj.input.Meshsize);...
        ceil(abs(V1(1,1)-V2(1,1))/obj.input.Meshsize)];
    numSteps=max(Temp);

    a1=Point2D('Top Verts','Echo',0);
    AddPoint(a1,y2,z2)

    % 使用线性放样创建阶梯面
    l=AddElement(l,a1,'transform',[x2(1,1),0,0,0,90,0]);
    l=LoftLinear(l,Nmeshes+1,Nmeshes+2,'patchType',patchType,'numSteps',numSteps,'closeLoopOpt',1);

    NN=size(mm.Vert,1);
    Nmeshes=Nmeshes+1;
    mm.Vert=[mm.Vert;l.Meshes{Nmeshes,1}.Vert];
    mm.Face=[mm.Face;l.Meshes{Nmeshes,1}.Face+NN];
    mm.Cb=[mm.Cb;l.Meshes{Nmeshes,1}.Cb];
    Nsec=Nsec+1;
    mm.Cb=mm.Cb*Nsec./Nmeshes.*(mm.Cb==Nmeshes)...
        +mm.Cb.*(mm.Cb~=Nmeshes);
    V1=V2;r1=r2;
end

%% 处理左端面到第一段外表面的过渡
x2=zeros(obj.params.E_Revolve,1);
r2=obj.input.OD(1,1)/2;  % 第一段起始处的外半径
y2=cos((0:deg:360-deg)'/180*pi)*r2;
z2=sin((0:deg:360-deg)'/180*pi)*r2;
V2=[x2 y2 z2];

Temp=[ceil(abs(r2-r1)/obj.input.Meshsize);...
    ceil(abs(V1(1,1)-V2(1,1))/obj.input.Meshsize)];
numSteps=max(Temp);

a1=Point2D('Top Verts','Echo',0);
a1=AddPoint(a1,y2,z2);

% 使用线性放样创建过渡面
l=AddElement(l,a1,'transform',[x2(1,1),0,0,0,90,0]);
l=LoftLinear(l,Nmeshes+1,Nmeshes+2,'patchType',patchType,'numSteps',numSteps,'closeLoopOpt',1);

NN=size(mm.Vert,1);
Nmeshes=Nmeshes+1;
mm.Vert=[mm.Vert;l.Meshes{Nmeshes,1}.Vert];
mm.Face=[mm.Face;l.Meshes{Nmeshes,1}.Face+NN];
mm.Cb=[mm.Cb;l.Meshes{Nmeshes,1}.Cb];
Nsec=Nsec+1;
mm.Cb=mm.Cb*Nsec./Nmeshes.*(mm.Cb==Nmeshes)+mm.Cb.*(mm.Cb~=Nmeshes);
V1=V2;r1=r2;

%% 处理外表面（从左向右遍历）
for i=1:size(obj.input.Length,1)-1
    %% 创建外表面（沿x轴推进）
    x2=repmat(obj.input.Length(i),obj.params.E_Revolve,1);
    r2=obj.input.OD(i,2)/2;  % 当前段结束处的外半径
    y2=cos((0:deg:360-deg)'/180*pi)*r2;
    z2=sin((0:deg:360-deg)'/180*pi)*r2;
    V2=[x2 y2 z2];

    Temp=[ceil(abs(r2-r1)/obj.input.Meshsize);...
        ceil(abs(V1(1,1)-V2(1,1))/obj.input.Meshsize)];
    numSteps=max(Temp);

    a1=Point2D('Top Verts','Echo',0);
    a1=AddPoint(a1,y2,z2);

    % 使用线性放样创建侧面
    l=AddElement(l,a1,'transform',[x2(1,1),0,0,0,90,0]);
    l=LoftLinear(l,Nmeshes+1,Nmeshes+2,'patchType',patchType,'numSteps',numSteps,'closeLoopOpt',1);

    NN=size(mm.Vert,1);
    Nmeshes=Nmeshes+1;
    mm.Vert=[mm.Vert;l.Meshes{Nmeshes,1}.Vert];
    mm.Face=[mm.Face;l.Meshes{Nmeshes,1}.Face+NN];
    mm.Cb=[mm.Cb;l.Meshes{Nmeshes,1}.Cb];
    % 更新边界标记（100+i表示第i段外表面）
    mm.Cb=mm.Cb*(100+i)./Nmeshes.*(mm.Cb==Nmeshes)+mm.Cb.*(mm.Cb~=Nmeshes);

    V1=V2;r1=r2;

    %% 处理外径阶梯面
    % 如果下一段外径相同，跳过
    if obj.input.OD(i+1,1)/2==r2
        continue
    end

    r2=obj.input.OD(i+1,1)/2;  % 下一段起始处的外半径
    y2=cos((0:deg:360-deg)'/180*pi)*r2;
    z2=sin((0:deg:360-deg)'/180*pi)*r2;
    V2=[x2 y2 z2];

    Temp=[ceil(abs(r2-r1)/obj.input.Meshsize);...
        ceil(abs(V1(1,1)-V2(1,1))/obj.input.Meshsize)];
   numSteps=max(Temp);

    a1=Point2D('Top Verts','Echo',0);
    a1=AddPoint(a1,y2,z2);

    % 使用线性放样创建阶梯面
    l=AddElement(l,a1,'transform',[x2(1,1),0,0,0,90,0]);
    l=LoftLinear(l,Nmeshes+1,Nmeshes+2,'patchType',patchType,'numSteps',numSteps,'closeLoopOpt',1);

    NN=size(mm.Vert,1);
    Nmeshes=Nmeshes+1;
    mm.Vert=[mm.Vert;l.Meshes{Nmeshes,1}.Vert];
    mm.Face=[mm.Face;l.Meshes{Nmeshes,1}.Face+NN];
    mm.Cb=[mm.Cb;l.Meshes{Nmeshes,1}.Cb];

    Nsec=Nsec+1;
    mm.Cb=mm.Cb*Nsec./Nmeshes.*(mm.Cb==Nmeshes)...
        +mm.Cb.*(mm.Cb~=Nmeshes);
    V1=V2;r1=r2;
end

%% 创建最后一段的外表面
x2=repmat(obj.input.Length(end),obj.params.E_Revolve,1);
r2=obj.input.OD(end,2)/2;
y2=cos((0:deg:360-deg)'/180*pi)*r2;
z2=sin((0:deg:360-deg)'/180*pi)*r2;
V2=[x2 y2 z2];

Temp=[ceil(abs(r2-r1)/obj.input.Meshsize);...
    ceil(abs(V1(1,1)-V2(1,1))/obj.input.Meshsize)];
numSteps=max(Temp);

a1=Point2D('Top Verts','Echo',0);
a1=AddPoint(a1,y2,z2);

% 使用线性放样创建侧面
l=AddElement(l,a1,'transform',[x2(1,1),0,0,0,90,0]);
l=LoftLinear(l,Nmeshes+1,Nmeshes+2,'patchType',patchType,'numSteps',numSteps,'closeLoopOpt',1);

NN=size(mm.Vert,1);
Nmeshes=Nmeshes+1;
mm.Vert=[mm.Vert;l.Meshes{Nmeshes,1}.Vert];
mm.Face=[mm.Face;l.Meshes{Nmeshes,1}.Face+NN];
mm.Cb=[mm.Cb;l.Meshes{Nmeshes,1}.Cb];

mm.Cb=mm.Cb*(100+size(obj.input.Length,1))./Nmeshes.*(mm.Cb==Nmeshes)...
    +mm.Cb.*(mm.Cb~=Nmeshes);
V1=V2;r1=r2;

%% 处理右端面内表面（如果有内孔）
r2=obj.input.ID(end,2)/2;  % 最后一段结束处的内半径
if r2~=0
    x2=repmat(obj.input.Length(end),obj.params.E_Revolve,1);
    y2=cos((0:deg:360-deg)'/180*pi)*r2;
    z2=sin((0:deg:360-deg)'/180*pi)*r2;
    V2=[x2 y2 z2];

    Temp=[ceil(abs(r2-r1)/obj.input.Meshsize);...
        ceil(abs(V1(1,1)-V2(1,1))/obj.input.Meshsize)];
    numSteps=max(Temp);

    a1=Point2D('Top Verts','Echo',0);
    a1=AddPoint(a1,y2,z2);

    % 使用线性放样创建内表面
    l=AddElement(l,a1,'transform',[x2(1,1),0,0,0,90,0]);
    l=LoftLinear(l,Nmeshes+1,Nmeshes+2,'patchType',patchType,'numSteps',numSteps,'closeLoopOpt',1);

    NN=size(mm.Vert,1);
    Nmeshes=Nmeshes+1;
    mm.Vert=[mm.Vert;l.Meshes{Nmeshes,1}.Vert];
    mm.Face=[mm.Face;l.Meshes{Nmeshes,1}.Face+NN];
    mm.Cb=[mm.Cb;l.Meshes{Nmeshes,1}.Cb];
    Nsec=Nsec+1;
    mm.Cb=mm.Cb*Nsec/Nmeshes.*(mm.Cb==Nmeshes)...
        +mm.Cb.*(mm.Cb~=Nmeshes);
    V1=V2;r1=r2;

    %% 处理右半部分的内表面（从右向左到实心段）
    for i=size(obj.input.Length,1):-1:1
        r2=obj.input.ID(i,1)/2;  % 当前段起始处的内半径
        x2=repmat(obj.input.Length(i-1),obj.params.E_Revolve,1);
        y2=cos((0:deg:360-deg)'/180*pi)*r2;
        z2=sin((0:deg:360-deg)'/180*pi)*r2;
        V2=[x2 y2 z2];

        Temp=[ceil(abs(r2-r1)/obj.input.Meshsize);...
            ceil(abs(V1(1,1)-V2(1,1))/obj.input.Meshsize)];
        numSteps=max(Temp);

        a1=Point2D('Top Verts','Echo',0);
        a1=AddPoint(a1,y2,z2);

        % 使用线性放样创建内表面
        l=AddElement(l,a1,'transform',[x2(1,1),0,0,0,90,0]);
        l=LoftLinear(l,Nmeshes+1,Nmeshes+2,'patchType',patchType,'numSteps',numSteps,'closeLoopOpt',1);

        NN=size(mm.Vert,1);
        Nmeshes=Nmeshes+1;
        mm.Vert=[mm.Vert;l.Meshes{Nmeshes,1}.Vert];
        mm.Face=[mm.Face;l.Meshes{Nmeshes,1}.Face+NN];
        mm.Cb=[mm.Cb;l.Meshes{Nmeshes,1}.Cb];

        % 更新边界标记（200+i表示第i段内表面）
        mm.Cb=mm.Cb*(200+i)./Nmeshes.*(mm.Cb==Nmeshes)...
            +mm.Cb.*(mm.Cb~=Nmeshes);
        V1=V2;r1=r2;

        %% 处理内径阶梯面
        r2=obj.input.ID(i-1,2)/2;
        if r2==0  % 到达实心部分，停止
            break
        elseif r2==obj.input.ID(i,1)/2
            continue
        end

        y2=cos((0:deg:360-deg)'/180*pi)*r2;
        z2=sin((0:deg:360-deg)'/180*pi)*r2;
        V2=[x2 y2 z2];

        Temp=[ceil(abs(r2-r1)/obj.input.Meshsize);...
            ceil(abs(V1(1,1)-V2(1,1))/obj.input.Meshsize)];
        numSteps=max(Temp);

        a1=Point2D('Top Verts','Echo',0);
        a1=AddPoint(a1,y2,z2);

        % 使用线性放样创建阶梯面
        l=AddElement(l,a1,'transform',[x2(1,1),0,0,0,90,0]);
        l=LoftLinear(l,Nmeshes+1,Nmeshes+2,'patchType',patchType,'numSteps',numSteps,'closeLoopOpt',1);

        NN=size(mm.Vert,1);
        Nmeshes=Nmeshes+1;
        mm.Vert=[mm.Vert;l.Meshes{Nmeshes,1}.Vert];
        mm.Face=[mm.Face;l.Meshes{Nmeshes,1}.Face+NN];
        mm.Cb=[mm.Cb;l.Meshes{Nmeshes,1}.Cb];
        Nsec=Nsec+1;
        mm.Cb=mm.Cb*Nsec./Nmeshes.*(mm.Cb==Nmeshes)...
            +mm.Cb.*(mm.Cb~=Nmeshes);
        V1=V2;r1=r2;

    end
end

%% 创建端面网格
% 实心段左侧端面
r2=r1;
r1=obj.input.ID(row-1,2)/2;  % 实心段左侧的内半径
if r1~=0
    m1=Mesh2D('Mesh1','Echo',0);
    m1=MeshQuadCircle(m1,'n',obj.params.E_Revolve/4,'r',r1);
    m1=Quad2Tri(m1);
    Temp=[obj.input.Length(row-1)*ones(size(m1.Vert,1),1),m1.Vert(:,1),m1.Vert(:,2)];
    numVert=size(mm.Vert,1);
    mm.Vert=[mm.Vert;Temp];
    mm.Face=[mm.Face;m1.Face+numVert.*ones(size(m1.Face,1),3)];
    mm.Cb=[mm.Cb;ones(size(m1.Face,1),1)*301];  % 左端面边界标记=301
end

% 实心段右侧端面（如果有内孔）
if r2~=0
    m2=Mesh2D('Mesh2','Echo',0);
    m2=MeshQuadCircle(m2,'n',obj.params.E_Revolve/4,'r',r2);
    m2=Quad2Tri(m2);
    % 反转面法线方向
    TempFace=[m2.Face(:,1),m2.Face(:,3),m2.Face(:,2)];
    m2.Face=TempFace;

    Temp=[V2(1,1)*ones(size(m2.Vert,1),1),m2.Vert(:,1),m2.Vert(:,2)];

    numVert=size(mm.Vert,1);
    mm.Vert=[mm.Vert;Temp];
    mm.Face=[mm.Face;m2.Face+numVert.*ones(size(m2.Face,1),3)];
    Nsec=Nsec+1;
    mm.Cb=[mm.Cb;ones(size(m2.Face,1),1)*Nsec];  % 右端面边界标记
end

%% 合并重复节点
mm=MergeFaceNode(mm);
end
