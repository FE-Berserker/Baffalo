%% Demo Non Hertz Contact
% 1. Demo
% 2. Beta effect
% 3. Q effect
clc
clear
close all
flag=3;
DemoNon_Hertz_Contact(flag);

function DemoNon_Hertz_Contact(flag)
switch flag
    case 1
        Lp=9;
        Rc=1800;
        Dw=10;
        L=14;
        x=-L/2:0.1:L/2;
        y=0.*(abs(x)<=Lp/2)+...
            (Rc-(Rc^2+(Lp/2)^2-x.^2).^(1/2)).*(abs(x)>Lp/2);
        % y=x.*0;
        % input1Struct.Q=920;
        input1Struct.Q=1840;
        input1Struct.x=x;
        input1Struct.y=y;
        input1Struct.Lwe=L;
        input1Struct.D1=Dw;
        input1Struct.D2=1000;
        params1Struct.Beta=0.0172;
        % params1Struct.Beta=0;
        Roller_Stress=method.Non_Hertz_Contact.Roller_Calculation(params1Struct, input1Struct);
        Roller_Stress=Roller_Stress.solve();
        PlotProfile(Roller_Stress)
        PlotP(Roller_Stress)
        Plota(Roller_Stress)
    case 2
        Lp=9;
        Rc=1800;
        Dw=10;
        L=14;
        x=-L/2:0.1:L/2;
        y=0.*(abs(x)<=Lp/2)+...
            (Rc-(Rc^2+(Lp/2)^2-x.^2).^(1/2)).*(abs(x)>Lp/2);
        input1Struct.Q=920;
        input1Struct.x=x;
        input1Struct.y=y;
        input1Struct.Lwe=L;
        input1Struct.D1=Dw;
        input1Struct.D2=1000;

        Beta=[0,0.0172/2,0.0172,0.0172*1.5,0.0172*2];
      
        figure
        for i=1:5
            params1Struct.Beta=Beta(i);
            Roller_Stress=method.Non_Hertz_Contact.Roller_Calculation(params1Struct, input1Struct);
            Roller_Stress=Roller_Stress.solve();
            plot(x,Roller_Stress.output.P)
            hold on
        end
        xlabel('x [mm]')
        ylabel('Contact max stress [MPa]')
    case 3
        Lp=9;
        Rc=1800;
        Dw=10;
        L=14;
        x=-L/2:0.1:L/2;
        y=0.*(abs(x)<=Lp/2)+...
            (Rc-(Rc^2+(Lp/2)^2-x.^2).^(1/2)).*(abs(x)>Lp/2);
        
        input1Struct.x=x;
        input1Struct.y=y;
        input1Struct.Lwe=L;
        input1Struct.D1=Dw;
        input1Struct.D2=1000;
        params1Struct.Beta=0;

        Q=[920/2,920,920*1.5,920*2,920*2.5];

        figure
        for i=1:5
            input1Struct.Q=Q(i);
            Roller_Stress=method.Non_Hertz_Contact.Roller_Calculation(params1Struct, input1Struct);
            Roller_Stress=Roller_Stress.solve();
            plot(x,Roller_Stress.output.P)
            hold on
        end
        xlabel('x [mm]')
        ylabel('Contact max stress [MPa]')

        



end


end