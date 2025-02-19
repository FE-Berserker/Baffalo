function obj=AddSolu(obj,opt)
% Add solution to Assembly
% Author : Xie Yu
Num=GetNSolu(obj);
obj.Solu{Num+1,1}=opt;

%% Print
if obj.Echo
    fprintf('Successfully add solution . \n');
end

end

