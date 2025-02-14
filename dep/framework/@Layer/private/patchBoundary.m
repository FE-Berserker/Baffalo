function [varargout]=patchBoundary(varargin)

%function [Eb,E,indBoundary]=patchBoundary(F)
%-------------------------------------------------------------------------
%
% 
%
% Change log: 
% 2018/10/08 Expanded to handle cell input for F
% 2021/07/30
% 2021/10/08 Simplified, especially cell handling
% 2021/10/08 No longer needs vertices as input
%-------------------------------------------------------------------------

%% Parse input

switch nargin
    case 1
        F=varargin{1};
    case 2
        F=varargin{1};
%         warning('Second input (vertices) no longer required. Update code to avoid future error.');
end

%% Get boundary edges

% Get non-unique edges
E=patchEdges(F,0);
   
% Get boundary edge indices
Es=sort(E,2); %Sort so edges with same nodes have the same rows
[~,~,~,countUse]=cunique(Es,'rows'); %Count occurances
logicBoundary=countUse==1;

% Boundary edges
Eb=E(logicBoundary,:);

%% Gather output
varargout{1}=Eb; %Boundary edges
varargout{2}=E; %All edges
if nargout==3
    varargout{3}=find(logicBoundary); %Indices for boundary edges
end
