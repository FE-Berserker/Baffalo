function [pc,ac]= ComputeGeometryDual(obj,Num)
% Compute Geometry Dual
% Author : Xie Yu

if isempty(obj.Duals)
    fprintf('Nothing to compute.\n');
end
cp=obj.Duals{Num,1}.cp;
ce=obj.Duals{Num,1}.ce;
pv=obj.Duals{Num,1}.pv;
ev=obj.Duals{Num,1}.ev;
[pc,ac] = geomdual2(cp,ce,pv,ev);

%% Print
if obj.Echo
    fprintf('Successfully compute geometry dual .\n');
end
end

