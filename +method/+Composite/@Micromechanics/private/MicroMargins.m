function [MoS, props] = MicroMargins(Criterion, props, Results_Mech, MoS)

if isfield(props, 'RUC')
    RUC = props.RUC;
else % -- For MOC, create and store 2x2 RUC
    RUC.NB = 2;
    RUC.NG = 2;
    RUC.mats = [props.Fiber.ID, props.Matrix.ID; ...
                props.Matrix.ID, props.Matrix.ID];
    RUC.matsCh = ['F', 'M'; 'M', 'M'];
    RUC.Vf = props.Vf;
    RUC.id = 2;
    RUC.h(1) = sqrt(props.Vf);
    RUC.h(2) = 1-RUC.h(1);
    RUC.l = RUC.h; 
    props.RUC = RUC;
end

% -- If a material doesn't have allowables, set them to +/-1.E99 
if ~isfield(props.Fiber,'allowables')
    [props.Fiber] = SetAllowablesHigh(props.Fiber);
end

if ~isfield(props.Matrix,'allowables')
    [props.Matrix] = SetAllowablesHigh(props.Matrix);
end

if isfield(props,'Interface')
    if ~isempty(props.Interface)
        if ~isfield(props.Interface,'allowables')
            [props.Interface] = SetAllowablesHigh(props.Interface);
        end
    end
end


Micro_Mech = Results_Mech;

if Micro_Mech.Type == "FM" % -- Voigt, Reuss, or MT (avg fields)
    Micro_Th.MicroFieldsF.stress = zeros(6,1);
    Micro_Th.MicroFieldsF.strain = zeros(6,1);
    Micro_Th.MicroFieldsF.thstrain = zeros(6,1);
    Micro_Th.MicroFieldsM.stress = zeros(6,1);
    Micro_Th.MicroFieldsM.strain = zeros(6,1);
    Micro_Th.MicroFieldsM.thstrain = zeros(6,1);
    Micro_Mech.MicroFieldsF.strain = Micro_Mech.MicroFieldsF.strain - Micro_Mech.MicroFieldsF.thstrain;
    Micro_Mech.MicroFieldsM.strain = Micro_Mech.MicroFieldsM.strain - Micro_Mech.MicroFieldsM.thstrain;
else % -- Subcell fields
    for b = 1:RUC.NB
        for g = 1:RUC.NG
            Micro_Th.MicroFields(b,g).stress = zeros(6,1);
            Micro_Th.MicroFields(b,g).strain = zeros(6,1);
            Micro_Th.MicroFields(b,g).thstrain = zeros(6,1);
            Micro_Mech.MicroFields(b,g).strain = Micro_Mech.MicroFields(b,g).strain - Micro_Mech.MicroFields(b,g).thstrain;
        end
    end
end



if Micro_Mech.Type == "FM" % -- Voigt, Reuss, or MT (avg fields)

     if isfield(props.Fiber,'allowables')
        MicroMechStrainF = Micro_Th.MicroFieldsF.strain - Micro_Th.MicroFieldsF.thstrain; % Max strain criterion based on mechanical strain, not total
        inputStruct.Stress=Micro_Mech.MicroFieldsF.stress';
        inputStruct.Strain=MicroMechStrainF';
        inputStruct.Material=props.Fiber;
        paramsStruct.Method=Criterion;
        paramsStruct.Echo=0;
        SC= method.Composite.StrengthCriterion(paramsStruct, inputStruct);
        SC=SC.solve();
        MoS.MicroF=SC.output.minR-1;
        % if MoS.MicroF>1
        %     MoS.MicroFFailed=false;
        % else
        %     MoS.MicroFFailed=true;
        % end

        % [MoS.MicroF] = FCriteria(Micro_Mech.MicroFieldsF.stress, Micro_Mech.MicroFieldsF.strain, ...
                                 % Micro_Th.MicroFieldsF.stress, MicroMechStrainF, props.Fiber.allowables, CriteriaOn, true);
     end
     if isfield(props.Matrix,'allowables')
        MicroMechStrainM = Micro_Th.MicroFieldsM.strain - Micro_Th.MicroFieldsM.thstrain; % Max strain criterion based on mechanical strain, not total
        inputStruct.Stress=Micro_Mech.MicroFieldsM.stress';
        inputStruct.Strain=MicroMechStrainM';
        inputStruct.Material=props.Matrix;
        paramsStruct.Method=Criterion;
        paramsStruct.Echo=0;
        SC= method.Composite.StrengthCriterion(paramsStruct, inputStruct);
        SC=SC.solve();
        MoS.MicroM=SC.output.minR-1;
        % if MoS.MicroM>1
        %     MoS.MicroMFailed=false;
        % else
        %     MoS.MicroMFailed=true;
        % end

        % [MoS.MicroM] = FCriteria(Micro_Mech.MicroFieldsM.stress, Micro_Mech.MicroFieldsM.strain, ...
        %                          Micro_Th.MicroFieldsM.stress, MicroMechStrainM, props.Matrix.allowables, CriteriaOn, true);
     end

