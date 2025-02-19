function obj=AddCon(obj,Numpart,No)
% Add Contact to Assembly
% Author : Xie Yu

num=GetNContactPair(obj)+1;
obj.ContactPair{num,1}.Con.elements=[];

for i=1:size(Numpart,1)
    FFb=obj.Part{Numpart(i,1),1}.mesh.facesBoundary;
    acc=obj.Part{Numpart(i,1),1}.acc_node;
    Cb=obj.Part{Numpart(i,1),1}.mesh.boundaryMarker;
    ConList=FFb(Cb==No(i,1),:);
    obj.ContactPair{num,1}.Con.elements=[obj.ContactPair{num,1}.Con.elements;ConList+acc];
end

obj.ContactPair{num,1}.Con.Part=Numpart;
obj.ContactPair{num,1}.Con.Cb=No;
obj.ContactPair{num,1}.RealConstants=[1,1;2,0.1];

obj.ContactPair{num,1}.Tar=[];

if isempty(obj.ContactPair{num,1}.Con.elements)
    error(strcat('Contact ',num2str(num)," elemnts are not selected"))
end

%% Print
if obj.Echo
    fprintf('Successfully add contactpair .\n');
end

end
