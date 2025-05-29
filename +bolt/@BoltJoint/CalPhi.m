function obj=CalPhi(obj)
% Calculate load factor Phi of Boltjoint
% Author: Xie Yu
deltap=obj.output.deltap;
deltapzu=obj.output.deltapzu;
deltas=obj.output.deltas;
n=obj.output.n;
PhiK=(deltap+deltapzu)/(deltas+deltap);
Phin=n*PhiK;
%% Parse
obj.output.Phin=Phin;

%% Print
if obj.params.Echo
    fprintf('Successfully calculate Phi .\n');
end
end