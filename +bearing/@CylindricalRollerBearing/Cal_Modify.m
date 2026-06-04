 function [value,par]=Cal_Modify(obj,Roller_Delta,method,opt)

switch method
    case 0 % 滚子无修形
        value=zeros(1,obj.params.N_Slice);
        par=[];

    case 1 % ISO16281修形
        if obj.output.Lwe<=2.5*obj.input.Dw
            value=(0.35*obj.input.Dw.*log(1./(1-(2*obj.output.Roller_point.x1./obj.output.Lwe).^2)))*0.001;
        elseif obj.output.Lwe>2.5*obj.input.Dw
            Temp=obj.output.Lwe-2.5*obj.input.Dw;
            value=0.5*obj.input.Dw.*...
                (log(1./(1-((2*abs(obj.output.Roller_point.x1)-Temp)./2.5./obj.input.Dw).^2)))*0.001.*...
                (abs(obj.output.Roller_point.x1)>Temp/2);
        end
        par=[];
    case 2 % 弧坡修缘，圆心在中心线上
        if isempty(opt)
            Deltac=max(Roller_Delta);
            lwe=obj.output.Lwe;
            lc=0.15*lwe;
            l1=lwe-2*lc;
            Rc=(lwe^2-l1^2)/8/Deltac;
            par.lc=lc;
            par.Rc=Rc;
        else
            lc=opt.lc;
            Rc=opt.Rc;
            lwe=obj.output.Lwe;
            l1=lwe-2*lc;
            par.lc=lc;
            par.Rc=Rc;
        end
        x=obj.output.Roller_point.x1;
        y0=-sqrt(Rc^2-(l1/2)^2);
        value=-sqrt(Rc^2-x.^2)-y0;
        value=value.*(value>0)+0.*(value<=0);
    case 3 % 弧坡修缘，圆心在两侧
        if isempty(opt)
            Deltac=max(Roller_Delta);
            lwe=obj.output.Lwe;
            lc=0.15*lwe;
            l1=lwe-2*lc;
            Rc=lwe^2/88/Deltac;
            par.lc=lc;
            par.Rc=Rc;
        else
            lc=opt.lc;
            Rc=opt.Rc;
            lwe=obj.output.Lwe;
            l1=lwe-2*lc;
            par.lc=lc;
            par.Rc=Rc;
        end
        x=obj.output.Roller_point.x1;
        value=-sqrt(Rc^2-(abs(x)-l1/2).^2)+Rc;
        value=value.*(abs(x)>=l1/2)+0.*(abs(x)<l1/2);

    case 4 % 全凸滚子
        if isempty(opt)
            Deltac=max(Roller_Delta);
            lwe=obj.output.Lwe;
            Rc=lwe^2/8/Deltac;
            par.Rc=Rc;
        else
            Rc=opt.Rc;
            par.Rc=Rc;
        end
        x=obj.output.Roller_point.x1;
        y0=-Rc;
        value=-sqrt(Rc^2-x.^2)-y0;

end

end