else % -- Subcell fields
    % MicroMechStrain = zeros(6,1);
    for b = 1:RUC.NB
        for g = 1:RUC.NG         
            if isfield(MoS, 'Micro')
                if isfield(MoS.Micro, 'Failed')
                    if MoS.Micro(b,g).Failed 
                        continue
                    end
                end
            end

            Fid = props.Fiber.ID;
            Mid = props.Matrix.ID;
            if (RUC.mats(b,g) == Fid) && isfield(props.Fiber,'allowables')
                % allowables = props.Fiber.allowables;
                mat=props.Fiber;
                % MicroMechStrain = Micro_Th.MicroFields(b,g).strain - Micro_Th.MicroFields(b,g).thstrain; % Max strain criterion based on mechanical strain, not total
            elseif (RUC.mats(b,g) == Mid) && isfield(props.Matrix,'allowables')
                % allowables = props.Matrix.allowables;
                mat= props.Matrix;
                % MicroMechStrain = Micro_Th.MicroFields(b,g).strain - Micro_Th.MicroFields(b,g).thstrain; % Max strain criterion based on mechanical strain, not total
            elseif isfield(props,'Interface')
                if ~isempty(props.Interface)
                    Iid = props.Interface.ID;
                    if (RUC.mats(b,g) == Iid) && isfield(props.Interface,'allowables')
                        % allowables = props.Interface.allowables;
                        mat=props.Interface;
                        % MicroMechStrain = Micro_Th.MicroFields(b,g).strain - Micro_Th.MicroFields(b,g).thstrain; % Max strain criterion based on mechanical strain, not total
                    end
                end
            else
                continue;
            end
            
            if ~isfield(MoS, 'Micro')

                inputStruct.Stress=Micro_Mech.MicroFields(b,g).stress';
                inputStruct.Strain=Micro_Mech.MicroFields(b,g).strain';
                inputStruct.Material=mat;
                paramsStruct.Method=Criterion;
                paramsStruct.Echo=0;
                SC= method.Composite.StrengthCriterion(paramsStruct, inputStruct);
                SC=SC.solve();
                MoS.Micro(b,g).MinMoS=SC.output.minR-1;
                MoS.Micro(b,g).MoS=SC.output.R-1;

                % [MoS.Micro(b,g)] = FCriteria(Micro_Mech.MicroFields(b,g).stress, Micro_Mech.MicroFields(b,g).strain, ...
                                   % Micro_Th.MicroFields(b,g).stress, MicroMechStrain, allowables, CriteriaOn, true);
            else
                % aa = size(MoS.Micro);
                % if aa(1) < b || aa(2) < g
                    inputStruct.Stress=Micro_Mech.MicroFields(b,g).stress';
                    inputStruct.Strain=Micro_Mech.MicroFields(b,g).strain';
                    inputStruct.Material=mat;
                    paramsStruct.Method=Criterion;
                    paramsStruct.Echo=0;
                    SC= method.Composite.StrengthCriterion(paramsStruct, inputStruct);
                    SC=SC.solve();
                    MoS.Micro(b,g).MinMoS=SC.output.minR-1;
                    MoS.Micro(b,g).MoS=SC.output.R-1;

                    % [MoS.Micro(b,g)] = FCriteria(Micro_Mech.MicroFields(b,g).stress, Micro_Mech.MicroFields(b,g).strain, ...
                    %                    Micro_Th.MicroFields(b,g).stress, MicroMechStrain, allowables, CriteriaOn, true);
                % else
                    % [MoS.Micro(b,g)] = FCriteria(Micro_Mech.MicroFields(b,g).stress, Micro_Mech.MicroFields(b,g).strain, ...
                                       % Micro_Th.MicroFields(b,g).stress, MicroMechStrain, allowables, CriteriaOn, true, MoS.Micro(b,g));
                % end
            end
            
        end
    end
end  


end

%**************************************************************************
%**************************************************************************

function [Mat] = SetAllowablesHigh(Mat)

% -- Set allowables to +/-1.E99 for materials with no allowabled specified

    Mat.allowables.F1t = 1.E99;
    Mat.allowables.F1c = 1.E99;
    Mat.allowables.F2t = 1.E99;
    Mat.allowables.F2c = 1.E99;
    Mat.allowables.F3t = 1.E99;
    Mat.allowables.F3c = 1.E99;
    Mat.allowables.F4 = 1.E99;
    Mat.allowables.F5 = 1.E99;
    Mat.allowables.F6 = 1.E99;
    Mat.allowables.Fe1t = 1.E99;
    Mat.allowables.Fe1c= 1.E99;
    Mat.allowables.Fe2t = 1.E99;
    Mat.allowables.Fe2c= 1.E99;
    Mat.allowables.Fe3t = 1.E99;
    Mat.allowables.Fe3c= 1.E99;
    Mat.allowables.Fe4 = 1.E99;
    Mat.allowables.Fe5 = 1.E99;
    Mat.allowables.Fe6 = 1.E99;

end
