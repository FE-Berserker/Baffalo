function obj= AddBearing(obj,NodeNum,Par,IsConnection)
% Add bearing to Shaft
% Par=[Kx,K11,K22,K12,K,21,Cx,C11,C22,C12,C21]
% Author : Xie Yu
if nargin<4
    IsConnection=0;
end

if IsConnection==0
    obj.input.Bearing=[obj.input.Bearing;NodeNum,Par,IsConnection,0];
elseif IsConnection==1
    % GetNodePosition
    Pos=obj.input.Shaft.Meshoutput.nodes(NodeNum,1);
    [obj,NodeNum1]=AddHousingCnode(obj,Pos);
    obj.input.Bearing=[obj.input.Bearing;NodeNum,Par,IsConnection,NodeNum1];
end

end
