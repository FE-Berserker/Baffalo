function obj=SetConRealConstants(obj,Numpair,opt)
% Set contact pair realcontants
obj.ContactPair{Numpair,1}.RealConstants=[obj.ContactPair{Numpair,1}.RealConstants;opt];
end

