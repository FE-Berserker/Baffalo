function obj = CalGJS(obj,Rm,Rp)

%% Main
Sigma_b=1.06*Rm;
Sigma_0d2=Rp;
R=obj.input.R;
Sps=obj.params.Sps;
Gamma_m=obj.params.Gamma_m;
Beta_k=obj.params.Beta_k;
Sigma_m=obj.input.Sigma_m;
j0=obj.params.j0;
j=obj.input.j;

Ft=1;
Fo=1-0.22*(log10(obj.input.Rz))^(0.64)*log10(Sigma_b)+0.45*(log10(obj.input.Rz))^(0.53);
Fot=1-sqrt((1-Fo)^2+(1-Ft)^2);
Fotk=sqrt((Beta_k)^2-1+(Fot)^(-2));
m1=5.5*(Fotk)^(-2)+6;
m2=2*m1-1;
Sigma_w=0.27*Sigma_b+100;
M=0.00035*Sigma_b+0.08;
Sigma_wk=Sigma_w/Fotk;
% u=1/(M+1)*Sigma_wk/Sigma_b;
% a=(1+R)/(1-R)*Sigma_wk/Sigma_b;
% p=(1/(M+1)-1+u^2)/(u^2-u);

% if p<=1
%     Fm=-1*(1+p*a)/(2*a^2*(1-p))+sqrt(1/(1-p)/a/a+((1+p*a)/(2*a^2*(1-p)))^2);
% else
%     Fm=-1*(1+p*a)/(2*a^2*(1-p))-sqrt(1/(1-p)/a/a+((1+p*a)/(2*a^2*(1-p)))^2);
% end

if Sigma_m<=Sigma_wk/(M+1)
    Fm=1-M*Sigma_m/Sigma_wk;
else
    Fm=(Rm-Sigma_m)/(Rm*(M+1)-Sigma_wk);
end

Sigma_A=Sigma_wk*Fm;
Sd=0.85^(j-j0);
St=1;
S=Sd*Sps*St;
Delta_Sigma_A=2*Sigma_A*S/Gamma_m;
Delta_Sigma_1=Rp*(1-R)/Gamma_m;
ND=10^(6.8-3.6*m1^(-1));
N1=ND*(Delta_Sigma_A/Delta_Sigma_1)^(m1);
%% Parse
obj.output.Sigma_b=Sigma_b;
obj.output.Sigma_0d2=Sigma_0d2;
obj.output.Ft=Ft;
obj.output.Fo=Fo;
obj.output.Fot=Fot;
obj.output.Fotk=Fotk;
obj.output.m1=m1;
obj.output.m2=m2;
obj.output.Sigma_w=Sigma_w;
obj.output.M=M;
obj.output.Sigma_wk=Sigma_wk;
obj.output.Sigma_A=Sigma_A;
obj.output.Delta_Sigma_A=Delta_Sigma_A;
obj.output.St=St;
obj.output.S=S;
obj.output.Delta_Sigma_1=Delta_Sigma_1;
obj.output.ND=ND;
obj.output.N1=N1;
obj.output.Sd=Sd;

%% Print
if obj.params.Echo
    fprintf('Successfully calculate SN curve . \n');
end

end

