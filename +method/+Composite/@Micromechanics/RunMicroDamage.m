function obj = RunMicroDamage(obj)
% Run micro damage problem
E=1;S=2;
Loads=obj.input.Load;
Loads.E = E;
Loads.S = S;

% -- Store initial eff props and RUC -- this will get changed when damage occurs
effprops_init = obj.output.Plyprops;
effprops=effprops_init;

% -- Specifed loads are final values for incremental loading
Loads.Final = Loads.Value;

% -- Prog dam not enabled for MOC or MOCu -- these are implemented for fiber/matrix not
%    different materials per matrix subcell
if effprops_init.micro == "MOC" ||effprops_init.micro == "MOCu"
    error('Progressive damage not implemented for MOC and MOCu')
end

%% Create Damaged Constituents
DamageFactor = obj.params.DamageFactor; % -- Stiffness reduction factor for damaged material
[effprops.FiberDam] = DamageConstit(effprops_init.Fiber, DamageFactor);
[effprops.MatrixDam] = DamageConstit(effprops_init.Matrix, DamageFactor);

if isfield(effprops_init,'Interface')
    if ~isempty(effprops_init.Interface)
        [effprops.InterfaceDam] = DamageConstit(effprops_init.Interface, DamageFactor);
    end
end

% -- Default to 100 increments if NINC not specified
if ~isfield(Loads, 'NINC')
    Loads.NINC = 100;
end

% Intial Damage Result Table
INC=[];
ITER=[];
Strain11=[];
Stress11=[];
Strain22=[];
Stress22=[];
Strain33=[];
Stress33=[];
Strain23=[];
Stress23=[];
Strain13=[];
Stress13=[];
Strain12=[];
Stress12=[];

E11=[];
E22=[];
E33=[];
v12=[];
v13=[];
v23=[];
G12=[];
G13=[];
G23=[];
alpha1=[];
alpha2=[];
alpha3=[];



DamageResult.StressStrain=table(INC,ITER,Strain11,Stress11,Strain22,Stress22,Strain33,Stress33,...
    Strain23,Stress23,Strain13,Stress13,Strain12,Stress12);
DamageResult.Property=table(INC,ITER,E11,E22,E33,...
    v12,v13,v23,...
    G12,G13,G23,...
    alpha1,alpha2,alpha3);

