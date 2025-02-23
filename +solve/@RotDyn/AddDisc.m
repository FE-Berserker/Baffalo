function obj= AddDisc(obj,NodeNum,OD,ID,Length,MatNum)
% Add Disc to Shaft
% Author : Xie Yu
obj.input.Discs=[obj.input.Discs;NodeNum,OD,ID,Length,MatNum];
% Update Shape
obj=CalculateShape(obj);
end

