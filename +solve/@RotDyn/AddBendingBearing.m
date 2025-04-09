function obj= AddBendingBearing(obj,NodeNum,par,IsConnection)
% Add bending bearing to Shaft
% par=[kroty,krotz,croty,ctotz]
% Author : Xie Yu

if nargin<4
    IsConnection=0;
end

if IsConnection==0
    obj.input.BendingBearing=[obj.input.BendingBearing;NodeNum,par,IsConnection,0];
elseif IsConnection==1
    % GetNodePosition
    Pos=obj.input.Shaft.Meshoutput.nodes(NodeNum,1);
    [obj,NodeNum1]=AddHousingCnode(obj,Pos);
    obj.input.BendingBearing=[obj.input.BendingBearing;NodeNum,par,IsConnection,NodeNum1];
end
end
