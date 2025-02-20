function Name=GetMarkerName(obj,No,NoMarker)
% Get Name of Body Marker
% Author : Xie Yu
if No==0
    Pre='$M_Isys';
    if NoMarker==1
        Name=Pre;
    else
        Name=strcat(Pre,'_',num2str(NoMarker-1));
    end
else
    Name=strcat('$M_Body',num2str(No),'_',num2str(obj.Body{No, 1}.Marker(NoMarker,1)));
end
end
