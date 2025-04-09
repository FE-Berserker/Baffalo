function obj= AddTorBearing(obj,NodeNum,par,IsConnection)
% Add torsional bearing to Shaft
% par=[ktor,ctor]
% Author : Xie Yu
if nargin<4
    IsConnection=0;
end

if IsConnection==0
    obj.input.TorBearing=[obj.input.TorBearing;NodeNum,par,IsConnection,0];
elseif IsConnection==1
    % GetNodePosition
    Pos=obj.input.Shaft.Meshoutput.nodes(NodeNum,1);
    [obj,NodeNum1]=AddHousingCnode(obj,Pos);
    obj.input.TorBearing=[obj.input.TorBearing;NodeNum,par,IsConnection,NodeNum1];
end

end
