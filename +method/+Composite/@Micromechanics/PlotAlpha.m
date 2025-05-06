function PlotAlpha(obj)
if obj.params.Theory=="GMC"
    Vf=[0.01,0.05:0.05:obj.output.Plyprops.RUC.Vf_max];
elseif obj.params.Theory=="HFGMC"
    Vf=[0.01,0.05:0.05:obj.output.Plyprops.RUC.Vf_max];
else
    Vf=[0.01,0.05:0.05:1];
end
Constits.Fiber=obj.input.Fiber;
Constits.Matrix=obj.input.Matrix;
Constits.Interface=obj.input.Interface;
if obj.params.Theory=="All"
    Alpha1=NaN(5,size(Vf,2));Alpha2=NaN(5,size(Vf,2));
    Theory={'Voigt','Reuss','MT','MOC','MOCu'};

    for i=1:size(Vf,2)
        for j=1:5

            [plyprops]=RunMicro(Theory{j},...
                obj.params.Name,...
                Vf(i),...
                Constits);

            Alpha1(j,i)=plyprops.a1; Alpha2(j,i)=plyprops.a2;
        end
    end
    C={'Voigt','Reuss','MT','MOC','MOCu'};
    g(1,1)=Rplot('x',Vf,'y',Alpha1,'color',C);
    g(1,1)=geom_line(g(1,1));
    g(1,1)=set_names(g(1,1),'x','Fiber Volume Fraction V_f','y','Thermal expansion coefficient \alpha_1','color','Type');

    g(1,2)=Rplot('x',Vf,'y',Alpha2,'color',C);
    g(1,2)=geom_line(g(1,2));
    g(1,2)=set_names(g(1,2),'x','Fiber Volume Fraction V_f','y','Thermal expansion coefficient \alpha_2','color','Type');
    title=strcat(obj.input.Fiber.Name,'/',obj.input.Matrix.Name,' Thermal expansion coefficient');
    g=set_title(g,title);
    g=set_axe_options(g,'grid',1);
    figure('Position',[100 100 800 400]);
    draw(g);

else
    Alpha1=NaN(1,size(Vf,2));Alpha2=NaN(1,size(Vf,2));
    for i=1:size(Vf,2)
        if obj.params.Theory=="GMC"
            if isempty(obj.input.Vi)
                Vi=0;
            else
                Vi=obj.input.Vi;
            end
            [plyprops]=RunMicro(obj.params.Theory,...
                obj.params.Name,...
                struct('Vf',Vf(i),'Vi',Vi),...
                Constits,obj.params.RUCid);
        elseif obj.params.Theory=="HFGMC"
            if isempty(obj.input.Vi)
                Vi=0;
            else
                Vi=obj.input.Vi;
            end
            [plyprops]=RunMicro(obj.params.Theory,...
                obj.params.Name,...
                struct('Vf',Vf(i),'Vi',Vi),...
                Constits,obj.params.RUCid);
        else
            [plyprops]=RunMicro(obj.params.Theory,...
                obj.params.Name,...
                Vf(i),...
                Constits);
        end
        Alpha1(i)=plyprops.a1;Alpha2(i)=plyprops.a2;
    end

    y=[Alpha1;Alpha2];
    C={'a_1','a_2'};
    g=Rplot('x',Vf,'y',y,'color',C);
    g=geom_line(g);
    g=set_names(g,'x','Fiber Volume Fraction V_f','y','Thermal expansion coefficient \alpha','color','Type');

    title=strcat(obj.input.Fiber.Name,'/',obj.input.Matrix.Name,' (',obj.params.Theory,' Method)');
    g=set_title(g,title);
    g=set_axe_options(g,'grid',1);
    figure('Position',[100 100 500 400]);
    draw(g);
end
end