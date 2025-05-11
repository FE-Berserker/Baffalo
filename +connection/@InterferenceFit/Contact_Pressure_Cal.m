function [Pmax,Pmin,Pmean] = Contact_Pressure_Cal(obj)
%CONTACT_PRESSURE_CAL 此处显示有关此函数的摘要
%   此处显示详细说明
EA=obj.input.Hub_Mat.E;
El=obj.input.Shaft_Mat.E;
vA=obj.input.Hub_Mat.v;
vl=obj.input.Shaft_Mat.v;
QA=obj.input.DF/obj.input.DaA;
Ql=obj.input.Dil/obj.input.DF;
K=EA/El*((1+Ql^2)/(1-Ql^2)-vl)+(1+QA^2)/(1-QA^2)+vA;
Keciwmin=obj.output.Uwmin/obj.input.DF;
Keciwmax=obj.output.Uwmax/obj.input.DF;
Pmin=Keciwmin*EA/K;
Pmax=Keciwmax*EA/K;
Pmean=(Pmax+Pmin)/2;
end

