function obj=AddForce(obj,FromBodyNo,FromNo,ToBodyNo,ToNo,varargin)
% Add Force to MultiBody
% Author : Xie Yu
p=inputParser;
addParameter(p,'Type',4);
addParameter(p,'Par',[]);
parse(p,varargin{:}); 
opt=p.Results;

% Check input
if ToBodyNo==FromBodyNo
    error('The Body number should not be the same !')
end

obj.Summary.Total_Force=GetNForce(obj)+1;
Id=obj.Summary.Total_Force;

obj.Force{Id,1}.Type=opt.Type;
obj.Force{Id,1}.From=[FromBodyNo,FromNo];
obj.Force{Id,1}.To=[ToBodyNo,ToNo];
obj.Force{Id,1}.Par=opt.Par;


%% Print
if obj.Echo
    fprintf('Successfully add force . \n');
end
end