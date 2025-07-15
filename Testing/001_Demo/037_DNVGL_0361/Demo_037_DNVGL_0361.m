clc
clear
close all
% Test DNVGL 0361 SN curve calculation
% 1. Create non-welded forged and rolled SN curve
% 2. Create spheroidal graphite cast iron SN curve
flag=1;
DemoDNVGL_0361(flag);

function DemoDNVGL_0361(flag)
switch flag
    case 1
        S=RMaterial('Basic');
        Mat=GetMat(S,20);
        inputStruct.Mat=Mat{1,1};
        inputStruct.deff=200;
        inputStruct.Rz=30;
        inputStruct.R=0.1;
        inputStruct.Sigma_m=150;
        paramsStruct=struct();
        SNCurve= method.DNVGL_0361(paramsStruct, inputStruct);
        SNCurve= SNCurve.solve();
        Plot(SNCurve);
    case 2
        S=RMaterial('Basic');
        Mat=GetMat(S,60);
        inputStruct.Mat=Mat{1,1};
        inputStruct.deff=200;
        inputStruct.Rz=85;
        inputStruct.R=0.1;
        inputStruct.Sigma_m=82;
        inputStruct.j=2;
        paramsStruct=struct();
        SNCurve= method.DNVGL_0361(paramsStruct, inputStruct);
        SNCurve= SNCurve.solve();
        Plot(SNCurve);

end
end
