function [r,t]=imp2rcs_t(imp,tz,dt)
% IMP2RCS_T: Compute rcs in time given an impedance from a well
%
% [r,t]=imp2rcs_t(imp,tz,dt)
%
% imp ... impedance vector, usually from a well 
% tz ...  time coordinate for imp. Usually this will be
%           irregularly sampled. If sp is a p-sonic from and LAS file and z is its depth coordinate
%           then tz is computed by tz=2*cumsum(diff(z).*sp(1:end-1))*10^6;
% dt ... time sample rate for the output rcs
% r ... output rcs in time
% t ... time coordinate for r
% 
%
% Convert impedance to rcs in time with a time-depth relation. This gives a Goupillaud layering.
% This is used by seismo1D and align_ref .
%
% Method:
%   1) Given an impedance log and its time coordinate, define equal intervals of dt
%   2) For each interval, compute the average impedance. This gives impedance as a function of time
%       at the sample rate dt. The averaging serves as an implicit anti-alias filter
%   3) Compute r(t) from imp(t) by the usual r(k)=(I(k)-I(k-1))/(I(k)+I(k-1))
%
%

if(length(imp)~=length(tz))
    error('imp and tz must be the same length');
end

t=(tz(1):dt:tz(end))';

if(length(t)>length(tz))
    error('dt is too small, output time has more samples than impedance in depth')
end

r=zeros(size(t));
for k=2:length(t)-1
   i1=near(tz,t(k-1),t(k));
   i2=near(tz,t(k),t(k+1));
   I1=mean(imp(i1));
   I2=mean(imp(i2));
   r(k)=(I2-I1)/(I2+I1);
end