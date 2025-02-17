function obj=AddCircle(obj,radius,Point,P,varargin)
% Add circle or circular arc
%
%Usage:
%
% Circle:
%   id = addCircle(obj,r,Point2D,P)
%  
% Circlar arc:
%   id = addCircle(__,sang,ang)
%
%Optional input:
%   sang -- start angle in degrees
%   ang  -- central angle in degrees: CCW = +, CW = -
%   '-seg'
%
%Output:
%   id  -- curve reference number
k=inputParser;
addParameter(k,'sang',0);
addParameter(k,'ang',360);
addParameter(k,'seg',[]);
addParameter(k,'rot',[0,0,0]);
parse(k,varargin{:});
opt=k.Results;
%default values
sang = opt.sang;
ang  = opt.ang;
eang=sang+ang;
c0 = nrbcirc(radius,[0,0,0],sang/180*pi,eang/180*pi) ;
Matrix = vectrans(Point.PP{P,1})*vecrotx(opt.rot(3)/180*pi)*vecroty(opt.rot(2)/180*pi)*vecrotx(opt.rot(1)/180*pi); 
curve= nrbtform(c0, Matrix); 

n = GetNcrv(obj);
obj.Nurbs{n+1,1}.Coefs=curve.coefs;
obj.Nurbs{n+1,1}.Knots=curve.knots;
obj.Nurbs{n+1,1}.Order=curve.order;
obj.Nurbs{n+1,1}.Dim=curve.dim;
if isempty(opt.seg)
    obj.Subd{n+1,1}=round(36/(360/ang));
else
    obj.Subd{n+1,1}=opt.seg;
end
obj.MP(n+1,:)=mean(Point.PP{P,1});

%% Print
if obj.Echo
    fprintf('Successfully add circle. \n');
end

end

