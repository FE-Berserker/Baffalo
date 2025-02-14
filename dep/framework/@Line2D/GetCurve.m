 function c = GetCurve(obj,id)
 % Get curve data

 narginchk(2,2)
 validateattributes(id,{'numeric'}, ...
     {'>=',1,'<=',GetNcrv(obj),'integer','scalar'});
 is = obj.CIX(id);
 ie = obj.CIX(id+1) - 1;
 c.type = obj.CT(id);
 c.data(:) = obj.C(is:ie);

 end
