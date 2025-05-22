function [obj,NodeNum] = AddHousingCnode(obj,x,varargin)
% Add HousingCnode to Shaft
% Author : Xie Yu
p=inputParser;
addParameter(p,'Dtol',0.001);
parse(p,varargin{:});
opt=p.Results;

Housing=obj.input.Housing;

if isempty(Housing)
    error('Please input Housing !');
end

Section=Housing.Section;
NodeX=Housing.Meshoutput.nodes(:,1);

if or(x<NodeX(1,1),x>NodeX(end,1))
    error('Exceed the housing range!')
end

dis=NodeX-x;
row=find(abs(dis)==min(abs(dis)));
row=row(1,1);
if abs(dis(row,1))<=opt.Dtol
    NodeX(row,1)=x;
    NodeNum=row;
    obj.input.Housing.Meshoutput.nodes(:,1)=NodeX;
else
    if dis(row,1)<0
        NodeX=[NodeX(1:row,1);x;NodeX(row+1:end,1)];
        NewNodes=[NodeX,zeros(size(NodeX,1),2)];
        obj.input.Housing.Meshoutput.nodes=NewNodes;
        obj.input.Housing.Meshoutput.elements=[obj.input.Housing.Meshoutput.elements;size(NodeX,1)-1,size(NodeX,1)];
        obj.input.Housing.Meshoutput.elementMaterialID=[obj.input.Housing.Meshoutput.elementMaterialID;1];
        obj.input.Housing.Meshoutput.boundaryMarker=[obj.input.Housing.Meshoutput.boundaryMarker;size(NodeX,1)];
        NewSection=[Section(1:row,1);Section(row,1);Section(row+1:end,1)];
        obj.input.Housing.Section=NewSection;
        obj.input.HousingMaterialNum=[obj.input.HousingMaterialNum(1:row-1,1);obj.input.HousingMaterialNum(row,1);obj.input.HousingMaterialNum(row:end,1)];
        NodeNum=row+1;
        obj=Update(obj,NodeNum);
    else
        NodeX=[NodeX(1:row-1,1);x;NodeX(row:end,1)];
        NewNodes=[NodeX,zeros(size(NodeX,1),2)];
        obj.input.Housing.Meshoutput.nodes=NewNodes;
        obj.input.Housing.Meshoutput.elements=[obj.input.Housing.Meshoutput.elements;size(NodeX,1)-1,size(NodeX,1)];
        obj.input.Housing.Meshoutput.elementMaterialID=[obj.input.Housing.Meshoutput.elementMaterialID;1];
        obj.input.Housing.Meshoutput.boundaryMarker=[obj.input.Housing.Meshoutput.boundaryMarker;size(NodeX,1)];
        NewSection=[Section(1:row-1,1);Section(row,1);Section(row:end,1)];
        obj.input.Housing.Section=NewSection;
        obj.input.HousingMaterialNum=[obj.input.HousingMaterialNum(1:row-1,1);obj.input.HousingMaterialNum(row-1,1);obj.input.HousingMaterialNum(row:end,1)];
        NodeNum=row;
        obj=Update(obj,NodeNum);
    end
    obj.output.TotalNode=obj.output.TotalNode+1;
    obj.output.TotalElement=obj.output.TotalElement+1;
end

if obj.params.Echo
    fprintf('Successfully add housing cnode .\n');
end

end

function obj=Update(obj,NodeNum)
% HousingBCNode update
Bound=obj.input.HousingBCNode;
if ~isempty(obj.input.HousingBCNode)
    Judge=Bound(:,1);
    obj.input.HousingBCNode(Judge>=NodeNum,1)=...
        obj.input.HousingBCNode(Judge>=NodeNum,1)+1;
end

% HousingBearing update
Bearing=obj.input.HousingBearing;
if ~isempty(obj.input.HousingBearing)
    Judge=Bearing(:,1);
    obj.input.HousingBearing(Judge>=NodeNum,1)=...
        obj.input.HousingBearing(Judge>=NodeNum,1)+1;
end

% HousingTorBearing update
TorBearing=obj.input.HousingTorBearing;
if ~isempty(obj.input.HousingTorBearing)
    Judge=TorBearing(:,1);
    obj.input.HousingTorBearing(Judge>=NodeNum,1)=...
        obj.input.HousingTorBearing(Judge>=NodeNum,1)+1;
end

% HousingBendingBearing update
BendingBearing=obj.input.HousingBendingBearing;
if ~isempty(obj.input.HousingBendingBearing)
    Judge=BendingBearing(:,1);
    obj.input.HousingBendingBearing(Judge>=NodeNum,1)=...
        obj.input.HousingBendingBearing(Judge>=NodeNum,1)+1;
end

% Bearing update
Bearing=obj.input.Bearing;
if ~isempty(obj.input.Bearing)
    Judge=Bearing(:,end);
    obj.input.Bearing(Judge>=NodeNum,end)=...
        obj.input.Bearing(Judge>=NodeNum,end)+1;
end

% TorBearing update
TorBearing=obj.input.TorBearing;
if ~isempty(obj.input.TorBearing)
    Judge=TorBearing(:,end);
    obj.input.TorBearing(Judge>=NodeNum,end)=...
        obj.input.TorBearing(Judge>=NodeNum,end)+1;
end

% BendingBearing update
BendingBearing=obj.input.BendingBearing;
if ~isempty(obj.input.BendingBearing)
    Judge=BendingBearing(:,end);
    obj.input.BendingBearing(Judge>=NodeNum,end)=...
        obj.input.BendingBearing(Judge>=NodeNum,end)+1;
end

% LUTBearing update
LUTBearing=obj.input.LUTBearing;
if ~isempty(obj.input.LUTBearing)
    Judge=LUTBearing(:,end);
    obj.input.LUTBearing(Judge>=NodeNum,end)=...
        obj.input.LUTBearing(Judge>=NodeNum,end)+1;
end

% KeyNode update
KeyNode=obj.input.HousingKeyNode;
if ~isempty(obj.input.HousingKeyNode)
    Judge=KeyNode(:,1);
    obj.input.HousingKeyNode(Judge>=NodeNum,1)=...
        obj.input.HousingKeyNode(Judge>=NodeNum,1)+1;
end

% PIDController update
for i=1:size(obj.input.PIDController,1)
    Judge=obj.input.PIDController{i, 1}.Node1;
    if ~isempty(Judge)
        if Judge>=NodeNum
            obj.input.PIDController{i, 1}.Node1=...
                obj.input.PIDController{i, 1}.Node1+1;
        end
    end
end

end