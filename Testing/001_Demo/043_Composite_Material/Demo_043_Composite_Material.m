%% Test Composite Material
clc
clear
close all
%% 1 Test STransform
%% 2 Test ETransform
%% 3 Test Compliance
%% 4 Test LaminateStiffness
%% 5 Test LaminateElasticConstants
flag=4;
DemoComposite(flag);

function value=DemoComposite(flag)
switch flag
    case 1
        paramsStruct1=struct();
        inputStruct1.Theta=30;
        inputStruct1.Sigma =[196;84;60;-27.6;62.1;37];
        obj1 = method.Composite.STransform(paramsStruct1, inputStruct1);
        obj1 = obj1.solve();
        disp(obj1.output.Tans_S)
        disp(obj1.output.Ts);
    case 2
        paramsStruct2=struct();
        inputStruct2.Theta=45;
        inputStruct2.Epison =[0.003;0.001;0;0;0;0.0001];
        obj2 = method.Composite.ETransform(paramsStruct2, inputStruct2);
        obj2 = obj2.solve();
        disp(obj2.output.Tans_E)
        disp(obj2.output.Te);
    case 3
        paramsStruct3=struct();
        inputStruct3.E=[181000,10300,10300];
        inputStruct3.v =[0.6,0.27,0.28];
        inputStruct3.G =[3000,7000,7170];
        obj3 = method.Composite.Compliance(paramsStruct3, inputStruct3);
        obj3 = obj3.solve();
        disp(obj3.output.Matrix_S)
        disp(obj3.output.Matrix_C);
    case 4
        inputStruct14.E=[147000,10300];
        inputStruct14.v =0.28;
        inputStruct14.G =7000;
        inputStruct14.tk =0.127;
        inputStruct14.theta =[0;30;-30;90];
        paramsStruct14=struct();
        obj4 = method.Composite.LaminateStiff(paramsStruct14, inputStruct14);
        obj4 = obj4.solve();
        disp(obj4.output.A)
        disp(obj4.output.B);
        disp(obj4.output.D);
    case 5
        inputStruct15.E=[181000,10300];
        inputStruct15.v =0.28;
        inputStruct15.G =7170;
        inputStruct15.tk =5;
        inputStruct15.theta =[0;90;0];
        paramsStruct15=struct();
        obj5 = method.Composite.LaminateEC(paramsStruct15, inputStruct15);
        obj5 = obj5.solve();
        disp(obj5.output.E_eq1)
        disp(obj5.output.E_eq2);

end
end