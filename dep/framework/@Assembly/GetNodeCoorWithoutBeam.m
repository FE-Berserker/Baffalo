function Coor=GetNodeCoorWithoutBeam(obj)
% Get Node coordinate (exclude beam dir node)
% Author : Xie Yu

Coor=[obj.V;obj.Cnode];
BeamNode=obj.BeamDirectionNode;
Coor(BeamNode,:)=[];

end