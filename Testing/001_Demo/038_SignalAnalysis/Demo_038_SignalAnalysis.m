% Demo Signal Analysis
clc
clear
close all
plotFlag = true;
%% 1. Do the analysis based on the bearing tests data
flag=1;
DemoSignalAnalysis(flag);

function DemoSignalAnalysis(flag)
switch flag
    case 1
        data=load('97.mat');
        Start=1;
        DataNum=20000;
        x=data.X097_DE_time(Start:Start+DataNum,:);
        inputSignal.TimeSeries=x;
        inputSignal.Fs=12000;
        paramsSignal.DataName='Accleration [g]';
        Signal=method.SignalAnalysis( paramsSignal, inputSignal);
        Signal=Signal.solve();
        PlotTimeSeries(Signal)
        PlotFFT(Signal,'Freq',[20,4000])
        PlotTET(Signal,3000);
        PlotSST(Signal,2000);
        PlotWT(Signal,2000);

end
end