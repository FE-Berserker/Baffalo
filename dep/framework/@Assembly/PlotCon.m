function PlotCon(obj,contactnum)
% Plot contactpair
% Author：Xie Yu

Num1=obj.ContactPair{contactnum,1}.Con.Part;
Acc=0;
CCb1=[];
Node1=[];
Face1=[];
PointData1=[];

TempNum1=unique(Num1);

for i=1:size(TempNum1,1)
    Cb1=obj.ContactPair{contactnum,1}.Con.Cb(Num1==TempNum1(i,1),1);
    Temp_Node1=obj.Part{TempNum1(i,1),1}.mesh.nodes;
    [row,col]=size(obj.Part{TempNum1(i,1),1}.mesh.facesBoundary);
    Temp_Face1=obj.Part{TempNum1(i,1),1}.mesh.facesBoundary+Acc*ones(row,col);
    if size(Temp_Face1,2)==3
        Temp_Face1=[Temp_Face1,Temp_Face1(:,3)]; %#ok<AGROW>
        Temp_Cb=obj.Part{TempNum1(i,1),1}.mesh.boundaryMarker;
        Temp_Cb=Temp_Cb./Temp_Cb*2;
        for j=1:size(Cb1,1)
            Temp_Cb(obj.Part{TempNum1(i,1),1}.mesh.boundaryMarker==Cb1(j,1),:)=1;
        end
        CCb1=[CCb1;Temp_Cb]; %#ok<AGROW>
        Node1=[Node1;Temp_Node1]; %#ok<AGROW>
        Face1=[Face1;Temp_Face1]; %#ok<AGROW>
        Acc=Acc+size(Temp_Node1,1);
    elseif size(Temp_Face1,2)==4
        Temp_Cb=obj.Part{TempNum1(i,1),1}.mesh.boundaryMarker;
        Temp_Cb=Temp_Cb./Temp_Cb*2;
        for j=1:size(Cb1,1)
            Temp_Cb(obj.Part{TempNum1(i,1),1}.mesh.boundaryMarker==Cb1(j,1),:)=1;
        end
        CCb1=[CCb1;Temp_Cb]; %#ok<AGROW>
        Node1=[Node1;Temp_Node1]; %#ok<AGROW>
        Face1=[Face1;Temp_Face1]; %#ok<AGROW>
        Acc=Acc+size(Temp_Node1,1);

    elseif size(Temp_Face1,2)==2
        Temp_Face1=[Temp_Face1,Temp_Face1(:,2),Temp_Face1(:,1)]; %#ok<AGROW>
        for j=1:size(Cb1,1)
            Temp_Face1=Temp_Face1(obj.Part{TempNum1(i,1),1}.mesh.boundaryMarker==Cb1(j,1),:);
        end
        TempPointData1=ones(size(Temp_Node1,1),1);
        TempPointData1(unique(Temp_Face1),:)=2;
        PointData1=[PointData1;TempPointData1]; %#ok<AGROW>

        Temp_Face2=obj.Part{TempNum1(i,1), 1}.mesh.elements+Acc;
        if size(Temp_Face2,2)==3
            Temp_Face2=[Temp_Face2,Temp_Face2(:,3)]; %#ok<AGROW>
        end
        Temp_Cb2=ones(size(Temp_Face2,1),1)*2;
                
        CCb1=[CCb1;Temp_Cb2]; %#ok<AGROW>
        Node1=[Node1;Temp_Node1]; %#ok<AGROW>
        Face1=[Face1;Temp_Face2]; %#ok<AGROW>
        Acc=Acc+size(Temp_Node1,1);
    end

end


Num2=obj.ContactPair{contactnum,1}.Tar.Part;
Acc=0;
CCb2=[];
Node2=[];
Face2=[];
TempNum2=unique(Num2);
for i=1:size(TempNum2,1)
    Cb2=obj.ContactPair{contactnum,1}.Tar.Cb(Num2==TempNum2(i,1),1);
    Temp_Node2=obj.Part{TempNum2(i,1),1}.mesh.nodes;
    [row,col]=size(obj.Part{TempNum2(i,1),1}.mesh.facesBoundary);
    Temp_Face2=obj.Part{TempNum2(i,1),1}.mesh.facesBoundary+Acc*ones(row,col);
    if size(Temp_Face2,2)==3
        Temp_Face2=[Temp_Face2,Temp_Face2(:,3)]; %#ok<AGROW>
    end

    
    Temp_Cb=obj.Part{TempNum2(i,1),1}.mesh.boundaryMarker;
    Temp_Cb=Temp_Cb./Temp_Cb*2;
    for j=1:size(Cb2,1)
    Temp_Cb(obj.Part{TempNum2(i,1),1}.mesh.boundaryMarker==Cb2(j,1),:)=1;
    end
    CCb2=[CCb2;Temp_Cb]; %#ok<AGROW>
    Node2=[Node2;Temp_Node2]; %#ok<AGROW>
    Face2=[Face2;Temp_Face2]; %#ok<AGROW>
    Acc=Acc+size(Temp_Node2,1);
end



if ~isempty(PointData1)
    g(1,1)=Rplot('faces',Face1,'vertices',Node1,'pointdata',PointData1);
else
    g(1,1)=Rplot('faces',Face1,'vertices',Node1,'facecolor',CCb1);
end
g(1,1)=set_title(g(1,1),'Contact');
g(1,1)=set_layout_options(g(1,1),'axe',1);
g(1,1)=set_line_options(g(1,1),'base_size',0.5,'step_size',0);
g(1,1)=set_axe_options(g(1,1),'grid',1,'equal',1);
g(1,1)=geom_patch(g(1,1),'alpha',1,'face_alpha',0.5);


g(1,2)=Rplot('faces',Face2,'vertices',Node2,'facecolor',CCb2);
g(1,2)=set_title(g(1,2),'Target');
g(1,2)=set_layout_options(g(1,2),'axe',1);
g(1,2)=set_line_options(g(1,2),'base_size',0.5,'step_size',0);
g(1,2)=set_axe_options(g(1,2),'grid',1,'equal',1);
g(1,2)=geom_patch(g(1,2),'alpha',1,'face_alpha',0.5);

[row,col]=size(Face2);
Face=[Face1;Face2+size(Node1,1)*ones(row,col)];
g(1,3)=Rplot('faces',Face,'vertices',[Node1;Node2],'facecolor',[CCb1;CCb2]);
g(1,3)=set_title(g(1,3),'Contact Pair');
g(1,3)=set_layout_options(g(1,3),'axe',1);
g(1,3)=set_line_options(g(1,3),'base_size',1,'step_size',0);
g(1,3)=set_axe_options(g(1,3),'grid',1,'equal',1);
g(1,3)=geom_patch(g(1,3),'alpha',1,'face_alpha',0.5);
% figure
g=set_title(g,strcat('View of Contact Pair ',num2str(contactnum)));
figure('Position',[100 100 1200 400]);
draw(g);

end

