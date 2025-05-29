function obj=CalSafety(obj)
% Calculate safety of Boltjoint
% Author: Xie Yu
Bolt=obj.input.Bolt;
Phin=obj.output.Phin;
As=Bolt.output.As;
MG=Bolt.output.MG;
ds=Bolt.output.ds;
Rp=Bolt.output.Rp;
d0=Bolt.output.d0;
d=Bolt.input.d;
FMmin=Bolt.output.FMmin;
MuT=obj.params.MuT;
Wp=pi/16*ds^3-pi/16*d0^3;
Nz=obj.input.Nz;
qF=obj.params.qF;
TauB=Bolt.output.TauB;
Rm=Bolt.output.Rm;
ra=obj.input.ra;
MT=obj.input.MT;

if isempty(obj.input.FAmax)
    FAmax=0;
else
    FAmax=obj.input.FAmax;
end

if isempty(obj.input.FAmin)
    FAmin=0;
else
    FAmin=obj.input.FAmin;
end

if isempty(obj.input.FQ)
    FQ=0;
else
    FQ=obj.input.FQ;
end

FVmax=Bolt.output.FMmax;
FSAmax=Phin*FAmax;
FSmax=FVmax+FSAmax;
SigmaZmax=FSmax/As;
Taumax=MG/Wp;
if obj.params.ConShear==1
    SigmaRedB=sqrt(SigmaZmax^2+3*(0.5*Taumax+FQ/As)^2);
else
    SigmaRedB=sqrt(SigmaZmax^2+3*(0.5*Taumax)^2);
end
SF=Rp/SigmaRedB;

if Nz>=2e6
    SigmaASV=0.85*(150/d+45);
elseif Nz>=1e4
    SigmaASV=((0.85*(150/d+45))^3*2e6/Nz)^(1/3);
else
    SigmaASV=((0.85*(150/d+45))^3*2e6/1e4)^(1/3);
end

SigmaA=Phin*(FAmax-FAmin)/2/As;
SD=SigmaASV/SigmaA;
if MT~=0
    FKQerf=FQ/qF/MuT+MT/qF/ra/MuT;
else
    FKQerf=FQ/qF/MuT;
end
FKRmin=FMmin-(1-Phin)*FAmax;
SG=FKRmin/FKQerf;

SA=TauB*Rm/FQ*As;
%% Parse
if SF==Inf
    obj.capacity.SF=1000;
else
    obj.capacity.SF=SF;
end

if SD==Inf
    obj.capacity.SD=1000;
else
    obj.capacity.SD=SD;
end

if SG==Inf
    obj.capacity.SG=1000;
else
    obj.capacity.SG=SG;
end

if SA==Inf
    obj.capacity.SA=1000;
else
    obj.capacity.SA=SA;
end
%% Print
if obj.params.Echo
    fprintf('Successfully calculate safety .\n');
end
end