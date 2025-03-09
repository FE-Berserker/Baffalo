function obj=calculate_geometry_parameters(obj)
% Processes how jumps in the geometry (which radius for the element) should be discretized

Area = pi*(obj.radius_outer.^2 - obj.radius_inner.^2); % m^2
Length = abs(obj.Node(2:end,1)-obj.Node(1:end-1,1)); % m;
Volume = Area.*Length; % m^3
I_p = 0.5*pi*(obj.radius_outer.^4-obj.radius_inner.^4);
I_y = pi*(obj.radius_outer.^4-obj.radius_inner.^4)/4;

obj.Area=mat2cell(Area,ones(1,numel(Area)))';
obj.Length=mat2cell(Length,ones(1,numel(Length)))';
obj.Volume=mat2cell(Volume,ones(1,numel(Volume)))';
obj.I_p=mat2cell(I_p,ones(1,numel(I_p)))';
obj.I_y=mat2cell(I_y,ones(1,numel(I_y)))';
end