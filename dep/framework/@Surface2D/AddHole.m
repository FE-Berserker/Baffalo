function obj=AddHole(obj,Line1,varargin)
% AddHole add internal Hole
% Author : Xie Yu

p=inputParser;
addParameter(p,'rot',0);% Rotate angle
addParameter(p,'dis',[0,0]);% Displacement
parse(p,varargin{:});
opt=p.Results;

Temp_lnum=size(obj.Line,1);
obj.Line{Temp_lnum+1,1}=Line1;
obj.FN=obj.FN+1;
id=GetNface(obj);
% Add Nodes
Temp_node=obj.Line{id,1}.Point.P;
rot=[cos(opt.rot/180*pi),-sin(opt.rot/180*pi);sin(opt.rot/180*pi),cos(opt.rot/180*pi)];
Temp_node=rot*Temp_node';
Temp_node=Temp_node'+repmat(opt.dis,size(Temp_node,2),1);

obj.Node{id,1} = Temp_node;
Temp_nnum=size(obj.Node{id,1},1);
% Add Edges
Temp1=(1:Temp_nnum)'+obj.NN;
Temp2=(2:Temp_nnum)'+obj.NN;
Temp2=[Temp2;obj.NN+1];
obj.Edge{id,1}=[Temp1 Temp2];
% Update number of Nodes and Edges
obj.N=cell2mat(obj.Node);
obj.NN=size(obj.N,1);
obj.E=cell2mat(obj.Edge);
obj.EN=size(obj.E,1);
obj.FS=[obj.FS;1];
%% Print
if obj.Echo
    fprintf('Successfully add holes.\n');
end
end