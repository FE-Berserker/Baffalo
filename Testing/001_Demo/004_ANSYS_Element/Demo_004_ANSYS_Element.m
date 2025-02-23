% Test ANSYS_Element
clc
clear
close all
plotFlag = true;
Cal=1;
flag=4;
% setRoTAPath
% 1. Link1 Static analysis of plane trusses
% 2. Link1 Elasto-plastic analysis of plane trusses
% 3. Link1 Two-force bar truss buckling analysis
% 4. Link8 Hexagonal Dome analysis
% 5. Link10 Force analysis of the cable in equilibrium state
% 6. Link10 Rod structure with gaps
% 7. Link180 Rod structure with initial stress
% 8. Beam3 Static analysis of multi-span beams
% 9. Beam3 Semicircular Hingeless Arch
% 10. Beam4 45° curve beam
% 11. Beam23 Plastic analysis of single-story frame
% 12. Beam24 Cross-section cantilever beam
% 13. Beam24 biaxially symmetrical I-beam rigid frame
% 14. Beam44 Stress analysis of simply supported beam with Z-shaped section
% 15. Beam54 Three-span continuous beam with variable section
% 16. Beam188 I-shaped section cantilever beam
% 17. Pipe16 Static calculation of cantilever tube
% 18. Pipe20 Steel pipe plastic analysis
% 19. Plane42 Variable section beam
% 20. Plane42 Plate with hole
% 21. Plane82 Flat bar with shoulder fillets
% 22. Plane182 Variable section beam
% 23. Plane183 Flat bar with shoulder fillets
% 24. Solid45 Variable solid beam
% 25. Solid95 Rotating part
% 26. Solid185 Ellipse beam
% 27. Solid186 Variable solid beam
% 28. Solid187 Cylinder Beam
% 29. Shell63 Plate under pressure
% 30. Shell93 Cylindrical shell
% 31. Shell181 Shell section
% 32. Shell281 Shell section
% 33. Con173 Glue contact

