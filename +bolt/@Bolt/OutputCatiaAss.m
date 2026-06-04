function OutputCatiaAss(obj)
% OutputCatiaAss - 输出catiaAss模型
% Author: Xie Yu

FileName=obj.params.Name;

CapAss=CatiaAss(strcat(FileName,'_Assembly'));

Path_Bolt=strcat('.\',FileName,'_Bolt.CATPart');


if obj.params.Washer==1
    Path_Washer=strcat('.\',FileName,'_Washer.CATPart');
    h=obj.output.Washer_h;
    CapAss=AddPart(CapAss,Path_Bolt,'Offset',[-h,0,0,0,0,0]);
    CapAss=AddPart(CapAss,Path_Washer,'Offset',[0,0,0,0,0,0]);
else
    CapAss=AddPart(CapAss,Path_Bolt,'Offset',[0,0,0,0,0,0]);
    h=0;
end

if obj.params.Nut==1
    Path_Nut=strcat('.\',FileName,'_Nut.CATPart');
    lk=obj.output.lk;
    lk=lk-h;
end

if obj.params.NutWasher==1
    Path_NutWasher=strcat('.\',FileName,'_NutWasher.CATPart');
    h=obj.output.NutWasher_h;
    CapAss=AddPart(CapAss,Path_Nut,'Offset',[lk,0,0,0,0,0]);
    CapAss=AddPart(CapAss,Path_NutWasher,'Offset',[lk-h,0,0,0,0,0]);
else
    CapAss=AddPart(CapAss,Path_Nut,'Offset',[lk,0,0,0,0,0]);
end

CatiaOutput(CapAss);

end
