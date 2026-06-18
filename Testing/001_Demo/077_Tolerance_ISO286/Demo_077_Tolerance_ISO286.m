%% Demo Tolerance_ISO286
% 1. Single fit analysis (H7/g6)
% 2. Compare different shaft fits with H7 hole

clc
clear
close all
flag=2;
DemoTolerance_ISO286(flag);

function DemoTolerance_ISO286(flag)
switch flag
    case 1
        % H7/g6 clearance fit, D=25 mm
        inputStruct.NominalSize=25;
        inputStruct.HoleTolerance='H7';
        inputStruct.ShaftTolerance='g6';
        paramsStruct.Echo=1;
        paramsStruct.Unit='um';
        Tol=method.Tolerance_ISO286(paramsStruct, inputStruct);
        Tol=Tol.solve();
        disp(Tol.output.Hole)
        disp(Tol.output.Shaft)
        disp(Tol.output.Fit)

    case 2
        % Compare different shaft fits with H7 hole
        NominalSize=25;
        HoleTolerance='H7';
        ShaftFits={'g6','h6','k6','n6','p6'};
        nFit=length(ShaftFits);
        MaxC=NaN(nFit,1);
        MinC=NaN(nFit,1);

        for i=1:nFit
            inputStruct.NominalSize=NominalSize;
            inputStruct.HoleTolerance=HoleTolerance;
            inputStruct.ShaftTolerance=ShaftFits{i};
            paramsStruct.Echo=0;
            paramsStruct.Unit='um';
            Tol=method.Tolerance_ISO286(paramsStruct, inputStruct);
            Tol=Tol.solve();
            MaxC(i)=Tol.output.Fit.MaxClearance;
            MinC(i)=Tol.output.Fit.MinClearance;
        end

        figure
        hold on
        b=bar([MaxC, MinC]*1000);
        b(1).FaceColor=[0.2 0.6 0.8];
        b(2).FaceColor=[0.9 0.4 0.3];
        set(gca,'XTickLabel',ShaftFits)
        xlabel('Shaft Tolerance')
        ylabel('Clearance / Interference (um)')
        title('H7 Hole with Different Shaft Fits')
        legend('Max clearance','Min clearance')
        grid on
        hold off
end
end
