classdef voronoi3d
    %% Author: Wan Ji, Wuhan University, Wuhan, China
    % Any advice or questions, please contact me via E-mail:
    % wanji@whu.edu.cn
    % Date of this version 2021/06/28
    %% expressions
    % voronoi3d class provides a description of  3d voronoi
    % one voronoi contains several faces
    % one face contains several nodes
    % each node posesses its ID the same as the row number of the matrix 'Nodes'
    
    properties
        Nodes % n-by-3 double matrix
        Faces % m-by-1 cell with each cell the arranged node numbers
        Voronois % r-by-1 cells, each cell the arranged face numbers
        FaceNormals % m-by-3 unit normal vectors of all the faces
        Centroids % r-by-3 centroids of all the voronois
        Volumes % r-by-1 volumes of all the voronois
    end
    
    methods
        function obj = voronoi3d(Nodes, Faces, Voronois)
            if(nargin==0)
                % create an empty voronoi3d class
                obj.Nodes = [];
                obj.Faces = {};
                obj.Voronois = {};
            end
            if(nargin==3)
                if(isnumeric(Nodes))
                    if(size(Nodes,2)~=3)
                        error('Error. Nodes must be an n-by-3 matrix, but the input number of column is %d', size(Nodes,2));
                    end
                    obj.Nodes = Nodes;
                else
                    error('MyComponent:incorrectType',...
                        'Error. \n Input Nodes must a numeric , not a %s.',class(Nodes))
                end
                if(iscell(Faces))
                    p = arrayfun(@(i)isnumeric(Faces{i}),1:1:numel(Faces));
                    if(all(p))
                        p = arrayfun(@(i)numel(Faces{i}),1:1:numel(Faces));
                        if(min(p)>=3)
                            obj.Faces = Faces;
                        else
                            error('Error. number of Nodes of each face must be >= 3');
                        end
                    else
                        q = find(~p);
                        error('MyComponent:incorrectType',...
                            'Error. \n Cells of the Input Faces must be all numeric, the %dth cell is not a numeric, but a %s, check if the other cells have the same error!',q(1), class(Faces{q(1)}))
                    end
                else
                    error('MyComponent:incorrectType',...
                        'Error. \n Input Nodes must a cell , not a %s.',class(Nodes))
                end
                if(iscell(Voronois))
                    p = arrayfun(@(i)isnumeric(Voronois{i}),1:1:numel(Voronois));
                    if(all(p))
                        p = arrayfun(@(i)numel(Voronois{i}),1:1:numel(Voronois));
                        if(min(p)>=4)
                            obj.Voronois = Voronois;
                        else
                            error('Error. number of faces of each Voronoi must be >= 4');
                        end
                    else
                        q = find(~p);
                        error('MyComponent:incorrectType',...
                            'Error. \n Cells of the Input Voronois must be all numeric, the %dth cell is not a numeric, but a %s, check if the other cells have the same error!',q(1), class(Voronois{q(1)}))
                    end
                else
                    error('MyComponent:incorrectType',...
                        'Error. \n Input Voronois must a cell , not a %s.',class(Voronois))
                end
                
            end
        end
        function obj = createVoronoi3dFromMesh(obj, node, element)
            [myNodes, polyhedronCell] = specialVoronoi3d(node, element);
            [myNodes, voronoiCellOut, myFaceNormals, myCentroids, myVols] = simplifyVoronoi3d(myNodes,polyhedronCell,1e-12 );
            nFace = zeros(size(voronoiCellOut));
            nFaceMaxNN = zeros(size(voronoiCellOut));
            for i = 1:1:numel(voronoiCellOut)
                nFace(i) = numel(voronoiCellOut{i});
                for j = 1:1:nFace(i)
                    nFaceMaxNN(i) = max(nFaceMaxNN(i), numel(voronoiCellOut{i}{j}));
                end
            end
            nMaxEdge = max(nFaceMaxNN);
            totFaces = zeros(sum(nFace), nMaxEdge);
            totNormals = zeros(sum(nFace), 3);
            nCount = 0;
            for i = 1:1:numel(voronoiCellOut)
                for j = 1:1:nFace(i)
                    nCount = nCount + 1;
                    totFaces(nCount,:) = [voronoiCellOut{i}{j}', NaN(1,nMaxEdge-numel(voronoiCellOut{i}{j}))];
                    totNormals(nCount,:) = myFaceNormals{i}(j,:);
                end
            end
            totFaces2 = sort(totFaces, 2);
            [~, ia, ic] = unique(totFaces2,'rows'); %
            myFaces = totFaces(ia,:);
            myFaceNormals = totNormals(ia,:);
            numFaces = size(myFaces,1);
            nFacesArray = (1:1:numFaces)';
            myVoronois = mat2cell(nFacesArray(ic,1),nFace(:)');
            myFaces = mat2cell(myFaces,ones(1,numFaces));
            for i = 1:numFaces
                myFaces{i}(isnan(myFaces{i})) = [];
            end
            obj.Nodes = myNodes;
            obj.Faces = myFaces;
            obj.Voronois = myVoronois;
            obj.FaceNormals = myFaceNormals;
            obj.Centroids = myCentroids;
            obj.Volumes = myVols;
        end
        
        function obj = createVoronoi3dFromGeometry(obj, geometry3D, maxEdgeLength)
            structuralModel = createpde('structural','static-solid');
            structuralModel.Geometry =  geometry3D;
            generateMesh(structuralModel,'hmax',maxEdgeLength,'GeometricOrder','quad');
            obj = createVoronoi3dFromMesh(obj, structuralModel.Mesh.Nodes', structuralModel.Mesh.Elements');
        end
        
        function [Fig, pH]= voronoiPatch(obj, patchType, val)
            Fig = figure;
            q = max(arrayfun(@(i)numel(obj.Faces{i}),1:1:numel(obj.Faces)));
            s = arrayfun(@(i)[obj.Faces{i}, NaN(1,q-numel(obj.Faces{i}))],...
                (1:1:numel(obj.Faces))', 'UniformOutput',false);
            totFaces = cell2mat(s);
            switch lower(patchType)
                case {'nodal'}
                    pH = patch('vertices',obj.Nodes, ...
                        'faces', totFaces, 'facevertexcdata',...
                        val, 'facecolor','interp','facealpha',0.4);
                    colormap(jet);
                case {'bycell'}
                    pH = arrayfun(@(i)patch('vertices',obj.Nodes, ...
                        'faces', totFaces(obj.Voronois{i},:), 'facecolor',...
                        rand(1,3),'facealpha',0.4), (1:1:numel(obj.Voronois))');
            end
            axis equal
            view(30, 45);
        end
    end
end

