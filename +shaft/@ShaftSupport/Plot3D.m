function Plot3D(obj,varargin)
% Plot3D - 绘制轴支座的3D模型
% 支持高亮显示特定面或显示所有面
% Author : Xie Yu
%
% 参数:
%   faceno   - 要高亮显示的面号（可选），为空时显示所有面
%   face_normal - 是否显示法向量（可选，默认0）

% 输入参数解析器
p=inputParser;
addParameter(p,'faceno',[]);          % 面号参数
addParameter(p,'face_normal',0);      % 法向量显示标志
parse(p,varargin{:});
opt=p.Results;

if isempty(opt.faceno)
    % 如果未指定面号，绘制所有面
    PlotFace(obj.output.SolidMesh,'face_normal',opt.face_normal,'face_alpha',1);
else
    % 如果指定了面号，高亮显示该面
    Temp=obj.output.SolidMesh;
    Cb=Temp.Cb;  % 获取边界标记数组

    % 将指定面设为颜色1，其他面设为颜色2
    Cb(Temp.Cb==opt.faceno,:)=1;
    Cb(Temp.Cb~=opt.faceno,:)=2;

    % 根据单元阶次选择不同的绘图方式
    if obj.params.Order==1
        % 一阶单元：使用完整的面数组
        g1=Rplot('faces',Temp.Face,'vertices',Temp.Vert,'facecolor',Cb);
    else
        % 二阶单元：面数组需要处理（只取前一半节点）
        g1=Rplot('faces',Temp.Face(:,1:end/2),'vertices',Temp.Vert,'facecolor',Cb);
    end

    % 设置图形属性
    g1=set_title(g1,'View face of elements');              % 设置标题
    g1=set_layout_options(g1,'axe',1);                    % 显示坐标轴
    g1=set_line_options(g1,'base_size',1,'step_size',0);  % 线条设置
    g1=set_axe_options(g1,'grid',1,'equal',1);           % 显示网格，等比例
    g1=geom_patch(g1,'alpha',1,'face_alpha',0.5,'face_normal',opt.face_normal);  % 面片设置

    % 创建图形窗口并绘制
    figure('Position',[100 100 800 800]);  % 800x800像素窗口
    draw(g1);
end
end