% -------------------------
% -- Loading increment loop
% -------------------------
INC = -1;
INCcount = 0;
while INC < Loads.NINC

    INC = INC + 1;
    INCcount = INCcount + 1;
    OutInfo.INC = INC;

    % -- Determine current load level
    pct = INC/Loads.NINC;
    Loads.Value = pct*Loads.Final;

    % -- Display increment progress
    disp(' ');
    disp('*****************************************************');
    disp(['* INC = ',num2str(INC), '  out of ', num2str(Loads.NINC)]);
    disp('*****************************************************');

    % -----------------
    % -- Iteration Loop
    % -----------------
    NITER = 1000000000; % -- Max number of iterations
    for ITER = 1:NITER

        % -- Display iteration progress
        disp(' ');
        disp(['----- ITER = ', char(num2str(ITER)), ' -----']);
        OutInfo.ITER = ITER;

        %-----------------------------------------------------------------
        % Solve loading and calculate local fields for micromechanics
        %-----------------------------------------------------------------

        [SG, FullGlobalStrain] = SolveLoading(6, effprops.Cstar, [0;0;0;0;0;0], Loads);

        if ~exist('Results', 'var')
            [Results] = MicroFields(FullGlobalStrain, 0, effprops);
        else
            [Results] = MicroFields(FullGlobalStrain, 0, effprops, Results);
        end
        epsth=[0;0;0;0;0;0];
        Stress = effprops.Cstar*(FullGlobalStrain -epsth);

        %------------------------------------------------------------------
        % Write initial micromechanics properties and write/plot results
        %------------------------------------------------------------------

        if INC == 0
            % effprops{mat}.Mat = mat;
            
            % [OutInfo] = OutputMicro(OutInfo, NP, effprops, Loads, SG, FullGlobalStrain, epsth, true);

            % -- Inverse of Cstar
            CstarInv = inv(effprops.Cstar);

            % -- Store initial trace(inv Cstar) - used as global compliance measure
            InitTraceCI = CstarInv(1,1) + CstarInv(2,2) + CstarInv(3,3);
            TraceCI = InitTraceCI;
        end

        % -- Loads.PlotComponent can be specified in MicroProblemDef.m, or
        %    will plot applied direction if only 1 component applied
        if isfield(Loads, 'PlotComponent')
            PlotComponent = Loads.PlotComponent;
        else
            PlotComponent = 2;
            for i = 1: 6
                if Loads.Final(i) ~= 0
                    PlotComponent = i;
                    break;
                end
            end
        end

        % -- Store global stress and strain history
        strainhist(INCcount) = FullGlobalStrain(PlotComponent);
        stresshist(INCcount) = Stress(PlotComponent);
        % fullhist(INCcount).Stress = Stress;
        % fullhist(INCcount).Strain = FullGlobalStrain;
        if INC == 0
            damfig = 0;
            Results.MoS.NewFailure = false;
        end

        % -- Function (included below) to write damage results
        % [damfig, strainhist, stresshist, OutInfo] = DamageWrite(NP, OutInfo, effprops{mat}, Results{NP}, Stress, FullGlobalStrain, INC, ...
        %     ITER, strainhist, stresshist, fullhist, damfig);
        [damfig, strainhist, stresshist,DamageResult] = ...
            DamageWrite(DamageResult, effprops, Results, Stress, FullGlobalStrain, INC, ...
            ITER, strainhist, stresshist, damfig);


        % -- Stop execution for if TraceCI exceeds termination factor
        if isfield(Loads, 'TerminationFactor')
            factor = Loads.TerminationFactor;
        else
            factor = 50000; % -- Defaults to very high factor
        end
        if TraceCI/InitTraceCI > factor
            INC = Loads.NINC + 1;
            break
        end

        %-----------------------------------------------------------------
        % Calculate Margins
        %-----------------------------------------------------------------
        % -- Check for turning off some failure criteria (Tsai-Wu only by default, 0 = off)
        % if (~isfield(Loads{NP},'CriteriaOn'))
        %     Loads{NP}.CriteriaOn = [0,0,0,1];
        % end
        % [Results] = CalcMicroMargin(effprops, Loads, Results, true);
        [Results] = CalcMicroMargin(effprops, Results,obj.params.Criterion);


        % -- Initialize failure flags
        if INC == 0
            if Results.Type == "FM"
                Temp1=Results.MoS.MicroF;
                Temp2=Results.MoS.MicroM;
                Results.MoS.MicroF=[];
                Results.MoS.MicroM=[];

                Results.MoS.MicroF.MinMoS=Temp1;
                Results.MoS.MicroM.MinMoS=Temp2;

                Results.MoS.MicroF.Failed = false;
                Results.MoS.MicroM.Failed = false;
            else
                for b = 1: effprops.RUC.NB
                    for g = 1: effprops.RUC.NG
                        Results.MoS.Micro(b,g).Failed = false;
                    end
                end
            end
        else
            if Results.Type == "FM"
                Temp1=Results.MoS.MicroF;
                Temp2=Results.MoS.MicroM;
                Results.MoS.MicroF=[];
                Results.MoS.MicroM=[];

                Results.MoS.MicroF.MinMoS=Temp1;
                Results.MoS.MicroM.MinMoS=Temp2;

                if Temp1<0
                    Results.MoS.MicroF.Failed = true;
                else
                    Results.MoS.MicroF.Failed = false;
                end

                if Temp2<0
                    Results.MoS.MicroM.Failed = true;
                else
                    Results.MoS.MicroM.Failed = false;
                end
            end
        end

        %-----------------------------------------------------------------------------
        % Reduce stiffness of any damaged subcell (those within a tolerance of the
        %    min negative margin)
        %-----------------------------------------------------------------------------
        [effprops, Results.MoS] = DamageMicro(obj,effprops, Results.MoS);

        % -- Find min MoS to skip (jump) increments
        CheckForSkip = true;
        if ITER ~= 1
            CheckForSkip = false;
        elseif isfield(Results.MoS, 'NewFailure')
            if Results.MoS.NewFailure
                CheckForSkip = false;
            end
        end

        if CheckForSkip
            MinMoS = 99998;
            if Results.Type == "FM"
                if isfield(Results.MoS.MicroF, 'MinMoS')
                    MinMoS = min(MinMoS, Results.MoS.MicroF.MinMoS);
                end
                if isfield(Results.MoS.MicroM, 'MinMoS')
                    MinMoS = min(MinMoS, Results.MoS.MicroM.MinMoS);
                end
            else
                for b = 1: effprops.RUC.NB
                    for g = 1: effprops.RUC.NG

                        if ~isfield(Results.MoS.Micro(b,g), 'MinMoS')
                            continue;
                        end

                        if isfield(Results.MoS.Micro(b,g), 'Failed')
                            if Results.MoS.Micro(b,g).Failed
                                continue;
                            else
                                MinMoS = min(MinMoS, Results.MoS.Micro(b,g).MinMoS);
                            end
                        else
                            MinMoS = min(MinMoS, Results.MoS.Micro(b,g).MinMoS);
                        end
                    end
                end
            end

            disp(['  MinMoS = ',char(num2str(MinMoS))]);

            % -- Step out to just before increment where next damage should occur
            %    if MinMoS is positive (no additional failures)
            if MinMoS > 0 && MinMoS < 99998 && INC < Loads.NINC
                INC_JUMP = round( INC*( (MinMoS + 1) - 1) );
                disp(['  INC_JUMP = ', char(num2str(INC_JUMP))]);
                if INC_JUMP > 2
                    INC = INC + INC_JUMP - 2;
                    % -- Jump to final increment if will no more damage will occur
                    if INC > Loads.NINC - 1
                        INC = Loads.NINC - 1;
                    end
                    break;
                end
            elseif MinMoS == 99998 && INC > 10 && INC < Loads.NINC
                INC = Loads.NINC - 1;
                break;
            end
        end

        % -- Inverse of Cstar
        CstarInv = inv(effprops.Cstar);

        % -- Check for large stiffness drop (Cinv increase)
        TraceCI = CstarInv(1,1) + CstarInv(2,2) + CstarInv(3,3);

        disp(['  --> Cinv Trace Factor = ',char(num2str(TraceCI/InitTraceCI))]);

        % -- Exit iteration loop if no new failure
        if ~Results.MoS.NewFailure
            break
        end

    end % -- End Iteration Loop

