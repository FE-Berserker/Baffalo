function ind=near(v,val1,val2)
% NEAR: return indices of those samples in a vector nearest given bounds
% NEAR: 返回向量中最接近给定边界的样本索引
%
% ind=near(v,val1,val2)
% ind=near(v,val1)
%
% NOTE: ind=near(val1,val2,v) is also supported.
% 注意：ind=near(val1,val2,v) 语法也是支持的
%
% NEAR searches the vector v and finds the index,I1, for which
% v(i) is closest to val1 and I2 for which v(i) is closest to
% val2. The returned value is the vector ind=I1:I2 (I2>I1) or
% ind=I1:-1:I2 for I2<I1. This differs from BETWEEN in that the range
% of the selected samples are nearest the given bounds. For example
% between(3.1,4.9,1:10) returns 4, while near(1:10,3.1,4.9) returns
% [3 4 5]. Also NEAR can be run with one limit so that near(1:10,3.1)
% returns 3 . The most common use of near is to define a time zone on a
% seismic trace. Suppose s is such a trace (column vector) and t is a
% vector of identical size giving the times of the samples in s. Assume
% that t extends from 0 to 2, then ind=near(t,.314,1.257) will cause ind to
% be a vector of sample indices that point to the time interval
% .314<t<1.267. Thus s(ind) contains the seismic samples in that time window.
% NEAR 搜索向量 v 并找到使 v(i) 最接近 val1 的索引 I1 和使 v(i)
% 最接近 val2 的索引 I2。返回值为向量 ind=I1:I2 (当 I2>I1) 或
% ind=I1:-1:I2 (当 I2<I1)。这与 BETWEEN 不同，因为所选样本的范围
% 最接近给定边界。例如，between(3.1,4.9,1:10) 返回 4，而
% near(1:10,3.1,4.9) 返回 [3 4 5]。NEAR 也可以只用一个界限，
% 如 near(1:10,3.1) 返回 3。NEAR 最常见的用途是在地震轨迹上定义时间区间。
% 假设 s 是一条轨迹（列向量），t 是大小相同的向量，给出 s 中样本的时间。
% 假设 t 从 0 延伸到 2，则 ind=near(t,.314,1.257) 将使 ind 成为指向
% 时间区间 .314<t<1.267 的样本索引向量。因此 s(ind) 包含该时间窗内的地震样本。
%
% v= input vector
%    输入向量
% val1= first input search value
%       第一个输入搜索值
% val2= second input serach value
%  ******** default= val1 ********
%       第二个输入搜索值
%       ******** 默认值= val1 ********
% ind= output vector of indicies such that
%       abs(v(l(1))-val1)==minimum and abs(v(l(length(I))-val2)==minimum
%       输出索引向量，使得 abs(v(l(1))-val1)==最小 且 abs(v(l(length(I))-val2)==最小


 if nargin<3
    val2=val1;           % 如果只有一个边界值，则 val2=val1
 end

 %allow for the syntax near(val1,val2,v);
 % 允许使用语法 near(val1,val2,v)
 if(length(val2)>1 && nargin>2)
    tmp=v;               % 交换变量以支持 near(val1,val2,v) 语法
    tmp2=val1;
    v=val2;
    val1=tmp;
    val2=tmp2;
  end


  ilive=find(~isnan(v));             % 找到非NaN的索引
  test=abs(v(ilive)-val1);           % 计算与val1的距离
  L1= test==min(test);               % 找到最接近val1的位置
  test=abs(v(ilive)-val2);           % 计算与val2的距离
  L2= test==min(test);               % 找到最接近val2的位置
  L1=ilive(L1);                     % 获取原始索引L1
  L2=ilive(L2);                     % 获取原始索引L2

 	if L1<=L2
  		ind=min(L1):max(L2);          % 递增顺序
	else
    	ind=max(L1):-1:min(L2);       % 递减顺序
 	end
 