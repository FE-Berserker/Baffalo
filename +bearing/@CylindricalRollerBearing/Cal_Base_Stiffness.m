function value = Cal_Base_Stiffness(obj)
% 计算滚子刚度
% Author : Xie Yu
switch obj.params.Stiffness_Method
    case 0 % ISO 16281刚度计算方法
        Temp_x=[(-1000:10:-101)'*0.001;(-100:0)'*0.001];
        cs1=35948*obj.output.Lwe^(8/9);
        y=-cs1.*abs(Temp_x).^(10/9);
        value(:,1)=Temp_x;
        value(:,2)=y;
    case 1 % Palmgren刚度计算
        Temp_x=[(-1000:10:-101)'*0.001;(-100:0)'*0.001];
        cs1=(1/(2*3.84*10^(-5))).^(10/9)*obj.output.Lwe^(8/9);
        y=-cs1.*abs(Temp_x).^(10/9);
        value(:,1)=Temp_x;
        value(:,2)=y;
    case 2 % 罗继伟刚度计算
        k1=obj.input.Dw/obj.input.Di;
        k2=obj.input.Dw/obj.input.Do;
        Temp_x=[(-1000:10:-101)'*0.001;(-100:0)'*0.001];
        cs11=1/4.83e-5*obj.output.Lwe^0.74*(obj.input.Dw)^0.1/((1+k1)^(0.1));
        cs22=1/4.83e-5*obj.output.Lwe^0.74*(obj.input.Dw)^0.1/((1-k2)^(0.1));
        cs3=(1/(1/cs11+1/cs22)).^(10/9);
        y=-cs3.*abs(Temp_x).^(10/9);
        value(:,1)=Temp_x;
        value(:,2)=y;
end
end

