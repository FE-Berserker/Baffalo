function value=Cal_Co(obj)
% Calculate C0 for bearing
% Author : Xie Yu
Z=obj.input.Z;
i=obj.input.i;
Lwe=obj.output.Lwe;
Alpha=0;
gamma=obj.input.Dw*cos(Alpha/180*pi)/obj.input.Dpw;
value=44*(1-gamma)*i*Z*Lwe*obj.input.Dw*cos(Alpha/180*pi);
end
        