% Demo MPC184
clc
clear
close all
plotFlag = true;
Cal=1;
flag=1;
% setBaffaloPath
% 1. MPC184 Add Rigid Beam
% 2. MPC184 Add slider
% 3. MPC184 Add revolute joint
% 4. MPC184 Add universal joint
% 5. MPC184 Add slot joint‌
% 6. MPC184 Add point plane joint
% 7. MPC184 Add translational joint
% 8. MPC184 Add cylindrical joint
% 9. MPC184 Add planar joint
% 10. MPC184 Add weld joint
% 11. MPC184 Add orient joint
% 12. MPC184 Add spherical joint
% 13. MPC184 Add general joint
% 14. MPC184 Add screw joint
% 15. MPC184 Add spotweld joint
% 16. MPC184 Add genb joint

DemoMPC184(flag,Cal);
function DemoMPC184(flag,Cal)
switch flag

    case 1
        % Create points
        a=Point2D('Point1');
        a=AddPoint(a,(1000:100:11000)',zeros(101,1));
        % Create lines
        b=Line2D('Line1');
        b=AddCurve(b,a,1);
        b=Meshoutput(b);
        % Add assembly
        Ass=Assembly('Beam');
        pos=[0,0,0,0,0,0];
        Ass=AddPart(Ass,b.Meshoutput,'position',pos);
        % Material
        mat.table=["EX",2.1e5;"PRXY",0.3];
        Ass=AddMaterial(Ass,mat);
        Ass=SetMaterial(Ass,1,1);
        % Add load
        Ass=AddLoad(Ass,1,'No',(1:101)');
        Load1=[0,0,-100,0,0,0];
        Ass=SetLoad(Ass,1,Load1);
        % Element type
        ET.name='188';
        ET.opt=[4,2];
        ET.R=[];
        Ass=AddET(Ass,ET);
        Ass=SetET(Ass,1,1);
        % Section
        Sec.type="beam";
        Sec.subtype="CTUBE";
        Sec.data=[190,200];
        Ass=AddSection(Ass,Sec);
        Ass=SetSection(Ass,1,1);
        Ass=BeamK(Ass,1);

        % Rigid beam
        Ass=AddCnode(Ass,0,0,0);
        Ass=AddRigidBeam(Ass,0,1,1,1);
        Ass=AddCnode(Ass,12000,0,0);
        Ass=AddRigidBeam(Ass,0,2,1,101);
        % Boundary
        Ass=AddBoundary(Ass,0,'No',[1;2]);
        Bound1=[1,1,1,1,1,1];
        Ass=SetBoundaryType(Ass,1,Bound1);
        Plot(Ass,'boundary',1,'load',1,'load_scale',0.02,'ylim',[-400,400],'zlim',[-400,400],'BeamGeom',1);
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
    case 2
        l1=1000;
        l2=400;
        l3=100;
        l4=500;
        % Create points
        a=Point2D('Point1');
        a=AddPoint(a,(0:50:l1)',zeros(21,1));
        a=AddPoint(a,(0:50:l2)',zeros(9,1));
        a=AddPoint(a,(0:50:l4)',zeros(11,1));

        % Create lines
        b1=Line2D('Line1');
        b1=AddCurve(b1,a,1);
        b1=Meshoutput(b1);

        b2=Line2D('Line2');
        b2=AddCurve(b2,a,2);
        b2=Meshoutput(b2);

        b3=Line2D('Line3');
        b3=AddCurve(b3,a,3);
        b3=Meshoutput(b3);

        % Add assembly
        Ass=Assembly('Beam');
        pos=[0,0,0,0,0,0];
        Ass=AddPart(Ass,b1.Meshoutput,'position',pos);

        pos=[0,0,-(l1-l2)*tan(30/180*pi),0,0,0];
        Ass=AddPart(Ass,b2.Meshoutput,'position',pos);

        pos=[l1+l3+l4,0,100*tan(30/180*pi),0,0,180];
        Ass=AddPart(Ass,b3.Meshoutput,'position',pos);

        % Material
        mat.table=["EX",2.1e5;"PRXY",0.3];
        Ass=AddMaterial(Ass,mat);
        Ass=SetMaterial(Ass,1,1);
        Ass=SetMaterial(Ass,2,1);
        Ass=SetMaterial(Ass,3,1);

        % Add load
        Ass=AddLoad(Ass,1,'No',21);
        Load1=[0,0,-2000,0,0,0];
        Ass=SetLoad(Ass,1,Load1);
        % Element type
        ET.name='188';
        ET.opt=[4,2];
        ET.R=[];
        Ass=AddET(Ass,ET);
        Ass=SetET(Ass,1,1);
        Ass=SetET(Ass,2,1);
        Ass=SetET(Ass,3,1);
        % Section
        Sec.type="beam";
        Sec.subtype="CTUBE";
        Sec.data=[8,10];
        Ass=AddSection(Ass,Sec);
        Ass=SetSection(Ass,1,1);
        Ass=SetSection(Ass,2,1);
        Ass=SetSection(Ass,3,1);
        Ass=BeamK(Ass,1);
        Ass=BeamK(Ass,2);
        Ass=BeamK(Ass,3);

        % Slider
        Ass=AddSlider(Ass,1,21,2,9,3,11);
        % Boundary
        Ass=AddBoundary(Ass,1,'No',1);
        Ass=AddBoundary(Ass,2,'No',1);
        Ass=AddBoundary(Ass,3,'No',1);
        Bound1=[1,1,1,1,1,1];
        Ass=SetBoundaryType(Ass,1,Bound1);
        Ass=SetBoundaryType(Ass,2,Bound1);
        Ass=SetBoundaryType(Ass,3,Bound1);
        Plot(Ass,'boundary',1,'load',1,'load_scale',0.02,'ylim',[-400,400],'zlim',[-400,400],'BeamGeom',1);
        % Static analysis
        opt.ANTYPE=0;
        opt.NLGEOM=1;
        opt.TIME=1;
        opt.NSUBST=20;
        opt.OUTRES={'All','All'};
        Ass=AddSolu(Ass,opt);

        % Add sensor
        Ass=AddSensor(Ass,'U',1);
        % Output to ANSYS
        ANSYS_Output(Ass);
        if Cal
            ANSYSSolve(Ass);
            PlotSensor(Ass,1);
        end
    case 3
        % Parameter
        R=1000;
        L=4000;
        % Assembly
        Ass=Assembly('Slider_crank');
        % Cnode
        Ass=AddCnode(Ass,0,0,0);
        Ass=AddCnode(Ass,0,0,0);
        Ass=AddCnode(Ass,R,0,0);
        Ass=AddCnode(Ass,R,0,0);
        Ass=AddCnode(Ass,R+L,0,0);
        Ass=AddCnode(Ass,L-3.1*R,0,0);
        Ass=AddCnode(Ass,L-3*R,0,0);
        Ass=AddCnode(Ass,R+1.2*L,0,0);
        Ass=AddCnode(Ass,R+1.3*L,0,0);
        % Rigid beam
        Ass=AddRigidBeam(Ass,0,2,0,3);
        Ass=AddRigidBeam(Ass,0,4,0,5);
        Ass=AddRigidBeam(Ass,0,6,0,7);
        Ass=AddRigidBeam(Ass,0,8,0,9);
        % Add CS
        Ass=AddCS(Ass,0,[0,0,0,0,0,0]);
        Ass=AddCS(Ass,0,[0,0,0,0,0,0]);
        % Add RevoluteJoint
        Ass=AddRevoluteJoint(Ass,0,0,0,2,'axis','z','cs',11,'DJType','ROTZ','DJValue',2*pi);
        Ass=AddRevoluteJoint(Ass,0,3,0,4,'axis','z','cs',12);
        % Slider
        Ass=AddSlider(Ass,0,5,0,7,0,8);
        % Boundary1
        Ass=AddBoundary(Ass,0,'No',6);
        Ass=AddBoundary(Ass,0,'No',9);
        Bound1=[1,1,1,1,1,1];
        Ass=SetBoundaryType(Ass,1,Bound1);
        Ass=SetBoundaryType(Ass,2,Bound1);

        Plot(Ass,'boundary',1,'load',1,'load_scale',0.02,'xlim',[-10,10000],'ylim',[-400,400],'zlim',[-400,400],'BeamGeom',1);
        % kinematics analysis
        opt.ANTYPE=0;
        opt.NLGEOM=1;
        opt.TIME=1;
        opt.NSUBST=[200,0,100];
        opt.cnvtol={'f',1.0};
        opt.OUTRES={'All','All'};
        opt1.cnvtol={'m',1.0};
        Ass=AddSolu(Ass,opt);
        Ass=AddSolu(Ass,opt1);

        % % Add sensor
        Ass=AddSensor(Ass,'U',1);
        % Output to ANSYS
        ANSYS_Output(Ass);
        if Cal
            ANSYSSolve(Ass);
            PlotSensor(Ass,1);
        end

end
end