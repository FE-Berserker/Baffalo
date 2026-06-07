function obj = AddBoolean(obj,Type,Bodyno)
% Add Boolean
% Author : Xie Yu
% type=1 Union type=2 Subtraction type=3 intersection

obj.Boolean=[obj.Boolean;Type,Bodyno];

if Bodyno==1
    error('Bodyno can not be 1 !')
end
   
obj.Summary.Total_Sketches=GetNBoolean(obj);
%% Print
if obj.Echo
    fprintf('Successfully add Boolean . \n');
end

end