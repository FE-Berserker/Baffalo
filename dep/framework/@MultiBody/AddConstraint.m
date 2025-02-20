function obj=AddConstraint(obj,FromBodyNo,FromNo,ToBodyNo,ToNo,varargin)
% Add Constraint to MultiBody
% Author : Xie Yu
p=inputParser;
addParameter(p,'Type',25);
addParameter(p,'Par',[]);
parse(p,varargin{:});
opt=p.Results;

% Check input
if ToBodyNo==FromBodyNo
    error('The Body number should not be the same !')
end

obj.Summary.Total_Constraint=GetNConstraint(obj)+1;
Id=obj.Summary.Total_Constraint;

obj.Constraint{Id,1}.Type=opt.Type;
obj.Constraint{Id,1}.From=[FromBodyNo,FromNo];
obj.Constraint{Id,1}.To=[ToBodyNo,ToNo];
obj.Constraint{Id,1}.Par=opt.Par;

switch opt.Type
    case 25
        Constraint=[0,0,0,0,0,0];
        for i=1:size(opt.Par,1)
            Judge=opt.Par(i,1);
            if Judge<=3
                Constraint(Judge+3)=opt.Par(i,2);
            else
                Constraint(Judge-3)=opt.Par(i,2);
            end

        end
end

obj.Body{ToBodyNo,1}.Constraint=Constraint;

%% Print
if obj.Echo
    fprintf('Successfully add constraint . \n');
end
end