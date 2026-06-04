function value=Cal_Cr(obj)
% Calculate Cr for bearing
% Author : Xie Yu

c=obj.params.c;
h=obj.params.h;
e=obj.params.e;
B1=551.13373/0.483;
i=obj.input.i;
Lwe=obj.output.Lwe;
bm=obj.params.bm;

Alpha=0;
Z=obj.input.Z;
gamma=obj.input.Dw*cos(Alpha/180*pi)/obj.input.Dpw;
Lambda_nu=0.83;
fc=0.377*Lambda_nu*1/(2^((c+h-1)/(c-h+1))*0.5^((2*e)/(c-h+1)))*...
    B1*((1-gamma)^((c+h-3)/(c-h+1))/((1+gamma)^(2*e/(c-h+1))))*gamma^(2/(c-h+1))*...
    (1+(1.04*((1-gamma)/(1+gamma))^((c+h+2*e-3)/(c-h+1)))^((c-h+1)/2))^(-2/(c-h+1));

value=bm*fc*(i*Lwe*cos(Alpha/180*pi))^((c-h-1)/(c-h+1))*...
    Z^((c-h-2*e+1)/(c-h+1))*obj.input.Dw^((c+h-3)/(c-h+1))...
    *obj.params.bm;
end