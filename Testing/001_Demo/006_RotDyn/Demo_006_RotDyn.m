% Demo RotDyn
clc
clear
close all
plotFlag = true;
% setRoTAPath
% 1. Create RotDyn
% 2. Add Discs
% 3. Add Userdefined Disc, output moment of inertia
% 4. Add Blade
% 5. Multi Discs & Calculate critical speed
% 6. Add Elastic Support
% 7. Consider prestress
% 8. Eccentricity of shaft
% 9. High speed rotor example
% 10. High speed rotor Harmonic analysis

flag=1;
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
        inputRotDyn.BCNode=[1,1,1,1,0,0,0;size(obj1.output.Node,1),1,1,1,0,0,0];
        paramsRotDyn.Material=mat;
        paramsRotDyn.PrintCampbell=1;
        paramsRotDyn.PrintORB=1;
        obj2 = solve.RotDyn(paramsRotDyn,inputRotDyn);
        Plot(obj2);
        obj2 = obj2.solve();
        ANSYSSolve(obj2.output.Assembly)

        
       PlotCampbell(obj2,'NMode',8);
       for i=1:10
           PlotORB(obj2,2,i,'scale',10)
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
        [Dyn,Num2]= AddCnode(Dyn,500);

        a1=Point2D('Circle center');
        a1=AddPoint(a1,0,0);
        a1=AddPoint(a1,[-50;50],[0;0]);
        b1=Line2D('Semi circle');
        b1=AddCircle(b1,50,a1,1,'ang',180);
        b1=AddLine(b1,a1,2);
        S1=Surface2D(b1);

        a2=Point2D('Square corner');
        a2=AddPoint(a2,[-100;-100;100;100],[0;50;50;0]);
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
        paramsRotDyn.PrintORB=1;
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
            PlotORB(Dyn,2,i,'scale',100)
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
        Dyn=CalculateCriticalSpeed(Dyn);

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
        paramsRotDyn.PrintORB=1;
        Dyn1 = solve.RotDyn(paramsRotDyn,inputRotDyn);
        Dyn1 = Dyn1.solve();
        Plot(Dyn1);
        ANSYSSolve(Dyn1.output.Assembly);
        Dyn1=PlotCampbell(Dyn1,'NMode',12);
        

        % Elastic support
        mat{1,1}=obj1.params.Material;
        inputRotDyn.Shaft=obj1.output.BeamMesh;
        inputRotDyn.Speed=[0,1000,2000,3000,4000,5000,6000];
        inputRotDyn.MaterialNum=1;
        inputRotDyn.Support=[1,1e8,8e3,3e3,0,0,0,1e-3,2e-4,0,0;size(obj1.output.Node,1),0,8e3,3e3,0,0,0,1e-3,2e-4,0,0];
        paramsRotDyn.Material=mat;
        paramsRotDyn.PrintCampbell=1;
        paramsRotDyn.ShaftTorsion=1;
        paramsRotDyn.PrintORB=1;
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
        % Elastic support
        mat{1,1}=obj1.params.Material;
        inputRotDyn.Shaft=obj1.output.BeamMesh;
        inputRotDyn.Speed=[0,1000,2000,3000,4000,5000,6000];
        inputRotDyn.MaterialNum=1;
        inputRotDyn.Support=[1,1e8,8e3,3e3,0,0,0,1e-3,2e-4,0,0;size(obj1.output.Node,1),0,8e3,3e3,0,0,0,1e-3,2e-4,0,0];
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
        % Rigid Boundary
        mat{1,1}=obj1.params.Material;
        inputRotDyn.Shaft=obj1.output.BeamMesh;
        inputRotDyn.Speed=[0,1000,2000,3000,4000,5000,6000];
        inputRotDyn.MaterialNum=1;
        inputRotDyn.BCNode=[1,1,1,1,1,0,0;size(obj1.output.Node,1),0,1,1,1,0,0];
        paramsRotDyn.Material=mat;
        paramsRotDyn.PrintCampbell=1;
        paramsRotDyn.ShaftTorsion=1;
        paramsRotDyn.PrintORB=1;
        paramsRotDyn.ey=[5,-5];
        Dyn1 = solve.RotDyn(paramsRotDyn,inputRotDyn);
        Dyn1 = Dyn1.solve();
        Plot(Dyn1);
        ANSYSSolve(Dyn1.output.Assembly);
        Dyn1=PlotCampbell(Dyn1,'NMode',12);
        disp(Dyn1.output.Campbell);
    case 9
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
        paramsRotDyn.PrintORB=1;
        Dyn1 = solve.RotDyn(paramsRotDyn,inputRotDyn);

        [Dyn1,Num1]= AddCnode(Dyn1,70);
        Dyn1=AddSupport(Dyn1,Num1,[1e10,8e4,1e5,1e4,6e4,0,0.0001,12/1e5,3/1e4,3/6e4]);

        [Dyn1,Num2]= AddCnode(Dyn1,200);
        Dyn1=AddSupport(Dyn1,Num2,[0,5e4,7e4,2e4,4e4,0,6/5e4,8/7e4,1.5/2e4,1.5/4e4]);
        Dyn1 = Dyn1.solve();

        ANSYSSolve(Dyn1.output.Assembly);
        Dyn1=PlotCampbell(Dyn1,'NMode',6);
        disp(Dyn1.output.Campbell);

        for i=1:6
            PlotORB(Dyn1,2,i,'scale',1)
        end
                Dyn1=CalculateCriticalSpeed(Dyn1);

        disp(Dyn1.output.CriticalSpeed);
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
        inputRotDyn.UnBalanceForce=[1,0.5e-6;size(obj1.output.Node,1),0.5e-6];
        inputRotDyn.MaterialNum=1;
        paramsRotDyn.Material=mat;
        paramsRotDyn.Type=3;

        Dyn1 = solve.RotDyn(paramsRotDyn,inputRotDyn);

        [Dyn1,Num1]= AddCnode(Dyn1,70);
        Dyn1=AddSupport(Dyn1,Num1,[1e10,8e4,1e5,1e4,6e4,0,0.0001,12/1e5,3/1e4,3/6e4]);

        [Dyn1,Num2]= AddCnode(Dyn1,200);
        Dyn1=AddSupport(Dyn1,Num2,[0,5e4,7e4,2e4,4e4,0,6/5e4,8/7e4,1.5/2e4,1.5/4e4]);
        Dyn1 = Dyn1.solve();

        ANSYSSolve(Dyn1.output.Assembly);
        Dyn1=PlotSpeedup(Dyn1);

end
end