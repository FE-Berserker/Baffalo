clc
clear
close all
% Test MultiBody
% 1. A Triple Pendulum
% 2. Flex body(with contact elements) input test
% 3. A Triple Pendulum with force element
% 4. Two-mass Oscillator
% 5. Slider-crank mechanism
% 6. Toy car assembly, substructure assembly
flag=1;
testMultiBody(flag);

function testMultiBody(flag)
switch flag
    case 1
        %  A Triple Pendulum
        Sphere=load('.\001_Multi1\Sphere\Sphere.mat').Sphere;
        Rod=load('.\001_Multi1\Rod\Rod.mat').Rod;
        Multi=MultiBody('Multi1');
        Multi=AddBody(Multi,Rod.output.SubStr);
        Multi=AddBody(Multi,Rod.output.SubStr);
        Multi=AddBody(Multi,Rod.output.SubStr);
        Multi=AddBody(Multi,Sphere.output.SubStr);
        Multi=AddBody(Multi,Sphere.output.SubStr);
        Multi=AddBody(Multi,Sphere.output.SubStr);
        Multi=AddJoint(Multi,0,1,1,3,'Type',1,'Pos',30);
        Multi=AddJoint(Multi,1,2,2,3,'Type',1,'Pos',30);
        Multi=AddJoint(Multi,2,2,3,3,'Type',1,'Pos',30);
        Multi=AddJoint(Multi,1,2,4,1);
        Multi=AddJoint(Multi,2,2,5,1);
        Multi=AddJoint(Multi,3,2,6,1);
        Simpack_Output(Multi);
        Plot(Multi)
    case 2
        Shaft=load('.\002_Multi2\Shaft\Shaft.mat').Shaft;
        Multi=MultiBody('Multi2');
        Multi=AddBody(Multi,Shaft);
        Simpack_Output(Multi);
        Plot(Multi)
    case 3
        %  A Triple Pendulum
        Sphere=load('.\003_Multi3\Sphere\Sphere.mat').Sphere;
        Rod=load('.\003_Multi3\Rod\Rod.mat').Rod;
        Multi=MultiBody('Multi3');
        Multi=AddBody(Multi,Rod.output.SubStr);
        Multi=AddBody(Multi,Rod.output.SubStr);
        Multi=AddBody(Multi,Rod.output.SubStr);
        Multi=AddBody(Multi,Sphere.output.SubStr);
        Multi=AddBody(Multi,Sphere.output.SubStr);
        Multi=AddBody(Multi,Sphere.output.SubStr);
        Multi=AddRefMarker(Multi,'Type',2,'Pos',[0,1000,0]);
        Multi=AddJoint(Multi,0,1,1,3,'Type',1,'Pos',30);
        Multi=AddJoint(Multi,1,2,2,3,'Type',1,'Pos',30);
        Multi=AddJoint(Multi,2,2,3,3,'Type',1,'Pos',30);
        Multi=AddJoint(Multi,1,2,4,1);
        Multi=AddJoint(Multi,2,2,5,1);
        Multi=AddJoint(Multi,3,2,6,1);
        Multi=AddForce(Multi,0,2,6,1,'Type',4,'Par',[1,1000;2,0.1;3,0.01]);
        Simpack_Output(Multi);
        Plot(Multi)
    case 4
        Block=load('.\004_Multi4\Block\Block.mat').Block;
        Multi=MultiBody('Multi4');
        Multi=AddBody(Multi,Block.output.SubStr);
        Multi=AddBody(Multi,Block.output.SubStr);
        Multi=AddJoint(Multi,0,1,1,2,'Type',6,'Pos',-300);
        Multi=AddJoint(Multi,1,3,2,2,'Type',6,'Pos',-400);
        Multi=AddForce(Multi,0,1,1,2,'Type',4,'Par',[1,300;2,0.2;3,0.02]);
        data=[-2000,-2000;-1000,-200;0,0;1000,200;2000,2000];
        Multi=AddFunction(Multi,data);
        Multi=AddForce(Multi,1,3,2,2,'Type',43,'Par',[15,0.02;21,GetFunctionName(Multi,1);42,-400]);
        Simpack_Output(Multi);
        Plot(Multi)
    case 5
        Wheel=load('.\005_Multi5\Wheel\Wheel.mat').Wheel;
        Rod=load('.\005_Multi5\Rod\Rod.mat').Rod;
        Slider=load('.\005_Multi5\Slider\Slider.mat').Slider;
        Multi=MultiBody('Multi5');
        Multi=AddBody(Multi,Wheel);
        Multi=AddBody(Multi,Rod.output.SubStr);
        Multi=AddBody(Multi,Slider);
        Multi=AddRefMarker(Multi,'Type',2,'Pos',[1000,0,0]);
        Multi=AddJoint(Multi,0,1,1,1,'Type',3,'Vel',20,'Dep',0);
        Multi=AddJoint(Multi,1,2,2,1,'Type',3);
        Multi=AddJoint(Multi,0,2,3,1,'Par',[2,-90]);
        Multi=AddConstraint(Multi,3,1,2,2,'Type',25,'Par',[5,1]);
        Simpack_Output(Multi);
        Plot(Multi)
    case 6
        Chassis=load('.\006_Multi6\Chassis\Chassis.mat').Chassis;
        Wheel=load('.\006_Multi6\Wheel\WheelMulti.mat'). WheelMulti;
        Multi=MultiBody('Multi6');
        Multi=AddBody(Multi,Chassis.output.SubStr);
        Multi=AddSubStructure(Multi,Wheel);
        Multi.SubStructure{1, 1}.Multi.Name='Wheel1';
        Multi=AddSubStructure(Multi,Wheel);
        Multi.SubStructure{2, 1}.Multi.Name='Wheel2';
        Multi=AddPair(Multi,1,2,1,0,2);
        Multi=AddPair(Multi,1,3,2,0,2);
        Simpack_Output(Multi);
        Plot(Multi)

end
end