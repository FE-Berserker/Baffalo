function obj=SetGroup(obj,opt)
num=GetNGroup(obj)+1;
obj.Group{num,1}=opt;
end