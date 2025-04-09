function obj= AddLUTBearing(obj,NodeNum,Tableno,IsConnection)
% Add LUT bearing to Shaft
% Author : Xie Yu

if nargin<4
    IsConnection=0;
end

if IsConnection==0
    obj.input.LUTBearing=[obj.input.LUTBearing;NodeNum,Tableno,IsConnection,0];
elseif IsConnection==1
    % GetNodePosition
    Pos=obj.input.Shaft.Meshoutput.nodes(NodeNum,1);
    [obj,NodeNum1]=AddHousingCnode(obj,Pos);
    obj.input.LUTBearing=[obj.input.LUTBearing;NodeNum,Tableno,IsConnection,NodeNum1];
end
end