end % -- End Increment Loop
obj.output.DamageResult=DamageResult;
% -- This will overwrite the plot each ITER for a given INC, so left with final
Plotname = ['Damage Snapshot  - ', 'INC = ', char(num2str(INC)),' FINAL','.bmp'];
saveas(gcf,Plotname);
end

function [damfig, strainhist, stresshist,DamageResult] = ...
    DamageWrite(DamageResult, props, Results, Stress, FullGlobalStrain, INC, ...
                ITER, strainhist, stresshist, damfig)

% -- Write and plot progressive damage results as damage progresses
warning off
MoS = Results.MoS;
if isfield(Results, 'MicroFields')
    MicroFields = Results.MicroFields;
end

row=size(DamageResult.StressStrain,1)+1;
T1=DamageResult.StressStrain;
T2=DamageResult.Property;
T1{row,1}=INC;
T1{row,2}=ITER;
T1{row,3}=FullGlobalStrain(1);T1{row,4}=Stress(1);
T1{row,5}=FullGlobalStrain(2);T1{row,6}=Stress(2);
T1{row,7}=FullGlobalStrain(3);T1{row,8}=Stress(3);
T1{row,9}=FullGlobalStrain(4);T1{row,10}=Stress(4);
T1{row,11}=FullGlobalStrain(5);T1{row,12}=Stress(5);
T1{row,13}=FullGlobalStrain(6);T1{row,14}=Stress(6);

T2{row,1}=INC;
T2{row,2}=ITER;
T2{row,3}=props.E1;T2{row,4}=props.E2;T2{row,5}=props.E3;
T2{row,6}=props.v12;T2{row,7}=props.v13;T2{row,8}=props.v23;
T2{row,9}=props.G12;T2{row,10}=props.G13;T2{row,11}=props.G23;
T2{row,12}=props.a1;T2{row,13}=props.a2;T2{row,14}=props.a3;

