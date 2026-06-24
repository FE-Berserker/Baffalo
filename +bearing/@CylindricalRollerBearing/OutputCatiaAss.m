function CapAss = OutputCatiaAss(obj, print)
% OutputCatiaAss - 将滚子、外圈、内圈组合成 Catia 装配体
% Author: Yu Xie

if nargin < 2
    print = 1;
end

CapAss = CatiaAss(strcat(obj.params.Name, '_Assembly'));

Z = obj.input.Z;            % 滚子数
ROTX = obj.params.ROTX;     % 初始旋转角
Dpw = obj.input.Dpw;        % 节圆直径


%% 添加滚子（同一零件实例化 Z 次，按节圆均布）
pathRoller = strcat('.\', obj.params.Name, '_Roller.CATPart');
theta = (0:2*pi/Z:2*pi-2*pi/Z)' + ROTX;
for i = 1:Z
    y = Dpw/2 * cos(theta(i));
    z = Dpw/2 * sin(theta(i));
    CapAss = AddPart(CapAss, pathRoller, 'Offset', [0, y, z, 0, 0, 0]);
end

%% 添加外圈
if obj.params.isOuterRing
    pathOuter = strcat('.\', obj.params.Name, '_OuterRing.CATPart');
    CapAss = AddPart(CapAss, pathOuter, 'Offset', [0, 0, 0, 0, 0, 0]);
end

%% 添加内圈
if obj.params.isInnerRing
    pathInner = strcat('.\', obj.params.Name, '_InnerRing.CATPart');
    CapAss = AddPart(CapAss, pathInner, 'Offset', [0, 0, 0, 0, 0, 0]);
end

%% 输出装配体
if print
    CatiaOutput(CapAss);
end

if obj.params.Echo
    fprintf('Successfully output CatiaAss for cylindrical roller bearing.\n');
end

end

