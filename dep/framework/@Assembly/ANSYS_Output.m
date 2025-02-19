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

%calculate outputs
if~isempty(opt.Name)
    filename=strcat('.\',opt.Name,'.cdb');
else
    filename=strcat('.\',obj.Name,'.cdb');
end

fid=fopen(filename,'w');

if opt.Warning==0
    fprintf(fid, '%s\n','/NERR,0');
end

sen=strcat('/FILNAME,',obj.Name);
fprintf(fid,'%s\n',sen);
fprintf(fid, '%s\n','/PREP7');
Nodeprint(obj,fid);
Matprint(obj,fid);
if ~isempty(obj.Section)
    SECprint(obj,fid);
end
ETprint(obj,fid);
CSprint(obj,fid);
ELprint(obj,fid);
if ~isempty(obj.ContactPair)
    Contactprint(obj,fid);
end
if ~isempty(obj.Slaver)
    Connectprint(obj,fid);
end

m1=GetNET(obj);
m2=GetNContactPair(obj);
m=m1+m2;

AccET=m1;
AccReal=m;

if ~isempty(obj.Spring)
    [AccET,AccReal]=Springprint(obj,fid);
end

if ~isempty(obj.Bearing)
    [AccET,AccReal]=Bearingprint(obj,fid,AccET,AccReal);
end

if ~isempty(obj.NodeMass)
    [AccET,~]=NodeMassprint(obj,fid,AccET,AccReal);
end

if ~isempty(obj.EndRelease)
    EndReleaseprint(obj,fid)
end

Dprint(obj,fid);

if ~isempty(obj.BeamPreload)
    BeamPreloadprint(obj,fid,AccET)
else
    fprintf(fid, '%s\n','/SOLU');
end

fprintf(fid, '%s\n','ALLSEL,ALL');
fprintf(fid, '%s\n',strcat('TREF,',num2str(obj.T_Ref)));
if ~isempty(obj.Temperature)
    Temperatureprint(obj,fid)
end

Disprint(obj,fid);
Fprint(obj,fid);
SFprint(obj,fid);
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
