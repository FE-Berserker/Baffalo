function obj=CalOutput(obj)
% Calculate output of Bolt
% Author: Xie Yu

d=obj.input.d;
l=obj.input.l;
lk=obj.input.lk;
d0=obj.input.d0;

% Thread Pitch
switch obj.params.ThreadType
    case 1
        Thread=load('StandardThread.mat').Thread;
    case 2
        Thread=load('FineThread.mat').Thread;
end

P=Thread.P(Thread.d==d,:);
% Shank diameter
di=d;

% Height of the fundamental thread triangle
H=sqrt(3)/2*P;

% Minor diameter of external thread
d1=d-5/4*H;

% Pitch diameter
d2=d-3/4*H;

% Minor diameter
d3=d1-H/6;

% Stress section diameter
ds=(d2+d3)/2;

% Inner diameter of head support
switch obj.params.BoltType
    case 0
        if d>10
            Bolt=load('ISO4017.mat').Bolt;
        else
            Bolt=load('ISO4762.mat').Bolt;
        end

        if ~any(Bolt.d==d, "all")
            error('Please input the right bolt size !')
        else
            da=Bolt.da(Bolt.d==d,:);
            dw=Bolt.dw(Bolt.d==d,:);
            K=Bolt.K(Bolt.d==d,:);
            if d>10
                sw=Bolt.sw(Bolt.d==d,:);
            else
                sw=Bolt.dk(Bolt.d==d,:);
            end
            % l1=Bolt.l1(Bolt.d==d,:);
            da=da(1,1);
            dw=dw(1,1);
            K=K(1,1);
            sw=sw(1,1);
            l1=0;
        end

    case 1
        Bolt=load('ISO4762.mat').Bolt;
        if ~and(Bolt.d==d,Bolt.l==l)
            error('Please input the right bolt size !')
        else
            da=Bolt.da(and(Bolt.d==d,Bolt.l==l),:);
            dw=Bolt.dw(and(Bolt.d==d,Bolt.l==l),:);
            K=Bolt.K(and(Bolt.d==d,Bolt.l==l),:);
            sw=Bolt.dk(and(Bolt.d==d,Bolt.l==l),:);
            l1=Bolt.l1(and(Bolt.d==d,Bolt.l==l),:);
        end
    case 2
        Bolt=load('ISO4014.mat').Bolt;
        if ~and(Bolt.d==d,Bolt.l==l)
            error('Please input the right bolt size !')
        else
            da=Bolt.da(and(Bolt.d==d,Bolt.l==l),:);
            dw=Bolt.dw(and(Bolt.d==d,Bolt.l==l),:);
            K=Bolt.K(and(Bolt.d==d,Bolt.l==l),:);
            sw=Bolt.sw(and(Bolt.d==d,Bolt.l==l),:);
            l1=Bolt.l1(and(Bolt.d==d,Bolt.l==l),:);
        end
    case 3
        Bolt=load('ISO4017.mat').Bolt;
        if ~and(Bolt.d==d,Bolt.l==l)
            error('Please input the right bolt size !')
        else
            da=Bolt.da(and(Bolt.d==d,Bolt.l==l),:);
            dw=Bolt.dw(and(Bolt.d==d,Bolt.l==l),:);
            K=Bolt.K(and(Bolt.d==d,Bolt.l==l),:);
            sw=Bolt.sw(and(Bolt.d==d,Bolt.l==l),:);
            l1=Bolt.l1(and(Bolt.d==d,Bolt.l==l),:);

        end
end

% Washer
if obj.params.Washer
    switch obj.params.WasherType
        case 1
            Washer=load('DIN7089.mat').Washer;
    end

    if any(Washer.d==d)
        Washer_d1=Washer.d1(Washer.d==d,:);
        Washer_d2=Washer.d2(Washer.d==d,:);
        Washer_h=Washer.h(Washer.d==d,:);
    else
        error('Please change the washer type !')
    end
    lk=lk+Washer_h;
