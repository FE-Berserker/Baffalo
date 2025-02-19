function obj=AddPart(obj,Meshoutput,varargin)
% Add Part to Assembly
% Author : Xie Yu

p=inputParser;
addParameter(p,'position',[0,0,0,0,0,0]);
parse(p,varargin{:});
opt=p.Results;

position=opt.position;
obj.Summary.Total_Part=GetNPart(obj)+1;
Id=obj.Summary.Total_Part;

NumElements=size(Meshoutput.elements,1);
NumNodes=size(Meshoutput.nodes,1);
mesh=Meshoutput;
T=Transform(mesh.nodes);
T=Rotate(T,position(4),position(5),position(6));
T=Translate(T,position(1),position(2),position(3));
mesh.nodes=Solve(T);

obj.Part{Id,1}.acc_node=obj.Summary.Total_Node;
obj.Part{Id,1}.acc_el=obj.Summary.Total_El;
obj.Part{Id,1}.NumElements=NumElements;
obj.Part{Id,1}.NumNodes=NumNodes;
obj.Part{Id,1}.mesh=mesh;
obj.Part{Id,1}.position=position;
obj.Part{Id,1}.ET=[];
obj.Part{Id,1}.ESYS=0;
obj.Part{Id,1}.Sec=0;
obj.Part{Id,1}.RealConstants=0;
obj.Part{Id,1}.New=0;

obj.Summary.Total_El=GetNEl(obj);
obj.Summary.Total_Node=GetNNode(obj);
obj.V=[obj.V;mesh.nodes];

%% Print
if obj.Echo
    fprintf('Successfully add parts . \n');
end
end