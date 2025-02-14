function [G,GroupSize]= GroupTest(obj)
% Test face group
% Author : Xie Yu
groupOptStruct.outputType='label';
[G,~,GroupSize]=tesgroup(obj.Face,groupOptStruct); %Group connected faces
%% Print
if obj.Echo
    fprintf('Successfully output face group .\n');
end
end


