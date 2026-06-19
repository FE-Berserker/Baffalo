function obj = AddPlane(obj,baseplane,varargin)
% Add Plane to Catia
% Author : Xie Yu
% baseplane: XY YZ ZX or planeno


p=inputParser;
addParameter(p,'Rot1',[]);
addParameter(p,'Rot2',[]);
addParameter(p,'Offset',[]);
addParameter(p,'Point',[]);
parse(p,varargin{:});
opt=p.Results;

Num=GetNPlane(obj)+1;

if ~isempty(opt.Rot1)
    switch baseplane
        case 'XY'
            obj.Plane=[obj.Plane;0,opt.Rot1,0,0,0];
        case 'YZ'
            obj.Plane=[obj.Plane;-1,opt.Rot1,0,0,0];
        case 'ZX'
            obj.Plane=[obj.Plane;-2,opt.Rot1,0,0,0];
    end

    if isnumeric(baseplane)
        error('This plane can not be rotated !')
    end

elseif ~isempty(opt.Rot2)

    switch baseplane
        case 'XY'
            obj.Plane=[obj.Plane;0,0,opt.Rot2,0,0];
        case 'YZ'
            obj.Plane=[obj.Plane;-1,0,opt.Rot2,0,0];
        case 'ZX'
            obj.Plane=[obj.Plane;-2,0,opt.Rot2,0,0];
    end

    if isnumeric(baseplane)
        error('This plane can not be rotated !')
    end

elseif ~isempty(opt.Offset)
    switch baseplane
        case 'XY'
            obj.Plane=[obj.Plane;0,0,0,opt.Offset,0];
        case 'YZ'
            obj.Plane=[obj.Plane;-1,0,0,opt.Offset,0];
        case 'ZX'
            obj.Plane=[obj.Plane;-2,0,0,opt.Offset,0];
    end

    if isnumeric(baseplane)
        obj.Plane=[obj.Plane;baseplane,0,0,opt.Offset,0];
    end

elseif ~isempty(opt.Point)
    switch baseplane
        case 'XY'
            obj.Plane=[obj.Plane;0,0,0,0,opt.Point];
        case 'YZ'
            obj.Plane=[obj.Plane;-1,0,0,0,opt.Point];
        case 'ZX'
            obj.Plane=[obj.Plane;-2,0,0,0,opt.Point];
    end

    if isnumeric(baseplane)
        obj.Plane=[obj.Plane;baseplane,0,0,0,opt.Point];
    end

else
    error('Please define the plane type !')
end

obj.Summary.Total_Plane=Num;

end