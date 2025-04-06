% ActiveFEMM (C)2006 David Meeker, dmeeker@ieee.org

function z=ei_getmaterial(matname)
callfemm(['ei_getmaterial(' , quote(matname) , ')' ]);

