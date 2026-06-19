function obj = AddPoint(obj,x,y,z)
% Add Point to Catia
% Author : Xie Yu

Num=GetNPoint(obj)+1;
obj.Point=[obj.Point;x,y,z];
obj.Summary.Total_Point=Num;

end