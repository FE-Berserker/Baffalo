function [Roller_Delta,Matrix,Bearing_Displacement] = Cal_Roller_U(obj)
%计算每个滚子的变形
% 轴承游隙
Pd=obj.output.Pd(1,1);
t = (0:2*pi/obj.input.Z:2*pi-2*pi/obj.input.Z)'+obj.params.ROTX;
% 计算位移和初始方位角
Uy=obj.input.Uy;
Uz=obj.input.Uz;
if isempty(Uy)
    Uy=0;
end
if isempty(Uz)
    Uz=0;
end

theta=acos(Uy/sqrt((Uz^2+Uy^2)));
if Uz<0
    theta=2*pi-theta;
end

Bearing_Displacement=[Uy,Uz];
deltar=sqrt(Uz^2+Uy^2);
fi=t-theta;
Roller_Delta=deltar*cos(fi)-0.5*Pd;

Matrix=[cos(t),sin(t)];

end
