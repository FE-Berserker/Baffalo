function [varargout]=euler2DCM(E)

% function [Q,Qi]=euler2DCM(E)
% ----------------------------------------------------------------------
% 
% This function uses the input Euler angle set |a|, a 1x3 vector, to
% compute a rotation tensor |Q|, also known as a direction cosine matrix
% (DCM). 
% See also DCM2euler
%
% Change log: 
% 2011/06/01 Created
% 2019/06/21 Update variable naming and documentation
% 2019/06/21 Use transpose instead of inverse operation
% 2019/06/21 Added assumption angles are real for symbolic input
%  
% ----------------------------------------------------------------------

%% 

switch class(E)
    case 'double'
        symbolicOpt=false(1,1);
        Q=zeros(3,3,size(E,1));
%     case 'sym'
%         symbolicOpt=true(1,1);
%         assume(E,'real'); %Assume angles are real
%         assume(E>=0 & E<2*pi); %Assume range 0-2*pi
%         Q=sym(zeros(3,3,size(E,1)));
end
Qi=Q;

for q=1:1:size(E,1)
    
    Qx=[1        0              0;...
        0        cos(E(q,1))  -sin(E(q,1));...
        0        sin(E(q,1))   cos(E(q,1))];
    
    Qy=[cos(E(q,2))  0        sin(E(q,2));...
            0        1        0;...
        -sin(E(q,2)) 0        cos(E(q,2))];
    
    Qz=[cos(E(q,3))  -sin(E(q,3)) 0;...
        sin(E(q,3))  cos(E(q,3))  0;...
        0        0        1];
    
    Rxyz=Qx*Qy*Qz;
    Q(:,:,q)=Rxyz;

    Qi(:,:,q)=Rxyz'; %Transpose to get inverse

end

varargout{1}=Q; 
varargout{2}=Qi; 

end

