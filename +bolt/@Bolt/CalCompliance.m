function obj=CalCompliance(obj)
% Calculate compliance of Bolt
% Author: Xie Yu

d=obj.input.d;
AN=pi/4*d^2;
d3=obj.output.d3;
Ad3=pi/4*d3^2;
switch obj.params.BoltType
    case 1
        lsk=0.4*d;
    case 2
        lsk=0.5*d;
    case 3
        lsk=0.5*d;
 
end

l1=obj.output.l1;

lGew=obj.output.lk-l1;
lG=0.5*d;

if obj.params.Nut==1
    lM=0.4*d;
else
    lM=0.33*d;
end

delta_sk=lsk/obj.params.Material{1,1}.E/AN;
delta_shank=l1/obj.params.Material{1,1}.E/AN;
delta_Gew=lGew/obj.params.Material{1,1}.E/Ad3;
delta_G=lG/obj.params.Material{1,1}.E/Ad3;
delta_M=lM/obj.params.Material{1,1}.E/AN;
delta_s=delta_sk+delta_shank+delta_Gew+delta_G+delta_M;

%% Parse
obj.output.deltas=delta_s;
obj.output.deltaM=delta_M;

%% Print
if obj.params.Echo
    fprintf('Successfully calculate bolt compliance .\n');
end
end