function obj=OutputSolidModel2(obj)
% OutputSolidModel2 - 生成类型2轴支座实体模型
% 类型2特征：方形带圆角底板（带4个平边），中心圆孔，装配孔沿圆周分布
% Author : Xie Yu

% 计算外圆直径（轴直径 + 2*壁厚）
D1=obj.input.D+2*obj.input.N;
% 计算网格尺寸：外圆圆周除以旋转分段数
Meshsize=pi*D1/obj.params.E_Revolve;

%% 创建底板几何（方形带圆角）
H=obj.input.H;  % 底板外接圆直径
K=obj.input.K;  % 平边之间的距离（方孔边长）
a=Point2D('Temp','Echo',0);  % 创建2D点集对象
a=AddPoint(a,0,0);            % 添加原点作为圆心

% 添加5个关键点：原点(1) + 4个圆弧中点(2-5)
% 这些点定义了方形底板4个平边的中点
a=AddPoint(a,[K/2;K/2],[sqrt(H^2-K^2);-sqrt(H^2-K^2)]/2);          % 右侧中点
a=AddPoint(a,[sqrt(H^2-K^2);-sqrt(H^2-K^2)]/2,-[K/2;K/2]);        % 下侧中点
a=AddPoint(a,-[K/2;K/2],[-sqrt(H^2-K^2);sqrt(H^2-K^2)]/2);        % 左侧中点
a=AddPoint(a,[-sqrt(H^2-K^2);sqrt(H^2-K^2)]/2,[K/2;K/2]);          % 上侧中点

% 添加外轮廓（由4条直线段和4段圆弧组成）
b1=Line2D('Out','Echo',0);  % 创建外轮廓线对象
sang=acos(K/H)/pi*180;      % 计算圆弧起始角度（弧度转角度）

% 右侧平边：点2到圆弧起点
b1=AddLine(b1,a,2);
% 右下角圆弧：从45°偏移位置开始，角度为-sang
b1=AddCircle(b1,H/2,a,1,'sang',-sang,'ang',-90+2*sang);
% 下侧平边
b1=AddLine(b1,a,3);
% 左下角圆弧
b1=AddCircle(b1,H/2,a,1,'sang',-sang-90,'ang',-90+2*sang);
% 左侧平边
b1=AddLine(b1,a,4);
% 左上角圆弧
b1=AddCircle(b1,H/2,a,1,'sang',-sang-180,'ang',-90+2*sang);
% 上侧平边
b1=AddLine(b1,a,5);
% 右上角圆弧
b1=AddCircle(b1,H/2,a,1,'sang',-sang-270,'ang',-90+2*sang);

% 添加内轮廓（中心轴孔）
b2=Line2D('Inner','Echo',0);  % 创建内轮廓线对象
b2=AddCircle(b2,D1/2,a,1,'seg',obj.params.E_Revolve);  % 中心圆孔

% 添加装配孔（用于连接固定）
h=Line2D('Hole','Echo',0);    % 创建装配孔线对象
h=AddCircle(h,obj.input.d1/2/2*3,a,1,'seg',16);  % 半径为d1*0.75的圆，16段

% 创建底板表面（带中心孔）
S=Surface2D(b1,'Echo',0);     % 基于外轮廓创建表面
S=AddHole(S,b2);               % 在表面中心添加轴孔

% 沿圆周分布添加多个装配孔（偏移π/4，即45°）
theta=2*pi/obj.input.NH;       % 孔之间的角间距
for i=1:obj.input.NH
    % 计算第i个孔的中心位置，加入45°偏移以适应方形底板
    S=AddHole(S,h,'dis',[obj.input.P/2*cos(theta*(i-1)+pi/4),...
                        obj.input.P/2*sin(theta*(i-1)+pi/4)]);
end

%% 生成2D网格
m=Mesh2D('Temp','Echo',0);     % 创建2D网格对象
m=AddSurface(m,S);             % 添加表面到网格
m=SetSize(m,Meshsize);         % 设置网格尺寸
m=Mesh(m);                     % 生成网格

%% 网格边界层加密
% 中心轴孔边界层加密
factor=1/cos((90-(obj.params.E_Revolve-2)*180/obj.params.E_Revolve/2)/180*pi);
m=MeshLayerEdge(m,2,obj.input.N*factor);  % 对边界2添加边界层

% 装配孔边界层加密
factor=1/cos((90-(16-2)*180/16/2)/180*pi);
for i=1:obj.input.NH
    m=MeshLayerEdge(m,2,obj.input.d1/2/2*factor);
end

%% 拉伸生成3D实体网格
mm=Mesh(obj.params.Name);      % 创建3D网格对象
mm=Extrude2Solid(mm,m,-obj.input.T,ceil(obj.input.T/Meshsize));  % 向下拉伸底板
mm=Extrude2Solid(mm,m,obj.input.L-obj.input.T,ceil((obj.input.L-obj.input.T)/Meshsize),'Cb',2);  % 向上拉伸主体

% 如果需要二阶单元，进行转换
if obj.params.Order==2
    mm = Convert2Order2(mm);
end

%% 保存结果
mm.Cb=mm.Meshoutput.boundaryMarker;
mm.Face=mm.Meshoutput.facesBoundary;
mm.Meshoutput.nodes=mm.Meshoutput.nodes+obj.input.T;  % 调整节点Z坐标
mm.Vert=mm.Meshoutput.nodes;
obj.output.SolidMesh=mm;

%% 打印提示信息
if obj.params.Echo
    fprintf('Successfully output solid model .\n');
end
end