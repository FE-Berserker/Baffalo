function Sdb= todb(S,refamp)
% Sdb = todb(S,refamp);
% Sdb = todb(S);
%
% converts a complex spectrum from (real,imaginary) to
% (decibels,phase angle). Thus if S is a complex spectrum,
% then plot(real(todb(S))) will plot the decibel amplitude
% and plot(imag(todb(S))) will plot the phase spectrum (radians)
% 将复数频谱从（实部、虚部）转换为（分贝、相位角）。
% 因此，如果 S 是复数频谱，则 plot(real(todb(S))) 将绘制分贝幅度，
% plot(imag(todb(S))) 将绘制相位谱（弧度）
%
% S= input complex spectrum
%    输入复数频谱
% refamp = input reference amplitude
%           decibels are dbdown from this value. If defaulted,
%           refamp=max(abs(S))
%           输入参考振幅。分贝值是相对于此值的下降量。
%           如果默认，则 refamp=max(abs(S))
% Sdb= output complex spectrum in the special format:
%       (dbdown, phase angle)
%       输出复数频谱，采用特殊格式：
%       （分贝下降量、相位角）
amp=abs(S);      % 幅度
phs=angle(S);    % 相位（弧度）
if(nargin==1)
   refamp=max(max(amp));  % 默认参考振幅为最大幅度
end
amp=20*log10(amp/refamp);  % 转换为分贝（相对参考振幅）
Sdb=amp + i*phs;            % 构造输出复数频谱（实部为分贝，虚部为相位）
    