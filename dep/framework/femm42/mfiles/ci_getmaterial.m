% ActiveFEMM (C)2006 David Meeker, dmeeker@ieee.org

function z=ci_getmaterial(matname)
callfemm(['ci_getmaterial(' , quote(matname) , ')' ]);
end


