function Plot_Roller_Stiffness(obj)
x=[(-1000:10:-101)'*0.001;(-100:0)'*0.001];
cs1=35948*obj.output.Lwe^(8/9);
cs2=(1/(2*3.84*10^(-5))).^(10/9)*obj.output.Lwe^(8/9);
y1=-cs1.*abs(x).^(10/9);
y2=-cs2.*abs(x).^(10/9);

k1=obj.input.Dw/obj.input.Di;
k2=obj.input.Dw/obj.input.Do;
cs11=1/4.83e-5*obj.output.Lwe^0.74*(obj.input.Dw)^0.1/((1+k1)^(0.1));
cs22=1/4.83e-5*obj.output.Lwe^0.74*(obj.input.Dw)^0.1/((1-k2)^(0.1));
cs3=(1/(1/cs11+1/cs22)).^(10/9);
y3=-cs3.*abs(x).^(10/9);

X=cell(4,1);Y=cell(4,1);Color=cell(4,1);
X{1,1}=x;X{2,1}=x;X{3,1}=x;
X{4,1}=obj.output.Roller_Stiffness(:,1)-obj.output.Pd(1,1)/2;
Y{1,1}=y1;Y{2,1}=y2;Y{3,1}=y3;
Y{4,1}=obj.output.Roller_Stiffness(:,2);
Color{1,1}='ISO 16281';
Color{2,1}='Palmgren';
Color{3,1}='罗继伟';
Color{4,1}='Real';


g=Rplot('x',X,'y',Y,'color',Color);
g=geom_line(g);
g=set_axe_options(g,'grid',1);
g=set_names(g,'column','Origin','x',"Displacement (mm)",'y','Q (N)','color','Method');
g=set_title(g,'Roller stiffness');
figure('Position',[100 100 800 600]);
draw(g);
end