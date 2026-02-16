function indicies = between(x1,x2,testpts,flag)
% BETWEEN: logical test, finds samples in vector between given bounds
% BETWEEN: 逻辑测试，查找向量中位于给定边界之间的样本
%
% indicies = between(x1,x2,testpts,flag)
% indicies = between(x1,x2,testpts)
%
% returns
% 返回 the indicies of those points in the array testpts which lie between
% the points x1 and x2. If no testpts are found between x1 and x2 then a
% single scalar 0 (false) is returned. Flag determines the exact nature of
% the inclusion of the endpoints:
%    数组 testpts 中位于点 x1 和 x2 之间的那些点的索引。
%    如果在 x1 和 x2 之间没有找到 testpts，则返回单个标量 0（false）。
%    Flag 决定端点的精确包含方式：
%    if flag == 0, then not endpoints are included
%    if flag == 1, then x1 is included. i.e. if a test point is precisely
%                  equal to x1,	it will be considered "between"
%    if flag == 2, then both x1 and x2 are included
%  ******** flag defaults to 0 ****
%    如果 flag == 0，则不包含端点
%    如果 flag == 1，则包含 x1。即如果测试点精确等于 x1，
%                  它将被认为是"介于之间"
%    如果 flag == 2，则同时包含 x1 和 x2
%  ******** flag 默认值为 0 ****
%
% Function works regardless of whether x1 < x2 or x2 < x1.
% 无论 x1 < x2 还是 x2 < x1，函数都能工作。


if nargin < 4, flag =0; end      % 默认flag=0

if(length(x1)~=1 || length(x2)~=1)
    error('x1 and x2 must be scalars')
end

if flag == 0
    if( x1 < x2)
        indicies = find( (testpts > x1)&(testpts < x2) );
        if(isempty(indicies))indicies=0;end
        return;
    else
        indicies = find( (testpts > x2)&(testpts < x1) );
        if(isempty(indicies))indicies=0;end
        return;
    end
end
if flag == 1
    if( x1 < x2)
        indicies = find( (testpts >= x1)&(testpts < x2) );
        if(isempty(indicies))indicies=0;end
        return;
    else
        indicies = find( (testpts > x2)&(testpts <= x1) );
        if(isempty(indicies))indicies=0;end
        return;
    end
end
if flag == 2
    if( x1 < x2)
        indicies = find( (testpts >= x1)&(testpts <= x2) );
        if(isempty(indicies))indicies=0;end
        return;
    else
        indicies = find( (testpts >= x2)&(testpts <= x1) );
        if(isempty(indicies))indicies=0;end
        return;
    end
end