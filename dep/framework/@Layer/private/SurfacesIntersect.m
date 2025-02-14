function [ Ind] = SurfacesIntersect( V1,F1,V2,F2 )

%SURFACESPENETRATE evaluates if triangles of surface 2 intersect with
%triangles of surfaces1.

%V1,F1,V2,F2  refer to vertices(n*3) and faces(m*3) of surfaces 1 and 2.
%Ind indicates the triangles of surface 1 and 2 that intersect, first
%column indicates the indices of the faces of surface 1 that intersect with
%the indices of the faces of surface 2 in column 2. Intersectionpoints on the edges are
%given in column 3:5

%EXAMPLE
%  load('Exampledata.mat')
%  [ Ind] = SurfacesIntersect( V1,F1,V2,F2 );
%  clf
%  trisurf(F2,V2(:,1),V2(:,2),V2(:,3),'FaceColor','r');
% hold
% trisurf(F1,V1(:,1),V1(:,2),V1(:,3),'FaceColor','y');
% daspect([1 1 1]);
% scatter3(Ind(:,3),Ind(:,4),Ind(:,5),200,'Filled','LineWidth',10);

iteration=2;
testsize(1,1)=-1;
Ind=[];
nr1=(1:size(F1,1))';

while size(Ind,1)-testsize(iteration-1,1)>0
testsize(iteration,1)=size(Ind,1);

Trianglecentres1=(V1(F1(:,1),:)+V1(F1(:,2),:)+V1(F1(:,3),:))./3;
Trianglecentres2=(V2(F2(:,1),:)+V2(F2(:,2),:)+V2(F2(:,3),:))./3;

[idx,d1]=knnsearch(Trianglecentres2,Trianglecentres1,'K',iteration-1);
idx1=idx(:,iteration-1);
Tri1=F2(idx1,:);

%one2two

A1=[(V1(F1(:,2),:)-V1(F1(:,1),:))];
B1=[(V1(F1(:,3),:)-V1(F1(:,2),:))];

a1=[(V2(Tri1(:,2),:)-V2(Tri1(:,1),:))];
b1=[(V2(Tri1(:,3),:)-V2(Tri1(:,2),:))];
c1=[(V2(Tri1(:,3),:)-V2(Tri1(:,1),:))];

aa1=[(V2(Tri1(:,1),:)-V1(F1(:,1),:))];
bb1=[(V2(Tri1(:,2),:)-V1(F1(:,1),:))];
cc1=[(V2(Tri1(:,1),:)-V1(F1(:,1),:))];

%for a1 intersection
Aa=Det([aa1 B1 -a1]);
Ab=Det([A1 aa1 -a1]);
Ac=Det([A1 B1 aa1]);
A= Det([A1 B1 -a1]); 
sola11=[Aa./A Ab./A Ac./A nr1 idx1 (V2(Tri1(:,1),:)+repmat((Ac./A),1,3).*a1)];
[ sola11 ] = bounderies( sola11);

%for b1 intersection
Aa=Det([bb1 B1 -b1]);
Ab=Det([A1 bb1 -b1]);
Ac=Det([A1 B1 bb1]);
A= Det([A1 B1 -b1]); 
solb11=[Aa./A Ab./A Ac./A nr1 idx1 (V2(Tri1(:,2),:)+repmat((Ac./A),1,3).*b1)];
[ solb11 ] = bounderies( solb11);

%for c1 intersection
Aa=Det([cc1 B1 -c1]);
Ab=Det([A1 cc1 -c1]);
Ac=Det([A1 B1 cc1]);
A= Det([A1 B1 -c1]); 
solc11=[Aa./A Ab./A Ac./A nr1 idx1 (V2(Tri1(:,1),:)+repmat((Ac./A),1,3).*c1)];
[ solc11 ] = bounderies( solc11);

%two2one
A1=[(V2(Tri1(:,2),:)-V2(Tri1(:,1),:))];
B1=[(V2(Tri1(:,3),:)-V2(Tri1(:,2),:))];

a1=[(V1(F1(:,2),:)-V1(F1(:,1),:))];
b1=[(V1(F1(:,3),:)-V1(F1(:,2),:))];
c1=[(V1(F1(:,3),:)-V1(F1(:,1),:))];

aa1=[(V1(F1(:,1),:)-V2(Tri1(:,1),:))];
bb1=[(V1(F1(:,2),:)-V2(Tri1(:,1),:))];
cc1=[(V1(F1(:,1),:)-V2(Tri1(:,1),:))];

%for a1 intersection
Aa=Det([aa1 B1 -a1]);
Ab=Det([A1 aa1 -a1]);
Ac=Det([A1 B1 aa1]);
A= Det([A1 B1 -a1]); 
sola12=[Aa./A Ab./A Ac./A nr1 idx1 (V1(F1(:,1),:)+repmat((Ac./A),1,3).*a1)];
[ sola12 ] = bounderies( sola12);

%for b1 intersection
Aa=Det([bb1 B1 -b1]);
Ab=Det([A1 bb1 -b1]);
Ac=Det([A1 B1 bb1]);
A= Det([A1 B1 -b1]); 
solb12=[Aa./A Ab./A Ac./A nr1 idx1 (V1(F1(:,2),:)+repmat((Ac./A),1,3).*b1)];
[ solb12 ] = bounderies( solb12);

%for c1 intersection
Aa=Det([cc1 B1 -c1]);
Ab=Det([A1 cc1 -c1]);
Ac=Det([A1 B1 cc1]);
A= Det([A1 B1 -c1]); 
solc12=[Aa./A Ab./A Ac./A nr1 idx1 (V1(F1(:,1),:)+repmat((Ac./A),1,3).*c1)];
[ solc12 ] = bounderies( solc12);

IndIteration=unique([sola11(:,4:8);sola12(:,4:8);solb11(:,4:8);solb12(:,4:8);solc11(:,4:8);solc12(:,4:8)],'rows');
Ind=[IndIteration;Ind];

iteration=iteration+1;
end

function [ D ] = Det( A )

D=A(:,1).*(A(:,5).*A(:,9))+A(:,4).*(A(:,8).*A(:,3))+A(:,7).*(A(:,2).*A(:,6))-A(:,3).*(A(:,5).*A(:,7))-A(:,2).*(A(:,4).*A(:,9))-A(:,1).*(A(:,6).*A(:,8));

function [ sol ] = bounderies( sol)

sol=sol(sol(:,1)<=1,:);
sol=sol(sol(:,1)>=0,:);
sol=sol(sol(:,2)<=sol(:,1),:);
sol=sol(sol(:,2)>=0,:);
sol=sol(sol(:,3)>=0,:);
sol=sol(sol(:,3)<=1,:);