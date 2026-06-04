function value=Cal_Spring_Stiffness(obj)
% 计算弹簧刚度
Qnorm=Cal_Cr(obj);
Temp_x1=[3,2,1,0.9,0.8,0.7,0.6,0.5,0.4,0.3,0.2,0.1,0.08,0.06,0.04,0.02,0.01,0];
Temp_x1=-(Qnorm*Temp_x1).^0.9./(35948^(0.9)*obj.output.Lwe^(0.8));
switch obj.params.Stiffness_Method
    case 0 % ISO 16281刚度计算方法
        cs=35948*obj.output.Lwe^(8/9)/obj.params.N_Slice;
        Temp_y1=-cs.*abs(Temp_x1).^(10/9);
    case 1 % Palmgren刚度计算
        cs=(1/(2*3.84*10^(-5))).^(10/9)*obj.output.Lwe^(8/9)/obj.params.N_Slice;
        Temp_y1=-cs.*abs(Temp_x1).^(10/9);
    case 2 % 罗继伟刚度计算
        k1=obj.input.Dw/obj.input.Di;
        k2=obj.input.Dw/obj.input.Do;
        cs1=1/4.83e-5*obj.output.Lwe^0.74*(obj.input.Dw)^0.1/((1+k1)^(0.1))...
            /obj.params.N_Slice;
        cs2=1/4.83e-5*obj.output.Lwe^0.74*(obj.input.Dw)^0.1/((1-k2)^(0.1))...
            /obj.params.N_Slice;
        cs=(1/(1/cs1+1/cs2)).^(10/9);
        Temp_y1=-cs.*abs(Temp_x1).^(10/9);
end


xx=[Temp_x1';100;200];
yy=[Temp_y1';100;200];
Mat=[xx,yy];
Mat=repmat(Mat,1,obj.params.N_Slice);
if obj.output.Pd(1,1)>=0
    Temp_fix=[2*obj.output.Delta_y'+1/2*obj.output.Pd(1,1),zeros(1,obj.params.N_Slice)'];
else
    Temp_fix=[2*obj.output.Delta_y',zeros(1,obj.params.N_Slice)'];
end
Temp_fix=reshape(Temp_fix',1,[]);
fix=repmat(Temp_fix,17,1);
Temp_zeros=zeros(3,obj.params.N_Slice*2);
fix=[fix;Temp_zeros];
fix=mat2cell(fix,20,ones(1,obj.params.N_Slice)*2);
value=mat2cell(Mat,20,ones(1,obj.params.N_Slice)*2);

value=cellfun(@(x,y)(x-y),value,fix,'UniformOutput',false);

end
