function mm = CreateMesh3D2(obj)
% CreateMesh3D2 - 创建完全空心轴的3D网格
% 通过旋转2D截面生成3D网格，适用于内径始终大于0的轴
% Author: Xie Yu
%
% Output:
%   mm  - 包含顶点、面和边界标记的网格对象

%% 创建2D截面网格
m=Mesh2D('Mesh1','Echo',0);
m=AddSurface(m,obj.output.Surface);  % 添加轴的截面
m=SetSize(m,obj.input.Meshsize);     % 设置网格尺寸
m=Mesh(m);                           % 生成2D网格

%% 创建3D网格对象
mm=Mesh('Mesh2','Echo',0);
mm=Revolve2Solid(mm,m,'Slice',obj.params.E_Revolve); % 旋转2D截面生成3D网格

%% 计算修正系数（用于识别边界）
fix=1/cos(pi/obj.params.E_Revolve);  % 修正旋转误差

%% 设置底面边界标记（boundaryMarker=301）
Vm=PatchCenter(mm);  % 获取面中心点坐标
[row,~]=find(Vm(:,1)==0);
mm.Meshoutput.boundaryMarker(row)=301;

%% 处理阶梯面边界标记
if isscalar(obj.input.Length)
    % 单段轴：设置顶面边界标记（boundaryMarker=302）
    [row,~]=find(Vm(:,1)==obj.input.Length(end));
    mm.Meshoutput.boundaryMarker(row)=302;
else
    % 多段轴：设置各阶梯面边界标记
    Nsec=301;  % 边界标记起始值

    %% 处理外径阶梯面（301之后的标记）
    for i=1:numel(obj.input.Length)-1
        [row1,~]=find(Vm(:,1)==obj.input.Length(i));
        if isempty(row1)
            continue
        end
        % 计算该位置的外径范围
        Temp_min=min(obj.input.OD(i,2)/2,obj.input.OD(i+1,1)/2);
        Temp_max=max(obj.input.OD(i,2)/2,obj.input.OD(i+1,1)/2);
        Nsec=Nsec+1;
        % 标记外径阶梯面
        for j=1:numel(row1)
            R=sqrt(Vm(row1(j),2).^2+Vm(row1(j),3).^2)*fix;
            if R>Temp_min&&R<Temp_max
                mm.Meshoutput.boundaryMarker(row1(j))=Nsec;
            end
        end
    end

    % 设置右端面边界标记
    [row1,~]=find(Vm(:,1)==obj.input.Length(end));
    Nsec=Nsec+1;
    mm.Meshoutput.boundaryMarker(row1)=Nsec;

    %% 处理内径阶梯面（继续递增标记）
    for i=numel(obj.input.Length)-1:-1:1
        [row1,~]=find(Vm(:,1)==obj.input.Length(i));
        if isempty(row1)
            continue
        end
        % 计算该位置的内径范围
        Temp_min=min(obj.input.ID(i,2)/2,obj.input.ID(i+1,1)/2);
        Temp_max=max(obj.input.ID(i,2)/2,obj.input.ID(i+1,1)/2);
        Nsec=Nsec+1;
        % 标记内径阶梯面
        for j=1:numel(row1)
            R=sqrt(Vm(row1(j),2).^2+Vm(row1(j),3).^2)*fix;
            if R>Temp_min&&R<Temp_max
                mm.Meshoutput.boundaryMarker(row1(j))=Nsec;
            end
        end
    end
end

%% 设置外表面边界标记（101-1xx）
% 找到初始边界标记为1的面（内部生成的面）
[row,~]=find(mm.Meshoutput.boundaryMarker==1);
[row1,~]=find(Vm(row,1)>0&Vm(row,1)<obj.input.Length(1));

% 第一段的外表面标记（boundaryMarker=101）
Temp_min1=min(obj.input.OD(1,:)/2,[],2);
Temp_max1=max(obj.input.OD(1,:)/2,[],2);
Temp_min2=min(obj.input.ID(1,:)/2,[],2);
Temp_max2=max(obj.input.ID(1,:)/2,[],2);
for j=1:numel(row1)
    R=sqrt(Vm(row(row1(j)),2).^2+Vm(row(row1(j)),3).^2)*fix;

    % 外表面（101）
    if R>Temp_min1-1e-5&&R<Temp_max1+1e-5
        mm.Meshoutput.boundaryMarker(row(row1(j)))=101;
    end

    % 内表面（201）
    if R>Temp_min2-1e-5&&R<Temp_max2+1e-5
        mm.Meshoutput.boundaryMarker(row(row1(j)))=201;
    end
end

% 处理其他段的外表面标记（102-1xx, 202-2xx）
for i=2:numel(obj.input.Length)
    [row1,~]=find(Vm(row,1)>obj.input.Length(i-1)&...
        Vm(row,1)<obj.input.Length(i));
    Temp_min1=min(obj.input.OD(i,:)/2,[],2);
    Temp_max1=max(obj.input.OD(i,:)/2,[],2);
    Temp_min2=min(obj.input.ID(i,:)/2,[],2);
    Temp_max2=max(obj.input.ID(i,:)/2,[],2);
    for j=1:numel(row1)
        R=sqrt(Vm(row(row1(j)),2).^2+Vm(row(row1(j)),3).^2)*fix;

        % 外表面（100+i）
        if R>Temp_min1-1e-5&&R<Temp_max1+1e-5
            mm.Meshoutput.boundaryMarker(row(row1(j)))=100+i;
        end

        % 内表面（200+i）
        if R>Temp_min2-1e-5&&R<Temp_max2+1e-5
            mm.Meshoutput.boundaryMarker(row(row1(j)))=200+i;
        end
    end
end

%% 保存边界标记
mm.Cb=mm.Meshoutput.boundaryMarker;
end
