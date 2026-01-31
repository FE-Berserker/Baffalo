function mm = CreateMesh3D1(obj,mm,r1,r2)
% CreateMesh3D1 - 创建单段实心轴的3D网格
% 适用于只有一段且完全实心的轴
% Author: Xie Yu
%
% Inputs:
%   mm  - 网格对象
%   r1  - 左端面半径
%   r2  - 右端面半径
%
% Output:
%   mm  - 包含顶点、面和边界标记的网格对象

%% 计算旋转角度
deg=360/obj.params.E_Revolve;  % 每个分段的角度（度）

%% 创建圆柱侧面网格
% 左端面圆周上的点
x1=zeros(obj.params.E_Revolve,1);
y1=cos((0:deg:360-deg)'/180*pi)*r1;
z1=sin((0:deg:360-deg)'/180*pi)*r1;
V1=[x1 y1 z1];

% 右端面圆周上的点
x2=repmat(obj.input.Length(1),obj.params.E_Revolve,1);
y2=cos((0:deg:360-deg)'/180*pi)*r2;
z2=sin((0:deg:360-deg)'/180*pi)*r2;
V2=[x2 y2 z2];

% 计算轴向和径向方向的网格分段数
Temp=[ceil(abs(r2-r1)/obj.input.Meshsize);...
    ceil(abs(V1(1,1)-V2(1,1))/obj.input.Meshsize)];
numSteps=max(Temp);

%% 使用Layer方法创建侧面网格
% 创建端面点集
a=Point2D('Bottom Verts','Echo',0);
a=AddPoint(a,y1,z1);  % 左端面圆周点（y-z平面）

a1=Point2D('Top Verts','Echo',0);
a1=AddPoint(a1,y2,z2); % 右端面圆周点（y-z平面）

% 使用Layer创建侧面
l=Layer('Layer','Echo',0);
l=AddElement(l,a,'transform',[0,0,0,0,90,0]);      % 添加左端面，旋转90度到x-z平面
l=AddElement(l,a1,'transform',[obj.input.Length(1),0,0,0,90,0]); % 添加右端面
% 使用线性放样创建侧面网格
l=LoftLinear(l,1,2,'patchType','tri_slash','numSteps',numSteps,'closeLoopOpt',1);

% 保存侧面网格数据
mm.Vert=l.Meshes{1,1}.Vert;
mm.Face=l.Meshes{1,1}.Face;
mm.Cb=l.Meshes{1,1}.Cb*101;  % 侧面边界标记=101

%% 创建左端面网格
% 生成圆面网格（四边形网格后转为三角形）
m1=Mesh2D('Mesh1','Echo',0);
m1=MeshQuadCircle(m1,'n',obj.params.E_Revolve/4,'r',r1);
m1=Quad2Tri(m1);

% 将2D网格坐标转换为3D（z方向为x方向）
Temp=[zeros(size(m1.Vert,1),1),m1.Vert(:,1),m1.Vert(:,2)];
numVert=size(mm.Vert,1);
mm.Vert=[mm.Vert;Temp];       % 添加节点
mm.Face=[mm.Face;m1.Face+numVert.*ones(size(m1.Face,1),3)]; % 更新面索引
mm.Cb=[mm.Cb;ones(size(m1.Face,1),1)*301]; % 左端面边界标记=301

%% 创建右端面网格
m2=Mesh2D('Mesh2','Echo',0);
m2=MeshQuadCircle(m2,'n',obj.params.E_Revolve/4,'r',r2);
m2=Quad2Tri(m2);
% 反转面法线方向
TempFace=[m2.Face(:,1),m2.Face(:,3),m2.Face(:,2)];
m2.Face=TempFace;

% 将2D网格坐标转换为3D
Temp=[obj.input.Length(1)*ones(size(m2.Vert,1),1),m2.Vert(:,1),m2.Vert(:,2)];
numVert=size(mm.Vert,1);
mm.Vert=[mm.Vert;Temp];       % 添加节点
mm.Face=[mm.Face;m2.Face+numVert.*ones(size(m2.Face,1),3)]; % 更新面索引
mm.Cb=[mm.Cb;ones(size(m2.Face,1),1)*302]; % 右端面边界标记=302

%% 合并重复节点
mm=MergeFaceNode(mm);
end
