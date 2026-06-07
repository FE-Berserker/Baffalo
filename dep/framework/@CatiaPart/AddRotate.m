function obj = AddRotate(obj,Sketchno,varargin)
% Add rotate body
% Author: Xie Yu

p=inputParser;
addParameter(p,'Axis','x');
addParameter(p,'BodyNo',1);
parse(p,varargin{:});
opt=p.Results;

Num1=opt.BodyNo;
if size(obj.Body,1)<Num1
    obj.Body{Num1,1}.BodyNo=opt.BodyNo;
    obj.Body{Num1,1}.Seq=[];
end
Num2=size(obj.Body{Num1,1}.Seq,1)+1;

obj.Body{Num1,1}.Seq{Num2,1}.SketchNo=Sketchno;
obj.Body{Num1,1}.Seq{Num2,1}.CatiaLab='AddNewShaft';
obj.Body{Num1,1}.Seq{Num2,1}.CatiaData=[];
obj.Body{Num1,1}.Seq{Num2,1}.Ref=opt.Axis;

%% Print
if obj.Echo
    fprintf('Successfully add Rotate . \n');
end

end