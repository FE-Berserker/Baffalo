function Plot3D(obj,varargin)
% Plot3D - 绘制轴的3D图形
% 可以绘制整个轴或指定的面
% Author: Xie Yu
%
% Inputs:
%   faceno        - 要绘制的面编号（可选）
%   face_normal   - 是否显示面法线，默认0
%
% Examples:
%   Plot3D(obj)                           % 绘制整个轴
%   Plot3D(obj,'faceno',101)              % 绘制外表面
%   Plot3D(obj,'face_normal',1)           % 绘制整个轴并显示法线

%% 解析输入参数
p=inputParser;
addParameter(p,'faceno',[]);
addParameter(p,'face_normal',0);
parse(p,varargin{:});
opt=p.Results;

%% 绘制图形
if isempty(opt.faceno)
    % 绘制整个轴
    PlotFace(obj.output.SolidMesh,'face_normal',opt.face_normal,'face_alpha',1);
else
    % 绘制指定面
    Temp=obj.output.SolidMesh;
    Cb=Temp.Cb;
    % 将目标面标记为1，其他面标记为2
    Cb(Temp.Cb==opt.faceno,:)=1;
    Cb(Temp.Cb~=opt.faceno,:)=2;

    % 根据单元阶次选择面
    if obj.params.Order==1
        g1=Rplot('faces',Temp.Face,'vertices',Temp.Vert,'facecolor',Cb);
    else
        % 二阶单元的面数量是一阶的两倍
        g1=Rplot('faces',Temp.Face(:,1:end/2),'vertices',Temp.Vert,'facecolor',Cb);
    end

    % 设置绘图选项
    g1=set_title(g1,'View face of elements');
    g1=set_layout_options(g1,'axe',1);
    g1=set_line_options(g1,'base_size',1,'step_size',0);
    g1=set_axe_options(g1,'grid',1,'equal',1);
    g1=geom_patch(g1,'alpha',1,'face_alpha',0.5,'face_normal',opt.face_normal);

    % 创建绘图窗口
    figure('Position',[100 100 800 800]);
    draw(g1);
end

end
