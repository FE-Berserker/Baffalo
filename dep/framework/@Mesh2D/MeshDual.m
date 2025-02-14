function obj= MeshDual(obj)
% Mesh Dual
% Author : Xie Yu

pp=obj.Vert;
tt=obj.Face;
[cp,ce,pv,ev] = makedual2(pp,tt);
obj.Dual.cp=cp;
obj.Dual.ce=ce;
obj.Dual.pv=pv;
obj.Dual.ev=ev;

%% Print
if obj.Echo
    fprintf('Successfully mesh dual .\n');
end
end

