function obj=SetESYS(obj,num,cs)
% Set elements system
% Author : Xie Yu
obj.Part{num,1}.ESYS=cs;

%% Print
if obj.Echo
    fprintf('Successfully set element coordinate system .\n');
end
end