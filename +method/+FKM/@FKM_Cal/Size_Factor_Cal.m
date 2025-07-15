function [Kdm,Kdp,Rm,Rp] = Size_Factor_Cal(obj)
% Size Factor Calculation
% Author : Xie Yu
Type=obj.input.Mat.Type;
KA=obj.params.KA;
RmN=obj.input.Mat.FKM.RmN;
RpN=obj.input.Mat.FKM.ReN;
adm=obj.input.Mat.FKM.adm;
adp=obj.input.Mat.FKM.adp;
deffN=obj.input.Mat.FKM.deffN;
deff=obj.input.deff;
switch Type
    case "Cast iron flake graphite GJL"
        Kdm=1.207*(deff<=7.5)+1.207*(deff/7.5)^(-0.1922)*(deff>7.5);
        Kdp=1.207*(deff<=7.5)+1.207*(deff/7.5)^(-0.1922)*(deff>7.5);
    case "Through hardening steel"
        Kdm=1*(deff<=deffN)+...
            (1-0.7686*adm*log10(deff/7.5))/(1-0.7686*adm*log10(deffN/7.5))*(deff>deffN);
        Kdp=1*(deff<=deffN)+...
            (1-0.7686*adp*log10(deff/7.5))/(1-0.7686*adp*log10(deffN/7.5))*(deff>deffN);
    case "case hardening steel"
        Kdm=1*(deff<=deffN)+...
            (1-0.7686*adm*log10(deff/7.5))/(1-0.7686*adm*log10(deffN/7.5))*(deff>deffN);
        Kdp=1*(deff<=deffN)+...
            (1-0.7686*adp*log10(deff/7.5))/(1-0.7686*adp*log10(deffN/7.5))*(deff>deffN);
    case "Structural steel"
        Kdm=1*(deff<=deffN)+...
            (1-0.7686*adm*log10(deff/7.5))/(1-0.7686*adm*log10(deffN/7.5))*(deff>deffN);
        Kdp=1*(deff<=deffN)+...
            (1-0.7686*adp*log10(deff/7.5))/(1-0.7686*adp*log10(deffN/7.5))*(deff>deffN);
    case "Nitriding steel"
        Kdm=1*(deff<=deffN)+...
            (1-0.7686*adm*log10(deff/7.5))/(1-0.7686*adm*log10(deffN/7.5))*(deff>deffN);
        Kdp=1*(deff<=deffN)+...
            (1-0.7686*adp*log10(deff/7.5))/(1-0.7686*adp*log10(deffN/7.5))*(deff>deffN);
    case "Cast iron spherioidal graphite GJS"
        Kdm=1*(deff<=deffN)+...
            (1-0.7686*adm*log10(deff/7.5))/(1-0.7686*adm*log10(deffN/7.5))*(deff>deffN);
        Kdp=1*(deff<=deffN)+...
            (1-0.7686*adp*log10(deff/7.5))/(1-0.7686*adp*log10(deffN/7.5))*(deff>deffN);

end
Rm=Kdm*KA*RmN;
Rp=Kdp*KA*RpN;

%% Print
if obj.params.Echo
    fprintf('Successfully calculate size factor . \n');
end
end

