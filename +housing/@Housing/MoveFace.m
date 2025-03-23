function obj=MoveFace(obj,Faceno,movement,varargin)
% Move face
% Author : Xie Yu
p=inputParser;
addParameter(p,'num',1);
parse(p,varargin{:});
opt=p.Results;

R_z=[cos(movement(3)/180*pi),-sin(movement(3)/180*pi);...
    sin(movement(3)/180*pi),cos(movement(3)/180*pi)];

Num=size(Faceno,1);
if opt.num==1
    for j=1:Num
        Node=obj.output.Surface.Node{Faceno(j,1),1};
        NumNodes=size(Node,1);
        Node=Node*R_z+repmat(movement(:,1:2),NumNodes,1);
        obj.output.Surface.Node{Faceno(j,1),1}=Node;
    end
end

if opt.num>1
    for i=2:opt.num
        Total_FaceNum = GetNFace(obj);
        for j=1:Num
            Node=obj.output.Surface.Node{Total_FaceNum-Num+1,1};
            NumNodes=size(Node,1);
            Node=Node*R_z+repmat(movement(:,1:2),NumNodes,1);
            a=Point2D('Temp_Point','Echo',0);
            a=AddPoint(a,Node(:,1),Node(:,2));
            Temp_Line=Line2D('Temp_Line','Echo',0);
            Temp_Line=AddCurve(Temp_Line,a,1);
            obj.output.Surface=AddHole(obj.output.Surface,Temp_Line);
        end
    end
end
obj=OutputSolidModel(obj);
obj=OutputAss(obj);
%% Print
if obj.params.Echo
    fprintf('Successfully move face .\n');
end
end

