function [Results, props] = CalcMicroMargin(props, Results,Criterion)
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Copyright 2020 United States Government as represented by the Administrator of the 
% National Aeronautics and Space Administration. No copyright is claimed in the 
% United States under Title 17, U.S. Code. All Other Rights Reserved. BY DOWNLOADING 
% OR USING THIS SOFTWARE, YOU ACKNOWLEDGE THAT YOU HAVE READ THE NASA OPEN SOURCE 
% AGREEMENT V1.3, THAT YOU UNDERSTAND IT, AND THAT YOU AGREE TO BE BOUND BY ITS 
% TERMS. IF YOU DO NOT AGREE TO THE TERMS AND CONDITIONS OF THIS AGREEMENT, DO NOT 
% USE OR DOWNLOAD THE SOFTWARE. THIS SOFTWARE IS PROVIDED AS IS WITHOUT ANY WARRANTY 
% OF ANY KIND. RECIPIENT AGREES TO WAIVE ANY AND ALL CLAIMS AGAINST, AND INDEMNIFIES 
% AND HOLDS HARMLESS, THE UNITED STATES GOVERNMENT, ITS CONTRACTORS AND 
% SUBCONTRACTORS, AS WELL AS ANY PRIOR RECIPIENT. This code was prepared by Drs. 
% B.A. Bednarcyk and S.M. Arnold to complement the book 揚ractical Micromechanics of 
% Composite Materials� during the course of their government work.
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Purpose: Divides stand-alone micromechanics thermomechanical problems into separate  
%          thermal and mechanical load cases and determines the local fields for use 
%          in calculating margins of safety
% Input:
% - props: struct containing material properties
% - Loads: Struct containing problem loading information
% - Results: Struct containing micromechanics analysis results
% - Damage: Flag indicating if problem involves prog. damage (Chapter 7)
% Output:
% - Results: Updated struct containing micromechanics analysis results
% - props: Updated struct containing material properties
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

% -- Determine if need to do MoS calcs based on presence of allowables
DoMicroMargins = false;
if isfield(props,'micro')
    if isfield(props.Fiber,'allowables') || isfield(props.Matrix,'allowables')
        DoMicroMargins = true;
    elseif isfield(props, 'Interface')
        if isfield(props.Interface, 'allowables')
            DoMicroMargins = true;
        end
    end
end

% -- Return if no allowables specified
if ~DoMicroMargins
   Results.MicroMoS = false;
   return 
end


Results_Mech = Results;

% -- Retain Results.MoS if it exists
if isfield(Results, 'MoS') 
    MoS = Results.MoS;
else
    MoS = struct;
end

% -- Calculate MoS
[MoS, props] = MicroMargins(Criterion, props, Results_Mech, MoS);
Results.MoS = MoS;

if isfield(Results, 'MoS')
    Results.MicroMoS = true;
else
    Results.MicroMoS = false;
end


end