DemoANSYSElement(flag,Cal);
function DemoANSYSElement(flag,Cal)
switch flag
    case 1
        % Create geometry
        a=Point2D('Point');
        a=AddPoint(a,[-4;-2],[0;0]);
        a=AddPoint(a,[-2;0],[0;0]);
        a=AddPoint(a,[0;2],[0;0]);
        a=AddPoint(a,[2;4],[0;0]);
        a=AddPoint(a,[-4;-2],[0;1]);
        a=AddPoint(a,[-2;-2],[0;1]);
        a=AddPoint(a,[-2;0],[1;0]);
        a=AddPoint(a,[0;2],[0;1]);
        a=AddPoint(a,[2;2],[0;1]);
        a=AddPoint(a,[2;4],[1;0]);
        a=AddPoint(a,[-2;0],[1;2]);
        a=AddPoint(a,[2;0],[1;2]);
        a=AddPoint(a,[0;0],[2;0]);
        b=Line2D('Plane Truss');
        for i=1:13
            b=AddLine(b,a,i);
        end
        Plot(b,'equal',1);
        b=Meshoutput(b);
        % Add assembly
        Ass=Assembly('Plane_Truss1');
        pos=[0,0,0,0,0,0];
        Ass=AddPart(Ass,b.Meshoutput,'position',pos);
        % Load
        Ass=AddLoad(Ass,1,'No',1);
        Ass=AddLoad(Ass,1,'No',6);
        Ass=AddLoad(Ass,1,'No',8);
        Load1=[0,-1e4,0,0,0,0];
        Load2=[0,-2e4,0,0,0,0];
        Ass=SetLoad(Ass,1,Load1);
        Ass=SetLoad(Ass,2,Load2);
        Ass=SetLoad(Ass,3,Load1);
        % Boundary
        Ass=AddBoundary(Ass,1,'No',1);
        Ass=AddBoundary(Ass,1,'No',5);
        Bound1=[1,1,0,0,0,0];
        Bound2=[0,1,0,0,0,0];
        Ass=SetBoundaryType(Ass,1,Bound1);
        Ass=SetBoundaryType(Ass,2,Bound2);
        % Material
        mat.Name='Wood';
        mat.table=["EX",8500;"PRXY",0.2];
        Ass=AddMaterial(Ass,mat);
        Ass=SetMaterial(Ass,1,1);
        % Element type
        ET.name='1';
        ET.opt=[];
        ET.R=14400;
        Ass=AddET(Ass,ET);
        Ass=SetET(Ass,1,1);
        Plot(Ass,'View',[0,90],...
            'boundary',1,...
            'load',1,...
            'load_scale',0.2);
        % Static analysis
        opt.ANTYPE=0;
        Ass=AddSolu(Ass,opt);
        % Add sensor
        Ass=AddSensor(Ass,'U',1);
        Ass=AddSensor(Ass,'Etable','SMISC',...
            'TableNum',1,...
            'Part',1);
        % Output to ANSYS
        ANSYS_Output(Ass);
        if Cal
            ANSYSSolve(Ass);
            PlotSensor(Ass,1);
            PlotSensor(Ass,2);
        end
    case 2
        % Create geometry
        a=Point2D('Point');
        a=AddPoint(a,[-2500*tan(pi/6);0],[0;-2500]);
        a=AddPoint(a,[0;0],[0;-2500]);
        a=AddPoint(a,[2500*tan(pi/6);0],[0;-2500]);
        b=Line2D('Plane Truss');
        for i=1:3
            b=AddLine(b,a,i);
        end
        Plot(b,'equal',1);
        b=Meshoutput(b);
        % Add assembly
        Ass=Assembly('Plane_Truss2');
        pos=[0,0,0,0,0,0];
        Ass=AddPart(Ass,b.Meshoutput,'position',pos);
        % Load
        Ass=AddLoad(Ass,1,'No',2);
        Load1=[0,-3e4,0,0,0,0];
        Ass=SetLoad(Ass,1,Load1);
        % Boundary
        Ass=AddBoundary(Ass,1,'No',1);
        Ass=AddBoundary(Ass,1,'No',3);
        Ass=AddBoundary(Ass,1,'No',4);
        Bound1=[1,1,0,0,0,0];
        Ass=SetBoundaryType(Ass,1,Bound1);
        Ass=SetBoundaryType(Ass,2,Bound1);
        Ass=SetBoundaryType(Ass,3,Bound1);
        Plot(Ass,'boundary',1,...
            'load',1,...
            'load_scale',0.2,'View',[0,90]);
        % Material
        mat.Name='Steel';
        mat.table=["EX",210000;"PRXY",0.3];
        mat.TBlab="BKIN";
        mat.TBtable="235";% yield strength
        Ass=AddMaterial(Ass,mat);
        Ass=SetMaterial(Ass,1,1);
        % Element type
        ET.name='1';
        ET.opt=[];
        ET.R=50;
        Ass=AddET(Ass,ET);
        Ass=SetET(Ass,1,1);
        % Static analysis
        opt.ANTYPE=0;
        Ass=AddSolu(Ass,opt);
        % Add sensor
        Ass=AddSensor(Ass,'U',1);
        Ass=AddSensor(Ass,'Etable','LS',...
            'TableNum',1,...
            'Part',1);
        % Output to ANSYS
        ANSYS_Output(Ass);
        if Cal
            ANSYSSolve(Ass);
            PlotSensor(Ass,1);
            PlotSensor(Ass,2);
        end
    case 3
        % Create geometry
        a=Point2D('Point');
        a=AddPoint(a,[-1000*cos(pi/9);0],[0;1000*sin(pi/9)]);
        a=AddPoint(a,[0;1000*cos(pi/9)],[1000*sin(pi/9);0]);
        b=Line2D('Two-force Truss');
        for i=1:2
            b=AddLine(b,a,i);
        end
        Plot(b,'equal',1);
        b=Meshoutput(b);
        % Add assembly
        Ass=Assembly('Two-force_Truss');
        pos=[0,0,0,0,0,0];
        Ass=AddPart(Ass,b.Meshoutput,'position',pos);
        % Load
        Ass=AddLoad(Ass,1,'No',2);
        Load1=[0,-2e5,0,0,0,0];
        Ass=SetLoad(Ass,1,Load1);
        % Boundary
        Ass=AddBoundary(Ass,1,'No',1);
        Ass=AddBoundary(Ass,1,'No',3);
        Bound1=[1,1,0,0,0,0];
        Ass=SetBoundaryType(Ass,1,Bound1);
        Ass=SetBoundaryType(Ass,2,Bound1);
        Plot(Ass,'boundary',1,...
            'load',1,...
            'load_scale',0.001,...
            'View',[0,90]);
        % Material
        mat.Name='Steel';
        mat.table=["EX",210000;"PRXY",0.3];
        Ass=AddMaterial(Ass,mat);
        Ass=SetMaterial(Ass,1,1);
        % Element type
        ET.name='1';
        ET.opt=[];
        ET.R=50;
        Ass=AddET(Ass,ET);
        Ass=SetET(Ass,1,1);
        % Static analysis
        opt.ANTYPE=0;
        Ass=AddSolu(Ass,opt);
        % Add sensor
        Ass=AddSensor(Ass,'U',1);
        % Output to ANSYS
        ANSYS_Output(Ass);
        if Cal
            ANSYSSolve(Ass)
            PlotSensor(Ass,1)
        end
    case 4
        % Create points
        theta1=linspace(60,360,6);
        theta2=linspace(30,330,6);
        a1=Point2D('Point1');
        a2=Point2D('Point2');
        a3=Point2D('Point3');
        a1=AddPoint(a1,500*ones(6,1),theta1','polar','deg');
        a2=AddPoint(a2,250*ones(6,1),theta2','polar','deg');
        a3=AddPoint(a3,0,0);
        % Create lines
        l=Layer('frame');
        pos2=[0,0,62.16,0,0,0];
        pos3=[0,0,82.16,0,0,0];
        l=AddElement(l,a1);
        l=AddElement(l,a2,'Transform',pos2);
        l=AddElement(l,a3,'Transform',pos3);
        Plot(l);
        l=ConnectPoints(l,1,2,[(1:6)';(1:6)'],[(1:6)';(2:6)';1]);
        l=ConnectPoints(l,2,2,(1:6)',[(2:6)';1]);
        l=ConnectPoints(l,2,3,(1:6)',ones(6,1));
        Plot(l);
        l=Meshoutput(l);
        % Add assembly
        Ass=Assembly('Hexagonal_Dome');
        pos=[0,0,0,0,0,0];
        Ass=AddPart(Ass,l.Meshoutput{1,1},...
            'position',pos);
        % Load
        Ass=AddLoad(Ass,1,'No',13);
        Load1=[0,0,-750,0,0,0];
        Ass=SetLoad(Ass,1,Load1);
        % Boundary
        Ass=AddBoundary(Ass,1,'locz',0);
        Bound1=[1,1,1,0,0,0];
        Ass=SetBoundaryType(Ass,1,Bound1);
        % Material
        mat.table=["EX",3030;"PRXY",0.3];
        Ass=AddMaterial(Ass,mat);
        Ass=SetMaterial(Ass,1,1);
        % Element type
        ET.name='8';
        ET.opt=[];
        ET.R=317;
        Ass=AddET(Ass,ET);
        Ass=SetET(Ass,1,1);
        Plot(Ass,'boundary',1,'load',1,'load_scale',0.1);
        % Static analysis
        opt.ANTYPE=0;
        Ass=AddSolu(Ass,opt);
        % Add sensor
        Ass=AddSensor(Ass,'U',1);
        % Output to ANSYS
        ANSYS_Output(Ass);
        if Cal
            ANSYSSolve(Ass);
            PlotSensor(Ass,1);
        end
    case 5
        % Create points
        x=[0 6 9 13.5 18];
        y=[0 -1.9285 -1.8213 1.5537 6];
        a=Point2D('Point');
        a=AddPoint(a,x',y');
        % Create lines
        b=Line2D('Line');
        b=AddCurve(b,a,1);
        Plot(b,'equal',1,'grid',1)
        b=Meshoutput(b);
        % Add assembly
        Ass=Assembly('Cable');
        pos=[0,0,0,0,0,0];
        Ass=AddPart(Ass,b.Meshoutput,'position',pos);
        % Load
        Ass=AddLoad(Ass,1,'No',2);
        Ass=AddLoad(Ass,1,'No',3);
        Ass=AddLoad(Ass,1,'No',4);
        Load1=[0,-3e4,0,0,0,0];
        Load2=[0,-6e4,0,0,0,0];
        Load3=[0,-2e4,0,0,0,0];
        Ass=SetLoad(Ass,1,Load1);
        Ass=SetLoad(Ass,2,Load2);
        Ass=SetLoad(Ass,3,Load3);
        % Boundary
        Ass=AddBoundary(Ass,1,'No',1);
        Ass=AddBoundary(Ass,1,'No',5);
        Bound1=[1,1,1,0,0,0];
        Ass=SetBoundaryType(Ass,1,Bound1);
        Ass=SetBoundaryType(Ass,2,Bound1);
        % Material
        mat.table=["EX",1.95e11*1e5;"PRXY",0.3];
        Ass=AddMaterial(Ass,mat);
        Ass=SetMaterial(Ass,1,1);
        % Element type
        ET.name='10';
        ET.opt=[];
        ET.R=[140e-6,1e6/(1.95e11*1e5)];
        Ass=AddET(Ass,ET);
        Ass=SetET(Ass,1,1);
        % Static analysis
        opt.ANTYPE=0;
        opt.NLGEOM=1;% Nolinear analysis
        Ass=AddSolu(Ass,opt);
        % Add sensor
        Ass=AddSensor(Ass,'U',1);
        Ass=AddSensor(Ass,'Etable','LS',...
            'TableNum',1,...
            'Part',1);
        % Output to ANSYS
        ANSYS_Output(Ass);
        Plot(Ass,'boundary',1,...
            'load',1,'load_scale',0.1,...
            'view',[0,90]);

        if Cal
            ANSYSSolve(Ass);
            PlotSensor(Ass,1);
            PlotSensor(Ass,2);
        end
    case 6
        % Create points
        a1=Point2D('Point1');
        a1=AddPoint(a1,[-1500;0],[0;2000]);
        a1=AddPoint(a1,[0;1500],[2000;0]);
        a2=Point2D('Point2');
        a2=AddPoint(a2,[0;0],[2000;0]);
        % Create lines
        b1=Line2D('Line1');
        b1=AddLine(b1,a1,1);
        b1=AddLine(b1,a1,2);
        b2=Line2D('Line2');
        b2=AddLine(b2,a2,1);
        l=Layer('Layer');
        l=AddElement(l,b1);
        l=AddElement(l,b2);
        Plot(l,'view',[0,90]);
        l=Meshoutput(l);
        % Add assembly
        Ass=Assembly('Rod_structure_with_gaps');
        pos=[0,0,0,0,0,0];
        Ass=AddPart(Ass,l.Meshoutput{1,1},'position',pos);
        % Load
        Ass=AddLoad(Ass,1,'No',2);
        Load1=[0,-20480,0,0,0,0];
        Ass=SetLoad(Ass,1,Load1);
        % Boundary
        Ass=AddBoundary(Ass,1,'No',1);
        Ass=AddBoundary(Ass,1,'No',4);
        Ass=AddBoundary(Ass,1,'No',3);
        Bound1=[1,1,1,0,0,0];
        Ass=SetBoundaryType(Ass,1,Bound1);
        Ass=SetBoundaryType(Ass,2,Bound1);
        Ass=SetBoundaryType(Ass,3,Bound1);
        % Material
        mat.table=["EX",1.2e5;"PRXY",0.3];
        Ass=AddMaterial(Ass,mat);
        Ass=SetMaterial(Ass,1,1);
        % Divide part
        Ass=DividePart(Ass,1,l.Matrix{1,1});
        % Element type
        ET1.name='8';
        ET1.opt=[];
        ET1.R=200;
        ET2.name='10';
        ET2.opt=[3,1];
        ET2.R=[200,1/2000];
        AddET(Ass,ET1);
        AddET(Ass,ET2);
        SetET(Ass,1,1);
        SetET(Ass,2,2);
        Plot(Ass,'boundary',1,...
            'load',1,'load_scale',0.05,...
            'view',[0,90]);
        % Static analysis
        opt.ANTYPE=0;
        Ass=AddSolu(Ass,opt);
        % Add sensor
        Ass=AddSensor(Ass,'U',1);
        % Output to ANSYS
        ANSYS_Output(Ass);
        if Cal
            ANSYSSolve(Ass);
            PlotSensor(Ass,1);
        end
    case 7
        % Create points
        a1=Point2D('Point1');
        a1=AddPoint(a1,[-1000;0],[0;2000]);
        a1=AddPoint(a1,[0;1000],[2000;0]);
        a2=Point2D('Point2');
        a2=AddPoint(a2,[0;0],[2000;0]);
        % Create lines
        b1=Line2D('Line1');
        b1=AddLine(b1,a1,1);
        b1=AddLine(b1,a1,2);
        b2=Line2D('Line2');
        b2=AddLine(b2,a2,1);
        l=Layer('Layer');
        l=AddElement(l,b1);
        l=AddElement(l,b2);
        Plot(l,'view',[0,90]);
        l=Meshoutput(l);
        % Add assembly
        Ass=Assembly('Rod_structure_with_initial_stress');
        pos=[0,0,0,0,0,0];
        Ass=AddPart(Ass,l.Meshoutput{1,1},'position',pos);
        % Boundary
        Ass=AddBoundary(Ass,1,'No',1);
        Ass=AddBoundary(Ass,1,'No',4);
        Ass=AddBoundary(Ass,1,'No',3);
        Ass=AddBoundary(Ass,1,'No',2);
        Bound1=[1,1,1,0,0,0];
        Bound2=[0,0,1,0,0,0];
        Ass=SetBoundaryType(Ass,1,Bound1);
        Ass=SetBoundaryType(Ass,2,Bound1);
        Ass=SetBoundaryType(Ass,3,Bound1);
        Ass=SetBoundaryType(Ass,4,Bound2);
        % Material
        mat.table=["EX",1.2e5;"PRXY",0.3];
        Ass=AddMaterial(Ass,mat);
        Ass=SetMaterial(Ass,1,1);
        % Element type
        ET1.name='180';
        ET1.opt=[];
        ET1.R=10;
        Ass=AddET(Ass,ET1);
        Ass=SetET(Ass,1,1);
        Plot(Ass,'boundary',1,...
            'load',1,'load_scale',0.05,...
            'view',[0,90]);
        % Intial Stress
        Ass=AddIStress(Ass,1,100,'element',2);
        % Static analysis
        opt.ANTYPE=0;
        Ass=AddSolu(Ass,opt);
        % Add sensor
        Ass=AddSensor(Ass,'U',1);
        % Output to ANSYS
        ANSYS_Output(Ass);
        if Cal
            ANSYSSolve(Ass);
            PlotSensor(Ass,1);
        end
    case 8
        % Create points
        a=Point2D('Point1');
        a=AddPoint(a,(0:500:22000)',zeros(45,1));
        % Creat lines
        b=Line2D('Line1');
        b=AddCurve(b,a,1);
        b=Meshoutput(b);
        % Add assembly
        Ass=Assembly('Multi-span_beams');
        pos=[0,0,0,0,0,0];
        Ass=AddPart(Ass,b.Meshoutput,'position',pos);
        % Boundary
        Ass=AddBoundary(Ass,1,'No',1);
        Ass=AddBoundary(Ass,1,'No',9);
        Ass=AddBoundary(Ass,1,'No',21);
        Ass=AddBoundary(Ass,1,'No',33);
        Ass=AddBoundary(Ass,1,'No',41);
        Bound1=[1,1,0,0,0,0];
        Bound2=[0,1,0,0,0,0];
        Ass=SetBoundaryType(Ass,1,Bound1);
        Ass=SetBoundaryType(Ass,2,Bound2);
        Ass=SetBoundaryType(Ass,3,Bound2);
        Ass=SetBoundaryType(Ass,4,Bound2);
        Ass=SetBoundaryType(Ass,5,Bound2);
        % Material
        mat.table=["EX",2.1e5;"PRXY",0.3];
        Ass=AddMaterial(Ass,mat);
        Ass=SetMaterial(Ass,1,1);
        % Element type
        ET1.name='3';
        ET1.opt=[];
        ET1.R=[4000,1e6,20];
        Ass=AddET(Ass,ET1);
        Ass=SetET(Ass,1,1);
        % Add load
        Ass=AddLoad(Ass,1,'No',13);
        Ass=AddLoad(Ass,1,'No',17);
        Ass=AddLoad(Ass,1,'No',45);
        Load1=[0,-3e4,0,0,0,0];
        Load2=[0,-2e4,0,0,0,0];
        Ass=SetLoad(Ass,1,Load1);
        Ass=SetLoad(Ass,2,Load1);
        Ass=SetLoad(Ass,3,Load2);
        % Add SF
        Ass=AddSF(Ass,1,(21:32)');
        value=[1,20,20];
        Ass=SetSF(Ass,1,value);
        Plot(Ass,'boundary',1,'load',1,'load_scale',1);
        % Static analysis
        opt.ANTYPE=0;
        Ass=AddSolu(Ass,opt);
        % Add sensor
        Ass=AddSensor(Ass,'U',1);
        % Output to ANSYS
        ANSYS_Output(Ass);
        if Cal
            ANSYSSolve(Ass);
            PlotSensor(Ass,1);
        end
    case 9
        % Create points
        a=Point2D('Point1');
        a=AddPoint(a,0,0);
        % Create lines
        b=Line2D('Line1');
        b=AddCircle(b,1000,a,1,'ang',180,'seg',50);
        Plot(b);
        b=Meshoutput(b);
        % Add assembly
        Ass=Assembly('Semicircular_Hingeless_Arch');
        pos=[0,0,0,0,0,0];
        Ass=AddPart(Ass,b.Meshoutput,'position',pos);
        % Boundary
        Ass=AddBoundary(Ass,1,'No',1);
        Ass=AddBoundary(Ass,1,'No',50+1);
        Bound1=[1,1,1,1,1,1];
        Ass=SetBoundaryType(Ass,1,Bound1);
        Ass=SetBoundaryType(Ass,2,Bound1);
        % Material
        mat.table=["EX",2.1e5;"PRXY",0.3];
        Ass=AddMaterial(Ass,mat);
        Ass=SetMaterial(Ass,1,1);
        % Element type
        ET1.name='3';
        ET1.opt=[];
        ET1.R=[100,10^4/12,10,1.2];
        Ass=AddET(Ass,ET1);
        Ass=SetET(Ass,1,1);
        % Add load
        Ass=AddLoad(Ass,1,'No',26);
        Load1=[0,-100,0,0,0,0];
        Ass=SetLoad(Ass,1,Load1);
        Plot(Ass,'boundary',1,...
            'load',1,'load_scale',1,...
            'view',[0,90]);
        % Static analysis
        opt.ANTYPE=0;
        Ass=AddSolu(Ass,opt);
        % Add sensor
        Ass=AddSensor(Ass,'U',1);
        % Output to ANSYS
        ANSYS_Output(Ass);
        if Cal
            ANSYSSolve(Ass);
            PlotSensor(Ass,1);
        end
    case 10
        % Create points
        a=Point2D('Point1');
        AddPoint(a,100,0);
        % Create lines
        b=Line2D('Line1');
        b=AddCircle(b,100,a,1,'sang',180,'ang',-45,'seg',10);
        Plot(b);
        b=Meshoutput(b);
        % Add assembly
        Ass=Assembly('Curve_Beam');
        pos=[0,0,0,-90,0,0];
        Ass=AddPart(Ass,b.Meshoutput,'position',pos);
        % Boundary
        Ass=AddBoundary(Ass,1,'No',1);
        Bound1=[1,1,1,1,1,1];
        Ass=SetBoundaryType(Ass,1,Bound1);
        % Material
        mat.table=["EX",1.1e7;"GXY",1.5e6];
        Ass=AddMaterial(Ass,mat);
        Ass=SetMaterial(Ass,1,1);
        % Element type
        ET1.name='4';
        ET1.opt=[];
        ET1.R=[1,1/12,1/12,1,1];
        Ass=AddET(Ass,ET1);
        Ass=SetET(Ass,1,1);
        % Load
        Ass=AddLoad(Ass,1,'No',11);
        Load1=[0,0,-300,0,0,0];
        Ass=SetLoad(Ass,1,Load1);
        Plot(Ass,'boundary',1,'load',1,'load_scale',0.1);
        % Static analysis
        opt.ANTYPE=0;
        Ass=AddSolu(Ass,opt);
        % Add sensor
        Ass=AddSensor(Ass,'U',1);
        % Output to ANSYS
        ANSYS_Output(Ass);
        if Cal
            ANSYSSolve(Ass);
            PlotSensor(Ass,1);
        end
    case 11
        % Create points
        a=Point2D('Point1');
        a=AddPoint(a,zeros(21,1),(0:100:2000)');
        a=AddPoint(a,(0:100:3000)',2000*ones(31,1));
        a=AddPoint(a,3000*ones(21,1),(2000:-100:0)');
        % Create lines
        b=Line2D('Line1');
        b=AddCurve(b,a,1);
        b=AddCurve(b,a,2);
        b=AddCurve(b,a,3);
        Plot(b);
        b=Meshoutput(b);
        % Add assembly
        Ass=Assembly('Single_story_Beam');
        pos=[0,0,0,0,0,0];
        Ass=AddPart(Ass,b.Meshoutput,'position',pos);
        % Boundary
        Ass=AddBoundary(Ass,1,'No',1);
        Ass=AddBoundary(Ass,1,'No',71);
        Bound1=[1,1,1,1,1,1];
        Ass=SetBoundaryType(Ass,1,Bound1);
        Ass=SetBoundaryType(Ass,2,Bound1);
        % Material
        mat.table=["EX",2.1e5;"PRXY",0.3];
        mat.TBlab="BISO";
        mat.TBtable=[345,0];
        Ass=AddMaterial(Ass,mat);
        Ass=SetMaterial(Ass,1,1);
        % Element type
        ET1.name='23';
        ET1.opt=[];
        ET1.R=[6000,50*120^3/12,120];
        Ass=AddET(Ass,ET1);
        Ass=SetET(Ass,1,1);
        % Add SF
        Ass=AddSF(Ass,1,(21:70)');
        value1=[1,80];
        Ass=SetSF(Ass,1,value1);
        Plot(Ass,'boundary',1,...
            'load',1,...
            'load_scale',1,...
            'view',[0,90]);
        % Static analysis
        opt.ANTYPE=0;
        Ass=AddSolu(Ass,opt);
        % Output to ANSYS
        ANSYS_Output(Ass);
        if Cal
            ANSYSSolve(Ass);
        end
    case 12
        % Creat points
        a=Point2D('Point1');
        a=AddPoint(a,(0:200:2000)',zeros(11,1));
        % Creat lines
        b=Line2D('Line1');
        b=AddCurve(b,a,1);
        b=Meshoutput(b);
        % Add assembly
        Ass=Assembly('Cross-section_cantilever_beam');
        pos=[0,0,0,0,0,0];
        Ass=AddPart(Ass,b.Meshoutput,'position',pos);
        % Boundary
        Ass=AddBoundary(Ass,1,'No',1);
        Bound1=[1,1,1,1,1,1];
        Ass=SetBoundaryType(Ass,1,Bound1);
        % Material
        mat.table=["EX",2.1e5;"PRXY",0.3];
        Ass=AddMaterial(Ass,mat);
        Ass=SetMaterial(Ass,1,1);
        % Element type
        ET1.name='24';
        ET1.opt=[1,1;3,1;6,1];
        ET1.R=[0,0,0,0,112,20,-60,112,16,0,112,0,0,200,20,0,112,0,140,112,16];
        Ass=BeamK(Ass,1);
        Ass=AddET(Ass,ET1);
        Ass=SetET(Ass,1,1);
        % Add load
        Ass=AddLoad(Ass,1,'No',11);
        Load1=[0,-1e4,0,0,0,0];
        Ass=SetLoad(Ass,1,Load1);
        Plot(Ass,'boundary',1,'load',1,'load_scale',1);
        % Static analysis
        opt.ANTYPE=0;
        Ass=AddSolu(Ass,opt);
        % Add sensor
        Ass=AddSensor(Ass,'U',1);
        % Output to ANSYS
        ANSYS_Output(Ass);
        if Cal
            ANSYSSolve(Ass);
            PlotSensor(Ass,1);
        end
    case 13
        % Create points
        a=Point2D('Point1');
        a=AddPoint(a,zeros(11,1),(0:300:3000)');
        a=AddPoint(a,(0:300:3000)',3000*ones(11,1));
        a=AddPoint(a,3000*ones(11,1),(0:300:3000)');
        % Creat lines
        b1=Line2D('Line1');
        b1=AddCurve(b1,a,1);
        b1=AddCurve(b1,a,2);
        b1=AddCurve(b1,a,3);
        b1=Meshoutput(b1);
        % Add assembly
        Ass=Assembly('biaxially_symmetrical_frame');
        pos=[0,0,0,-90,0,0];
        Ass=AddPart(Ass,b1.Meshoutput,'position',pos);
        % Boundary
        Ass=AddBoundary(Ass,1,'No',1);
        Ass=AddBoundary(Ass,1,'No',22);
        Bound1=[1,1,1,1,1,1];
        Ass=SetBoundaryType(Ass,1,Bound1);
        Ass=SetBoundaryType(Ass,2,Bound1);
        % Material
        mat.table=["EX",2.1e5;"PRXY",0.3];
        Ass=AddMaterial(Ass,mat);
        Ass=SetMaterial(Ass,1,1);
        % Add load
        Ass=AddLoad(Ass,1,'No',11);
        Load1=[50000,0,0,0,0,0];
        Ass=SetLoad(Ass,1,Load1);
        % Element type
        ET1.name='24';
        ET1.opt=[];
        ET1.R=[-92,142,0,92,142,20,92,-142,20,-92,-142,20,-92,142,20];
        ET2.name='24';
        ET2.opt=[];
        ET2.R=[-140,-100,0,-140,100,20,-140,0,0,140,0,16,140,100,0,140,-100,20];
        Ass=BeamK(Ass,1);
        Ass=AddET(Ass,ET1);
        Ass=AddET(Ass,ET2);
        % Divide part
        Matrix{1,1}=(1:10)';
        Matrix{2,1}=(11:20)';
        Matrix{3,1}=(21:30)';
        Ass=DividePart(Ass,1,Matrix);
        Ass=SetET(Ass,1,2);
        Ass=SetET(Ass,2,1);
        Ass=SetET(Ass,3,2);
        % Add SF
        Ass=AddSF(Ass,2,(1:10)');
        value1=[1,300];
        Ass=SetSF(Ass,1,value1);
        Plot(Ass,'boundary',1,...
            'load',1,'load_scale',0.01,...
            'zlim',[0,3000]);
        % Static analysis
        opt.ANTYPE=0;
        Ass=AddSolu(Ass,opt);
        % Add sensor
        Ass=AddSensor(Ass,'U',1);
        % Output to ANSYS
        ANSYS_Output(Ass);
        if Cal
            ANSYSSolve(Ass);
            PlotSensor(Ass,1);
        end
    case 14
        % Create points
        a=Point2D('Point1');
        a=AddPoint(a,(0:200:2400)',zeros(13,1));
        % Create lines
        b=Line2D('Line1');
        b=AddCurve(b,a,1);
        b=Meshoutput(b);
        % Add assembly
        Ass=Assembly('Z-shaped_section_beam');
        pos=[0,0,0,0,0,0];
        Ass=AddPart(Ass,b.Meshoutput,'position',pos);
        % Boundary
        Ass=AddBoundary(Ass,1,'No',1);
        Ass=AddBoundary(Ass,1,'No',13);
        Bound1=[1,1,1,1,0,0];
        Bound2=[0,1,1,1,0,0];
        Ass=SetBoundaryType(Ass,1,Bound1);
        Ass=SetBoundaryType(Ass,2,Bound2);
        % Material
        mat.table=["EX",2.06e5;"PRXY",0.3];
        Ass=AddMaterial(Ass,mat);
        Ass=SetMaterial(Ass,1,1);
        % Element type
        ET1.name='44';
        ET1.opt=[];
        ET1.R=[];
        Ass=BeamK(Ass,1);
        Ass=AddET(Ass,ET1);
        Ass=SetET(Ass,1,1);
        % Section
        Sec.type="beam";
        Sec.subtype="Z";
        Sec.data=[35,35,50,5,5,5];
        Ass=AddSection(Ass,Sec);
        Ass=SetSection(Ass,1,1);
        % Add load
        Ass=AddLoad(Ass,1,'No',5);
        Load1=[0,0,880,0,0,0];
        Ass=SetLoad(Ass,1,Load1);
        Plot(Ass,'boundary',1,'load',1,'load_scale',0.1,'BeamGeom',1,'ylim',[-40,40]);
        % Static analysis
        opt.ANTYPE=0;
        Ass=AddSolu(Ass,opt);
        % Add sensor
        Ass=AddSensor(Ass,'U',1);
        % Output to ANSYS
        ANSYS_Output(Ass);
        if Cal
            ANSYSSolve(Ass);
            PlotSensor(Ass,1);
        end
    case 15
        % Create points
        a=Point2D('Point1');
        a=AddPoint(a,(0:1:200)',zeros(201,1));
        % Create lines
        b=Line2D('Line1');
        b=AddCurve(b,a,1);
        Plot(b);
        b=Meshoutput(b);
        % Add assembly
        Ass=Assembly('Variable_section_beam');
        pos=[0,0,0,0,0,0];
        Ass=AddPart(Ass,b.Meshoutput,'position',pos);
        % Boundary
        Ass=AddBoundary(Ass,1,'No',1);
        Ass=AddBoundary(Ass,1,'No',61);
        Ass=AddBoundary(Ass,1,'No',141);
        Ass=AddBoundary(Ass,1,'No',201);
        Bound1=[1,1,0,0,0,0];
        Bound2=[0,1,0,0,0,0];
        Ass=SetBoundaryType(Ass,1,Bound2);
        Ass=SetBoundaryType(Ass,2,Bound1);
        Ass=SetBoundaryType(Ass,3,Bound2);
        Ass=SetBoundaryType(Ass,4,Bound2);
        % Material
        mat.table=["EX",3.5e10;"PRXY",0.2];
        Ass=AddMaterial(Ass,mat);
        Ass=SetMaterial(Ass,1,1);
        % Add load
        Ass=AddLoad(Ass,1,'No',(1:201)');
        Load1=[0,-1,0,0,0,0];
        Ass=SetLoad(Ass,1,Load1);
        % Divide part
        Temp=1:200;
        Matrix=num2cell(Temp');
        Ass=DividePart(Ass,1,Matrix);
        % Element type
        b=2;
        h1=2:2/60:4-2/60;
        h2=4:-2/40:2+2/40;
        h3=2:2/40:4-2/40;
        h4=4:-2/60:2+2/60;
        H1=[h1 h2 h3 h4];
        H2=[H1(2:end),2];
        Area1=H1.*b;
        Area2=H2.*b;
        Iz1=b.*H1.^3/12;
        Iz2=b.*H2.^3/12;
        Hyt1=H1/2;
        Hyt2=H2/2;
        Hyb1=H1/2;
        Hyb2=H2/2;
        Dy1=-H1/2+1;
        Dy2=-H2/2+1;
        for i=1:200
            ET.name='54';
            ET.opt=[];
            ET.R=[Area1(i),Iz1(i),Hyt1(i),Hyb1(i),...
                Area2(i),Iz2(i),Hyt2(i),Hyb2(i),...
                0,Dy1(i),0,Dy2(i)];
            Ass=AddET(Ass,ET);
            Ass=SetET(Ass,i,i);
        end
        Plot(Ass,'boundary',1,'load',1,'load_scale',0.1);
        % Static analysis
        opt.ANTYPE=0;
        Ass=AddSolu(Ass,opt);
        % Add sensor
        Ass=AddSensor(Ass,'U',1);
        % Output to ANSYS
        ANSYS_Output(Ass);
        if Cal
            ANSYSSolve(Ass);
            PlotSensor(Ass,1);
        end
    case 16
        % Create points
        a=Point2D('Point1');
        a=AddPoint(a,(0:100:2000)',zeros(21,1));
        % Create lines
        b=Line2D('Line1');
        b=AddCurve(b,a,1);
        b=Meshoutput(b);
        % Add assembly
        Ass=Assembly('I-shaped_section_beam');
        pos=[0,0,0,-90,0,0];
        Ass=AddPart(Ass,b.Meshoutput,'position',pos);
        % Boundary
        Ass=AddBoundary(Ass,1,'No',1);
        Bound1=[1,1,1,1,1,1];
        Ass=SetBoundaryType(Ass,1,Bound1);
        % Material
        mat.table=["EX",2.1e5;"PRXY",0.3];
        Ass=AddMaterial(Ass,mat);
        Ass=SetMaterial(Ass,1,1);
        % Add load
        Ass=AddLoad(Ass,1,'No',21);
        Load1=[0,-5e4,-2e4,0,0,0];
        Ass=SetLoad(Ass,1,Load1);
        % Element type
        ET.name='188';
        ET.opt=[4,2];
        ET.R=[];
        Ass=AddET(Ass,ET);
        Ass=SetET(Ass,1,1);
        % Section
        Sec.type="beam";
        Sec.subtype="I";
        Sec.data=[200,200,300,16,16,12];
        Ass=AddSection(Ass,Sec);
        Ass=SetSection(Ass,1,1);
        Ass=BeamK(Ass,1);
        Plot(Ass,'boundary',1,'load',1,'load_scale',0.02,'ylim',[-200,400],'zlim',[-300,300],'BeamGeom',1);
        % Static analysis
        opt.ANTYPE=0;
        Ass=AddSolu(Ass,opt);
        % Add sensor
        Ass=AddSensor(Ass,'U',1);
        % Output to ANSYS
        ANSYS_Output(Ass);
        if Cal
            ANSYSSolve(Ass);
            PlotSensor(Ass,1);
        end
    case 17
        % Create points
        a=Point2D('Point1');
        a=AddPoint(a,(0:0.1:6)',zeros(61,1));
        % Create lines
        b=Line2D('Line1');
        b=AddCurve(b,a,1);
        b=Meshoutput(b);
        % Add assembly
        Ass=Assembly('Cantilever_tube');
        Ass=AddPart(Ass,b.Meshoutput);
        % Boundary
        Ass=AddBoundary(Ass,1,'No',1);
        Bound1=[1,1,1,1,1,1];
        Ass=SetBoundaryType(Ass,1,Bound1);
        % Material
        mat.table=["EX",2.1e11;"PRXY",0.3;"DENS",7800];
        Ass=AddMaterial(Ass,mat);
        Ass=SetMaterial(Ass,1,1);
        % Add load
        Ass=AddLoad(Ass,1,'No',61);
        Load1=[-1e6,0,0,4e5,0,0];
        Ass=SetLoad(Ass,1,Load1);
        % Add SF
        Ass=AddSF(Ass,1,(1:60)','type','SFE');
        Ass=AddSF(Ass,1,(1:60)','type','SFE');
        value1=[3,0,-5e4];
        value2=[4,0,4e4];
        Ass=SetSF(Ass,1,value1);
        Ass=SetSF(Ass,2,value2);
        % Element type
        ET.name='16';
        ET.opt=[];
        ET.R=[0.6,0.016,0,0,0,1000,2500,0.05];
        Ass=AddET(Ass,ET);
        Ass=SetET(Ass,1,1);
        Plot(Ass,'boundary',1,'load',1,'load_scale',0.0000001);
        % Static analysis
        opt.ANTYPE=0;
        Ass=AddSolu(Ass,opt);
        % Add sensor
        Ass=AddSensor(Ass,'U',1);
        % Output to ANSYS
        ANSYS_Output(Ass);
        if Cal
            ANSYSSolve(Ass);
            PlotSensor(Ass,1);
        end
    case 18
        % Create points
        a=Point2D('Point1');
        a=AddPoint(a,(0:0.1:3)',zeros(31,1));
        % Create lines
        b=Line2D('Line1');
        b=AddCurve(b,a,1);
        b=Meshoutput(b);
        % Add assembly
        Ass=Assembly('Plastic_tube');
        Ass=AddPart(Ass,b.Meshoutput);
        % Boundary
        Ass=AddBoundary(Ass,1,'No',1);
        Bound1=[1,1,1,1,1,1];
        Ass=SetBoundaryType(Ass,1,Bound1);
        % Material
        mat.table=["EX",2.1e11;"PRXY",0.3;"DENS",7800];
        mat.TBlab="BKIN";
        mat.TBtable=[235e6,0];
        Ass=AddMaterial(Ass,mat);
        Ass=SetMaterial(Ass,1,1);
        % Add load
        Ass=AddLoad(Ass,1,'No',31);
        Load1=[-7e5,1e4,0,0,0,0];
        Ass=SetLoad(Ass,1,Load1);
        % Element type
        ET.name='20';
        ET.opt=[];
        ET.R=[0.2,0.005];
        Ass=AddET(Ass,ET);
        Ass=SetET(Ass,1,1);
        Plot(Ass,'boundary',1,'load',1,'load_scale',0.000001);
        % Static analysis
        opt.ANTYPE=0;
        opt.NLGEOM=1;
        opt.NSUBST=50;
        opt.ARCLEN=[1,5];
        Ass=AddSolu(Ass,opt);
        % Add sensor
        Ass=AddSensor(Ass,'U',1);
        % Output to ANSYS
        ANSYS_Output(Ass);
        if Cal
            ANSYSSolve(Ass);
            PlotSensor(Ass,1);
        end
    case 19
        % Create points
        a=Point2D('Point1');
        a=AddPoint(a,[0;0;-100;-100;0],[0;-12;-4;0;0]);
        % Create lines
        b=Line2D('Line1');
        b=AddCurve(b,a,1);
        % Create surface2D
        S=Surface2D(b);
        % Create Mehs2D
        m=Mesh2D('Variable section beam');
        m=AddSurface(m,S);
        m=SetSize(m,0.5);
        m=Mesh(m);
        Plot(m);
        % Add assembly
        Ass=Assembly('Variable_section_beam');
        Ass=AddPart(Ass,m.Meshoutput);
        % Boundary
        Ass=AddBoundary(Ass,1,'locx',0);
        Bound1=[1,1,0,0,0,0];
        Ass=SetBoundaryType(Ass,1,Bound1);
        % Material
        mat.table=["EX",2.1e11;"PRXY",0.3;"DENS",7800];
        Ass=AddMaterial(Ass,mat);
        Ass=SetMaterial(Ass,1,1);
        % Add load
        Ass=AddLoad(Ass,1,'locx',-100);
        Load1=[0,-80,0,0,0,0];
        Ass=SetLoad(Ass,1,Load1);
        % Element type
        ET.name='42';
        ET.opt=[3,3;6,2];
        ET.R=3;
        Ass=AddET(Ass,ET);
        Ass=SetET(Ass,1,1);
        Plot(Ass,'boundary',1,...
            'load',1,'load_scale',0.2,...
            'view',[0,90]);
        % Static analysis
        opt.ANTYPE=0;
        Ass=AddSolu(Ass,opt);
        % Add sensor
        Ass=AddSensor(Ass,'U',1);
        Ass=AddSensor(Ass,'Stress',1);
        % Output to ANSYS
        ANSYS_Output(Ass);
        if Cal
            ANSYSSolve(Ass);
            PlotSensor(Ass,1);
            PlotSensor(Ass,2);
        end
    case 20
        % Create points
        a=Point2D('Point1');
        a=AddPoint(a,0,0);
        a=AddPoint(a,[0;0;100;100;30],[30;50;50;0;0]);
        % Create lines
        b=Line2D('Line1');
        b=AddCircle(b,30,a,1,'sang',0,'ang',90);
        b=AddCurve(b,a,2);
        Plot(b,'equal',1);
        % Create surface2D
        S=Surface2D(b);
        % Create Mehs2D
        m=Mesh2D('Plate with hole');
        m=AddSurface(m,S);
        m=SetSize(m,5);
        m=Mesh(m);
        Plot(m);
        % Add assembly
        Ass=Assembly('Plate_with_hole');
        Ass=AddPart(Ass,m.Meshoutput);
        % Boundary
        Ass=AddBoundary(Ass,1,'locx',0);
        Bound1=[1,0,0,0,0,0];
        Ass=SetBoundaryType(Ass,1,Bound1);
        Ass=AddBoundary(Ass,1,'locy',0);
        Bound2=[0,1,0,0,0,0];
        Ass=SetBoundaryType(Ass,2,Bound2);
        % Material
        mat.table=["EX",2.1e11;"PRXY",0.3;"DENS",7800];
        Ass=AddMaterial(Ass,mat);
        Ass=SetMaterial(Ass,1,1);
        % Add load
        Ass=AddLoad(Ass,1,'locx',100);
        Load1=[12000,0,0,0,0,0];
        Ass=SetLoad(Ass,1,Load1);
        % Element type
        ET.name='42';
        ET.opt=[3,3];
        ET.R=6;
        Ass=AddET(Ass,ET);
        Ass=SetET(Ass,1,1);
        Plot(Ass,'boundary',1,...
            'load',1,'load_scale',0.2,...
            'view',[0,90]);
        % Static analysis
        opt.ANTYPE=0;
        Ass=AddSolu(Ass,opt);
        % Add sensor
        Ass=AddSensor(Ass,'U',1);
        Ass=AddSensor(Ass,'Stress',1);
        % Output to ANSYS
        ANSYS_Output(Ass);
        if Cal
            ANSYSSolve(Ass);
            PlotSensor(Ass,1);
            PlotSensor(Ass,2);
        end
    case 21
        % Create points
        a=Point2D('Point1');
        a=AddPoint(a,[0;300],[80;80]);
        a=AddPoint(a,[300;300],[80;40]);
        a=AddPoint(a,[300;450;600;600],[40;40;40;-40]);
        a=AddPoint(a,[600;300],[-40;-40]);
        a=AddPoint(a,[300;300],[-40;-80]);
        a=AddPoint(a,[300;0;0],[-80;-80;80]);
        % Create lines
        b=Line2D('Line1');
        b=AddLine(b,a,1);
        b=AddLine(b,a,2);
        b=AddCurve(b,a,3);
        b=AddLine(b,a,4);
        b=AddLine(b,a,5);
        b=AddCurve(b,a,6);

        b=CreateRadius(b,2,40);
        b=CreateRadius(b,5,40);
        Plot(b,'equal',1)
        % Create surface2D
        S=Surface2D(b);
        % Create Mehs2D
        m=Mesh2D('Flat bar with shoulder fillets');
        m=AddSurface(m,S);
        m=SetSize(m,5);
        m=Mesh(m);
        m=Convert2Order2(m);
        % Add assembly
        Ass=Assembly('Flat_bar_with_shoulder_fillets');
        Ass=AddPart(Ass,m.Meshoutput);
        % Boundary
        Ass=AddBoundary(Ass,1,'locx',0);
        Bound1=[1,1,0,0,0,0];
        Ass=SetBoundaryType(Ass,1,Bound1);
        % Material
        mat.table=["EX",2.1e5;"PRXY",0.3;"DENS",7.85e-9];
        Ass=AddMaterial(Ass,mat);
        Ass=SetMaterial(Ass,1,1);
        % Add load
        Ass=AddLoad(Ass,1,'locx',600);
        Load1=[96e3,0,0,0,0,0];
        Ass=SetLoad(Ass,1,Load1);
        % Element type
        ET.name='82';
        ET.opt=[3,3;5,1];
        ET.R=12;
        Ass=AddET(Ass,ET);
        Ass=SetET(Ass,1,1);
        Plot(Ass,'boundary',1,...
            'load',1,'load_scale',0.2,...
            'view',[0,90]);
        % Static analysis
        opt.ANTYPE=0;
        Ass=AddSolu(Ass,opt);
        % Add sensor
        Ass=AddSensor(Ass,'U',1);
        Ass=AddSensor(Ass,'Stress',1);
        % Output to ANSYS
        ANSYS_Output(Ass);
        if Cal
            ANSYSSolve(Ass);
            PlotSensor(Ass,2);
        end
    case 22
        % Create points
        a=Point2D('Point1');
        a=AddPoint(a,[0;0;-100;-100;0],[0;-12;-4;0;0]);
        % Create lines
        b=Line2D('Line1');
        b=AddCurve(b,a,1);
        % Create surface2D
        S=Surface2D(b);
        % Create Mehs2D
        m=Mesh2D('Variable section beam');
        m=AddSurface(m,S);
        m=SetSize(m,0.5);
        m=Mesh(m);
        Plot(m);
        % Add assembly
        Ass=Assembly('Variable_section_beam');
        Ass=AddPart(Ass,m.Meshoutput);
        % Boundary
        Ass=AddBoundary(Ass,1,'locx',0);
        Bound1=[1,1,0,0,0,0];
        Ass=SetBoundaryType(Ass,1,Bound1);
        % Material
        mat.table=["EX",2.1e11;"PRXY",0.3;"DENS",7800];
        Ass=AddMaterial(Ass,mat);
        Ass=SetMaterial(Ass,1,1);
        % Add load
        Ass=AddLoad(Ass,1,'locx',-100);
        Load1=[0,-80,0,0,0,0];
        Ass=SetLoad(Ass,1,Load1);
        % Element type
        ET.name='182';
        ET.opt=[3,3];
        ET.R=3;
        Ass=AddET(Ass,ET);
        Ass=SetET(Ass,1,1);
        Plot(Ass,'boundary',1,...
            'load',1,'load_scale',0.2,...
            'view',[0,90]);
        % Static analysis
        opt.ANTYPE=0;
        Ass=AddSolu(Ass,opt);
        % Add sensor
        Ass=AddSensor(Ass,'U',1);
        Ass=AddSensor(Ass,'Stress',1);
        % Output to ANSYS
        ANSYS_Output(Ass);
        if Cal
            ANSYSSolve(Ass);
            PlotSensor(Ass,1);
            PlotSensor(Ass,2);
        end
    case 23
        % Create points
        a=Point2D('Point1');
        a=AddPoint(a,[0;300],[80;80]);
        a=AddPoint(a,[300;300],[80;40]);
        a=AddPoint(a,[300;450;600;600],[40;40;40;-40]);
        a=AddPoint(a,[600;300],[-40;-40]);
        a=AddPoint(a,[300;300],[-40;-80]);
        a=AddPoint(a,[300;0;0],[-80;-80;80]);
        % Create lines
        b=Line2D('Line1');
        b=AddLine(b,a,1);
        b=AddLine(b,a,2);
        b=AddCurve(b,a,3);
        b=AddLine(b,a,4);
        b=AddLine(b,a,5);
        b=AddCurve(b,a,6);

        b=CreateRadius(b,2,40);
        b=CreateRadius(b,5,40);
        Plot(b,'equal',1)
        % Create surface2D
        S=Surface2D(b);
        % Create Mehs2D
        m=Mesh2D('Flat bar with shoulder fillets');
        m=AddSurface(m,S);
        m=SetSize(m,5);
        m=Mesh(m);
        m=Convert2Order2(m);
        Plot(m);
        % Add assembly
        Ass=Assembly('Flat_bar_with_shoulder_fillets');
        Ass=AddPart(Ass,m.Meshoutput);
        % Boundary
        Ass=AddBoundary(Ass,1,'locx',0);
        Bound1=[1,1,0,0,0,0];
        Ass=SetBoundaryType(Ass,1,Bound1);
        % Material
        mat.table=["EX",2.1e5;"PRXY",0.3;"DENS",7.85e-9];
        Ass=AddMaterial(Ass,mat);
        Ass=SetMaterial(Ass,1,1);
        % Add load
        Ass=AddLoad(Ass,1,'locx',600);
        Load1=[96e3,0,0,0,0,0];
        Ass=SetLoad(Ass,1,Load1);
        % Element type
        ET.name='183';
        ET.opt=[3,3];
        ET.R=12;
        Ass=AddET(Ass,ET);
        Ass=SetET(Ass,1,1);
        Plot(Ass,'boundary',1,...
            'load',1,'load_scale',0.2,...
            'view',[0,90]);
        % Static analysis
        opt.ANTYPE=0;
        Ass=AddSolu(Ass,opt);
        % Add sensor
        Ass=AddSensor(Ass,'U',1);
        Ass=AddSensor(Ass,'Stress',1);
        % Output to ANSYS
        ANSYS_Output(Ass);
        if Cal
            ANSYSSolve(Ass);
            PlotSensor(Ass,1);
            PlotSensor(Ass,2);
        end
    case 24
        B=20;
        h0=50;
        x1=0:10:200;
        y1=h0/2*sqrt(abs(x1)./200);
        x2=200:-10:00;
        y2=-h0/2*sqrt(abs(x2)/200);
        % Create points
        a=Point2D('Point1');
        a=AddPoint(a,x1',y1');
        a=AddPoint(a,x2',y2');
        a=AddPoint(a,[200;200],[-h0/2;h0/2]);
        % Create lines
        b=Line2D('Line1');
        b=AddCurve(b,a,1);
        b=AddCurve(b,a,2);
        b=AddLine(b,a,3);
        Plot(b,'equal',1)
        % Create surface2D
        S=Surface2D(b);
        % Create Mehs2D
        m=Mesh2D('Variable solid beam');
        m=AddSurface(m,S);
        m=SetSize(m,5);
        m=Mesh(m);
        Plot(m);
        % Create Mesh
        mm=Mesh('Mesh');
        mm=Extrude2Solid(mm,m,B,4);
        PlotFace(mm);
        % Add assembly
        Ass=Assembly('Variable_solid_beam');
        Ass=AddPart(Ass,mm.Meshoutput);
        % Boundary
        Ass=AddBoundary(Ass,1,'locx',200);
        Bound1=[1,1,1,0,0,0];
        Ass=SetBoundaryType(Ass,1,Bound1);
        % Material
        mat.table=["EX",2.1e5;"PRXY",0.3;"DENS",7.85e-9];
        Ass=AddMaterial(Ass,mat);
        Ass=SetMaterial(Ass,1,1);
        % Add load
        Ass=AddLoad(Ass,1,'locx',0);
        Load1=[0,-5000,0,0,0,0];
        Ass=SetLoad(Ass,1,Load1);
        % Element type
        ET.name='45';
        ET.opt=[];
        ET.R=[];
        Ass=AddET(Ass,ET);
        Ass=SetET(Ass,1,1);
        Plot(Ass,'boundary',1,...
            'load',1,'load_scale',1);
        % Static analysis
        opt.ANTYPE=0;
        Ass=AddSolu(Ass,opt);
        % Add sensor
        Ass=AddSensor(Ass,'U',1);
        Ass=AddSensor(Ass,'Stress',1);
        % Output to ANSYS
        ANSYS_Output(Ass);
        if Cal
            ANSYSSolve(Ass);
            PlotSensor(Ass,1);
            PlotSensor(Ass,2);
        end
    case 25
        % Create points
        a=Point2D('Point1');
        a=AddPoint(a,[120;120],[0;75]);
        a=AddPoint(a,[120;132],[75;75]);
        a=AddPoint(a,[132;132],[75;5]);
        a=AddPoint(a,[132;188],[5;5]);
        a=AddPoint(a,[188;188],[5;45]);
        a=AddPoint(a,[188;200],[45;45]);
        a=AddPoint(a,[200;200],[45;-45]);
        a=AddPoint(a,[200;188],[-45;-45]);
        a=AddPoint(a,[188;188],[-45;-5]);
        a=AddPoint(a,[188;132],[-5;-5]);
        a=AddPoint(a,[132;132],[-5;-45]);
        a=AddPoint(a,[132;120],[-45;-45]);
        a=AddPoint(a,[120;120],[-45;0]);

        % Create lines
        b=Line2D('Line1');
        for i=1:13
            b=AddLine(b,a,i);
        end
        b=CreateRadius(b,3,6);
        b=CreateRadius(b,5,6);
        b=CreateRadius(b,11,6);
        b=CreateRadius(b,13,6);

        Plot(b,'equal',1)
        % Create surface2D
        S=Surface2D(b);
        % Create Mehs2D
        m=Mesh2D('Rotating part');
        m=AddSurface(m,S);
        m=SetSize(m,5);
        m=Mesh(m);
        Plot(m);
        % Create Mesh
        mm=Mesh('Mesh');
        mm=Revolve2Solid(mm,m,'Type',2,'Degree',90);
        mm=Convert2Order2(mm);
        PlotFace(mm,'marker',1);
        PlotElement(mm);
        % Add assembly
        Ass=Assembly('Rotating_part');
        Ass=AddPart(Ass,mm.Meshoutput);
        % Boundary
        Ass=AddBoundary(Ass,1,'locx',0);
        Ass=AddBoundary(Ass,1,'locz',0);
        Ass=AddBoundary(Ass,1,'locy',-45);
        Bound1=[1,0,0,0,0,0];
        Bound2=[0,0,1,0,0,0];
        Bound3=[0,1,0,0,0,0];
        Ass=SetBoundaryType(Ass,1,Bound1);
        Ass=SetBoundaryType(Ass,2,Bound2);
        Ass=SetBoundaryType(Ass,3,Bound3);
        % Material
        mat.table=["EX",2.1e5;"PRXY",0.3;"DENS",7.85e-9];
        Ass=AddMaterial(Ass,mat);
        Ass=SetMaterial(Ass,1,1);
        % Element type
        ET.name='95';
        ET.opt=[];
        ET.R=[];
        Ass=AddET(Ass,ET);
        Ass=SetET(Ass,1,1);
        Plot(Ass,'boundary',1);
        % Static analysis
        opt.ANTYPE=0;
        n=5000;%RPM
        w=n*2*pi/60;
        opt.OMEGA=[0,w,0];
        Ass=AddSolu(Ass,opt);
        % Add sensor
        Ass=AddSensor(Ass,'Stress',1);
        % Output to ANSYS
        ANSYS_Output(Ass);
        if Cal
            ANSYSSolve(Ass);
            PlotSensor(Ass,1);
        end
    case 26
        % Create points
        a=Point2D('Point1');
        a=AddPoint(a,0,0);
        % Create lines
        b=Line2D('Line1');
        b=AddEllipse(b,100,60,a,1);
        Plot(b,'equal',1)
        % Create surface2D
        S=Surface2D(b);
        % Create Mehs2D
        m=Mesh2D('Ellipse beam');
        m=AddSurface(m,S);
        m=SetSize(m,5);
        m=Mesh(m);
        Plot(m);
        % Create Mesh
        mm=Mesh('Mesh');
        mm=Extrude2Solid(mm,m,1000,30);
        PlotFace(mm);
        % Add assembly
        Ass=Assembly('Ellipse_beam');
        Ass=AddPart(Ass,mm.Meshoutput);
        % Boundary
        Ass=AddBoundary(Ass,1,'locz',0);
        Bound1=[1,1,1,0,0,0];
        Ass=SetBoundaryType(Ass,1,Bound1);
        % Material
        mat.table=["EX",2.1e5;"PRXY",0.3;"DENS",7.85e-9];
        Ass=AddMaterial(Ass,mat);
        Ass=SetMaterial(Ass,1,1);
        % Element type
        ET.name='185';
        ET.opt=[];
        ET.R=[];
        Ass=AddET(Ass,ET);
        Ass=SetET(Ass,1,1);
        ET1.name='21';ET1.opt=[3,0];ET1.R=[0,0,0,0,0,0];
        AddET(Ass,ET1);
        % Cnode
        Ass=AddCnode(Ass,0,0,1000);
        Ass=SetCnode(Ass,1,2);
        % Connection
        Ass=AddMaster(Ass,0,1);
        Ass=AddSlaver(Ass,1,'face',3);
        % Rbe2
        Ass=SetRbe2(Ass,1,1);
        % Add load
        Ass=AddLoad(Ass,0,'No',1);
        Load1=[0,0,0,0,0,1e10];
        Ass=SetLoad(Ass,1,Load1);
        Plot(Ass,'boundary',1,...
            'load',1,'load_scale',0.2);
        % Static analysis
        opt.ANTYPE=0;
        Ass=AddSolu(Ass,opt);
        % Add sensor
        Ass=AddSensor(Ass,'U',1);
        Ass=AddSensor(Ass,'Stress',1);
        % Output to ANSYS
        ANSYS_Output(Ass);
        if Cal
            ANSYSSolve(Ass);
            PlotSensor(Ass,1);
            PlotSensor(Ass,2);
        end
    case 27
        % Create points
        a=Point2D('Point1');
        a=AddPoint(a,[120;120],[0;75]);
        a=AddPoint(a,[120;132],[75;75]);
        a=AddPoint(a,[132;132],[75;5]);
        a=AddPoint(a,[132;188],[5;5]);
        a=AddPoint(a,[188;188],[5;45]);
        a=AddPoint(a,[188;200],[45;45]);
        a=AddPoint(a,[200;200],[45;-45]);
        a=AddPoint(a,[200;188],[-45;-45]);
        a=AddPoint(a,[188;188],[-45;-5]);
        a=AddPoint(a,[188;132],[-5;-5]);
        a=AddPoint(a,[132;132],[-5;-45]);
        a=AddPoint(a,[132;120],[-45;-45]);
        a=AddPoint(a,[120;120],[-45;0]);

        % Create lines
        b=Line2D('Line1');
        for i=1:13
            b=AddLine(b,a,i);
        end
        b=CreateRadius(b,3,6);
        b=CreateRadius(b,5,6);
        b=CreateRadius(b,11,6);
        b=CreateRadius(b,13,6);

        Plot(b,'equal',1)
        % Create surface2D
        S=Surface2D(b);
        % Create Mehs2D
        m=Mesh2D('Rotating part');
        m=AddSurface(m,S);
        m=SetSize(m,5);
        m=Mesh(m);
        Plot(m);
        % Create Mesh
        mm=Mesh('Mesh');
        mm=Revolve2Solid(mm,m,'Type',2,'Degree',90);
        mm=Convert2Order2(mm);
        PlotFace(mm,'marker',1);
        PlotElement(mm);
        % Add assembly
        Ass=Assembly('Rotating_part');
        Ass=AddPart(Ass,mm.Meshoutput);
        % Boundary
        Ass=AddBoundary(Ass,1,'locx',0);
        Ass=AddBoundary(Ass,1,'locz',0);
        Ass=AddBoundary(Ass,1,'locy',-45);
        Bound1=[1,0,0,0,0,0];
        Bound2=[0,0,1,0,0,0];
        Bound3=[0,1,0,0,0,0];
        Ass=SetBoundaryType(Ass,1,Bound1);
        Ass=SetBoundaryType(Ass,2,Bound2);
        Ass=SetBoundaryType(Ass,3,Bound3);
        % Material
        mat.table=["EX",2.1e5;"PRXY",0.3;"DENS",7.85e-9];
        Ass=AddMaterial(Ass,mat);
        Ass=SetMaterial(Ass,1,1);
        % Element type
        ET.name='186';
        ET.opt=[];
        ET.R=[];
        Ass=AddET(Ass,ET);
        Ass=SetET(Ass,1,1);
        Plot(Ass,'boundary',1);
        % Static analysis
        opt.ANTYPE=0;
        n=5000;%RPM
        w=n*2*pi/60;
        opt.OMEGA=[0,w,0];
        Ass=AddSolu(Ass,opt);
        % Add sensor
        Ass=AddSensor(Ass,'Stress',1);
        % Output to ANSYS
        ANSYS_Output(Ass);
        if Cal
            ANSYSSolve(Ass);
            PlotSensor(Ass,1);
        end
    case 28
        mm=Mesh('Cylinder Beam');
        mm=MeshCylinder(mm,20,100,1000);
        % The cyclinder is meshed using tetrahedral elements using tetgen
        mm=Mesh3D(mm);
        mm=Convert2Order2(mm);
        PlotElement(mm);
        % Add assembly
        Ass=Assembly('Cylinder_beam');
        Ass=AddPart(Ass,mm.Meshoutput);
        % Boundary
        Ass=AddBoundary(Ass,1,'locz',-500);
        Bound1=[1,1,1,0,0,0];
        Ass=SetBoundaryType(Ass,1,Bound1);
        % Material
        mat.table=["EX",2.1e5;"PRXY",0.3;"DENS",7.85e-9];
        Ass=AddMaterial(Ass,mat);
        Ass=SetMaterial(Ass,1,1);
        % Element type
        ET.name='187';
        ET.opt=[];
        ET.R=[];
        Ass=AddET(Ass,ET);
        Ass=SetET(Ass,1,1);
        ET1.name='21';ET1.opt=[3,0];ET1.R=[0,0,0,0,0,0];
        AddET(Ass,ET1);
        % Cnode
        Ass=AddCnode(Ass,0,0,500);
        Ass=SetCnode(Ass,1,2);
        % Connection
        Ass=AddMaster(Ass,0,1);
        Ass=AddSlaver(Ass,1,'face',2);
        % Rbe2
        Ass=SetRbe2(Ass,1,1);
        % Add load
        Ass=AddLoad(Ass,0,'No',1);
        Load1=[0,0,0,0,0,1e10];
        Ass=SetLoad(Ass,1,Load1);
        Plot(Ass,'boundary',1,...
            'load',1,'load_scale',0.2);
        % Static analysis
        opt.ANTYPE=0;
        Ass=AddSolu(Ass,opt);
        % Add sensor
        Ass=AddSensor(Ass,'U',1);
        % Output to ANSYS
        ANSYS_Output(Ass);
        if Cal
            ANSYSSolve(Ass);
            PlotSensor(Ass,1);
        end
    case 29
        % Mesh plate
        m=Mesh2D('Plate under pressure');
        m=MeshQuadPlate(m,[2000,400],[20,4]);
        Plot(m);
        % Add assembly
        Ass=Assembly('Plate_under_pressure');
        Ass=AddPart(Ass,m.Meshoutput);
        % Boundary
        Ass=AddBoundary(Ass,1,'locx',-1000);
        Ass=AddBoundary(Ass,1,'locx',1000);
        Bound1=[1,1,1,1,1,1];
        Ass=SetBoundaryType(Ass,1,Bound1);
        Ass=SetBoundaryType(Ass,2,Bound1);
        % Material
        mat.table=["EX",2.1e5;"PRXY",0.3;"DENS",7.85e-9];
        Ass=AddMaterial(Ass,mat);
        Ass=SetMaterial(Ass,1,1);
        % Element type
        ET.name='63';
        ET.opt=[];
        ET.R=16;
        Ass=AddET(Ass,ET);
        Ass=SetET(Ass,1,1);
        % Add SF
        Num=Ass.Part{1,1}.NumElements;
        Ass=AddSF(Ass,1,(1:Num)','type','SFE');
        Ass=SetSF(Ass,1,-2e-2);
        Plot(Ass,'boundary',1,...
            'load',1,'load_scale',0.2);
        % Static analysis
        opt.ANTYPE=0;
        Ass=AddSolu(Ass,opt);
        % Add sensor
        Ass=AddSensor(Ass,'U',1);
        % Output to ANSYS
        ANSYS_Output(Ass);
        if Cal
            ANSYSSolve(Ass);
            PlotSensor(Ass,1);
        end
    case 30
        % Mesh cylinder
        mm=Mesh('Cylinder Mesh');
        mm=MeshCylinder(mm,20,400,1000,'ElementType','quad','close',0);
        mm=Convert2Order2(mm);
        PlotFace(mm);

        % Add assembly
        Ass=Assembly('Cylindrical_shell');
        Ass=AddPart(Ass,mm.Meshoutput);
        % Boundary
        Ass=AddBoundary(Ass,1,'locz',-500);
        Ass=AddBoundary(Ass,1,'locz',500);
        Bound1=[1,1,1,0,0,0];
        Ass=SetBoundaryType(Ass,1,Bound1);
        Bound2=[1,1,0,0,0,0];
        Ass=SetBoundaryType(Ass,2,Bound2);
        % Material
        mat.table=["EX",2.1e5;"PRXY",0.3;"DENS",7.85e-9];
        Ass=AddMaterial(Ass,mat);
        Ass=SetMaterial(Ass,1,1);
        % Element type
        ET.name='93';
        ET.opt=[];
        ET.R=2;
        Ass=AddET(Ass,ET);
        Ass=SetET(Ass,1,1);
        % Add load
        Ass=AddLoad(Ass,1,'locz',500);
        Ass=SetLoad(Ass,1,[0,0,-100000,0,0,0]);
        Plot(Ass,'boundary',1,...
            'load',1,'load_scale',0.2);
        % Static analysis
        opt.ANTYPE=0;
        Ass=AddSolu(Ass,opt);
        % Add sensor
        Ass=AddSensor(Ass,'U',1);
        % Output to ANSYS
        ANSYS_Output(Ass);
        if Cal
            ANSYSSolve(Ass);
            PlotSensor(Ass,1);
        end
    case 31
        % Mesh plate
        m=Mesh2D('Shell Section');
        m=MeshQuadPlate(m,[1000,40],[50,4]);
        Plot(m);
        % Add assembly
        Ass=Assembly('Shell_Section');
        Ass=AddPart(Ass,m.Meshoutput);
        % Boundary
        Ass=AddBoundary(Ass,1,'locx',-1000/2);
        Bound1=[1,1,1,1,1,1];
        Ass=SetBoundaryType(Ass,1,Bound1);
        % Material
        mat1.table=["EX",2e5;"PRXY",0];
        Ass=AddMaterial(Ass,mat1);
        mat2.table=["EX",2e4;"PRXY",0];
        Ass=AddMaterial(Ass,mat2);
        % Section
        Sec.type="shell";
        Sec.data=[6,1,0,3;60,2,0,9;6,1,0,3];
        Sec.offset="MID";
        Ass=AddSection(Ass,Sec);
        Ass=SetSection(Ass,1,1);
        % Element type
        ET.name='181';
        ET.opt=[3,2;8,1];
        ET.R=[];
        Ass=AddET(Ass,ET);
        Ass=SetET(Ass,1,1);
        % Add SF
        Num=Ass.Part{1,1}.NumElements;
        Ass=AddSF(Ass,1,(1:Num)','type','SFE');
        Ass=SetSF(Ass,1,0.1);
        Plot(Ass,'boundary',1,...
            'load',1,'load_scale',0.2);
        % Static analysis
        opt.ANTYPE=0;
        Ass=AddSolu(Ass,opt);
        % Add sensor
        Ass=AddSensor(Ass,'U',1);
        % Output to ANSYS
        ANSYS_Output(Ass);
        if Cal
            ANSYSSolve(Ass);
            PlotSensor(Ass,1);
        end
    case 32
        % Mesh plate
        m=Mesh2D('Shell Section');
        m=MeshQuadPlate(m,[1000,40],[50,4]);
        m=Convert2Order2(m);
        Plot(m);
        % Add assembly
        Ass=Assembly('Shell_Section');
        Ass=AddPart(Ass,m.Meshoutput);
        % Boundary
        Ass=AddBoundary(Ass,1,'locx',-1000/2);
        Bound1=[1,1,1,1,1,1];
        Ass=SetBoundaryType(Ass,1,Bound1);
        % Material
        mat1.table=["EX",2e5;"PRXY",0];
        Ass=AddMaterial(Ass,mat1);
        mat2.table=["EX",2e4;"PRXY",0];
        Ass=AddMaterial(Ass,mat2);
        % Section
        Sec.type="shell";
        Sec.data=[6,1,0,3;60,2,0,9;6,1,0,3];
        Sec.offset="MID";
        Ass=AddSection(Ass,Sec);
        Ass=SetSection(Ass,1,1);
        % Element type
        ET.name='281';
        ET.opt=[3,2;8,1];
        ET.R=[];
        Ass=AddET(Ass,ET);
        Ass=SetET(Ass,1,1);
        % Add SF
        Num=Ass.Part{1,1}.NumElements;
        Ass=AddSF(Ass,1,(1:Num)','type','SFE');
        Ass=SetSF(Ass,1,0.1);
        Plot(Ass,'boundary',1,...
            'load',1,'load_scale',0.2);
        % Static analysis
        opt.ANTYPE=0;
        Ass=AddSolu(Ass,opt);
        % Add sensor
        Ass=AddSensor(Ass,'U',1);
        % Output to ANSYS
        ANSYS_Output(Ass);
        if Cal
            ANSYSSolve(Ass);
            PlotSensor(Ass,1);
        end
    case 33
        %% Specifying dimensions and number of elements
        m=Mesh('Mesh');
        %% Create a box with hexahedral elements
        beamDimensions=[120 20 1.55]; %Dimensions
        beamElementNumbers=[60 20 6]; %Number of elements
        m=MeshCube(m,beamDimensions,beamElementNumbers);
        Vm = PatchCentre(m);

        m.Cb(and(m.Cb==5,Vm(:,1)<=120-55-60),:)=11;
        m.Cb(and(m.Cb==6,Vm(:,1)<=120-55-60),:)=12;
        m.Cb(and(and(m.Cb==5,Vm(:,1)>=120-22-60),Vm(:,1)<=120-18-60),:)=13;
        m.Cb(and(and(m.Cb==6,Vm(:,1)>=120-22-60),Vm(:,1)<=120-18-60),:)=14;

        m.Meshoutput.boundaryMarker=m.Cb;

        PlotFace(m)
        % Add assembly
        Ass=Assembly('Glue_plate');
        Ass=AddPart(Ass,m.Meshoutput,'position',[60,0,0,0,0,0]);
        Ass=AddPart(Ass,m.Meshoutput,'position',[60,0,1.55,0,0,0]);
        % Boundary
        Ass=AddBoundary(Ass,1,'locx',0);
        Ass=AddBoundary(Ass,2,'locx',0);
        Bound1=[1,1,1,0,0,0];
        Ass=SetBoundaryType(Ass,1,Bound1);
        Ass=SetBoundaryType(Ass,2,Bound1);
        % Material
        % mat1.table=["EX",2e5;"PRXY",0.3;"DENS",7.85e-9];
        mat1.table=["DENS",1.6e-9;"EX",1.2e5;"EY",1.1e4;"EZ",1.1e4;...
            "PRXY",0.32;"PRYZ",0.45;"PRXZ",0.32;...
            "GXY",5500;"GYZ",5500;"GXZ",5500];
        Ass=AddMaterial(Ass,mat1);
        Ass=SetMaterial(Ass,1,1);
        Ass=SetMaterial(Ass,2,1);
        mat2.TBlab=["CZM",1,0,"CBDE"];
        % mat2.TBtable=[30,0.35,60,1,5e-4,1];
        mat2.TBtable=[30,0.26,60,1,5e-4,1.002];
        Ass=AddMaterial(Ass,mat2);
        % Element type
        ET.name='185';
        ET.opt=[];
        ET.R=[];
        Ass=AddET(Ass,ET);
        Ass=SetET(Ass,1,1);
        Ass=SetET(Ass,2,1);
        ET2.name='170';ET2.opt=[];ET2.R=[];
        Ass=AddET(Ass,ET2);
        ET3.name='173';ET3.opt=[5,3;9,1;10,2;12,6];ET3.R=[]; % Standard contact
        Ass=AddET(Ass,ET3);
        % Add Force
        Ass=AddLoad(Ass,1,'No',13);
        Load1=[0,0,-150,0,0,0];
        Ass=SetLoad(Ass,1,Load1);

        % Ass=AddLoad(Ass,2,'No',14);
        % Load2=[0,0,150,0,0,0];
        % Ass=SetLoad(Ass,2,Load2);
        % Add Displacement
        % Ass=AddDisplacement(Ass,1,'No',13);
        % Dis1=[0,0,-2.5,0,0,0];
        % Ass=SetDisplacement(Ass,1,Dis1);
        %
        % Ass=AddDisplacement(Ass,2,'No',14);
        % Dis2=[0,0,2.5,0,0,0];
        % Ass=SetDisplacement(Ass,2,Dis2);

        Plot(Ass,'boundary',1,...
            'load',1,'load_scale',1,'face_alpha',0.2,'dis',1);
        %% Define Contacts
        Ass=AddCon(Ass,1,12);
        Ass=AddTar(Ass,1,2,11);
        Ass=SetConMaterial(Ass,1,2);
        Ass=SetConET(Ass,1,3);
        Ass=SetTarET(Ass,1,2);
        PlotCon(Ass,1);
        % Static analysis
        opt.ANTYPE=0;
        opt.NSUBST=40;
        opt.AUTOTS="OFF";
        opt.NLGEOM=1;
        opt.ARCLEN=1;
        opt.OUTRES=["ALL","ALL"];
        Ass=AddSolu(Ass,opt);
        % Add sensor
        % Ass=AddSensor(Ass,'U',1);
        % Output to ANSYS
        ANSYS_Output(Ass);
        if Cal
            ANSYSSolve(Ass);
            PlotSensor(Ass,1);
        end


end
end