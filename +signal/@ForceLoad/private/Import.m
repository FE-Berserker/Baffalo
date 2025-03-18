function Out=Import(In,module)
% Import and check data
% Author : Xie Yu
if isempty(In)
    Out=module;
else
    % Check in
    if or(size(module,1)~=size(In,1),...
            size(module,2)~=size(In,2))
        error('Size mismatch !')
    end
    Out=In;
end
end
