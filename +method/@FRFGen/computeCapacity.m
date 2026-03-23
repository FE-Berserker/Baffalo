function obj = computeCapacity(obj)
%COMPUTECAPACITY 计算容量指标
%   计算最小固有频率、最大共振幅值和模态数量

    % 计算最小固有频率 [Hz]
    obj.capacity.MinNaturalFreq = min(obj.input.Wn)/(2*pi);
    
    % 计算最大共振幅值 [m/N]
    obj.capacity.MaxResonanceAmp = max(obj.output.FRFMag);
    
    % 存储模态数量
    obj.capacity.NumModes = length(obj.input.Wn);
end
