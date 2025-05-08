function obj=CalcLamMargins(obj,Plymat,LamResults,Geometry)
% Calculate safety of laminate
% Author : Xie Yu


% -- Determine if need to do MoS calcs based on presence of allowables
% DoMicroMargins = false;

LamResults_Mech = LamResults;
LamResults_Th.MCstress = zeros(6,2*Geometry.N);
LamResults_Th.MCstrain = zeros(6,2*Geometry.N);
LamResults_Th.Micro(1:2*Geometry.N) = 0;


%% Claculate ply margin
MoSControllingZPt = 0;
MinMoS = 99999;
MoSmin=NaN(2*Geometry.N,1);
SFmin=NaN(2*Geometry.N,1);

% -- Loop through points in each ply
for kk = 1:2*Geometry.N

    k = round(kk/2);
    mat = Plymat{k};

    if isfield(mat,'allowables')

        stress = zeros(6,1);
        stress(1) = LamResults_Mech.MCstress(1, kk);
        stress(2) = LamResults_Mech.MCstress(2, kk);
        stress(6) = LamResults_Mech.MCstress(3, kk);

        strain = zeros(6,1);
        strain(1) = LamResults_Mech.MCstrain(1, kk);
        strain(2) = LamResults_Mech.MCstrain(2, kk);
        strain(6) = LamResults_Mech.MCstrain(3, kk);

        inputStruct.Stress=stress';
       inputStruct.Strain=strain';
        inputStruct.Material=mat;
        paramsStruct.Method=obj.params.Criterion;
        paramsStruct.Echo=0;
        SC= method.Composite.StrengthCriterion(paramsStruct, inputStruct);
        SC=SC.solve();

        MoSmin(kk,1)=SC.output.minR-1;
        SFmin(kk,1)=SC.output.minR;
        MoS(kk,:)=SC.output.R-1; %#ok<AGROW>
        SF(kk,:)=SC.output.R; %#ok<AGROW>

        % -- Check if this point is controlling so far
        if MoS(kk,1)< MinMoS
            MinMoS = MoS(kk,1);
            MoSControllingZPt = kk;
        end

    end

end

obj.output.Safety.MoS = MoS;
obj.output.Safety.MoSControllingZPt = MoSControllingZPt;
obj.output.Safety.SF = SF;
obj.output.Safety.MoSmin = MoSmin;
obj.output.Safety.SFmin = SFmin;
obj.capacity.SF1 = min(SFmin);
end