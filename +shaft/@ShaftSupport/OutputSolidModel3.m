function obj=OutputSolidModel3(obj)
% Output solid model of ShaftSupport
% Author : Xie Yu

D1=obj.input.D+2*obj.input.N;
Meshsize=pi*D1/obj.params.E_Revolve;
%% Create plate
H=obj.input.H;
W=obj.input.W;
a=Point2D('Temp','Echo',0);
a=AddPoint(a,0,0);
a=AddPoint(a,[W/2;W/2],[sqrt(H^2-W^2);-sqrt(H^2-W^2)]/2);
a=AddPoint(a,-[W/2;W/2],[-sqrt(H^2-W^2);sqrt(H^2-W^2)]/2);
% Add outline
b1=Line2D('Out','Echo',0);
b1=AddLine(b1,a,2);
sang=acos(W/H)/pi*180;
b1=AddCircle(b1,H/2,a,1,'sang',-sang,'ang',-180+2*sang);
b1=AddLine(b1,a,3);
b1=AddCircle(b1,H/2,a,1,'sang',-sang-180,'ang',-180+2*sang);
% Add innerline
b2=Line2D('Inner','Echo',0);
b2=AddCircle(b2,D1/2,a,1,'seg',obj.params.E_Revolve);
% Add assembly hole
h=Line2D('Hole','Echo',0);
h=AddCircle(h,obj.input.d1/2/2*3,a,1,'seg',16);

S=Surface2D(b1,'Echo',0);
S=AddHole(S,b2);

theta=2*pi/obj.input.NH;
for i=1:obj.input.NH
    S=AddHole(S,h,'dis',[obj.input.P/2*cos(theta*(i-1)+pi/2),obj.input.P/2*sin(theta*(i-1)+pi/2)]);
end

m=Mesh2D('Temp','Echo',0);
m=AddSurface(m,S);
m=SetSize(m,Meshsize);
m=Mesh(m);

% Mesh Layer edge
factor=1/cos((90-(obj.params.E_Revolve-2)*180/obj.params.E_Revolve/2)/180*pi);
m=MeshLayerEdge(m,2,obj.input.N*factor);

% Mesh Layer edge
factor=1/cos((90-(16-2)*180/16/2)/180*pi);
for i=1:obj.input.NH
    m=MeshLayerEdge(m,2,obj.input.d1/2/2*factor);
end

mm=Mesh(obj.params.Name);
mm=Extrude2Solid(mm,m,-obj.input.T,ceil(obj.input.T/Meshsize));
mm=Extrude2Solid(mm,m,obj.input.L-obj.input.T,ceil((obj.input.L-obj.input.T)/Meshsize),'Cb',2);

if obj.params.Order==2
    mm = Convert2Order2(mm);
end

%% Prase
mm.Cb=mm.Meshoutput.boundaryMarker;  
mm.Face=mm.Meshoutput.facesBoundary;
mm.Meshoutput.nodes=mm.Meshoutput.nodes+obj.input.T;
mm.Vert=mm.Meshoutput.nodes;
obj.output.SolidMesh=mm;
%% Print
if obj.params.Echo
    fprintf('Successfully output solid model .\n');
end
end