% ActiveFEMM (C)2006 David Meeker, dmeeker@ieee.org

function z=hi_getmaterial(matname)
callfemm(['hi_getmaterial(' , quote(matname) , ')' ]);

