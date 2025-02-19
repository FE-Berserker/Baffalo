function obj=SetTarET(obj,Numpair,ETno)
% Set target elememt type
% Author : Xie Yu
obj.ContactPair{Numpair,1}.Tar.ET=ETno;
%% Print
if obj.Echo
    fprintf('Successfully set contact element type .\n');
end
end
