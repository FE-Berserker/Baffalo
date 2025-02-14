function [L,R,k,Normal] = CalculateCurvature(obj,LineNo)
% Calculate curvature of curve
% Author : Xie Yu
P=obj.Lines{LineNo,1}.P;
[L,R,k,Normal] = curvature(P);
%% Print
if obj.Echo
    fprintf('Successfully calculate curvature .\n');
end
end

