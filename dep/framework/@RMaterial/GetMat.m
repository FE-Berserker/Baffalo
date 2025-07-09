function Mat = GetMat(obj,num,varargin)
% Get material properties
% Author : Xie Yu
p=inputParser;
addParameter(p,'unit',1);
parse(p,varargin{:});
opt=p.Results;

switch opt.unit
    case 1 % tonne mm s ℃ mA mN mV
        adjust1=1e-12;
        adjust2=1;
        adjust3=1e-3;

    case 2 % kg m s ℃ A N V
        adjust1=1;
        adjust2=1e6;
        adjust3=1;
end

switch obj.SheetName
    case 'Basic'
        Mat=cell(size(num,1),1);
        for i=1:size(num,1)
            Mat{i,1}.ID=obj.Sheet.No(num(i,1),1);
            Mat{i,1}.Name=obj.Sheet.Name{num(i,1),1};
            Mat{i,1}.Type=obj.Sheet.Type{num(i,1),1};
            Mat{i,1}.Dens=obj.Sheet.Density(num(i,1),1)*adjust1;
            Mat{i,1}.v=obj.Sheet.Poisson(num(i,1),1);
            Mat{i,1}.E=obj.Sheet.E(num(i,1),1)*adjust2;
            Mat{i,1}.a=obj.Sheet.a(num(i,1),1)*1e-6;
            Mat{i,1}.FKM.RmN=obj.Sheet.FKM_RmN(num(i,1),1)*adjust2;
            Mat{i,1}.FKM.ReN=obj.Sheet.FKM_ReN(num(i,1),1)*adjust2;
            Mat{i,1}.FKM.A=obj.Sheet.FKM_A(num(i,1),1)/100;
            Mat{i,1}.FKM.deffN=obj.Sheet.FKM_deffN(num(i,1),1);
            Mat{i,1}.FKM.fsigma=obj.Sheet.FKM_fsigma(num(i,1),1);
            Mat{i,1}.FKM.ftau=obj.Sheet.FKM_ftau(num(i,1),1);
            Mat{i,1}.FKM.fwsigma=obj.Sheet.FKM_fwsigma(num(i,1),1);
            Mat{i,1}.FKM.fwtau=obj.Sheet.FKM_fwtau(num(i,1),1);
            Mat{i,1}.FKM.adm=obj.Sheet.FKM_adm(num(i,1),1);
            Mat{i,1}.FKM.adp=obj.Sheet.FKM_adp(num(i,1),1);
        end
    case 'Composite'
        Mat=cell(size(num,1),1);
        for i=1:size(num,1)
            Mat{i,1}.ID=obj.Sheet.No(num(i,1),1);
            Mat{i,1}.Name=obj.Sheet.Name{num(i,1),1};
            Mat{i,1}.Vf=obj.Sheet.Vf(num(i,1),1);
            Mat{i,1}.Dens=obj.Sheet.Density(num(i,1),1)*adjust1;
            Mat{i,1}.E1=obj.Sheet.E1(num(i,1),1)*adjust2;
            Mat{i,1}.E2=obj.Sheet.E2(num(i,1),1)*adjust2;
            Mat{i,1}.E3=obj.Sheet.E3(num(i,1),1)*adjust2;
            Mat{i,1}.G12=obj.Sheet.G12(num(i,1),1)*adjust2;
            Mat{i,1}.G23=obj.Sheet.G23(num(i,1),1)*adjust2;
            Mat{i,1}.G13=obj.Sheet.G13(num(i,1),1)*adjust2;
            Mat{i,1}.v12=obj.Sheet.v12(num(i,1),1);
            Mat{i,1}.v23=obj.Sheet.v23(num(i,1),1);
            Mat{i,1}.v13=obj.Sheet.v13(num(i,1),1);
            Mat{i,1}.a1=obj.Sheet.a1(num(i,1),1)*1e-6;
            Mat{i,1}.a2=obj.Sheet.a2(num(i,1),1)*1e-6;

            Mat{i,1}.allowables.F1t=obj.Sheet.F1t(num(i,1),1)*adjust2;
            Mat{i,1}.allowables.F2t=obj.Sheet.F2t(num(i,1),1)*adjust2;
            Mat{i,1}.allowables.F3t=obj.Sheet.F3t(num(i,1),1)*adjust2;
            Mat{i,1}.allowables.F1c=obj.Sheet.F1c(num(i,1),1)*adjust2;
            Mat{i,1}.allowables.F2c=obj.Sheet.F2c(num(i,1),1)*adjust2;
            Mat{i,1}.allowables.F3c=obj.Sheet.F3c(num(i,1),1)*adjust2;
            Mat{i,1}.allowables.F4=obj.Sheet.F4(num(i,1),1)*adjust2;
            Mat{i,1}.allowables.F5=obj.Sheet.F6(num(i,1),1)*adjust2;
            Mat{i,1}.allowables.F6=obj.Sheet.F6(num(i,1),1)*adjust2;

            Mat{i,1}.allowables.Fe1t=Mat{i,1}.allowables.F1t/Mat{i,1}.E1;
            Mat{i,1}.allowables.Fe2t=Mat{i,1}.allowables.F2t/Mat{i,1}.E2;
            Mat{i,1}.allowables.Fe3t=Mat{i,1}.allowables.F3t/Mat{i,1}.E3;
            Mat{i,1}.allowables.Fe1c=Mat{i,1}.allowables.F1c/Mat{i,1}.E1;
            Mat{i,1}.allowables.Fe2c=Mat{i,1}.allowables.F2c/Mat{i,1}.E2;
            Mat{i,1}.allowables.Fe3c=Mat{i,1}.allowables.F3c/Mat{i,1}.E3;
            Mat{i,1}.allowables.Fe4=Mat{i,1}.allowables.F4/Mat{i,1}.G23;
            Mat{i,1}.allowables.Fe5=Mat{i,1}.allowables.F5/Mat{i,1}.G13;
            Mat{i,1}.allowables.Fe6=Mat{i,1}.allowables.F6/Mat{i,1}.G12;

            Mat{i,1}.allowables.XZIT=obj.Sheet.XZIT(num(i,1),1);
            Mat{i,1}.allowables.XZIC=obj.Sheet.XZIC(num(i,1),1);
            Mat{i,1}.allowables.YZIT=obj.Sheet.YZIT(num(i,1),1);
            Mat{i,1}.allowables.YZIC=obj.Sheet.YZIC(num(i,1),1);
        end
   
    case 'FEA'
        Mat=cell(size(num,1),1);
        for i=1:size(num,1)
            Mat{i,1}.ID=obj.Sheet.No(num(i,1),1);
            Mat{i,1}.Name=obj.Sheet.Name{num(i,1),1};
            Mat{i,1}.Dens=obj.Sheet.Density(num(i,1),1)*adjust1;
            Mat{i,1}.v=obj.Sheet.v(num(i,1),1);
            Mat{i,1}.E=obj.Sheet.E(num(i,1),1)*adjust2;
            Mat{i,1}.a=obj.Sheet.a(num(i,1),1)*1e-6;
        end
    case 'Magnetic'
        Mat=cell(size(num,1),1);
        for i=1:size(num,1)
            Mat{i,1}.ID=obj.Sheet.No(num(i,1),1);
            Mat{i,1}.Name=obj.Sheet.Name{num(i,1),1};
            Mat{i,1}.Dens=obj.Sheet.Density(num(i,1),1)*adjust1;
            Mat{i,1}.v=obj.Sheet.v(num(i,1),1);
            Mat{i,1}.E=obj.Sheet.E(num(i,1),1)*adjust2;
            Mat{i,1}.a=obj.Sheet.a(num(i,1),1)*1e-6;
            Mat{i,1}.Mux=obj.Sheet.Mu_x(num(i,1),1);
            Mat{i,1}.Muy=obj.Sheet.Mu_y(num(i,1),1);
            Mat{i,1}.Hc=obj.Sheet.H_c(num(i,1),1);% A/m -> mA/mm
            Mat{i,1}.Sigma=obj.Sheet.Sigma(num(i,1),1)*adjust3;% S/m -> S/mm
            Mat{i,1}.d_lam=obj.Sheet.d_lam(num(i,1),1);% mm
            Mat{i,1}.LamFill=obj.Sheet.LamFill(num(i,1),1);
            Mat{i,1}.Phi_h=obj.Sheet.Phi_h(num(i,1),1);
            Mat{i,1}.LamType=obj.Sheet.LamType(num(i,1),1);
            Mat{i,1}.NStrands=obj.Sheet.NStrands(num(i,1),1);
            Mat{i,1}.Phi_hx=obj.Sheet.Phi_hx(num(i,1),1);
            Mat{i,1}.Phi_hy=obj.Sheet.Phi_hy(num(i,1),1);
            Mat{i,1}.WireD=obj.Sheet.WireD(num(i,1),1);
            Temp=obj.Sheet.BHPoints(num(i,1),1);
            if size(Temp{1,1},2)==2
                Mat{i,1}.BHPoints=Temp{1,1};
            end
        end
    case 'Lubricant'
        Mat=cell(size(num,1),1);
        for i=1:size(num,1)
            Mat{i,1}.Name=obj.Sheet.Name{num(i,1),1};
            Mat{i,1}.v40=obj.Sheet.v40(num(i,1),1);
            Mat{i,1}.v100=obj.Sheet.v100(num(i,1),1);
            Mat{i,1}.Dens=obj.Sheet.Dens(num(i,1),1);
        end
end


%% Print
if obj.Echo
    fprintf('Successfully get material properties .\n');
end

end

