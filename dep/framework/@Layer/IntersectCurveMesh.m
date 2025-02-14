function obj=IntersectCurveMesh(obj,lineno,meshno,varargin)
% Intersect curve and mesh
% Author : Xie Yu
% It needs at least one point located in the meshes
p=inputParser;
addParameter(p,'eps',1e-5);
parse(p,varargin{:});
opt=p.Results;

Num=0;
v=[];
f=[];
for i=1:size(meshno,1)
    v=[v;obj.Meshes{meshno(i,1),1}.Vert]; %#ok<AGROW> 
    f=[f;obj.Meshes{meshno(i,1),1}.Face+Num]; %#ok<AGROW> 
    Num=Num+size(v,1);
end

    vert1  = v(f(:,1),:);
    vert2  = v(f(:,2),:);
    vert3  = v(f(:,3),:);
    coordinate=[];

for i=1:size(lineno,1)
    P=obj.Lines{lineno(i,1),1}.P;
    in= PointInsideVolume(P, f, v);
    row=find(in==1);
    Total_Num=size(in,1);
    for j=1:size(row,1)
        if row(j,1)==1
            orig=P(row(j,1),:);
            if in(row(j,1)+1,1)==0
                dir=P(row(j,1)+1,:)-orig;
                [~, ~, ~, ~, coor] = TriangleRayIntersection (orig, dir, vert1, vert2, vert3,'eps',opt.eps,'border', 'inclusive');
                coordinate=[coordinate;coor(~isnan(coor(:,1)),:)];
            end
        end

        if row(j,1)==Total_Num
            orig=P(row(j,1),:);
            if in(row(j,1)-1,1)==0
                dir=P(row(j-1,1),:)-orig;
                [~, ~, ~, ~, coor] = TriangleRayIntersection (orig, dir,vert1, vert2, vert3,'eps',opt.eps,'border', 'inclusive');
                coordinate=[coordinate;coor(~isnan(coor(:,1)),:)];
            end
        end

        if and(row(j,1)~=1,row(j,1))~=Total_Num
            orig=P(row(j,1),:);
            if in(row(j,1)+1,1)==0
                dir=P(row(j,1)+1,:)-orig;
                [~, ~, ~, ~, coor] = TriangleRayIntersection (orig, dir,vert1, vert2, vert3,'eps',opt.eps,'border', 'inclusive');
                coordinate=[coordinate;coor(~isnan(coor(:,1)),:)];
            end

            if in(row(j,1)-1,1)==0
                dir=P(row(j,1)-1,:)-orig;
                [~, ~, ~, ~, coor] = TriangleRayIntersection (orig, dir,vert1, vert2, vert3,'eps',opt.eps,'border', 'inclusive');
                coordinate=[coordinate;coor(~isnan(coor(:,1)),:)];
            end


        end
        

    end
    


end
%% Check inner
Num=GetNPoints(obj);
obj.Points{Num+1,1}.P=coordinate;
% obj.Points{Num+1,1}.PP{1,1}=coordinate;
%% Print
if obj.Echo
    fprintf('Successfully interct curve and mesh . \n');
end
end

