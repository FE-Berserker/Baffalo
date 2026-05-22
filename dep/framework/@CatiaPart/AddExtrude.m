function obj = AddExtrude(obj,Sketchno,height)
% Add extrude body
% Author: Xie Yu

Num=GetNBody(obj)+1;
obj.Body{Num,1}.SketchNo=Sketchno;
obj.Body{Num,1}.CatiaLab='AddNewPad';
obj.Body{Num,1}.CatiaData=height;

end