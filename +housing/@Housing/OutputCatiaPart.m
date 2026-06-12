function Cap=OutputCatiaPart(obj,print)
% OutputCatiaPart - 输出catiaPart模型
% Author: Xie Yu

if nargin<2
    print=1;
end

Cap=CatiaPart(obj.params.Name);
Cap=AddSketch(Cap,obj.output.Surface);
axis=obj.params.Axis;
Cap=AddRotate(Cap,1,'Axis',axis);

if print
    CatiaOutput(Cap);
end

end
