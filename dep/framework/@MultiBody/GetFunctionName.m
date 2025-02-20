function Name=GetFunctionName(obj,NoFunction)
% Get Name of Body Function
% Author : Xie Yu

DataType=obj.Function{NoFunction,1}.DataType;
Name=strcat("$I_",num2str(NoFunction),"_",DataType);

end
