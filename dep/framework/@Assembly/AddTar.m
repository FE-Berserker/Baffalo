function obj=AddTar(obj,Numpair,Numpart,No)
% Add Target to Assembly
% Author : Xie Yu

if ~isempty(obj.ContactPair{Numpair,1}.Tar)
    error(strcat('ContactPair ',num2str(Numpair),' has been defined!'));
else
    
obj.ContactPair{Numpair,1}.Tar.elements=[];
end
for i=1:size(Numpart,1)
    FFb=obj.Part{Numpart(i,1),1}.mesh.facesBoundary;
    acc=obj.Part{Numpart(i,1),1}.acc_node;
    Cb=obj.Part{Numpart(i,1),1}.mesh.boundaryMarker;
    TarList=FFb(Cb==No(i,1),:);
    obj.ContactPair{Numpair,1}.Tar.elements=[obj.ContactPair{Numpair,1}.Tar.elements;TarList+acc];
    obj.ContactPair{Numpair,1}.Tar.Part=Numpart;
    obj.ContactPair{Numpair,1}.Tar.Cb=No;
end

if isempty(obj.ContactPair{Numpair,1}.Tar.elements)
    error(strcat('Target ',num2str(Numpair)," elemnts are not selected"))
end

%% Print
if obj.Echo
    fprintf('Successfully add target .\n');
end
end
