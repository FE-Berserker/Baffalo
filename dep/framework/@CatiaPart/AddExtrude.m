function obj = AddExtrude(obj,Sketchno,height,varargin)
% Add extrude body
% Author: Xie Yu

p=inputParser;
addParameter(p,'BodyNo',1);
addParameter(p,'Height2',[]);
parse(p,varargin{:});
opt=p.Results;

Num1=opt.BodyNo;
if size(obj.Body,1)<Num1
    obj.Body{Num1,1}.BodyNo=opt.BodyNo;
    obj.Body{Num1,1}.Seq=[];
end
Num2=size(obj.Body{Num1,1}.Seq,1)+1;
obj.Body{Num1,1}.Seq{Num2,1}.SketchNo=Sketchno;
obj.Body{Num1,1}.Seq{Num2,1}.CatiaLab='AddNewPad';

if isempty(opt.Height2)
    obj.Body{Num1,1}.Seq{Num2,1}.CatiaData=height;
else
    obj.Body{Num1,1}.Seq{Num2,1}.CatiaData=[height,opt.Height2];
end
%% Print
if obj.Echo
    fprintf('Successfully add Extrude . \n');
end

end