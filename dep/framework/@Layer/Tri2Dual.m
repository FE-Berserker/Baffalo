function obj=Tri2Dual(obj,meshno)
% convert Tri mesh to Dual mesh

%% Parse input
pp = obj.Meshes{meshno,1}.Vert;
tt = obj.Meshes{meshno,1}.Face;

[cp,ce,pv,ev] = makedual2(pp,tt);

Num=GetNDuals(obj);
obj.Duals{Num+1,1}.cp=cp;
obj.Duals{Num+1,1}.ce=ce;
obj.Duals{Num+1,1}.pv=pv;
obj.Duals{Num+1,1}.ev=ev;
[~,tv] = triadual2(cp,ce,ev);
obj.Duals{Num+1,1}.Cb=(Num+1)*ones(size(tv,1),1);

%% Print
if obj.Echo
    fprintf('Successfully convert tri to dual .\n');
end
end

