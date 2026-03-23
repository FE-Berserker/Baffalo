function obj = validateInputs(obj)
%VALIDATEINPUTS 验证FRFGen输入参数
%   根据GenerationMode检查必需字段是否存在且有效

    % 检查必需字段: Wn
    if isempty(obj.input.Wn)
        error('FRFGen: 输入参数 Wn (固有频率) 不能为空');
    end
    
    % 检查必需字段: Zeta
    if isempty(obj.input.Zeta)
        error('FRFGen: 输入参数 Zeta (阻尼比) 不能为空');
    end
    
    % 检查数组长度一致性
    if length(obj.input.Wn) ~= length(obj.input.Zeta)
        error('FRFGen: Wn 和 Zeta 数组长度必须相同');
    end
    
    % 根据生成模式检查特定字段
    switch upper(obj.params.GenerationMode)
        case 'MODEBASED'
            if isempty(obj.input.K)
                error('FRFGen: ModeBased模式需要输入参数 K (模态刚度)');
            end
            if length(obj.input.Wn) ~= length(obj.input.K)
                error('FRFGen: Wn 和 K 数组长度必须相同');
            end
            
        case {'RESIDUEKAI', 'RESIDUEALTINTAS'}
            if isempty(obj.input.Residue)
                error('FRFGen: Residue模式需要输入参数 Residue (残差)');
            end
            if length(obj.input.Wn) ~= length(obj.input.Residue)
                error('FRFGen: Wn 和 Residue 数组长度必须相同');
            end
            
        otherwise
            error('FRFGen: 未知的生成模式: %s', obj.params.GenerationMode);
    end
    
    % 检查频率范围有效性
    if obj.params.FStart >= obj.params.FEnd
        error('FRFGen: FStart (%.1f) 必须小于 FEnd (%.1f)', obj.params.FStart, obj.params.FEnd);
    end
    
    if obj.params.dF <= 0
        error('FRFGen: dF (频率分辨率) 必须大于 0');
    end
    
    % 检查阻尼比范围
    if any(obj.input.Zeta <= 0) || any(obj.input.Zeta >= 1)
        warning('FRFGen: 阻尼比 Zeta 应在 (0,1) 范围内');
    end
end
