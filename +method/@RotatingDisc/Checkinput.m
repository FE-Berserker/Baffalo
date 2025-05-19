function [Ri,Ro,v,Rho,Omega]=Checkinput(obj)
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

if isempty(obj.input.v)
    v=0.3;
else
    v=obj.input.v;
end

if isempty(obj.input.Rho)
    Rho=7.85e-9;
else
    Rho=obj.input.Rho;
end

if isempty(obj.input.Omega)
    error('Please input rotating speed (RPM) !')
else
    Omega=obj.input.Omega/60*2*pi;% RPM --> Rad/s
end

end