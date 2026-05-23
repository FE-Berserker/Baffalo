function OutputCatiaPart(obj)
% OutputCatiaPart - 输出catiaPart模型
% Author: Xie Yu

Cap=CatiaPart(obj.params.Name);
Cap=AddSketch(Cap,obj.output.Surface);
Cap=AddRotate(Cap,1);
CatiaOutput(Cap);

end
