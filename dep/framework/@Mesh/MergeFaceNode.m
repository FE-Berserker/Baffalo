function [obj,varargout]=MergeFaceNode(obj,varargin)
% Merge mesh face nodes
%% Parse input

switch nargin    
    case 1
        F=obj.Face;
        V=obj.Vert;
        numDigitsMerge=[];
    case 2
        F=obj.Face;
        V=obj.Vert;
        numDigitsMerge=varargin{1};
    otherwise
        error('Wrong number of input arguments');
end

cellMode=isa(F,'cell'); 

if isempty(numDigitsMerge)    
    D=patchEdgeLengths(F,V);
    if cellMode
        mean_D=mean(cellfun(@mean,D)); %Take mean across cell entries
    else
        mean_D=mean(D); %Mean across array
    end    
    numDigitsMerge=6-numOrder(mean_D); %base number of digits on mean
end

%% Merge nodes

[~,indKeep,indFix]=unique(pround(V,numDigitsMerge),'rows');
V=V(indKeep,:);

%% Fix indices in face array
if isa(F,'cell')
    for q=1:1:numel(F)
        F{q}=fixFaces(F{q},indFix);
    end
else
    F=fixFaces(F,indFix);
end

%% Parse
varargout{1}=F;
varargout{2}=V;
varargout{3}=indKeep;
varargout{4}=indFix;
obj.Face=F;
obj.Vert=V;

%% Print
if obj.Echo
    fprintf('Successfully merge nodes .\n');
end

end

%% Fix indices in face array
function F=fixFaces(F,indFix)
    if size(F,1)==1
        F=indFix(F)'; %Fix indices in F
    else
        F=indFix(F); %Fix indices in F
    end
end
