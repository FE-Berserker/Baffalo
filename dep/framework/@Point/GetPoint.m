function p = GetPoint(obj,id,t)
% Get point coordinate
% Author : Xie Yu

if nargin == 2
    % Get point from point pool
    p = obj.P(id,:);
elseif nargin == 3
    % Get point form point group pool
    p = obj.PP{id,1}{t,:};
end

end

