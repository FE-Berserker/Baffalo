function obj= Smoothface(obj,N,method)
if nargin<3
    cPar.Method='LAP';
else
    cPar.Method=method;
end
cPar.n=N;
Eb=patchBoundary(obj.Face);
cPar.RigidConstraints=unique(Eb(:));
[Vcs]=patchSmooth(obj.Face,obj.Vert,[],cPar);
obj.Vert=Vcs;
end

