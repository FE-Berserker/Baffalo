function obj=SetET(obj,Numpart,NumET,varargin)
% Set element type for part
% Author : Xie Yu
obj.Part{Numpart,1}.ET=NumET;
SetRealConstants(obj,Numpart,NumET);
%% Print
if obj.Echo
    fprintf('Successfully set part element type . \n');
end
end