function obj=OutputSolidModel1(obj)
% OutputSolidModel1 - 生成类型1轴支座实体模型
% 类型1特征：圆形底板，中心圆孔，多个装配孔沿圆周均匀分布
% Author : Xie Yu

% 计算外圆直径（轴直径 + 2*壁厚）
D1=obj.input.D+2*obj.input.N;
% 计算网格尺寸：外圆圆周除以旋转分段数
Meshsize=pi*D1/obj.params.E_Revolve;

%% 创建底板几何
a=Point2D('Temp','Echo',0);  % 创建2D点集对象
a=AddPoint(a,0,0);            % 添加原点作为圆心

% 添加外轮廓（圆形底板外缘）
b1=Line2D('Out','Echo',0);    % 创建外轮廓线对象
b1=AddCircle(b1,obj.input.H/2,a,1);  % 添加半径为H/2的完整圆

% 添加内轮廓（中心轴孔）
b2=Line2D('Inner','Echo',0);  % 创建内轮廓线对象
b2=AddCircle(b2,D1/2,a,1,'seg',obj.params.E_Revolve);  % 添加半径为D1/2的圆，指定分段数

% 添加装配孔（用于连接固定）
h=Line2D('Hole','Echo',0);    % 创建装配孔线对象
h=AddCircle(h,obj.input.d1/2/2*3,a,1,'seg',16);  % 半径为d1*0.75的圆，16段

% 创建底板表面（带中心孔）
S=Surface2D(b1,'Echo',0);     % 基于外轮廓创建表面
S=AddHole(S,b2);               % 在表面中心添加轴孔

% 沿圆周分布添加多个装配孔
theta=2*pi/obj.input.NH;       % 孔之间的角间距
for i=1:obj.input.NH
    % 计算第i个孔的中心位置（极坐标转直角坐标）
    S=AddHole(S,h,'dis',[obj.input.P/2*cos(theta*(i-1)),...
                        obj.input.P/2*sin(theta*(i-1))]);
end

%% 生成2D网格
m=Mesh2D('Temp','Echo',0);     % 创建2D网格对象
m=AddSurface(m,S);             % 添加表面到网格
m=SetSize(m,Meshsize);         % 设置网格尺寸
m=Mesh(m);                     % 生成网格

%% 网格边界层加密（提高边界处网格质量）
% 中心轴孔边界层加密
% factor计算：根据分段数计算边界拉伸系数
factor=1/cos((90-(obj.params.E_Revolve-2)*180/obj.params.E_Revolve/2)/180*pi);
m=MeshLayerEdge(m,2,obj.input.N*factor);  % 对边界2（中心孔）添加2层边界单元

% 装配孔边界层加密
factor=1/cos((90-(16-2)*180/16/2)/180*pi);
for i=1:obj.input.NH
    m=MeshLayerEdge(m,2,obj.input.d1/2/2*factor);  % 对装配孔边界添加边界层
end

%% 拉伸生成3D实体网格
mm=Mesh(obj.params.Name);      % 创建3D网格对象

% 向下拉伸底板厚度T（负方向）
mm=Extrude2Solid(mm,m,-obj.input.T,ceil(obj.input.T/Meshsize));

% 向上拉伸轴支座主体长度（L-T）
mm=Extrude2Solid(mm,m,obj.input.L-obj.input.T,ceil((obj.input.L-obj.input.T)/Meshsize),'Cb',2);
% 'Cb',2 表示设置边界标记为2

% 如果需要二阶单元，进行转换
if obj.params.Order==2
    mm = Convert2Order2(mm);
end

%% 保存结果
mm.Cb=mm.Meshoutput.boundaryMarker;       % 保存边界标记
mm.Face=mm.Meshoutput.facesBoundary;       % 保存边界面信息
mm.Meshoutput.nodes=mm.Meshoutput.nodes+obj.input.T;  % 调整节点Z坐标（向上平移T）
mm.Vert=mm.Meshoutput.nodes;               % 保存顶点坐标
obj.output.SolidMesh=mm;                   % 保存到输出对象

%% 打印提示信息
if obj.params.Echo
    fprintf('Successfully output solid model .\n');
end
end