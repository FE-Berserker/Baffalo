function Vm = PatchCenter(obj)
% Get Center of Face boundary
% Author : Xie Yu
F=obj.Meshoutput.facesBoundary;
V=obj.Meshoutput.nodes;
[Vm]=patchCentre(F,V);

%% Print
if obj.Echo
    fprintf('Successfully get surface center .\n');
end
end

