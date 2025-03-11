function Pos = GetNodePos(obj,NodeNum)
% Get Node position
% Author : Xie Yu

Shaft=obj.input.Shaft;
Pos=Shaft.Meshoutput.nodes(NodeNum,1);

end