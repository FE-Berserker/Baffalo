% Demo RotDyn
clc
clear
close all
plotFlag = true;
% setBaffaloPath
% 1. Shaft modal analysis
% 2. Add Discs
% 3. Add Userdefined Disc, output moment of inertia
% 4. Add Blade
% 5. Multi Discs & Calculate critical speed
% 6. Add Bearing
% 7. Add LUT bearing
% 8. Consider prestress
% 9. Eccentricity of shaft
% 10. High speed rotor example
% 11. High speed rotor Harmonic analysis
% 12. High speed unbalance
% 13. Rotor FRF analysis
% 14. Rotor modal analysis with loacl solver 
% 15. Rotor campbell analysis with loacl solver
% 16. Rotor stationary analysis with constant speed 
% 17. Rotor with disc campbell analysis with local solver
% 18. Disc rotor stationary analysis with PID controller
% 19. Disc rotor speedup analysis with PID controller
% 20. Rotor speedup analysis with AMB
% 21. Generate unbalance time series
% 22. Modal analysis with housing
flag=22;
DemoRotDyn(flag);

function DemoRotDyn(flag)
switch flag
    case 1
        % Shaft 1
        inputshaft1.Length = 1000;
        inputshaft1.ID = [0,0];
        inputshaft1.OD = [40,40];
        paramsshaft1 = struct();
        obj1 = shaft.Commonshaft(paramsshaft1, inputshaft1);
        obj1 = obj1.solve();

        mat{1,1}=obj1.params.Material;
        inputRotDyn.Shaft=obj1.output.BeamMesh;
        inputRotDyn.Speed=[0,15000,30000];
        inputRotDyn.MaterialNum=1;
        inputRotDyn.BCNode=[1,1,1,1,0,0,0;size(obj1.output.Node,1),0,1,1,0,0,0];
        paramsRotDyn.Material=mat;
        paramsRotDyn.PrintCampbell=1;
        paramsRotDyn.PrintMode=1;
        paramsRotDyn.Freq=[0,3000];
        obj2 = solve.RotDyn(paramsRotDyn,inputRotDyn);
        Plot(obj2);
        obj2 = obj2.solve();
        ANSYSSolve(obj2.output.Assembly)
    
       obj2=PlotCampbell(obj2,'NMode',8);
       for i=1:10
           PlotMode(obj2,2,i,'scale',10)
       end
    case 2  
        ID=30;
        inputshaft1.Length =750;
        inputshaft1.ID = [0,0];
        inputshaft1.OD = [ID,ID];
        paramsshaft1.Beam_N = 16;
        obj1 = shaft.Commonshaft(paramsshaft1, inputshaft1);
        obj1 = obj1.solve();

        mat{1,1}=obj1.params.Material;
        inputRotDyn.Shaft=obj1.output.BeamMesh;
        inputRotDyn.Speed=[0,400,800,1200,1600,2000];% Unit: RPM
        inputRotDyn.MaterialNum=1;
        inputRotDyn.BCNode=[1,1,1,1,0,0,0;size(obj1.output.Node,1),1,1,1,0,0,0];
        paramsRotDyn.Material=mat;
        paramsRotDyn.PrintCampbell=1;
        paramsRotDyn.Position=[0,0,0,0,0,0];
        Dyn = solve.RotDyn(paramsRotDyn,inputRotDyn);
        [Dyn,Num1]= AddCnode(Dyn,250);
        DiscMass=20*10^-3;
        rou=obj1.params.Material.Dens;
        OD=240;
        L=DiscMass/((OD^2-ID^2)*pi/4*rou);
        Dyn= AddDisc(Dyn,Num1,OD,ID,L,1);
        Plot(Dyn);
        Dyn = Dyn.solve();
        ANSYSSolve(Dyn.output.Assembly)

        PlotCampbell(Dyn,'NMode',4);
    case 3 
        OD=30;
        inputshaft1.Length =750;
        inputshaft1.ID = [0,0];
        inputshaft1.OD = [OD,OD];
        paramsshaft1.Beam_N = 30;
        obj1 = shaft.Commonshaft(paramsshaft1, inputshaft1);
        obj1 = obj1.solve();

        mat{1,1}=obj1.params.Material;
        inputRotDyn.Shaft=obj1.output.BeamMesh;
        inputRotDyn.Speed=[0,1500,3000];% Unit: RPM
        inputRotDyn.MaterialNum=1;
        inputRotDyn.BCNode=[1,1,1,1,0,0,0;size(obj1.output.Node,1),1,1,1,0,0,0];
        paramsRotDyn.Material=mat;
        paramsRotDyn.PrintCampbell=1;
        paramsRotDyn.Position=[0,0,0,0,0,0];
        Dyn = solve.RotDyn(paramsRotDyn,inputRotDyn);
        [Dyn,Num1]= AddCnode(Dyn,250);
        % [Dyn,Num2]= AddCnode(Dyn,500);
        [Dyn,Num2]= AddCnode(Dyn,520);

        a1=Point2D('Circle center');
        a1=AddPoint(a1,0,0);
        a1=AddPoint(a1,[-50;50],[0;0]);
        b1=Line2D('Semi circle');
        b1=AddCircle(b1,50,a1,1,'ang',180);
        b1=AddLine(b1,a1,2);
        S1=Surface2D(b1);

        a2=Point2D('Square corner');
        % a2=AddPoint(a2,[-100;-100;100;100],[0;50;50;0]);
        a2=AddPoint(a2,[-120;-120;80;80],[0;50;50;0]);
        b2=Line2D('Square');
        b2=AddCurve(b2,a2,1);
        S2=Surface2D(b2);

        Dyn= AddUserdefinedDisc(Dyn,Num1,S1,1);
        Dyn= AddUserdefinedDisc(Dyn,Num2,S2,1);

        Plot(Dyn);
        disp(Dyn.input.PointMass)
    case 4
        OD=425;
        inputshaft1.Length =1000;
        inputshaft1.ID = [0,0];
        inputshaft1.OD = [OD,OD];
        paramsshaft1.Beam_N = 30;
        obj1 = shaft.Commonshaft(paramsshaft1, inputshaft1);
        obj1 = obj1.solve();

        mat{1,1}=obj1.params.Material;
        inputRotDyn.Shaft=obj1.output.BeamMesh;
        inputRotDyn.Speed=[0,1500,3000];% Unit: RPM
        inputRotDyn.MaterialNum=1;
        inputRotDyn.BCNode=[1,1,1,1,0,0,0;size(obj1.output.Node,1),1,1,1,0,0,0];
        paramsRotDyn.Material=mat;
        paramsRotDyn.NMode=15;
        paramsRotDyn.Freq=[0,3000];
        paramsRotDyn.PrintCampbell=1;
        paramsRotDyn.PrintMode=1;
        paramsRotDyn.Position=[0,0,0,0,0,0];
        Dyn = solve.RotDyn(paramsRotDyn,inputRotDyn);
        [Dyn,Num1]= AddCnode(Dyn,500);

        a=Point2D('Circle center');
        a=AddPoint(a,[-160;-160;-155;-155;-95;-55;55;90;155;155;160;160;-160],...
            [212.5;350;350;380;390;595;595;385;355;320;320;212.5;212.5]);
        a=AddPoint(a,[-45;-20;18;45],...
            [595;1050;1050;595]);
        b1=Line2D('Section1');
        b1=AddCurve(b1,a,1);
        S1=Surface2D(b1);

        b2=Line2D('Section2');
        b2=AddCurve(b2,a,2);
        S2=Surface2D(b2);

        Dyn= AddUserdefinedDisc(Dyn,Num1,S1,1);
        Dyn= AddBlade(Dyn,Num1,S2,1,30,3);
        Plot(Dyn);

        Dyn = Dyn.solve();
        ANSYSSolve(Dyn.output.Assembly);

        PlotCampbell(Dyn,'NMode',8);
        for i=1:8
            PlotMode(Dyn,2,i,'scale',100)
        end
    case 5
        m1=0.102;% unit:ton
        JT1=6377*2;% unit: ton/mm2
        JD1=6377;% unit: ton/mm2
        % Shaft1
        OD=50;% Unit: mm
        inputshaft1.Length =1200;
        inputshaft1.ID = [0,0];
        inputshaft1.OD = [OD,OD];
        paramsshaft1.Beam_N = 30;
        obj1 = shaft.Commonshaft(paramsshaft1, inputshaft1);
        obj1 = obj1.solve();

        mat{1,1}=obj1.params.Material;
        inputRotDyn.Shaft=obj1.output.BeamMesh;
        inputRotDyn.Speed=[0,1000,2000,3000];% Unit: RPM
        inputRotDyn.MaterialNum=1;
        inputRotDyn.BCNode=[1,1,1,1,0,0,0];
        paramsRotDyn.Material=mat;
        paramsRotDyn.PrintCampbell=1;
        Dyn = solve.RotDyn(paramsRotDyn,inputRotDyn);

        [Dyn,Num1]= AddCnode(Dyn,400);
        Dyn=AddPointMass(Dyn,Num1,m1,JT1,JD1);

        [Dyn,Num2]= AddCnode(Dyn,800);
        Bound=[1,1,1,0,0,0];
        Dyn= AddBCNode(Dyn,Num2,Bound);

        [Dyn,Num3]= AddCnode(Dyn,1200);
        Dyn=AddPointMass(Dyn,Num3,m1,JT1,JD1);
        Plot(Dyn);
        Dyn = Dyn.solve();
        ANSYSSolve(Dyn.output.Assembly);

        PlotCampbell(Dyn,'NMode',12);
        Dyn=CalculateCriticalSpeed(Dyn,'NMode',12);

        disp(Dyn.output.CriticalSpeed);
    case 6
        L1=200;
        L2=300;
        L3=500;
        L4=300;
        t1=50;t2=50;t3=60;
        R1=120;
        R2=200;
        R3=200;
        d=50;
        % Shaft1
        inputshaft1.Length = [L1-t1/2;L1+t1/2;L1+L2-t2/2;L1+L2+t2/2;L1+L2+L3-t3/2;L1+L2+L3+t3/2;L1+L2+L3+L4];
        inputshaft1.ID = [[0,0];[0,0];[0,0];[0,0];[0,0];[0,0];[0,0]];
        inputshaft1.OD = [[d,d];[R1*2,R1*2];[d,d];[R2*2,R2*2];[d,d];[R3*2,R3*2];[d,d]];
        paramsshaft1.Beam_N = 16;
        paramsshaft1.N_Slice=201;
        obj1 = shaft.Commonshaft(paramsshaft1, inputshaft1);
        obj1 = obj1.solve();
        Plot3D(obj1)
        % Rigid Boundary
        mat{1,1}=obj1.params.Material;
        inputRotDyn.Shaft=obj1.output.BeamMesh;
        inputRotDyn.Speed=[0,1000,2000,3000,4000,5000,6000];
        inputRotDyn.MaterialNum=1;
        inputRotDyn.BCNode=[1,1,1,1,1,0,0;size(obj1.output.Node,1),0,1,1,1,0,0];
        paramsRotDyn.Material=mat;
        paramsRotDyn.PrintCampbell=1;
        paramsRotDyn.ShaftTorsion=1;
        paramsRotDyn.PrintMode=1;
        Dyn1 = solve.RotDyn(paramsRotDyn,inputRotDyn);
        Dyn1 = Dyn1.solve();
        Plot(Dyn1);
        ANSYSSolve(Dyn1.output.Assembly);
        Dyn1=PlotCampbell(Dyn1,'NMode',12);
        
        % Bearing
        mat{1,1}=obj1.params.Material;
        inputRotDyn.Shaft=obj1.output.BeamMesh;
        inputRotDyn.Speed=[0,1000,2000,3000,4000,5000,6000];
        inputRotDyn.MaterialNum=1;
        inputRotDyn.Bearing=[1,1e8,8e3,3e3,0,0,0,1e-3*8e3,2e-4*3e3,0,0;size(obj1.output.Node,1),0,8e3,3e3,0,0,0,1e-3*8e3,2e-4*3e3,0,0];
        paramsRotDyn.Material=mat;
        paramsRotDyn.PrintCampbell=1;
        paramsRotDyn.ShaftTorsion=1;
        paramsRotDyn.PrintMode=1;
        inputRotDyn.BCNode=[];
        Dyn2 = solve.RotDyn(paramsRotDyn,inputRotDyn);
        Dyn2 = Dyn2.solve();
        Plot(Dyn2);
        ANSYSSolve(Dyn2.output.Assembly);

        Dyn2=PlotCampbell(Dyn2,'NMode',12);

        disp(Dyn1.output.Campbell);
        disp(Dyn2.output.Campbell);
    case 7
        L1=200;
        L2=300;
        L3=500;
        L4=300;
        t1=50;t2=50;t3=60;
        R1=120;
        R2=200;
        R3=200;
        d=50;
        % Shaft1
        inputshaft1.Length = [L1-t1/2;L1+t1/2;L1+L2-t2/2;L1+L2+t2/2;L1+L2+L3-t3/2;L1+L2+L3+t3/2;L1+L2+L3+L4];
        inputshaft1.ID = [[0,0];[0,0];[0,0];[0,0];[0,0];[0,0];[0,0]];
        inputshaft1.OD = [[d,d];[R1*2,R1*2];[d,d];[R2*2,R2*2];[d,d];[R3*2,R3*2];[d,d]];
        paramsshaft1.Beam_N = 16;
        paramsshaft1.N_Slice=201;
        obj1 = shaft.Commonshaft(paramsshaft1, inputshaft1);
        obj1 = obj1.solve();
        Plot3D(obj1)
 
        % LUTBearing
        RPM=[0,2000,4000,6000,8000,10000,12000]';
        K11=[1.6e3,2e3,4.8e3,8.8e3,1.3e4,1.8e4,2.3e4]';
        K22=[2e3,3e3,6e3,1.1e4,1.7e4,2.3e4,3e4]';
        K12=[-2e1,-2.4e1,-6.8e1,-1.2e2,-1.9e2,-2.6e2,-3.6e2]';
        K21=[6,4e1,1e2,1.7e2,2.5e2,3.4e2,4.3e2]';
        C11=[2,2,2,2,2,2,2]';
        C22=[5,5,5,5,5,5,5]';
        C12=[-4,-4,-4,-4,-4,-4,-4]';
        C21=[3,3,3,3,3,3,3]';
        LUTBearing=table(RPM,K11,K22,K12,K21,C11,C22,C12,C21);

        mat{1,1}=obj1.params.Material;
        inputRotDyn.Shaft=obj1.output.BeamMesh;
        inputRotDyn.Speed=[0,1000,2000,3000,4000,5000,6000];
        inputRotDyn.MaterialNum=1;
        inputRotDyn.Bearing=[1,1e8,0,0,0,0,0,0,0,0,0];
        paramsRotDyn.Material=mat;
        paramsRotDyn.PrintCampbell=1;
        paramsRotDyn.ShaftTorsion=1;
        paramsRotDyn.PrintMode=1;
        inputRotDyn.BCNode=[];
        Dyn2 = solve.RotDyn(paramsRotDyn,inputRotDyn);
        
        Dyn2=AddTable(Dyn2,LUTBearing);
        Dyn2=AddLUTBearing(Dyn2,1,1);% Node 1, Table 1
        Dyn2=AddLUTBearing(Dyn2,size(obj1.output.Node,1),1);

        Dyn2 = Dyn2.solve();

        Plot(Dyn2);
        ANSYSSolve(Dyn2.output.Assembly);

        Dyn2=PlotCampbell(Dyn2,'NMode',12);

        disp(Dyn2.output.Campbell);

    case 8
        L1=200;
        L2=300;
        L3=500;
        L4=300;
        t1=50;t2=50;t3=60;
        R1=120;
        R2=200;
        R3=200;
        d=50;
        % Shaft1
        inputshaft1.Length = [L1-t1/2;L1+t1/2;L1+L2-t2/2;L1+L2+t2/2;L1+L2+L3-t3/2;L1+L2+L3+t3/2;L1+L2+L3+L4];
        inputshaft1.ID = [[0,0];[0,0];[0,0];[0,0];[0,0];[0,0];[0,0]];
        inputshaft1.OD = [[d,d];[R1*2,R1*2];[d,d];[R2*2,R2*2];[d,d];[R3*2,R3*2];[d,d]];
        paramsshaft1.Beam_N = 16;
        paramsshaft1.N_Slice=201;
        obj1 = shaft.Commonshaft(paramsshaft1, inputshaft1);
        obj1 = obj1.solve();
        Plot3D(obj1)
        % Bearing
        mat{1,1}=obj1.params.Material;
        inputRotDyn.Shaft=obj1.output.BeamMesh;
        inputRotDyn.Speed=[0,1000,2000,3000,4000,5000,6000];
        inputRotDyn.MaterialNum=1;
        inputRotDyn.Bearing=[1,1e8,8e3,3e3,0,0,0,1e-3,2e-4,0,0;size(obj1.output.Node,1),0,8e3,3e3,0,0,0,1e-3,2e-4,0,0];
        paramsRotDyn.Material=mat;
        paramsRotDyn.PrintCampbell=1;
        paramsRotDyn.ShaftTorsion=1;
        paramsRotDyn.Material=mat;
        paramsRotDyn.PStress=1;
        Dyn2 = solve.RotDyn(paramsRotDyn,inputRotDyn);
        Dyn2 = Dyn2.solve();
        Plot(Dyn2);
        ANSYSSolve(Dyn2.output.Assembly);

        Dyn2=PlotCampbell(Dyn2,'NMode',12);

        disp(Dyn2.output.Campbell);
    case 9
        L1=200;
        L2=300;
        L3=500;
        L4=300;
        t1=50;t2=50;t3=60;
        R1=120;
        R2=200;
        R3=200;
        d=50;
        % Shaft1
        inputshaft1.Length = [L1-t1/2;L1+t1/2;L1+L2-t2/2;L1+L2+t2/2;L1+L2+L3-t3/2;L1+L2+L3+t3/2;L1+L2+L3+L4];
        inputshaft1.ID = [[0,0];[0,0];[0,0];[0,0];[0,0];[0,0];[0,0]];
        inputshaft1.OD = [[d,d];[R1*2,R1*2];[d,d];[R2*2,R2*2];[d,d];[R3*2,R3*2];[d,d]];
        paramsshaft1.Beam_N = 16;
        paramsshaft1.N_Slice=201;
        obj1 = shaft.Commonshaft(paramsshaft1, inputshaft1);
        obj1 = obj1.solve();
        % Rigid Boundary
        mat{1,1}=obj1.params.Material;
        inputRotDyn.Shaft=obj1.output.BeamMesh;
        inputRotDyn.Speed=[0,1000,2000,3000,4000,5000,6000];
        inputRotDyn.MaterialNum=1;
        inputRotDyn.BCNode=[1,1,1,1,1,0,0;size(obj1.output.Node,1),0,1,1,1,0,0];
        paramsRotDyn.Material=mat;
        paramsRotDyn.PrintCampbell=1;
        paramsRotDyn.ShaftTorsion=1;
        paramsRotDyn.PrintMode=1;
        paramsRotDyn.ey=[5,-5];
        Dyn1 = solve.RotDyn(paramsRotDyn,inputRotDyn);
        Dyn1 = Dyn1.solve();
        Plot(Dyn1);
        ANSYSSolve(Dyn1.output.Assembly);
        Dyn1=PlotCampbell(Dyn1,'NMode',12);
        disp(Dyn1.output.Campbell);
    case 10
        % Shaft
        inputshaft1.Length = [35;45;70;200;250;300];
        inputshaft1.ID = [[0,0];[10,10];[10,10];[10,10];[10,10];[10,10]];
        inputshaft1.OD = [[40,40];[70,70];[40,40];[40,40];[40,40];[70,70]];
        paramsshaft1.Beam_N = 16;
        paramsshaft1.N_Slice=201;
        obj1 = shaft.Commonshaft(paramsshaft1, inputshaft1);
        obj1 = obj1.solve();
        Plot3D(obj1)

        mat{1,1}=obj1.params.Material;
        inputRotDyn.Shaft=obj1.output.BeamMesh;
        inputRotDyn.Speed=[0,10000,20000,30000,40000,50000,60000];
        inputRotDyn.PointMass=[1,1.2e-3,2.4,1.2;size(obj1.output.Node,1),1e-3,2,1];
        inputRotDyn.MaterialNum=1;
        paramsRotDyn.Material=mat;
        paramsRotDyn.PrintCampbell=1;
        paramsRotDyn.PrintMode=1;
        Dyn1 = solve.RotDyn(paramsRotDyn,inputRotDyn);

        [Dyn1,Num1]= AddCnode(Dyn1,70);
        Dyn1=AddBearing(Dyn1,Num1,[1e10,8e4,1e5,1e4,6e4,0,8,12,3,3]);

        [Dyn1,Num2]= AddCnode(Dyn1,200);
        Dyn1=AddBearing(Dyn1,Num2,[0,5e4,7e4,2e4,4e4,0,6,8,1.5,1.5]);
        Dyn1 = Dyn1.solve();

        ANSYSSolve(Dyn1.output.Assembly);
        Dyn1=PlotCampbell(Dyn1,'NMode',6);
        disp(Dyn1.output.Campbell);

        for i=1:6
            PlotMode(Dyn1,2,i,'scale',1)
        end
                Dyn1=CalculateCriticalSpeed(Dyn1);

        disp(Dyn1.output.CriticalSpeed);
    case 11
        % Shaft
        inputshaft1.Length = [35;45;70;200;250;300];
        inputshaft1.ID = [[0,0];[10,10];[10,10];[10,10];[10,10];[10,10]];
        inputshaft1.OD = [[40,40];[70,70];[40,40];[40,40];[40,40];[70,70]];
        paramsshaft1.Beam_N = 16;
        paramsshaft1.N_Slice=201;
        obj1 = shaft.Commonshaft(paramsshaft1, inputshaft1);
        obj1 = obj1.solve();
        Plot3D(obj1)

        mat{1,1}=obj1.params.Material;
        inputRotDyn.Shaft=obj1.output.BeamMesh;
        inputRotDyn.Speed=[0,10000,20000,30000,40000,50000,60000];
        inputRotDyn.PointMass=[1,1.2e-3,2.4,1.2;size(obj1.output.Node,1),1e-3,2,1];
        inputRotDyn.UnBalanceForce=[1,0.5e-6;size(obj1.output.Node,1),0.5e-6];
        inputRotDyn.MaterialNum=1;
        paramsRotDyn.Material=mat;
        paramsRotDyn.Type=3;

        Dyn1 = solve.RotDyn(paramsRotDyn,inputRotDyn);

        [Dyn1,Num1]= AddCnode(Dyn1,70);
        Dyn1=AddBearing(Dyn1,Num1,[1e10,8e4,1e5,1e4,6e4,0,8,12,3,3]);

        [Dyn1,Num2]= AddCnode(Dyn1,200);
        Dyn1=AddBearing(Dyn1,Num2,[0,5e4,7e4,2e4,4e4,0,6,8,1.5,1.5]);
        Dyn1 = Dyn1.solve();

        ANSYSSolve(Dyn1.output.Assembly);
        PlotSpeedup(Dyn1);
    case 12
        % Shaft
        inputshaft1.Length = [35;45;70;200;250;300];
        inputshaft1.ID = [[0,0];[10,10];[10,10];[10,10];[10,10];[10,10]];
        inputshaft1.OD = [[40,40];[70,70];[40,40];[40,40];[40,40];[70,70]];
        paramsshaft1.Beam_N = 16;
        paramsshaft1.N_Slice=201;
        obj1 = shaft.Commonshaft(paramsshaft1, inputshaft1);
        obj1 = obj1.solve();
        Plot3D(obj1)

        mat{1,1}=obj1.params.Material;
        inputRotDyn.Shaft=obj1.output.BeamMesh;
        inputRotDyn.Speed=[0,10000,20000,30000,40000,50000,60000];
        inputRotDyn.PointMass=[1,1.2e-3,2.4,1.2;size(obj1.output.Node,1),1e-3,2,1];
        inputRotDyn.MaterialNum=1;
        inputRotDyn.BalanceQuality=[2.5,3000,0,300,0];
        paramsRotDyn.Material=mat;
        paramsRotDyn.Type=3;

        Dyn1 = solve.RotDyn(paramsRotDyn,inputRotDyn);

        [Dyn1,Num1]= AddCnode(Dyn1,70);
        Dyn1=AddBearing(Dyn1,Num1,[1e10,8e4,1e5,1e4,6e4,0,8,12,3,3]);

        [Dyn1,Num2]= AddCnode(Dyn1,200);
        Dyn1=AddBearing(Dyn1,Num2,[0,5e4,7e4,2e4,4e4,0,6,8,1.5,1.5]);
        Dyn1 = Dyn1.solve();

        ANSYSSolve(Dyn1.output.Assembly);
        PlotSpeedup(Dyn1);
    case 13
        % Shaft
        inputshaft1.Length = 500;
        inputshaft1.ID = [0,0];
        inputshaft1.OD = [8,8];
        paramsshaft1.Beam_N = 16;
        paramsshaft1.N_Slice=10;
        obj1 = shaft.Commonshaft(paramsshaft1, inputshaft1);
        obj1 = obj1.solve();
        Plot3D(obj1)

        mat{1,1}=obj1.params.Material;
        inputRotDyn.Shaft=obj1.output.BeamMesh;
        inputRotDyn.Speed=0;
        inputRotDyn.MaterialNum=1;
        paramsRotDyn.Material=mat;
        paramsRotDyn.Type=1;
        paramsRotDyn.Solver='Local';
        paramsRotDyn.Rayleigh=[1e-5,10];

        Dyn1 = solve.RotDyn(paramsRotDyn,inputRotDyn);
        Dyn1 = AddBCNode(Dyn1,1,[1,1,1,1,1,1]);
        [Dyn1,Num1]= AddCnode(Dyn1,500);
        [Dyn1,Num2]= AddCnode(Dyn1,250);
        Dyn1 = AddBearing(Dyn1,Num1,[0,1e2,1e2,0,0,0,0,0,0,0]);
        Dyn1 = AddInNode(Dyn1,Num1);
        Dyn1 = AddOutNode(Dyn1,[Num1;Num2]);
        Dyn1 = Dyn1.solve();
        PlotBode(Dyn1)
    case 14
        % Shaft
        inputshaft1.Length = 500;
        inputshaft1.ID = [0,0];
        inputshaft1.OD = [8,8];
        paramsshaft1.Beam_N = 16;
        paramsshaft1.N_Slice=10;
        obj1 = shaft.Commonshaft(paramsshaft1, inputshaft1);
        obj1 = obj1.solve();
        Plot3D(obj1)

        mat{1,1}=obj1.params.Material;
        inputRotDyn.Shaft=obj1.output.BeamMesh;
        inputRotDyn.Speed=0;
        inputRotDyn.MaterialNum=1;
        paramsRotDyn.Material=mat;
        paramsRotDyn.Type=2;
        paramsRotDyn.PrintMode=1;
        paramsRotDyn.PrintCampbell=1;
        paramsRotDyn.Solver='Local';
        % paramsRotDyn.Rayleigh=[0,0];
        paramsRotDyn.Rayleigh=[1e-5,10];

        Dyn1 = solve.RotDyn(paramsRotDyn,inputRotDyn);
        Dyn1 = AddBCNode(Dyn1,1,[1,1,1,1,1,1]);
        [Dyn1,Num1]= AddCnode(Dyn1,500);
        Dyn1 = AddBearing(Dyn1,Num1,[0,1e2,1e2,0,0,0,0,0,0,0]);
        Dyn1 = Dyn1.solve();

        for i=1:10
            PlotMode(Dyn1,1,i,'scale',5)
        end
    case 15
        % Shaft
        inputshaft1.Length = 500;
        inputshaft1.ID = [0,0];
        inputshaft1.OD = [8,8];
        paramsshaft1.Beam_N = 16;
        paramsshaft1.N_Slice=10;
        obj1 = shaft.Commonshaft(paramsshaft1, inputshaft1);
        obj1 = obj1.solve();
        Plot3D(obj1)

        mat{1,1}=obj1.params.Material;
        inputRotDyn.Shaft=obj1.output.BeamMesh;
        inputRotDyn.Speed=(0:1000:10000);
        inputRotDyn.MaterialNum=1;
        paramsRotDyn.Material=mat;
        paramsRotDyn.Type=2;
        paramsRotDyn.PrintMode=1;
        paramsRotDyn.PrintCampbell=1;
        paramsRotDyn.Solver='Local';
        % paramsRotDyn.Rayleigh=[0,0];
        paramsRotDyn.Rayleigh=[1e-5,10];

        Dyn1 = solve.RotDyn(paramsRotDyn,inputRotDyn);
        Dyn1 = AddBCNode(Dyn1,1,[1,1,1,1,1,1]);
        [Dyn1,Num1]= AddCnode(Dyn1,500);
        Dyn1 = AddBearing(Dyn1,Num1,[0,1e2,1e2,0,0,0,0,0,0,0]);
        Dyn1 = Dyn1.solve();

        Dyn1=PlotCampbell(Dyn1,'NMode',8);
        disp(Dyn1.output.Campbell);
    case 16
        % Shaft
        inputshaft1.Length = 500;
        inputshaft1.ID = [0,0];
        inputshaft1.OD = [8,8];
        paramsshaft1.Beam_N = 16;
        paramsshaft1.N_Slice=10;
        Shaft = shaft.Commonshaft(paramsshaft1, inputshaft1);
        Shaft = Shaft.solve();
        Plot3D(Shaft)
        % Load 
        inputStruct2.Time=0:1e-3:1;
        inputStruct2.Fy=rand(1,length(inputStruct2.Time));
        paramsStruct2=struct();
        Load=signal.ForceLoad(paramsStruct2, inputStruct2);
        Load=Load.solve();
        Plot(Load);

        mat{1,1}=Shaft.params.Material;
        inputRotDyn.Shaft=Shaft.output.BeamMesh;
        inputRotDyn.Speed=(0:1000:2000);
        inputRotDyn.MaterialNum=1;
        paramsRotDyn.Material=mat;
        paramsRotDyn.Type=4;
        paramsRotDyn.PrintMode=1;
        paramsRotDyn.PrintCampbell=1;
        paramsRotDyn.Solver='Local';
        % paramsRotDyn.Rayleigh=[0,0];
        paramsRotDyn.Rayleigh=[1e-5,10];
       
        Dyn1 = solve.RotDyn(paramsRotDyn,inputRotDyn);
        Dyn1 = AddBCNode(Dyn1,1,[1,1,1,1,1,1]);
        [Dyn1,Num1]= AddCnode(Dyn1,500);
        [Dyn1,Num2]= AddCnode(Dyn1,250);
        Dyn1 = AddBearing(Dyn1,Num1,[0,1e2,1e2,0,0,0,0,0,0,0]);
        Dyn1 = AddTimeSeries(Dyn1,Num2,Load.output.Load);
        Dyn1 = Dyn1.solve();
        PlotTimeSeriesResult(Dyn1,'Node',Dyn1.input.KeyNode,'Component',[1;2],'Load',1);
    case 17
        % Shaft
        inputshaft1.Length = [118;158;215;345;402;442;580];
        inputshaft1.ID = [[0,0];[0,0];[0,0];[0,0];[0,0];[0,0];[0,0]];
        inputshaft1.OD = [[16,16];[17.6,17.6];[16,16];[17.6,17.6];[16,16];[17.6,17.6];[16,16]];
        paramsshaft1.Beam_N = 16;
        paramsshaft1.N_Slice=118;
        Shaft = shaft.Commonshaft(paramsshaft1, inputshaft1);
        Shaft = Shaft.solve();
        Plot3D(Shaft)

        mat{1,1}=Shaft.params.Material;
        inputRotDyn.Shaft=Shaft.output.BeamMesh;
        inputRotDyn.Speed=(1000:1000:8000);
        inputRotDyn.MaterialNum=1;
        paramsRotDyn.Material=mat;
        paramsRotDyn.Type=2;
        paramsRotDyn.PrintMode=1;
        paramsRotDyn.PrintCampbell=1;
        paramsRotDyn.Solver='Local';
        % paramsRotDyn.Rayleigh=[0,0];
        paramsRotDyn.Rayleigh=[1.69e-5,16.04];% 0.001

        Dyn1 = solve.RotDyn(paramsRotDyn,inputRotDyn);
        [Dyn1,Num1]= AddCnode(Dyn1,9);
        [Dyn1,Num2]= AddCnode(Dyn1,138);
        [Dyn1,Num3]= AddCnode(Dyn1,422);
        [Dyn1,Num4]= AddCnode(Dyn1,551);

        Dyn1=AddPointMass(Dyn1,Num1,1.056e-4,2.4649e-2,1.6004e-2);
        Dyn1=AddPointMass(Dyn1,Num2,4.207e-4,1.3102e-2,1.2324e-2);
        Dyn1=AddPointMass(Dyn1,Num3,4.207e-4,1.3102e-2,1.2324e-2);
        Dyn1=AddPointMass(Dyn1,Num4,1.056e-4,2.4649e-2,1.6004e-2);

        nEle=28;
        Step=(345-215)/(nEle-1);
        [Dyn1,Num]= AddCnode(Dyn1,215);
        Dyn1=AddPointMass(Dyn1,Num,2.01e-5,7.0059e-3,3.3452e-3);
        for i=2:nEle-1
            [Dyn1,Num]= AddCnode(Dyn1,215+(i-1)*Step);
            Dyn1=AddPointMass(Dyn1,Num,2.01e-5,7.0059e-3,3.3452e-3);
            [Dyn1,Num]= AddCnode(Dyn1,215+(i-1)*Step);
            Dyn1=AddPointMass(Dyn1,Num,2.01e-5,7.0059e-3,3.3452e-3);
        end
        [Dyn1,Num]= AddCnode(Dyn1,345);
        Dyn1=AddPointMass(Dyn1,Num,2.01e-5,7.0059e-3,3.3452e-3);

        Dyn1=AddBearing(Dyn1,1,[1e7,0,0,0,0,0,0,0,0,0]); % Axial bearing
        [Dyn1,Num1]= AddCnode(Dyn1,9);
        Dyn1=AddTorBearing(Dyn1,Num1,[1e13,0]);% Torsional bearing
        Dyn1=AddBearing(Dyn1,Num1,[0,2e5,2e5,0,0,0,0,0,0,0]);% Simple bearing
        [Dyn1,Num4]= AddCnode(Dyn1,551);
        Dyn1=AddBearing(Dyn1,Num4,[0,2e5,2e5,0,0,0,0,0,0,0]);% Simple bearing

        % LUTBearing
        load TestRigLam1Ecc0.mat %#ok<LOAD>
        RPM=rpm';
        K11=stiffness_matrix{1,1}/1000; %#ok<USENS>
        K22=stiffness_matrix{2,2}/1000;
        K12=stiffness_matrix{1,2}/1000;
        K21=stiffness_matrix{2,1}/1000;
        C11=damping_matrix{1, 1}/1000; %#ok<USENS>
        C22=damping_matrix{2, 2}/1000;
        C12=damping_matrix{1, 2}/1000;
        C21=damping_matrix{2, 1}/1000;
        LUTBearing1=table(RPM,K11,K22,K12,K21,C11,C22,C12,C21);
        Dyn1=AddTable(Dyn1,LUTBearing1);

        % LUTBearing
        load TestRigLam2Ecc0.mat %#ok<LOAD>
        RPM=rpm';
        K11=stiffness_matrix{1,1}/1000;
        K22=stiffness_matrix{2,2}/1000;
        K12=stiffness_matrix{1,2}/1000;
        K21=stiffness_matrix{2,1}/1000;
        C11=damping_matrix{1, 1}/1000;
        C22=damping_matrix{2, 2}/1000;
        C12=damping_matrix{1, 2}/1000;
        C21=damping_matrix{2, 1}/1000;
        LUTBearing2=table(RPM,K11,K22,K12,K21,C11,C22,C12,C21);
        Dyn1=AddTable(Dyn1,LUTBearing2);

        [Dyn1,Num]= AddCnode(Dyn1,250);
        Dyn1=AddLUTBearing(Dyn1,Num,1);

        [Dyn1,Num]= AddCnode(Dyn1,310);
        Dyn1=AddLUTBearing(Dyn1,Num,2);
        Dyn1 = Dyn1.solve();
        PlotCampbell(Dyn1,'NMode',9);
        % PlotMode(Dyn1,1,1)
    case 18
        % Disc rotor
        inputshaft1.Length = [220;280;500];
        inputshaft1.ID = [[0,0];[0,0];[0,0]];
        inputshaft1.OD = [[20,20];[100,100];[20,20]];
        paramsshaft1.Beam_N = 16;
        paramsshaft1.N_Slice=20;
        Shaft = shaft.Commonshaft(paramsshaft1, inputshaft1);
        Shaft = Shaft.solve();
        Plot3D(Shaft)

        % Load
        inputLoad.Time=0:1e-4:0.5;
        inputLoad.Fy=ones(1,length(inputLoad.Time));
        paramsLoad=struct();
        Load=signal.ForceLoad(paramsLoad, inputLoad);
        Load=Load.solve();
        Plot(Load);

        mat{1,1}=Shaft.params.Material;
        inputRotDyn.Shaft=Shaft.output.BeamMesh;
        inputRotDyn.Speed=0;
        inputRotDyn.MaterialNum=1;
        paramsRotDyn.Material=mat;
        paramsRotDyn.Type=4;
        paramsRotDyn.Solver='Local';
        paramsRotDyn.Rayleigh=[1e-5,10];

        Dyn1 = solve.RotDyn(paramsRotDyn,inputRotDyn);

        Dyn1 = AddBearing(Dyn1,1,[1e-3,1e3,1e3,0,0,0,0,0,0,0]);
        [Dyn1,Num1]= AddCnode(Dyn1,500);
        Dyn1 = AddBearing(Dyn1,Num1,[0,1e3,1e3,0,0,0,0,0,0,0]);

        [Dyn1,Num2]= AddCnode(Dyn1,250);
        Dyn1 = AddTimeSeries(Dyn1,Num2,Load.output.Load);
        load pidTestLUT %#ok<LOAD>
        Dyn1 = AddPIDController(Dyn1,Num2,2e2/70,2e2/70,1/70,'Type',3,'Table',pidTestLUT,'Direction','Uy');
        Dyn1 = AddPIDController(Dyn1,Num2,2e2/70,2e2/70,1/70,'Type',3,'Table',pidTestLUT,'Direction','Uz');
        Dyn1 = AddKeyNode(Dyn1,Num2);
        Dyn1 = Dyn1.solve();

        PlotTimeSeriesResult(Dyn1,'Node',Dyn1.input.KeyNode,'Component',[1;2],'Load',1,'PIDController',1);
        % PlotTimeSeriesResult(Dyn1,'Node',Dyn1.input.KeyNode,'Component',[1;2],'Load',1);
    case 19
        % Disc rotor
        inputshaft1.Length = [220;280;500];
        inputshaft1.ID = [[0,0];[0,0];[0,0]];
        inputshaft1.OD = [[20,20];[100,100];[20,20]];
        paramsshaft1.Beam_N = 16;
        paramsshaft1.N_Slice=20;
        Shaft = shaft.Commonshaft(paramsshaft1, inputshaft1);
        Shaft = Shaft.solve();
        Plot3D(Shaft)

        % Load
        inputLoad.Time=0:1e-4:0.5;
        inputLoad.Fy=ones(1,length(inputLoad.Time));
        paramsLoad=struct();
        Load=signal.ForceLoad(paramsLoad, inputLoad);
        Load=Load.solve();
        Plot(Load);

        mat{1,1}=Shaft.params.Material;
        inputRotDyn.Shaft=Shaft.output.BeamMesh;
        inputRotDyn.SpeedRange=[0,1000];
        inputRotDyn.MaterialNum=1;
        paramsRotDyn.Material=mat;
        paramsRotDyn.Type=5;
        paramsRotDyn.Solver='Local';
        paramsRotDyn.Rayleigh=[1e-5,10];

        Dyn1 = solve.RotDyn(paramsRotDyn,inputRotDyn);

        Dyn1 = AddBearing(Dyn1,1,[1e-3,1e3,1e3,0,0,0,0,0,0,0]);
        [Dyn1,Num1]= AddCnode(Dyn1,500);
        Dyn1 = AddBearing(Dyn1,Num1,[0,1e3,1e3,0,0,0,0,0,0,0]);

        [Dyn1,Num2]= AddCnode(Dyn1,250);
        Dyn1 = AddTimeSeries(Dyn1,Num2,Load.output.Load);
        load pidTestLUT %#ok<LOAD>
        Dyn1 = AddPIDController(Dyn1,Num2,2e2/70,2e2/70,1/70,'Type',3,'Table',pidTestLUT,'Direction','Uy');
        Dyn1 = AddPIDController(Dyn1,Num2,2e2/70,2e2/70,1/70,'Type',3,'Table',pidTestLUT,'Direction','Uz');
        Dyn1 = AddKeyNode(Dyn1,Num2);
        Dyn1 = Dyn1.solve();

        PlotTimeSeriesResult(Dyn1,'Node',Dyn1.input.KeyNode,'Component',[1;2],'Load',1,'PIDController',1);
    case 20
        % Shaft
        inputshaft1.Length = [94;132;350;376;700];
        inputshaft1.ID = [[0,0];[0,0];[0,0];[0,0];[0,0]];
        inputshaft1.OD = [[8,8];[9.6,9.6];[8,8];[9.6,9.6];[8,8]];
        paramsshaft1.Beam_N = 16;
        paramsshaft1.N_Slice=50;
        Shaft = shaft.Commonshaft(paramsshaft1, inputshaft1);
        Shaft = Shaft.solve();
        Plot3D(Shaft)
        % Load
        inputStruct2.Time=0:1e-3:0.2;
        inputStruct2.Fy=rand(1,length(inputStruct2.Time));
        paramsStruct2=struct();
        Load1=signal.ForceLoad(paramsStruct2, inputStruct2);
        Load1=Load1.solve();
        Plot(Load1);

        Load2=signal.ForceLoad(paramsStruct2, inputStruct2);
        Load2=Load2.solve();
        Plot(Load2);

        mat{1,1}=Shaft.params.Material;
        inputRotDyn.Shaft=Shaft.output.BeamMesh;
        inputRotDyn.SpeedRange=[0,1000];
        inputRotDyn.MaterialNum=1;
        paramsRotDyn.Material=mat;
        paramsRotDyn.Type=5;
        paramsRotDyn.Solver='Local';
        paramsRotDyn.Rayleigh=[1e-5,10];
        % Add disc
        Dyn1 = solve.RotDyn(paramsRotDyn,inputRotDyn);
        [Dyn1,Num1]= AddCnode(Dyn1,113);
        Dyn1=AddPointMass(Dyn1,Num1,0.85074e-3,4.036839e-1,4.840066e-1);
        [Dyn1,Num2]= AddCnode(Dyn1,363);
        Dyn1=AddPointMass(Dyn1,Num2,1.276499e-3,2.83275,1.487212);
        [Dyn1,Num3]= AddCnode(Dyn1,623);
        Dyn1=AddPointMass(Dyn1,Num3,0.8574e-3,4.036839e-1,4.840066e-1);
        % Add Bearing
        Dyn1 = AddBearing(Dyn1,Num1,[1e7,1e7,1e7,0,0,0,0,0,0,0]);
        Dyn1 = AddBearing(Dyn1,Num1,[0,-1e2,-1e2,0,0,0,0,0,0,0]);
        Dyn1 = AddBearing(Dyn1,Num3,[0,-1e2,-1e2,0,0,0,0,0,0,0]);
        % Add PIDController
        Dyn1 = AddPIDController(Dyn1,Num1,5,1.5,5e-3,'Type',1,'Ki',50,'Direction','Uy');
        Dyn1 = AddPIDController(Dyn1,Num1,5,1.5,5e-3,'Type',1,'Ki',50,'Direction','Uz');
        Dyn1 = AddPIDController(Dyn1,Num3,5,1.5,5e-3,'Type',1,'Ki',50,'Direction','Uy');
        Dyn1 = AddPIDController(Dyn1,Num3,5,1.5,5e-3,'Type',1,'Ki',50,'Direction','Uz');
        % Add Timeseries
        Dyn1 = AddTimeSeries(Dyn1,Num1,Load1.output.Load);
        Dyn1 = AddTimeSeries(Dyn1,Num3,Load2.output.Load);
        Dyn1 = Dyn1.solve();

        PlotTimeSeriesResult(Dyn1,'Node',Dyn1.input.KeyNode,'Component',[1;2;3],'Load',[1;2],'PIDController',[1;3]);
    case 21
        % Shaft
        inputshaft1.Length = [35;45;70;200;250;300];
        inputshaft1.ID = [[0,0];[10,10];[10,10];[10,10];[10,10];[10,10]];
        inputshaft1.OD = [[40,40];[70,70];[40,40];[40,40];[40,40];[70,70]];
        paramsshaft1.Beam_N = 16;
        paramsshaft1.N_Slice=201;
        obj1 = shaft.Commonshaft(paramsshaft1, inputshaft1);
        obj1 = obj1.solve();
        Plot3D(obj1)

        mat{1,1}=obj1.params.Material;
        inputRotDyn.Shaft=obj1.output.BeamMesh;
        inputRotDyn.Speed=1000;
        inputRotDyn.SpeedRange=[0,1000];
        inputRotDyn.PointMass=[1,1.2e-3,2.4,1.2;size(obj1.output.Node,1),1e-3,2,1];
        inputRotDyn.MaterialNum=1;
        inputRotDyn.Time=0:1e-4:1;
        inputRotDyn.BalanceQuality=[2.5,3000,0,300,0];
        paramsRotDyn.Material=mat;
        paramsRotDyn.Rayleigh=[1e-5,10];
        % paramsRotDyn.Type=4;
        paramsRotDyn.Type=5;

        Dyn1 = solve.RotDyn(paramsRotDyn,inputRotDyn);

        [Dyn1,Num1]= AddCnode(Dyn1,70);
        Dyn1=AddBearing(Dyn1,Num1,[1e10,8e4,1e5,1e4,6e4,0,8,12,3,3]);

        [Dyn1,Num2]= AddCnode(Dyn1,200);
        Dyn1=AddBearing(Dyn1,Num2,[0,5e4,7e4,2e4,4e4,0,6,8,1.5,1.5]);
        Dyn1 = Dyn1.solve();

        PlotTimeSeriesResult(Dyn1,'Node',Dyn1.input.KeyNode,'Component',[1;2]);
    case 22
        % Shaft
        inputshaft1.Length = 300;
        inputshaft1.ID = [0,0];
        inputshaft1.OD = [40,40];
        paramsshaft1.Beam_N = 16;
        paramsshaft1.N_Slice=5;
        obj1 = shaft.Commonshaft(paramsshaft1, inputshaft1);
        obj1 = obj1.solve();
        Plot3D(obj1)
        % Housing
        inputshaft2.Length = 300;
        inputshaft2.ID = [50,50];
        inputshaft2.OD = [100,100];
        paramsshaft2.Beam_N = 16;
        paramsshaft2.N_Slice=5;
        obj2 = shaft.Commonshaft(paramsshaft2, inputshaft2);
        obj2 = obj2.solve();
        Plot3D(obj2)

        mat{1,1}=obj1.params.Material;
        inputRotDyn.Shaft=obj1.output.BeamMesh;
        inputRotDyn.Housing=obj2.output.BeamMesh;
        inputRotDyn.Speed=0;
        inputRotDyn.MaterialNum=1;
        paramsRotDyn.Material=mat;
        paramsRotDyn.Type=2;
        paramsRotDyn.PrintMode=1;
        paramsRotDyn.PrintCampbell=1;
        % paramsRotDyn.ShaftTorsion=1;
        paramsRotDyn.NMode=5;
        % paramsRotDyn.Solver='ANSYS';
        paramsRotDyn.Solver='Local';

        Dyn1 = solve.RotDyn(paramsRotDyn,inputRotDyn);
        
        Dyn1=AddHousingBearing(Dyn1,1,[1e8,1e8,1e8,0,0,0,0,0,0,0]);
        Dyn1=AddHousingBendingBearing(Dyn1,1,[1e13,1e13,0,0]);
        Dyn1=AddHousingTorBearing(Dyn1,1,[1e13,0]);


        Dyn1=AddBCNode(Dyn1,1,[0,0,0,1,0,0]);
        Dyn1=AddBCNode(Dyn1,6,[0,0,0,1,0,0]);
        Dyn1=AddBearing(Dyn1,2,[1e10,2e4,2e4,0,0,0,0,0,0,0],1);
        Dyn1=AddBearing(Dyn1,4,[0,2e4,2e4,0,0,0,0,0,0,0],1);
        Dyn1 = Dyn1.solve();

        Plot(Dyn1)
        % ANSYSSolve(Dyn1.output.Assembly)
end
end