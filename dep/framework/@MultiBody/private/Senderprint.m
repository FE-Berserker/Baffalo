function Senderprint(obj,fid)
% Print Sender to simpack
% Author : Xie Yu

% Create Sender
for i=1:size(obj.Sender,1)
    Sen=strcat(' Spck.currentModel.createSender("',obj.Sender{i,1}.PairName,'");');
    fprintf(fid, '%s\n',Sen);

    Sen=strcat(' var COM_',num2str(i),' = Spck.currentModel.findElement("',obj.Sender{i,1}.PairName,'");');
    fprintf(fid, '%s\n',Sen);

    Sen=strcat(' COM_',num2str(i),'.ref.src = "',obj.Sender{i,1}.MarkerName,'";');
    fprintf(fid, '%s\n',Sen);
end

end

