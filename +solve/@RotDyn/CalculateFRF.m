function obj = CalculateFRF(obj)
% Calculate FRF of shaft
% Author : Xie Yu
if isempty(obj.input.InNode)
    error('Please set InNode !')
end

if isempty(obj.input.OutNode)
    error('Please set OutNode !')
end

inputNode = obj.input.InNode;
outputNode = obj.input.OutNode;

inputDofNode = get_dof_no(obj.output.RotorSystem,inputNode);
outputDofNode = get_dof_no(obj.output.RotorSystem,outputNode);

inputDirection = set_dof_number('Uy');
outputDirection = set_dof_number('Uy');

nNodesOut = length(outputNode);
nNodesIn = length(inputNode);
indexIn=[];indexOut=[];
for i=1:nNodesOut
    indexOut = [indexOut, outputDirection+6*(i-1)]; %#ok<AGROW>
end
for i=1:nNodesIn
    indexIn = [indexIn, inputDirection+6*(i-1)]; %#ok<AGROW>
end

inputDof = inputDofNode(indexIn);
outputDof = outputDofNode(indexOut);


% calculation
if isempty(obj.input.Speed)
    rpm=0;
elseif size(obj.input.Speed,2)==1
    rpm=obj.input.Speed;
else
    rpm=obj.input.Speed(1);
    warning('Only the first speed is considered')
end

[M,C,G,K] = assemble_system_matrices(obj.output.RotorSystem,rpm);
D = C + G*rpm/60*2*pi;
f=obj.params.Freq(1):(obj.params.Freq(2)-obj.params.Freq(1))/1000:obj.params.Freq(2);
H = mck2frf(f,M,D,K,inputDof,outputDof,obj.params.FRFType); % AbraVibe

obj.output.FRFResult.f = f;
obj.output.FRFResult.H = H*1000;% unit m --> mm
obj.output.FRFResult.type = obj.params.FRFType;
obj.output.FRFResult.inputPosition = GetNodePos(obj,inputNode);
obj.output.FRFResult.outputPosition = GetNodePos(obj,outputNode);


% obj.make_unit_from_type;
% obj.make_descriptions_for_FRF(inputNode,outputNode,inputDirection,outputDirection);

end
