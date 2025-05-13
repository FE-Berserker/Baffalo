function [Ri,Ro,Pi,Po]=Checkinput(obj)
if isempty(obj.input.Ri)
    Ri=0;
else
    Ri=obj.input.Ri;
end

if isempty(obj.input.Ro)
    error('Please input outer radius !')
else
    Ro=obj.input.Ro;
end

if isempty(obj.input.Pi)
    Pi=0;
else
    Pi=obj.input.Pi;
end

if isempty(obj.input.Po)
    Po=0;
else
    Po=obj.input.Po;
end


end