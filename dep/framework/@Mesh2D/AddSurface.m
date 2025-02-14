function obj=AddSurface(obj,Surface)
% Add surface to Mesh2D
% Author : Xie Yu

if ~isa(Surface,'Surface2D')
    error('Excepted input is ''Surface2D'' object.')
end

%% Parse
obj.N=Surface.N;
obj.E=Surface.E;

%% Print
if obj.Echo
    fprintf('Successfully add surface .\n');
end
end