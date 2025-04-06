% ActiveFEMM (C)2006 David Meeker, dmeeker@ieee.org

function z=mi_getmaterial(matname)
callfemm(['mi_getmaterial(' , quote(matname) , ')' ]);

