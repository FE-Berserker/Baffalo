function L = CurveClockwise(obj,LineNum)
% Check curve clockwise
V=obj.Lines{LineNum,1}.P;
[L]=isPolyClockwise(V);
end

