function obj= SmoothFace(obj,N)
% Smooth face elements
cPar.Method='LAP';
cPar.n=N;
Eb=obj.Boundary;
cPar.RigidConstraints=unique(Eb(:));
[Vcs]=patchSmooth(obj.Face,obj.Vert,[],cPar);
obj.Vert=Vcs;
%% Print
if obj.Echo
    fprintf('Successfully smooth face .\n');
end
end

