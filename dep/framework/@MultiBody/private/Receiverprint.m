function Receiverprint(obj,fid)
% Print Receiver to simpack
% Author : Xie Yu

% Create Receiver
for i=1:size(obj.Receiver,1)
    Sen=strcat(' Spck.currentModel.createReceiver("',obj.Receiver{i,1}.PairName,'");');
    fprintf(fid, '%s\n',Sen);

    Sen=strcat(' var COM_',num2str(i),' = Spck.currentModel.findElement("',obj.Receiver{i,1}.PairName,'");');
    fprintf(fid, '%s\n',Sen);

    Sen=strcat(' COM_',num2str(i),'.ref.src = "',obj.Receiver{i,1}.MarkerName,'";');
    fprintf(fid, '%s\n',Sen);
end

end

