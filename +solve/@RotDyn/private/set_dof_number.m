function num = set_dof_number(direction)
% Assigns the char orientation to numbers fo further handling (e.g.: 'u_x' -> 1) 
%
%    :param direction: Direction of the DoFs
%    :type direction: vector (char)
%    :return: Vector of numbers containing the orientation info

% Licensed under GPL-3.0-or-later, check attached LICENSE file

dof_name = {'Ux','Uy','Uz','Rotx','Roty','Rotz'};
dof_loc = [3,1,2,6,4,5];
ldof = containers.Map(dof_name,dof_loc);

if strcmpi(direction,'all')
    num = 1:6;
    return
end

if iscell(direction)
    for i=1:length(direction)
        if ischar(direction{i})
            num(i) = ldof(direction{i}); %#ok<AGROW>
        elseif isscalar(direction{i})
            num(i) = direction{i}; %#ok<AGROW>
        end
    end
    
elseif ischar(direction)
    num = ldof(direction);
else
    num = direction;
end

end