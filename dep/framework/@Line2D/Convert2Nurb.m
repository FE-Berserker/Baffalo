function obj=Convert2Nurb( obj,CrvNum, varargin )
% Convert cuvre to nurb
% Author : Xie Yu
k=inputParser;
addParameter(k,'seg',[]);
parse(k,varargin{:});
opt=k.Results;

c = GetCurve(obj,CrvNum);
switch c.type
    case obj.LINE
        [x,y] = PolyCurve(obj,CrvNum,'opt',1);
        Points=[x,y];
        Knots=[0,0:1/(size(x,1)-1):1,1];
        obj=AddNurb(obj,Points,Knots,'seg',opt.seg);
    case obj.CIRCLE
        radius=c.data(1);
        center=c.data(2:3);
        sang=c.data(4);
        eang=sang+c.data(5);
        curve = nrbcirc(radius,center,sang/180*pi,eang/180*pi);
        Num=GetNNurb(obj);
        obj.Dim(Num+1,1)=4;
        obj.Coefs{Num+1,1}=curve.coefs;
        obj.Knots{Num+1,1}=curve.knots;
        obj.Order(Num+1,1)=curve.order;
    case obj.CURVE
        [x,y]=PolyCurve(obj,CrvNum,'opt',1);
        Points=[x;y]';
        Knots=[0,0:1/(size(x,2)-1):1,1];
        obj=AddNurb(obj,Points,Knots,'seg',opt.seg);
    case obj.ELLIPSE
        a=c.data(1);
        b=c.data(2);
        center=c.data(3:4);
        rot=c.data(5);
        sang=c.data(6);
        eang=sang+c.data(7);
        curve = nrbcirc(a,[0,0],sang/180*pi,eang/180*pi);
        xx = vectrans(center)*vecrotz(rot/180*pi)*vecscale([1 b/a]) ;
        c0 = nrbtform(curve, xx);
        Num=GetNNurb(obj);
        obj.Dim(Num+1,1)=4;
        obj.Coefs{Num+1,1}=c0.coefs;
        obj.Knots{Num+1,1}=c0.knots;
        obj.Order(Num+1,1)=c0.order;
    case obj.BEZIER
        [x,y]=PolyCurve(obj,CrvNum,'opt',1);
        Points=[x,y];
        Knots=[0,0:1/(size(x,1)-1):1,1];
        obj=AddNurb(obj,Points,Knots,'seg',opt.seg);
    case obj.BSPLINE
        [x,y]=PolyCurve(obj,CrvNum,'opt',1);
        Points=[x,y];
        Knots=[0,0:1/(size(x,1)-1):1,1];
        obj=AddNurb(obj,Points,Knots,'seg',opt.seg);
    case obj.SPLINE
        [x,y]=PolyCurve(obj,CrvNum,'opt',1);
        Points=[x,y];
        Knots=[0,0:1/(size(x,1)-1):1,1];
        obj=AddNurb(obj,Points,Knots,'seg',opt.seg);
    case obj.PARABOLA
        [x,y]=PolyCurve(obj,CrvNum,'opt',1);
        Points=[x,y];
        Knots=[0,0:1/(size(x,1)-1):1,1];
        obj=AddNurb(obj,Points,Knots,'seg',opt.seg);
    case obj.HYPERBOLA
        [x,y]=PolyCurve(obj,CrvNum,'opt',1);
        Points=[x,y];
        Knots=[0,0:1/(size(x,1)-1):1,1];
        obj=AddNurb(obj,Points,Knots,'seg',opt.seg);
end

%% Print
if obj.Echo
    fprintf('Successfully convert to Nurb .\n');
end

end

