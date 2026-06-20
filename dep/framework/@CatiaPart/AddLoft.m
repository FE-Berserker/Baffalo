function obj = AddLoft(obj,Sketchno1,Sketchno2,varargin)
% Add loft body
% Author: Xie Yu

p=inputParser;
addParameter(p,'BodyNo',1);
addParameter(p,'Type',3);
parse(p,varargin{:});
opt=p.Results;

Num1=opt.BodyNo;
if size(obj.Body,1)<Num1
    obj.Body{Num1,1}.BodyNo=opt.BodyNo;
    obj.Body{Num1,1}.Seq=[];
end
Num2=size(obj.Body{Num1,1}.Seq,1)+1;
obj.Body{Num1,1}.Seq{Num2,1}.SketchNo=[Sketchno1,Sketchno2];
obj.Body{Num1,1}.Seq{Num2,1}.CatiaLab='AddNewLoft';
obj.Body{Num1,1}.Seq{Num2,1}.CatiaData=opt.Type;

%% Print
if obj.Echo
    fprintf('Successfully add Loft . \n');
end

end