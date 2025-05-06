function obj=HashinCriterion(obj)
%函数功能：基于Hashin强度准则计算强度比。
%调用格式：HashinCriterion(Sigma,Xt,Xc,Yt,Yc,S)。
%输入参数：Sigma—为正轴应力列向量；
%          Xt,Xc,Yt,Yc,S—单层板的基本强度。
%运行结果：强度比的数值。
Sigma=obj.input.Stress;

Num=size(Sigma,1);
F1t=repmat(obj.input.Material.allowables.F1t,Num,1);
F1c=repmat(obj.input.Material.allowables.F1c,Num,1);
F2t=repmat(obj.input.Material.allowables.F2t,Num,1);
F2c=repmat(obj.input.Material.allowables.F2c,Num,1);
F3t=repmat(obj.input.Material.allowables.F3t,Num,1);
F3c=repmat(obj.input.Material.allowables.F3c,Num,1);
F4=repmat(obj.input.Material.allowables.F4,Num,1);
F5=repmat(obj.input.Material.allowables.F5,Num,1);
F6=repmat(obj.input.Material.allowables.F6,Num,1);


R1=1./sqrt((Sigma(:,1)./F1t).^2+(Sigma(:,5)./F5).^2+(Sigma(:,6)./F6).^2).*(Sigma(:,1)>=0)+...
    F1c./abs(Sigma(:,1)).*(Sigma(:,1)<0);

A=((Sigma(:,2)+Sigma(:,3))./(2.*F4)).^2+...
    (Sigma(:,4).^2-Sigma(:,2).*Sigma(:,3))/(F4.^2)+...
    (Sigma(:,5)./F5).^2+...
    (Sigma(:,6)./F6).^2;
B=((F2c./(2.*F4)).^2-1).*((Sigma(:,2)+Sigma(:,3))./F2c);
R2=1./sqrt(((Sigma(:,2)+Sigma(:,3))./F2t).^2+...
    (Sigma(:,4).^2-Sigma(:,2).*Sigma(:,3))./(F4.^2)+...
    (Sigma(:,5)./F5).^2+...
    (Sigma(:,6)./F6).^2).*((Sigma(:,2)+Sigma(:,3))>=0)+...
    (-B+sqrt(B.^2+4.*A))./(2.*A).*((Sigma(:,2)+Sigma(:,3))<0);


minR=min(min([R1,R2]));
minR_detail=min([R1,R2]);
R=[R1,R2];

obj.output.minR=minR;
obj.output.minR_detail=minR_detail;
obj.output.R=R;
end
