function [G,GroupSize]= EdgeGroup(obj)
% Find edge group
% Author : Xie Yu
groupOptStruct.outputType='label';
[G,~,GroupSize]=tesgroup(obj.Boundary,groupOptStruct); %Group connected faces
%% Print
if obj.Echo
    fprintf('Successfully output face group .\n');
end
end


