clc
clear
close all
% Demo Rubber Property
% 1. Calculate Rubber Property, method 1
% 2. Plot Stress strain curve
flag=1;
DemoRubberProperty(flag);

function DemoRubberProperty(flag)
switch flag
    case 1
        E=NaN(41,1);
        d=NaN(41,1);
        G=NaN(41,1);
        C10=NaN(41,1);
        C01=NaN(41,1);
        HS=(30:70)';
        for i=30:70
            inputRubber.HS=i;
            paramsRubber= struct();
            obj1=method.Rubber.RubberProperty(paramsRubber, inputRubber);
            obj1=obj1.solve();
            E(i-29,1)=obj1.output.E;
            G(i-29,1)=obj1.output.G;
            d(i-29,1)=obj1.output.d;
            C10(i-29,1)=obj1.output.MR_Parameter(1);
            C01(i-29,1)=obj1.output.MR_Parameter(2);
        end
        X1={HS;HS};
        Y1={E;G};
        Color{1,1}='E';
        Color{2,1}='G';
        g(1,1)=Rplot('x',X1,'y',Y1,'color',Color);
        g(1,1)=geom_line(g(1,1));
        g(1,1)=set_axe_options(g(1,1),'grid',1);
        g(1,1)=set_names(g(1,1),'column','Origin','x',"HS",'y','Property (N/mm2)','color','Property');

        g(1,2)=Rplot('x',HS,'y',d);
        g(1,2)=geom_line(g(1,2));
        g(1,2)=set_axe_options(g(1,2),'grid',1);
        g(1,2)=set_names(g(1,2),'column','Origin','x',"HS",'y','Ed/Es');

        Y3={C10;C01};
        Color1{1,1}='C10';
        Color1{2,1}='C01';
        g(1,3)=Rplot('x',X1,'y',Y3,'color',Color1);
        g(1,3)=geom_line(g(1,3));
        g(1,3)=set_axe_options(g(1,3),'grid',1);
        g(1,3)=set_names(g(1,3),'column','Origin','x',"HS",'y','Parameter');
        g=set_title(g,'Relationship between HS and Property');
        figure('Position',[100 100 1200 500]);
        draw(g);
    case 2
        inputRubber.HS=43;
        paramsRubber= struct();
        obj1=method.Rubber.RubberProperty(paramsRubber, inputRubber);
        obj1=obj1.solve();
        PlotStressStrainCurve(obj1);




end

end