else
    Washer_d1=[];
    Washer_d2=[];
    Washer_h=[];
end

% Nut
if obj.params.Nut
    switch obj.params.NutType
        case 1
           Nut=load('ISO4032.mat').Nut;
    end

    if any(Nut.d==d)
        Nut_s=Nut.s(Nut.d==d,:);
        Nut_m=Nut.m(Nut.d==d,:);
        Nut_sw=Nut.sw(Nut.d==d,:);
    else
        error('Please change the washer type !')
    end

    NutWasher_d1=[];
    NutWasher_d2=[];
    NutWasher_h=[];
    % NutWasher
    if obj.params.NutWasher
        switch obj.params.NutWasherType
            case 1
                Washer=load('DIN7089.mat').Washer;
        end

        if any(Washer.d==d)
            NutWasher_d1=Washer.d1(Washer.d==d,:);
            NutWasher_d2=Washer.d2(Washer.d==d,:);
            NutWasher_h=Washer.h(Washer.d==d,:);
        else
            error('Please change the nutwasher type !')
        end
        lk=lk+NutWasher_h;
    end

else
    Nut_s=[];
    Nut_m=[];
    Nut_sw=[];
    NutWasher_d1=[];
    NutWasher_d2=[];
    NutWasher_h=[];
end


Dki=max([da,obj.input.dh,obj.input.dha]);
Dkm=(dw+Dki)/2;

As=pi/4*ds^2-pi/4*d0^2;

% Strength
Strength=load('Strength.mat').Strength;
Rp=Strength.Rp(Strength.Class==obj.params.Strength,:);
Rm=Strength.Rm(Strength.Class==obj.params.Strength,:);
TauB=Strength.TauB(Strength.Class==obj.params.Strength,:);
if and(obj.params.Strength=="8.8",d>16)
    Rm=830;
    Rp=660;  
end
MuG=obj.params.MuG;
v=obj.params.v;
alpha=obj.params.alpha;


MuGG=1/cos(alpha/2/180*pi)*MuG;% Increased coefficient of friction in angular threads
SigmaM=v*Rp/sqrt(1+3*(1.5*d2*(ds^2-d0^2)/(ds^3-d0^3)*(P/pi/d2+MuGG))^2);
FMmax=SigmaM*As;

MuK=obj.params.MuK;
MG=FMmax*(1/2/pi*P+MuGG/2*d2);
MK=FMmax*Dkm/2*MuK;
MA=MG+MK;

Fhmax=Rp*As;
Fh=Fhmax*v;
%% Parse
obj.output.P=P;
obj.output.di=di;
obj.output.d1=d1;
obj.output.d2=d2;
obj.output.d3=d3;
obj.output.H=H;
obj.output.ds=ds;
obj.output.da=da;
obj.output.dw=dw;
obj.output.Dkm=Dkm;
obj.output.As=As;
obj.output.Rp=Rp;
obj.output.Rm=Rm;
obj.output.TauB=TauB;
obj.output.SigmaM=SigmaM;
obj.output.FMmax=FMmax;
obj.output.FMmin=FMmax/obj.params.alphaA;
obj.output.MG=MG;
obj.output.MK=MK;
obj.output.MA=MA;
obj.output.Fhmax=Fhmax;
obj.output.Fh=Fh;
obj.output.K=K;
obj.output.sw=sw;
obj.output.lk=lk;
obj.output.l1=l1;
obj.output.Washer_d1=Washer_d1;
obj.output.Washer_d2=Washer_d2;
obj.output.Washer_h=Washer_h;
obj.output.Nut_s=Nut_s;
obj.output.Nut_m=Nut_m;
obj.output.Nut_sw=Nut_sw;
obj.output.NutWasher_d1=NutWasher_d1;
obj.output.NutWasher_d2=NutWasher_d2;
obj.output.NutWasher_h=NutWasher_h;
obj.output.d0=d0;

%% Print
if obj.params.Echo
    fprintf('Successfully calculate output .\n');
end
end