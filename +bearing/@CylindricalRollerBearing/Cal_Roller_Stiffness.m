function [Slice_Stiffness,Roller_Stiffness] = Cal_Roller_Stiffness(obj,Delta_y)
% Calculate roller stiffness
% Author : Xie Yu

switch obj.params.Stiffness_Method
    case 0 % ISO 16281刚度计算方法
        cs=35948*obj.output.Lwe^(8/9)/obj.params.N_Slice;
        Temp_x=[(-1000:10:-101)'*0.001;(-100:0)'*0.001];
        Temp_y=-cs.*abs(Temp_x).^(10/9);
    case 1 % Palmgren刚度计算
        cs=(1/(2*3.84*10^(-5))).^(10/9)*obj.output.Lwe^(8/9)/obj.params.N_Slice;
        Temp_x=[(-1000:10:-101)'*0.001;(-100:0)'*0.001];
        Temp_y=-cs.*abs(Temp_x).^(10/9);
    case 2 % 罗继伟刚度计算
        k1=obj.input.Dw/obj.input.Di;
        k2=obj.input.Dw/obj.input.Do;
        cs1=1/4.83e-5*obj.output.Lwe^0.74*(obj.input.Dw)^0.1/((1+k1)^(0.1))...
            /obj.params.N_Slice;
        cs2=1/4.83e-5*obj.output.Lwe^0.74*(obj.input.Dw)^0.1/((1-k2)^(0.1))...
            /obj.params.N_Slice;
        cs=(1/(1/cs1+1/cs2)).^(10/9);
        Temp_x=[(-1000:10:-101)'*0.001;(-100:0)'*0.001];
        Temp_y=-cs.*abs(Temp_x).^(10/9);
end

xx=[Temp_x;100];
yy=[Temp_y;0];
Mat=[xx,yy];
Mat=repmat(Mat,1,obj.params.N_Slice);
Temp_fix=[2*Delta_y',zeros(1,obj.params.N_Slice)'];
Temp_fix=reshape(Temp_fix',1,[]);
fix=repmat(Temp_fix,192,1);
fix=mat2cell(fix,192,ones(1,obj.params.N_Slice)*2);
Slice_Stiffness=mat2cell(Mat,192,ones(1,obj.params.N_Slice)*2);
Slice_Stiffness=cellfun(@(x,y)(x-y),Slice_Stiffness,fix,'UniformOutput',false);

Roller_Stiffness=NaN(size(Temp_x,1),2);
Roller_Stiffness(:,1)=Temp_x();
for i=1:size(Temp_x,1)
    delta=Temp_x(i,1);
    yyy=cellfun(@(x)interp1(x(:,1),x(:,2),delta,"linear"),Slice_Stiffness,'UniformOutput',false);
    Roller_Stiffness(i,2)=sum(cell2mat(yyy));
end
end


