function [P]=patchSmooth(F,V,IND_V,optionStruct)

% function [P]=patchSmooth(F,V,IND_V,optionStruct)
% ------------------------------------------------------------------------
%
%
% Kevin Mattheus Moerman
% 2014/06/02
% 2023/04/26 Switch to use structComplete for input handling, which is
% clearer and more concise
%------------------------------------------------------------------------

%%

%Set default structure
defaultOptionStruct.n=1; %Number of smoothing iterations
defaultOptionStruct.Method='LAP'; %Smoothing method
defaultOptionStruct.RigidConstraints=[]; %Indicices for nodes to hold on to

%Complement input with default if missing
[optionStruct]=structComplete(optionStruct,defaultOptionStruct,1);

if isempty(IND_V)
    [~,IND_V]=patchIND(F,V,2);
end

%%

smoothMethod=optionStruct.Method;

%Smooth
switch smoothMethod
    case 'LAP' %Laplacian
        [P]=tesSmooth_LAP(F,V,IND_V,optionStruct);
    otherwise
        error('Invalid smooth method specified');        
end
 

