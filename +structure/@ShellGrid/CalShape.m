function obj=CalShape(obj)
% Calculate shape of grid
% Author : Xie Yu
L=Layer(obj.params.Name,'Echo',0);

switch obj.params.Type
    case 1
        L=AddShellGrid(L,obj.input.f,obj.input.span,obj.input.kn,obj.input.nx,'Type',1);
    case 2
        L=AddShellGrid(L,obj.input.f,obj.input.span,obj.input.kn,obj.input.nx,'Type',2);
    case 3
        L=AddShellGrid(L,obj.input.f,obj.input.span,obj.input.kn,obj.input.nx,'Type',3);
    case 4
        L=AddShellGrid(L,obj.input.f,obj.input.span,obj.input.kn,obj.input.nx,'Type',4);
end

%% Parse
obj.output.Shape=L;
%% Print
if obj.params.Echo
    fprintf('Successfully calculate shape .\n');
end
end