function obj=SetConET(obj,Numpair,ETno)
% Set contact elememt type
% Author : Xie Yu
obj.ContactPair{Numpair,1}.Con.ET=ETno;

%% Print
if obj.Echo
    fprintf('Successfully set contact element type .\n');
end
end
