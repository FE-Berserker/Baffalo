function ANSYS_Output(obj,varargin)
% Output Assembly to ANSYS cdb file
% Author : Xie Yu
p=inputParser;
addParameter(p,'MultiSolve',0);
addParameter(p,'Echo',1);
addParameter(p,'Warning',1);
addParameter(p,'Save',1);
addParameter(p,'Name',[]);
addParameter(p,'CDBWrite',0);
parse(p,varargin{:});
opt=p.Results;

if opt.Echo
    fprintf('Start output to ANSYS ...\n');
end

% Calculate outputs
if~isempty(opt.Name)
    filename=strcat('.\',opt.Name,'.cdb');
else
    filename=strcat('.\',obj.Name,'.cdb');
end

fid=fopen(filename,'w');

if opt.Warning==0
    fprintf(fid, '%s\n','/NERR,0,99999999,,1');
end

% Check substrM
if ~isempty(obj.SubStrM)
    ExistSubStrM=1;
    Total_Node=obj.Summary.Total_Node;
    Ori=obj.SubStrM.Node(:,2);
    Ori(obj.SubStrM.Node(:,1)==0,:)=Ori(obj.SubStrM.Node(:,1)==0,:)+Total_Node;
    Rep=obj.SNN+(1:size(Ori,1))';
else
    ExistSubStrM=0;
    Ori=[];
    Rep=[];
end

sen=strcat('/FILNAME,',obj.Name);
fprintf(fid,'%s\n',sen);
fprintf(fid, '%s\n','/PREP7');
% Node print
Nodeprint(obj,fid,'ExistSubStrM',ExistSubStrM,'Ori',Ori,'Rep',Rep);

% Material print
Matprint(obj,fid);
% Section print
if ~isempty(obj.Section)
    SECprint(obj,fid);
end
% Element type print
ETprint(obj,fid);

% Coordinate system print
CSprint(obj,fid);
% Element print
ELprint(obj,fid,'ExistSubStrM',ExistSubStrM,'Ori',Ori,'Rep',Rep);
% SubStr print
if ~isempty(obj.SubStr)
    SubStrprint(obj,fid);
end
% Table print
Tableprint(obj,fid);
% Contact pair print
if ~isempty(obj.ContactPair)
    Contactprint(obj,fid,'ExistSubStrM',ExistSubStrM,'Ori',Ori,'Rep',Rep);
end
% Connection print
if ~isempty(obj.Slaver)
    Connectprint(obj,fid);
end

% Spring print
if ~isempty(obj.Spring)
    [AccET,AccReal]=Springprint(obj,fid);
end

% Bearing print
if or(~isempty(obj.Bearing),~isempty(obj.LUTBearing))
    [AccET,AccReal]=Bearingprint(obj,fid,AccET,AccReal);
end

% Nodemass print
if ~isempty(obj.NodeMass)
    [AccET,AccReal]=NodeMassprint(obj,fid,AccET,AccReal,'ExistSubStrM',ExistSubStrM,'Ori',Ori,'Rep',Rep);
end

% Joint print
if ~isempty(obj.Joint)
    [AccET,~,AccCS,AccSec]=Jointprint(obj,fid,AccET,AccReal,'ExistSubStrM',ExistSubStrM,'Ori',Ori,'Rep',Rep);
else
    AccCS=obj.Summary.Total_CS;
    AccSec=obj.Summary.Total_Section;
end

% EndRelease print
if ~isempty(obj.EndRelease)
    EndReleaseprint(obj,fid)
end

% D print
Dprint(obj,fid,'ExistSubStrM',ExistSubStrM,'Ori',Ori,'Rep',Rep);

% Preload print
if or(~isempty(obj.BeamPreload),~isempty(obj.SolidPreload))
    Preloadprint(obj,fid,AccET,AccCS,AccSec)
else
    fprintf(fid, '%s\n','/SOLU');
end

fprintf(fid, '%s\n','ALLSEL,ALL');
fprintf(fid, '%s\n',strcat('TREF,',num2str(obj.T_Ref)));

% Temperature print
if ~isempty(obj.Temperature)
    Temperatureprint(obj,fid)
end

% Displacement print
Disprint(obj,fid,'ExistSubStrM',ExistSubStrM,'Ori',Ori,'Rep',Rep);
% Force print
Fprint(obj,fid,'ExistSubStrM',ExistSubStrM,'Ori',Ori,'Rep',Rep);
% SF print
SFprint(obj,fid);
% Insitial stress print
ISprint(obj,fid);

fprintf(fid, '%s\n','ALLSEL,ALL');
if ~isempty(obj.Solu)
    SOLUprint(obj,fid,'MultiSolve',opt.MultiSolve,'Save',opt.Save);
end

if opt.CDBWrite==1
    fprintf(fid, '%s\n','/PREP7');
    fprintf(fid, '%s\n','CDOPT,IGES');
    sen=strcat('CDWRITE,ALL,''',obj.Name,''',''cdb'',,''',obj.Name,''',''iges''');
    fprintf(fid,'%s\n',sen);
end

if ~isempty(obj.Sensor)
    fprintf(fid, '%s\n','/POST1');
    Sensorprint(obj,fid);
end

if ~isempty(obj.Sensor1)
    fprintf(fid, '%s\n','/POST26');
    Sensor1print(obj,fid);
end
fclose(fid);
%% Print
if opt.Echo
    fprintf('Successfully output to ANSYS . \n');
end
end
