function obj = AddRotate(obj,Sketchno,varargin)
% Add rotate body
% Author: Xie Yu

p=inputParser;
addParameter(p,'Axis','x');
parse(p,varargin{:});
opt=p.Results;

Num=GetNBody(obj)+1;
obj.Body{Num,1}.SketchNo=Sketchno;
obj.Body{Num,1}.CatiaLab='AddNewShaft';
obj.Body{Num,1}.CatiaData=[];
obj.Body{Num,1}.Ref=opt.Axis;

end