function [meshOutput]=importTETGEN(loadNameStruct)


%% IMPORT ELE file
try
    [~,E,elementMaterialID]=importEleFile_tetGen(loadNameStruct.loadName_ele);
catch
%     disp([loadNameStruct.loadName_ele,' import unsuccesful']);
    E=[];
    elementMaterialID=[];
end

%% IMPORT NODE file
try
    [~,V]=importNodeFile_tetGen(loadNameStruct.loadName_node);
    
%     %Check voronoi nodes
%     [pathName,fileName,extension]=fileparts(loadNameStruct.loadName_node);
%     fileName=fullfile(pathName,[fileName,'.v',extension]);
%     if exist(fileName,'file')==2
%         [~,V_vor]=importNodeFile_tetGen(fileName);
%     else
%         V_vor=[];        
%     end
catch
    warning([loadNameStruct.loadName_node,' import unsuccesful']);
    V=[];
    V_vor=[];        
end

%% IMPORT FACES file

try
    [~,F,faceBoundaryID]=importFaceFile_tetGen(loadNameStruct.loadName_face);    
    
%     %Check voronoi faces
%     [pathName,fileName,extension]=fileparts(loadNameStruct.loadName_face);
%     fileName=fullfile(pathName,[fileName,'.v',extension]);
%     if exist(fileName,'file')==2
%         [~,F_vor,faceBoundaryID_vor]=importFaceFile_tetGen(fileName);
%     else
%         F_vor=[];
%         faceBoundaryID_vor=[];
%     end
catch
%     warning([loadNameStruct.loadName_face,' import unsuccesful']);
    F=[];
    faceBoundaryID=[];
    F_vor=[];
    faceBoundaryID_vor=[];
end

%% CONVERT ELEMENTS TO FACES
if ~isempty(E)
    [FE,faceMaterialID]=element2patch(E,elementMaterialID,'tet4');
else
    FE=[];
    faceMaterialID=[];
end

%% Create meshOutput structure
meshOutput.nodes=V; 
meshOutput.facesBoundary=F; 
meshOutput.boundaryMarker=faceBoundaryID;
meshOutput.faces=FE; 
meshOutput.elements=E; 
meshOutput.elementMaterialID=elementMaterialID; 
meshOutput.faceMaterialID=faceMaterialID; 
meshOutput.loadNameStruct=loadNameStruct; 

% meshOutput.facesVoronoi=F_vor; 
% meshOutput.nodesVoronoi=V_vor; 
% meshOutput.boundaryMarkeVoronoi=faceBoundaryID_vor; 

%%
disp(['--- Done --- ',datestr(now)]);
 
