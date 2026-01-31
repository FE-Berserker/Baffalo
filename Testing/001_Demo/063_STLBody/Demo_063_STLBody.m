clc
clear
close all
% Demo STLBody
% 1. Create STLBody

flag=1;
DemoSTLBody(flag);

function DemoSTLBody(flag)
switch flag
    case 1
        inputBody.STLFile= 'Example';
        paramBody.Position=[0,0,0,90,0,0];
        obj1=body.STLBody(paramBody, inputBody);
        obj1=obj1.solve();
        Plot3D(obj1);
end

end