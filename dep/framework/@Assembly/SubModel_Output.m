function SubModel_Output(obj,varargin)
% Output SubModel to ANSYS cdb file
% Author : Xie Yu
p=inputParser;
addParameter(p,'Echo',1);
addParameter(p,'Warning',1);
addParameter(p,'Save',1);
parse(p,varargin{:});
opt=p.Results;

if opt.Echo
    fprintf('Start output to ANSYS submodel ...\n');
end
filename='.\Coarse.cdb';
fid=fopen(filename,'a');

fprintf(fid, '%s\n','FINISH');
fprintf(fid, '%s\n','/CLEAR');
sen=strcat('/FILNAME,','SUBMOD');
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
    [~,~]=NodeMassprint(obj,fid,AccET,AccReal);
end

if ~isempty(obj.EndRelease)
    EndReleaseprint(obj,fid)
end

Dprint(obj,fid);
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
CutBoundaryprint(obj,fid)

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
