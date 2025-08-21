function obj=OutputBeamModel(obj)
% Output Beam model
% Author : Xie Yu
L=obj.output.Shape;
L=Meshoutput(L);
%% Parse
obj.output.BeamMesh.Meshoutput=L.Meshoutput{1,1};
obj.output.Matrix=L.Matrix{1,1};
%% Print
if obj.params.Echo
    fprintf('Successfully output beam assembly .\n');
end
end