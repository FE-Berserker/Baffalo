function obj=CalculateShape(obj)
% Calculate shape of rotor
% Author : Xie YU

L=Layer('Space','Echo',0);
% Add Shaft
Temp2D= Mesh2D('Temp2D','Echo',0);
Temp3D=Mesh('Temp3D','Echo',0);
Node=obj.input.Shaft.Meshoutput.nodes;
Element=obj.input.Shaft.Meshoutput.elements;
ElementLength=Node(2:end,1)-Node(1:end-1,1);
RotNum=obj.input.Shaft.Section{1,1}.data(1,end);
Section=cellfun(@(x)x.data(1,1:end-1),obj.input.Shaft.Section,'UniformOutput',false);
Section=cellfun(@(x)ExpandSection(x),Section,'UniformOutput',false);
Section=cell2mat(Section);
AccLength=tril(ones(size(Element,1)))*ElementLength;
Node1x=AccLength-ElementLength;
Node2x=AccLength;
Node3x=AccLength;
Node4x=AccLength-ElementLength;
Node1y=Section(:,1);
Node2y=Section(:,1);
Node3y=Section(:,2);
Node4y=Section(:,2);
x=reshape([Node1x,Node2x,Node3x,Node4x]',[],1);
y=reshape([Node1y,Node2y,Node3y,Node4y]',[],1);
Temp2D.Vert=[x,y];
Temp2D.Face=reshape((1:size(x,1))',[],size(x,1)/4)';
Temp3D=Revolve2Solid(Temp3D,Temp2D,'Slice',RotNum);
L=AddElement(L,Temp3D,'Transform',obj.params.Position);

% Add Disc
for i=1:size(obj.input.Discs,1)
    Disc=obj.input.Discs(i,:);
    Temp=obj.input.Shaft.Meshoutput.nodes;
    P=Temp(Disc(i,1),:);
    RotNum=obj.input.Shaft.Section{1,1}.data(1,end);
    Length=Disc(1,4);
    OD=Disc(1,2);
    ID=Disc(1,3);
    Node1x=P(1,1)-Length/2;
    Node2x=P(1,1)+Length/2;
    Node3x=P(1,1)+Length/2;
    Node4x=P(1,1)-Length/2;
    Node1y=OD/2;
    Node2y=OD/2;
    Node3y=ID/2;
    Node4y=ID/2;
    x=reshape([Node1x,Node2x,Node3x,Node4x]',[],1);
    y=reshape([Node1y,Node2y,Node3y,Node4y]',[],1);
    Temp2D.Vert=[x,y];
    Temp2D.Face=reshape((1:size(x,1))',[],size(x,1)/4)';
    Temp3D=Revolve2Solid(Temp3D,Temp2D,'Slice',RotNum);
    L=AddElement(L,Temp3D,'Transform',obj.params.Position);
end

obj.output.Shape=L;

end

function x=ExpandSection(x)
Num=size(x,2);
if Num==1
    x=[x,0];
end
end