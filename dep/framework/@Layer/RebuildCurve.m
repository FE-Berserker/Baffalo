function obj=RebuildCurve(obj,LinesNum,n,varargin)
% The evenlySampleCurve function samples a curve evenly in n points. The
% curve is parameterized using curve distance and can be closed loop if
% closeLoopOpt==1 (default=0). The resampling is performed using
% interpolation based on the method specified by interpPar.
% Available methods are those associated with interp1 i.e.: 'linear',
% 'nearest', 'next', 'previous', 'spline', 'pchip' (default), 'cubic'.
% Alternatively interpPar my be set as a scalar in the range 0-1 to use the
% csaps method for cubic spline based smoothening.
p=inputParser;
addParameter(p,'interpPar','pchip');
addParameter(p,'closeLoopOpt',0);
addParameter(p,'spacingFlag',0);
parse(p,varargin{:});
opt=p.Results;

V=obj.Lines{LinesNum,1}.P;

Vg= evenlySampleCurve(V,n,opt.interpPar,opt.closeLoopOpt,opt.spacingFlag);
obj=AddCurve(obj,Vg);

end

