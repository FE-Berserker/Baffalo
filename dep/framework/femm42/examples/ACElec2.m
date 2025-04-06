% ACElec2
% Modeled after Quickfield's ACElec2 example

% make sure that Octave knows where the FEMM-related commands are
%addpath('/cygdrive/c/progra~1/femm42/mfiles');

openfemm;
create(3);

% define some parameters.  These can then
% be used to draw the geometry parametrically
ri=1;
ro=1.5;
z=1.5;

% draw geometry of interest
ci_drawline(ri,-z,ri,z);
ci_drawline(ri,z,ro,z);
ci_drawline(ro,z,ro,-z);
ci_drawline(ri,-z,ro,-z);
ci_addnode(ri,z-0.1);
ci_addnode(ro,-z+0.15);
ci_addnode(ro,-z+0.25);

% draw boundary
ci_drawarc(0,-4,0,4,180,2);
ci_drawline(0,-4,0,4);

% add material definitions
ci_addmaterial('Air',0,0,1,1,0,0);
ci_addmaterial('Ceramic',1e-8,1e-8,6,6,0,0);

% add some block labels
ci_addblocklabel((ri+ro)/2,0);
ci_selectlabel((ri+ro)/2,0);
ci_setblockprop('Ceramic',0,0.05,0)
ci_clearselected;

ci_addblocklabel(ri/2,0);
ci_selectlabel(ri/2,0);
ci_setblockprop('Air',0,0.05,0)
ci_clearselected;

% Add some boundary properties
ci_addboundprop('U+', 5,0,0,0,0)
ci_addboundprop('U-',-5,0,0,0,0)

ci_selectsegment(ro,-z+0.1);
ci_selectsegment((ro+ri)/2,-z);
ci_selectsegment(ri,0);
ci_setsegmentprop('U+',0,1,0,0,'<None>');
ci_clearselected;

ci_selectsegment((ro+ri)/2,z);
ci_selectsegment(ro,0);
ci_setsegmentprop('U-',0,1,0,0,'<None>');
ci_clearselected;
ci_zoomnatural;

% Save, analyze, and view results
ci_saveas('ACElec2.fec');
ci_analyze;
ci_loadsolution;
