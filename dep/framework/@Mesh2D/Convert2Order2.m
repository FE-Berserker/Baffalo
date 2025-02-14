function obj = Convert2Order2(obj)
% Convert element order
% Author : Xie Yu
m=size(obj.Meshoutput.elements,2);
switch m
    case 3
        [TRI6,V6,~]=tri3_tri6(obj.Meshoutput.elements,obj.Meshoutput.nodes);
        obj.Face=TRI6;
        obj.Vert=V6;
        obj.Meshoutput.elements=TRI6;
        obj.Meshoutput.nodes=V6;
        obj.Meshoutput.order=2;
        O=FindBoundary(obj);
        obj.Boundary=O;
        obj.Meshoutput.facesBoundary=O;
    case 4
        [QUAD8,V8,~]=quad4_quad8(obj.Meshoutput.elements,obj.Meshoutput.nodes);
        obj.Face=QUAD8;
        obj.Vert=V8;
        obj.Meshoutput.elements=QUAD8;
        obj.Meshoutput.nodes=V8;
        obj.Meshoutput.order=2;
        O=FindBoundary(obj);
        obj.Boundary=O;
        obj.Meshoutput.facesBoundary=O;

end
%% Print
if obj.Echo
    fprintf('Successfully convert element order .\n');
end
end
