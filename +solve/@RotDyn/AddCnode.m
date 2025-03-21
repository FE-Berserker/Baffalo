function [obj,NodeNum] = AddCnode(obj,x,varargin)
% Add Cnode to Shaft
% Author : Xie Yu
p=inputParser;
addParameter(p,'Dtol',0.001);
parse(p,varargin{:});
opt=p.Results;

Shaft=obj.input.Shaft;
Section=Shaft.Section;
NodeX=Shaft.Meshoutput.nodes(:,1);
dis=NodeX-x;
row=find(abs(dis)==min(abs(dis)));
row=row(1,1);
if abs(dis(row,1))<=opt.Dtol
    NodeX(row,1)=x;
    NodeNum=row;
    obj.input.Shaft.Meshoutput.nodes(:,1)=NodeX;
else
    if dis(row,1)<0
        NodeX=[NodeX(1:row,1);x;NodeX(row+1:end,1)];
        NewNodes=[NodeX,zeros(size(NodeX,1),2)];
        obj.input.Shaft.Meshoutput.nodes=NewNodes;
        obj.input.Shaft.Meshoutput.elements=[obj.input.Shaft.Meshoutput.elements;size(NodeX,1)-1,size(NodeX,1)];
        obj.input.Shaft.Meshoutput.elementMaterialID=[obj.input.Shaft.Meshoutput.elementMaterialID;1];
        obj.input.Shaft.Meshoutput.boundaryMarker=[obj.input.Shaft.Meshoutput.boundaryMarker;size(NodeX,1)];
        NewSection=[Section(1:row,1);Section(row,1);Section(row+1:end,1)];
        obj.input.Shaft.Section=NewSection;
        NodeNum=row+1;
        obj=Update(obj,NodeNum);
    else
        NodeX=[NodeX(1:row-1,1);x;NodeX(row:end,1)];
        NewNodes=[NodeX,zeros(size(NodeX,1),2)];
        obj.input.Shaft.Meshoutput.nodes=NewNodes;
        obj.input.Shaft.Meshoutput.elements=[obj.input.Shaft.Meshoutput.elements;size(NodeX,1)-1,size(NodeX,1)];
        obj.input.Shaft.Meshoutput.elementMaterialID=[obj.input.Shaft.Meshoutput.elementMaterialID;1];
        obj.input.Shaft.Meshoutput.boundaryMarker=[obj.input.Shaft.Meshoutput.boundaryMarker;size(NodeX,1)];
        NewSection=[Section(1:row-1,1);Section(row,1);Section(row:end,1)];
        obj.input.Shaft.Section=NewSection;
        NodeNum=row;
        obj=Update(obj,NodeNum);
    end
end

if obj.params.Echo
    fprintf('Successfully add cnode .\n');
end

end

function obj=Update(obj,NodeNum)
% BCNode update
Bound=obj.input.BCNode;
if ~isempty(obj.input.BCNode)
    Judge=Bound(:,1);
    obj.input.BCNode(Judge>=NodeNum,1)=...
        obj.input.BCNode(Judge>=NodeNum,1)+1;
end

% Bearing update
Bearing=obj.input.Bearing;
if ~isempty(obj.input.Bearing)
    Judge=Bearing(:,1);
    obj.input.Bearing(Judge>=NodeNum,1)=...
        obj.input.Bearing(Judge>=NodeNum,1)+1;
end

% TorBearing update
TorBearing=obj.input.TorBearing;
if ~isempty(obj.input.TorBearing)
    Judge=TorBearing(:,1);
    obj.input.TorBearing(Judge>=NodeNum,1)=...
        obj.input.TorBearing(Judge>=NodeNum,1)+1;
end

% LUTBearing update
LUTBearing=obj.input.LUTBearing;
if ~isempty(obj.input.LUTBearing)
    Judge=LUTBearing(:,1);
    obj.input.LUTBearing(Judge>=NodeNum,1)=...
        obj.input.LUTBearing(Judge>=NodeNum,1)+1;
end

% Spring update
Springs=obj.input.Springs;
if ~isempty(obj.input.Springs)
    Judge=Springs(:,1);
    obj.input.Springs(Judge>=NodeNum,1)=...
        obj.input.Springs(Judge>=NodeNum,1)+1;
end

% Pointmass update
PointMass=obj.input.PointMass;
if ~isempty(obj.input.PointMass)
    Judge=PointMass(:,1);
    obj.input.PointMass(Judge>=NodeNum,1)=...
        obj.input.PointMass(Judge>=NodeNum,1)+1;
end

% UnBalanceForce update
UnBalanceForce=obj.input.UnBalanceForce;
if ~isempty(obj.input.UnBalanceForce)
    Judge=UnBalanceForce(:,1);
    obj.input.UnBalanceForce(Judge>=NodeNum,1)=...
        obj.input.UnBalanceForce(Judge>=NodeNum,1)+1;
end


% KeyNode update
KeyNode=obj.input.KeyNode;
if ~isempty(obj.input.KeyNode)
    Judge=KeyNode(:,1);
    obj.input.KeyNode(Judge>=NodeNum,1)=...
        obj.input.KeyNode(Judge>=NodeNum,1)+1;
end

% InNode update
InNode=obj.input.InNode;
if ~isempty(obj.input.InNode)
    Judge=InNode(:,1);
    obj.input.InNode(Judge>=NodeNum,1)=...
        obj.input.InNode(Judge>=NodeNum,1)+1;
end

% OutNode update
OutNode=obj.input.OutNode;
if ~isempty(obj.input.OutNode)
    Judge=OutNode(:,1);
    obj.input.OutNode(Judge>=NodeNum,1)=...
        obj.input.OutNode(Judge>=NodeNum,1)+1;
end

% TimeSeries update
TimeSeries=obj.input.TimeSeries;
if ~isempty(obj.input.TimeSeries)
    for i=1:size(obj.input.TimeSeries,1)
        TimeSeries{i,1}.Node=TimeSeries{i,1}.Node+(TimeSeries{i,1}.Node>=NodeNum);
    end
    obj.input.TimeSeries=TimeSeries;
end

% PIDController update
PIDController=obj.input.PIDController;
if ~isempty(obj.input.PIDController)
    for i=1:size(obj.input.PIDController,1)
        PIDController{i,1}.Node=PIDController{i,1}.Node+(PIDController{i,1}.Node>=NodeNum);
    end
    obj.input.PIDController=PIDController;
end

end