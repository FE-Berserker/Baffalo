function obj=AddPair(obj,SendBodyNo,SendNo,ReceiveSubNo,ReceiveBodyNo,ReceiveMarkerNo)
% Add Joint to MultiBody
% Author : Xie Yu

obj.Summary.Total_Pair=GetNPair(obj)+1;
PairId=obj.Summary.Total_Pair;
obj.Pair{PairId,1}=[SendBodyNo,SendNo,ReceiveSubNo,ReceiveBodyNo,ReceiveMarkerNo];

% Sender
obj.Summary.Total_Sender=GetNSender(obj)+1;
SenderId=obj.Summary.Total_Sender;
obj.Sender{SenderId,1}.PairName=strcat('$COM_',obj.Name,'_Pair_',num2str(PairId));
obj.Sender{SenderId,1}.MarkerName=GetMarkerName(obj,SendBodyNo,SendNo);

% Receiver
Subobj=obj.SubStructure{ReceiveSubNo,1}.Multi;
Subobj.Summary.Total_Receiver=GetNReceiver(Subobj)+1;
ReceiverId=Subobj.Summary.Total_Receiver;
Subobj.Receiver{ReceiverId,1}.PairName=strcat('$COM_',obj.Name,'_Pair_',num2str(PairId));
Subobj.Receiver{ReceiverId,1}.MarkerName=GetMarkerName(Subobj,ReceiveBodyNo,ReceiveMarkerNo);

% Position update
[Coor1,Rot1]=GetBodyMarker(obj,SendBodyNo,SendNo);
[Coor2,Rot2]=GetBodyMarker(Subobj,ReceiveBodyNo,ReceiveMarkerNo);
obj.SubStructure{ReceiveSubNo,1}.Position=[Coor1-Coor2,Rot1-Rot2];

% Pasrse
obj.SubStructure{ReceiveSubNo,1}.Multi=Subobj;

%% Print
if obj.Echo
    fprintf('Successfully add pair . \n');
end
end