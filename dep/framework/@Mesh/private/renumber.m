function [node, element] = renumber(node, element)
%% Author: Wan Ji, Wuhan University, Wuhan, China
% Any advice or questions, please contact me via E-mail:
% wanji@whu.edu.cn
% Date of this version 2021/06/28
[node,idx ]= sortrows(node); % 对坐标进行重排先排x再排y从小到大
[~,idx2] = sortrows(idx); % 对实际原先的点进行编号排序
qNum = (1:1:numel(idx2))';
qNum = qNum(idx2)'; % 将排序策略记录
element = qNum(element); % 排序策略赋值给新的单元编号
end