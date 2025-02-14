function obj = Convert2Order2(obj)
% Convert element order
% Author : Xie Yu
m=size(obj.Meshoutput.elements,2);
switch m
    case 8
        [obj.El,obj.Vert,~,obj.Face]=hex8_hex20(obj.Meshoutput.elements,obj.Meshoutput.nodes,{},obj.Meshoutput.facesBoundary);
        obj.Meshoutput.elements=obj.El;
        obj.Meshoutput.nodes=obj.Vert;
        obj.Meshoutput.facesBoundary=obj.Face;
        obj.Meshoutput.order=2;
    case 4
        if ~isempty(obj.Meshoutput.faces)
            [obj.El,obj.Vert,~,obj.Face]=tet4_tet10(obj.Meshoutput.elements,obj.Meshoutput.nodes,{},obj.Meshoutput.facesBoundary);
            obj.Meshoutput.elements=obj.El;
            obj.Meshoutput.nodes=obj.Vert;
            obj.Meshoutput.facesBoundary=obj.Face;
            obj.Meshoutput.order=2;
        else
            [QUAD8,V8,~]=quad4_quad8(obj.Meshoutput.elements,obj.Meshoutput.nodes);
            obj.Face=QUAD8;
            obj.Vert=V8;
            obj.Meshoutput.elements=QUAD8;
            obj.Meshoutput.nodes=V8;
            obj.Meshoutput.order=2;
            O=FindBoundary(obj);
            obj.Meshoutput.facesBoundary=O;

        end
    case 3
        [TRI6,V6,~]=tri3_tri6(obj.Meshoutput.elements,obj.Meshoutput.nodes);
        obj.Face=TRI6;
        obj.Vert=V6;
        obj.Meshoutput.elements=TRI6;
        obj.Meshoutput.nodes=V6;
        obj.Meshoutput.order=2;
        O=FindBoundary(obj);
        obj.Meshoutput.facesBoundary=O;
end
%% Print
if obj.Echo
    fprintf('Successfully convert elements .\n');
end
end