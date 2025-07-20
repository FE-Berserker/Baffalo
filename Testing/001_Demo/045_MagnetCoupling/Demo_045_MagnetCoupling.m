clc
clear
close all
% Demo MagnetCoupling
% 1. Demo Magnet coupling
% 2. Magnet coupling stiffness

flag=2;
DemoMagnetCoupling(flag);

function DemoMagnetCoupling(flag)
switch flag
    case 1
        S=RMaterial('Magnetic');
        Mat=GetMat(S,[36,72,92]'); % Set Material
        PairNum=8;

        Mat{1,1}.Mux=1.124;
        Mat{1,1}.Muy=1.124;
        Mat{1,1}.Hc=800000;
        Mat{1,1}.BHPoints=[];
        
        inputStruct1.Pair=PairNum;
        inputStruct1.A=10;
        inputStruct1.B=28;
        inputStruct1.C=35;
        inputStruct1.D=52;
        inputStruct1.OuterMagnetSize=[8,3];
        inputStruct1.InnerMagnetSize=[8,3];
        inputStruct1.Width=20;

        paramsStruct1.Material=Mat;
        
        paramsStruct1.Dx=0;
        paramsStruct1.Dy=0;

        Conn= connection.MagnetCoupling(paramsStruct1, inputStruct1);
        Conn= Conn.solve();
        Plot2D(Conn);
        Plot3D(Conn);

       Step=360/PairNum/20;
       Angle=NaN(1,21);
       Torque=NaN(1,21);
        for i=1:21
            Angle(i)=Step*(i-1);
            paramsStruct1.Rot=Step*(i-1);
            Conn= connection.MagnetCoupling(paramsStruct1, inputStruct1);
            Conn= Conn.solve();
            Conn=CalMagneticField(Conn);
            Torque(i)=Conn.output.FEA_Force(3);
        end

        figure
        plot(Angle,Torque)
    case 2
        S=RMaterial('Magnetic');
        Mat=GetMat(S,[36,72,92]'); % Set Material
        PairNum=8;

        Mat{1,1}.Mux=1.124;
        Mat{1,1}.Muy=1.124;
        Mat{1,1}.Hc=800000;
        Mat{1,1}.BHPoints=[];

        inputStruct1.Pair=PairNum;
        inputStruct1.A=10;
        inputStruct1.B=28;
        inputStruct1.C=35;
        inputStruct1.D=52;
        inputStruct1.OuterMagnetSize=[8,3];
        inputStruct1.InnerMagnetSize=[8,3];
        inputStruct1.Width=20;

        paramsStruct1.Material=Mat;
        
        paramsStruct1.Rot=11.25;
        paramsStruct1.Dy=0;

        Conn= connection.MagnetCoupling(paramsStruct1, inputStruct1);
        Conn= Conn.solve();
        Plot2D(Conn);
        Plot3D(Conn);

       Step=2/10;
       Angle=NaN(1,11);
       Fx=NaN(1,11);
        for i=1:11
            Angle(i)=Step*(i-1);
            paramsStruct1.Dx=Step*(i-1);
            Conn= connection.MagnetCoupling(paramsStruct1, inputStruct1);
            Conn= Conn.solve();
            Conn=CalMagneticField(Conn);
            Fx(i)=Conn.output.FEA_Force(1);
        end

        figure
        plot(Angle,Fx)

end
end