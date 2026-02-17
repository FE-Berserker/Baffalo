function amat=event_spike(amat,t,x,tnot,xnot,amp)
% EVENT_SPIKE: inserts a spike in a matrix
%
% amat=event_spike(amat,t,x,tnot,xnot,amp)
%
% EVENT_SPIKE inserts a spike event in a matrix.
% EVENT_SPIKE 在矩阵中插入一个尖峰事件。
%
% amat ... the matrix of size nrows by ncols
% t ... vector of length nrows giving the matrix t coordinates
% x ... vector of length ncols giving the matrix x coordinates
% tnot ... t coordinate of the spike
% xnot ... x coordinate of the spike
% amp ... amplitude spike
%
% NOTE: This SOFTWARE may be used by any individual or corporation for any purpose
% with the exception of re-selling or re-distributing the SOFTWARE.
% By using this software, you are agreeing to the terms detailed in this software's
% Matlab source file.

%loop over columns
% 遍历列
ic=near(x,xnot);
jc=near(t,tnot);
[nsamp,nc]=size(amat);

amat(jc,ic)=amat(jc,ic)+amp;