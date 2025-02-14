function [C]=linspacen(A,B,n)

% function [C]=linspacen(A,B,n)
% ------------------------------------------------------------------------
% This function is a generalization of the linspace function to N
% dimensions. The output C is a matrix of size [size(A) n] such that "it
% goes from A to B in n steps in the last dimention. The input variables A
% and B (scalars, vectors or matrices). For scalar input this function is
% equivalent to linspace.
% The inputs A and B should have the same size.
%
% Change log:
% 2010/07/15 Updated
% 2019/06/29 Fixed bug in relation to numerical precission
% 2019/06/29 Improved error handling
% 2019/06/29 Avoid NaN if n=1, and copy behaviour of linspace for this case
%
%------------------------------------------------------------------------

%%

size_A=size(A); %Store size

if ~all(size(A)==size(B))
    error('A and B should be the same size');
end

if n==1 %Same behaviour as linspace
    C=B;
else
    logicReshape=~isvector(A);
    
    %Make columns
    A=A(:);
    B=B(:);
    
    C=repmat(A,[1,n])+((B-A)./(n-1))*(0:1:n-1);
    
    %Force start and end to match (also avoids numerical precission issues) 
    C(:,1)=A; %Overide start
    C(:,end)=B; %Overide end
    if logicReshape
        C=reshape(C,[size_A n]);
    end
end
