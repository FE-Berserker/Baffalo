clc
clear
close all
% Test CatiaAss
% case=1 Create BoltJointAssembly

flag=1;

switch flag
    case 1
        CapAss=CatiaAss('BoltAssembly');
        CapAss=AddPart(CapAss,'.\Bolt1_Bolt.CATPart','Offset',[-3,0,0,0,0,0]);
        CapAss=AddPart(CapAss,'.\Bolt1_Nut.CATPart','Offset',[45,0,0,0,0,0]);
        CapAss=AddPart(CapAss,'.\Bolt1_NutWasher.CATPart','Offset',[42,0,0,0,0,0]);
        CapAss=AddPart(CapAss,'.\Bolt1_Washer.CATPart');
        CatiaOutput(CapAss);
end