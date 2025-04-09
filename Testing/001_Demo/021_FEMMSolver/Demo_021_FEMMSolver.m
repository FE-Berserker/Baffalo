clc
clear
close all
% Demo FEMMSolver
% 1. The box problem
flag=1;
DemoFEMMSolver(flag);

function DemoFEMMSolver(flag)
switch flag
    case 1
        a=Point2D('Temp');
        a=AddPoint(a,[0;1;1;0],[0;0;1;1]);
        b=Line2D('Temp');
        b=AddCurve(b,a,1);
        S=Surface2D(b);
        openfemm;
        newdocument(1)
        ei_probdef('millimeters','planar',1e-8,1,30)
        FEMM_TransferSurface2D(S,'Type',1)
        ei_addblocklabel(0.5,0.5);
        ei_getmaterial('Air');
        ei_selectlabel(0.5,0.5);
        ei_setblockprop('Air',0,0.1,0);
        ei_addboundprop('V=0',0,0,0,0,0);
        ei_addboundprop('V=1',1,0,0,0,0);
        ei_selectsegment(0.5,0);
        ei_setsegmentprop('V=0',0.1,1,0,0,'<None>');
        ei_clearselected
        ei_selectsegment(1,0.5);
        ei_setsegmentprop('V=0',0.1,1,0,0,'<None>');
        ei_clearselected
        ei_selectsegment(0.5,1);
        ei_setsegmentprop('V=0',0.1,1,0,0,'<None>');
        ei_clearselected
        ei_selectsegment(0,0.5);
        ei_setsegmentprop('V=1',0.1,1,0,0,'<None>');
        ei_saveas('Box_problem.FEE')
        ei_createmesh;    
        ei_analyze(0)
    case 2
        




end
end