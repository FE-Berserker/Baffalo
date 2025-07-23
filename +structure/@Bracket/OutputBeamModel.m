function obj=OutputBeamModel(obj)
% Output Beam model
% Author : Xie Yu
L=obj.input.Layer;
L.Echo=0;
Num=size(L.Lines,1);
if ~isempty(obj.input.Meshsize)
    for i=1:Num
        [Length,~,~,~] = CalculateCurvature(L,i);
        L=RebuildCurve(L,i,ceil(Length(end,1)/obj.input.Meshsize));
    end
    L1=Layer('New');
    for i=1:Num
        L1=AddCurve(L1,L.Lines{end/2+i,1}.P);
    end
else
    L1=L;
end
L1=Meshoutput(L1);
%% Parse
obj.output.BeamMesh.Meshoutput=L1.Meshoutput{1,1};
obj.output.Matrix=L1.Matrix{1,1};
%% Print
if obj.params.Echo
    fprintf('Successfully output beam assembly .\n');
end
end