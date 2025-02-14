function [pc,ac]= ComputeGeometryDual(obj)
% Compute Geometry Dual

if isempty(obj.Dual)
    fprintf('Nothing to compute.\n');
end
cp=obj.Dual.cp;
ce=obj.Dual.ce;
pv=obj.Dual.pv;
ev=obj.Dual.ev;
[pc,ac] = geomdual2(cp,ce,pv,ev);
end

