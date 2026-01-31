function [C10,C01] = MR_Estimate(obj)
% Mooney-Rivlin parameter estimate
% Author : Xie Yu
E=obj.output.E;
Ratio=0.25;
C10=E/6/(1+Ratio);
C01=C10*Ratio;
end

