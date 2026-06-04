function obj=OutputAss(obj)
% Output Assembly of bearing
% Author : Xie Yu
if obj.output.Pd(1,1)>=0
    obj=OutputAss1(obj);
else
    obj=OutputAss2(obj);
end
end

