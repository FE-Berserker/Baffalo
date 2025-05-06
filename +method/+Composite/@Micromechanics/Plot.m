function Plot(obj)
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
    E1=NaN(5,size(Vf,2));E2=NaN(5,size(Vf,2));
    G12=NaN(5,size(Vf,2));G23=NaN(5,size(Vf,2));
    v12=NaN(5,size(Vf,2));v23=NaN(5,size(Vf,2));
    Theory={'Voigt','Reuss','MT','MOC','MOCu'};
    for i=1:size(Vf,2)
        for j=1:5
            [plyprops]=RunMicro(Theory{j},...
                obj.params.Name,...
                Vf(i),...
                Constits);
            E1(j,i)=plyprops.E1;E2(j,i)=plyprops.E2;
            G12(j,i)=plyprops.G12;G23(j,i)=plyprops.G23;
            v12(j,i)=plyprops.v12;v23(j,i)=plyprops.v23;
        end
    end

    C={'Voigt','Reuss','MT','MOC','MOCu'};
    g(1,1)=Rplot('x',Vf,'y',E1,'color',C);
    g(1,1)=geom_line(g(1,1));
    g(1,1)=set_names(g(1,1),'x','Fiber Volume Fraction V_f','y','Elastic modulus E_1','color','Type');

    g(1,2)=Rplot('x',Vf,'y',E2,'color',C);
    g(1,2)=geom_line(g(1,2));
    g(1,2)=set_names(g(1,2),'x','Fiber Volume Fraction V_f','y','Elastic modulus E_2','color','Type');

    g(1,3)=Rplot('x',Vf,'y',G12,'color',C);
    g(1,3)=geom_line(g(1,3));
    g(1,3)=set_names(g(1,3),'x','Fiber Volume Fraction V_f','y','Shear modulus G_{12}','color','Type');

    g(2,1)=Rplot('x',Vf,'y',G23,'color',C);
    g(2,1)=geom_line(g(2,1));
    g(2,1)=set_names(g(2,1),'x','Fiber Volume Fraction V_f','y','Shear modulus G_{23}','color','Type');

    g(2,2)=Rplot('x',Vf,'y',v12,'color',C);
    g(2,2)=geom_line(g(2,2));
    g(2,2)=set_names(g(2,2),'x','Fiber Volume Fraction V_f','y','Possion''s ratio \nu_{12}','color','Type');

    g(2,3)=Rplot('x',Vf,'y',v23,'color',C);
    g(2,3)=geom_line(g(2,3));
    g(2,3)=set_names(g(2,3),'x','Fiber Volume Fraction V_f','y','Possion''s ratio \nu_{23}','color','Type');

    title=strcat(obj.input.Fiber.Name,'/',obj.input.Matrix.Name,' properties');
    g=set_title(g,title);
    g=set_axe_options(g,'grid',1);
    figure('Position',[100 100 1000 600]);
    draw(g);

else
    E1=NaN(1,size(Vf,2));E2=NaN(1,size(Vf,2));
    G12=NaN(1,size(Vf,2));G23=NaN(1,size(Vf,2));
    v12=NaN(1,size(Vf,2));v23=NaN(1,size(Vf,2));
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
        E1(i)=plyprops.E1;E2(i)=plyprops.E2;
        G12(i)=plyprops.G12;G23(i)=plyprops.G23;
        v12(i)=plyprops.v12;v23(i)=plyprops.v23;
    end

    y=[E1;E2];
    C={'E_1','E_2'};
    g(1,1)=Rplot('x',Vf,'y',y,'color',C);
    g(1,1)=geom_line(g(1,1));
    g(1,1)=set_names(g(1,1),'x','Fiber Volume Fraction V_f','y','Elastic modulus E','color','Type');

    y=[v12;v23];
    C={'\nu_{12}','\nu_{23}'};
    g(1,2)=Rplot('x',Vf,'y',y,'color',C);
    g(1,2)=geom_line(g(1,2));
    g(1,2)=set_names(g(1,2),'x','Fiber Volume Fraction V_f','y','Possion''s ratio \nu','color','Type');

    y=[G12;G23];
    C={'G_{12}','G_{23}'};
    g(1,3)=Rplot('x',Vf,'y',y,'color',C);
    g(1,3)=geom_line(g(1,3));
    g(1,3)=set_names(g(1,3),'x','Fiber Volume Fraction V_f','y','Shear modulus G','color','Type');

    title=strcat(obj.input.Fiber.Name,'/',obj.input.Matrix.Name,' properties (',obj.params.Theory,' Method)');
    g=set_title(g,title);
    g=set_axe_options(g,'grid',1);
    figure('Position',[100 100 1000 350]);
    draw(g);
end

end