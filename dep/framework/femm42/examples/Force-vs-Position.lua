showconsole()
clearconsole()
print("position in inches | force in lbf")
open("Roters-Ch9Fig6.fem")
mi_saveas("temp.fem")
for n=0,20,1 do
    mi_analyze()
    mi_loadsolution()
    mo_groupselectblock(1)
    f=mo_blockintegral(19)/4.4482
    print(0.1*n,f)
    mo_close()
    mi_seteditmode("group")
    mi_selectgroup(1)
    mi_movetranslate(0,-0.1)
end