DamageResult.StressStrain=T1;
DamageResult.Property=T2;


% -- Plot stress vs. strain
if INC == 0
    damfig = figure('units','normalized','outerposition',[0 0.5 1 0.5]);
else
    figure(damfig);
    subplot(1,3,1)
    plot(strainhist,stresshist,'-o')
    title('stress vs. strain');
    xlabel('strain'); 
    ylabel('stress (MPa)','rotation',90);
    drawnow
end

% -- Display and save stress-strain plot, local von Mises stress and damage

% -- Only update/write plot when new failure happens
if (MoS.NewFailure || INC == 1) && (props.micro == "GMC" || props.micro == "HFGMC")
% -- Plot/write every increment
%if INC > 0 && (props.micro == "GMC" || props.micro == "HFGMC")

    mats = zeros(2*props.RUC.NB, 2*props.RUC.NG);
    x2 = zeros(1, 2*props.RUC.NB);
    x3 = zeros(1, 2*props.RUC.NG);
    Svm = zeros(2*props.RUC.NB, 2*props.RUC.NG);
    
    % -- Plot vm stress and failed subcells
    for j = 1:2*props.RUC.NG
        g = round(j/2);
        for i = 1:2*props.RUC.NB
            b = round(i/2);
            switch props.RUC.matsCh(b,g)
                case 'F'
                    mats(i,j) = 1;
                case 'M'
                    mats(i,j) = 2;
                case 'I'
                    mats(i,j) = 1.6;
                otherwise
                    mats(i,j) = 3;
            end
        end 
    end 

    % place an x2-point at bottom and top of each subcell
    h = 0;
    i = 1;
    for b = 1:props.RUC.NB
        x2(i) = h;
        h = h + props.RUC.h(b);
        i = i + 1;
        x2(i) = h;
        i = i + 1;
    end

    % place an x3-point at left and right of each subcell
    l = 0;
    i = 1;
    for g = 1:props.RUC.NG
        x3(i) = l;
        l = l + props.RUC.l(g);
        i = i + 1;
        x3(i) = l;
        i = i + 1;
    end
    
   % -- Create grid
    [X,Y] = meshgrid(x3,x2);

   % -- Calc von Mises stress
    for j = 1:2*props.RUC.NG
        g = round(j/2);
        for i = 1:2*props.RUC.NB
            b = round(i/2);
            stress = MicroFields(b,g).stress;
            Svm(i,j) = sqrt( (stress(1) - stress(2))^2 + ...
                             (stress(2) - stress(3))^2 + ...
                             (stress(1) - stress(3))^2 + ...
                              6*stress(4)^2 + ...
                              6*stress(5)^2 + ...
                              6*stress(6)^2 ) / sqrt(2);
        end 
    end 

    % --- Plot von Mises ---
    subplot(1,3,2)
    colormap(jet);
    pcolor( X, Y, Svm), shading interp;
    %pcolor( X, Y, Svm), shading faceted;
    fontsize = 12;
    c=colorbar;
    c.FontSize=fontsize;
    c.FontWeight='bold';
    title(['von Mises stress, INC = ',char(num2str(INC)),' ITER = ',char(num2str(ITER))],'FontSize',fontsize);
    set (gca,'FontSize',fontsize,'FontWeight','bold','LineWidth',2)
    axis image;
    axis off; 
    drawnow

    % --- Plot damage ---
    subplot(1,3,3)
    colormap(jet);
    %pcolor( X, Y, mats), shading interp;
    pcolor( X, Y, mats), shading faceted;
    clim([1 3]);
    fontsize = 12;
    c.FontSize=fontsize;
    c.FontWeight='bold';
    title(['Subcell Failure, INC = ',char(num2str(INC)),' ITER = ',char(num2str(ITER))],'FontSize',fontsize);
    set (gca,'FontSize',fontsize,'FontWeight','bold','LineWidth',2)
    axis image;
    axis off; 
    drawnow
end

% -- Save damage snapshot figure


if ITER >= 2
    Plotname = ['Initiation Location Damage Snapshot  - ', 'INC = ', char(num2str(INC)), ' ITER = ', char(num2str(ITER)),'.bmp'];
    saveas(gcf,Plotname);
    OutInfo.PlottedInit = true;
end



warning on
end

