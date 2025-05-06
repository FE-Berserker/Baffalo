function obj=TsaiWuCriterion(obj)
%函数功能：基于Tsai-Wu强度准则计算强度比。
%调用格式：TsaiWuCriterion(Sigma,Xt,Xc,Yt,Yc,S)。
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

F1=1./F1t-1./F1c;
F2=1./F2t-1./F2c;
F3=1./F3t-1./F3c;
F44=1./F4.^2;
F55=1./F5.^2;
F66=1./F6.^2;
F11=1./(F1t.*F1c);
F22=1./(F2t.*F2c);
F33=1./(F3t.*F3c);

F12=-1./(2.*sqrt(F1t.*F1c.*F2t.*F2c));
F13=-1./(2.*sqrt(F1t.*F1c.*F3t.*F3c));
F23=-1./(2.*sqrt(F2t.*F2c.*F3t.*F3c));

A=F11.*Sigma(:,1).^2+F22.*Sigma(:,2).^2+F33.*Sigma(:,3).^2+...
    F44.*Sigma(:,4).^2+F55.*Sigma(:,5).^2+F66.*Sigma(:,6).^2+...
    2.*F12.*Sigma(:,1).*Sigma(:,2)+2.*F13.*Sigma(:,1).*Sigma(:,3)+2.*F23.*Sigma(:,2).*Sigma(:,3);

B=F1.*Sigma(:,1)+F2.*Sigma(:,2)+F3.*Sigma(:,3);
R=(-B+sqrt(B.^2+4.*A))./(2.*A);
minR=min(min(R));
minR_detail=min(R);

obj.output.minR=minR;
obj.output.minR_detail=minR_detail;
obj.output.R=R;

end
