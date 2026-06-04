function [Pd,Pd_0,Pd_T,Pd_f] = Cal_Pd(obj)
% Calculate pd for bearing
% Author : Xie Yu

%1. 安装游隙计算
Pd_0=obj.params.Pd0;

%2. 温差游隙计算
Outring=obj.input.Dpw+obj.input.Dw;
Innerring=obj.input.Dpw-obj.input.Dw;
alpha=1.25e-5;%热膨胀系数
T_ref=obj.params.T_Ref;
T_outring=obj.params.Temp(1,2);
T_innerring=obj.params.Temp(1,1);
T_roller=(T_outring+T_innerring)/2;

delta1=Outring*(T_outring-T_ref)*alpha+Outring;%外圈变形
delta2=Innerring*(T_innerring-T_ref)*alpha+Innerring;%内圈变形
delta3=obj.input.Dw*(T_roller-T_ref)*alpha+obj.input.Dw;%滚子变形

Pd_T=delta1-delta2-delta3*2;
obj.output.Temperature=[T_outring,T_roller,T_innerring];

%3. 过盈游隙计算
I1=obj.params.U(1,1);
I2=obj.params.U(1,2);
Dii=obj.input.Di;
Dio=Innerring;
Doi=Outring;
Doo=obj.input.Do;
Dsi=obj.params.Dil;
if Dsi==0
    Dsi=0.001;
end
if ~isempty(obj.params.DaA)
    Dho=obj.params.DaA;
else
    Dho=2*Doo;
end
deltas=I1*Dio/Dii*(((Dii/Dsi)^2-1)/((Dio/Dsi)^2-1))*(I1>=0)+I1*(I1<0);
deltah=I2*Doo/Doi*(((Dho/Doo)^2-1)/((Dho/Doi)^2-1))*(I2>=0)+I2*(I2<0);
Pd_f=-deltas-deltah;
Pd=Pd_0+Pd_T+Pd_f;

end

