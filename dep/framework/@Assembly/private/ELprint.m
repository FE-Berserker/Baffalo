function ELprint(obj,fid)
% Output element to ANSYS
% Author : Xie Yu

[m,~]=size(obj.Part);
for i=1:m

    ETnum=obj.Part{i,1}.ET;
    ETname=obj.ET{ETnum,1}.name;
    switch ETname
        case '1'
            mm=obj.Part{i,1}.NumElements;
            acc=obj.Part{i,1}.acc_el;
            acc1=obj.Part{i,1}.acc_node;
            col1=obj.Part{i,1}.mesh.elementMaterialID;
            col2=obj.Part{i,1}.ET;
            col3=obj.Part{i,1}.RealConstants;
            % col4=0;
            col5=obj.Part{i,1}.ESYS;
            % col6=0;
            % col7=0;
            % col8=0;
            col9=size(obj.Part{i,1}.mesh.elements(1,:)',1);
            % col10=0;
            Temp1=[col1,repmat(col2,mm,1),repmat(col3,mm,1),zeros(mm,1),...
                repmat(col5,mm,1),zeros(mm,1),zeros(mm,1),...
                zeros(mm,1),repmat(col9,mm,1),zeros(mm,1)];
            Temp=[Temp1,((1:mm)+acc)',obj.Part{i,1}.mesh.elements+...
                acc1*ones(mm,col9)];
            fprintf(fid, '%s\n','EBLOCK,19,SOLID,');
            fprintf(fid, '%s\n','(19i8)');
            for j=1:size(Temp,1)
                fprintf(fid,'%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i\n',Temp(j,1:13)');
            end
        case '3'
            mm=obj.Part{i,1}.NumElements;
            acc=obj.Part{i,1}.acc_el;
            acc1=obj.Part{i,1}.acc_node;
            col1=obj.Part{i,1}.mesh.elementMaterialID;
            col2=obj.Part{i,1}.ET;
            col3=obj.Part{i,1}.RealConstants;
            % col4=0;
            col5=obj.Part{i,1}.ESYS;
            % col6=0;
            % col7=0;
            % col8=0;
            col9=size(obj.Part{i,1}.mesh.elements(1,:)',1);
            % col10=0;
            Temp1=[col1,repmat(col2,mm,1),repmat(col3,mm,1),zeros(mm,1),...
                repmat(col5,mm,1),zeros(mm,1),zeros(mm,1),...
                zeros(mm,1),repmat(col9,mm,1),zeros(mm,1)];
            Temp=[Temp1,((1:mm)+acc)',obj.Part{i,1}.mesh.elements+...
                acc1*ones(mm,col9)];
            fprintf(fid, '%s\n','EBLOCK,19,SOLID,');
            fprintf(fid, '%s\n','(19i8)');
            for j=1:size(Temp,1)
                fprintf(fid,'%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i\n',Temp(j,1:13)');
            end
        case '4'
            mm=obj.Part{i,1}.NumElements;
            acc=obj.Part{i,1}.acc_el;
            acc1=obj.Part{i,1}.acc_node;
            col1=obj.Part{i,1}.mesh.elementMaterialID;
            col2=obj.Part{i,1}.ET;
            col3=obj.Part{i,1}.RealConstants;
            % col4=0;
            col5=obj.Part{i,1}.ESYS;
            % col6=0;
            % col7=0;
            % col8=0;
            col9=size(obj.Part{i,1}.mesh.elements(1,:)',1);
            % col10=0;
            Temp1=[col1,repmat(col2,mm,1),repmat(col3,mm,1),zeros(mm,1),...
                repmat(col5,mm,1),zeros(mm,1),zeros(mm,1),...
                zeros(mm,1),repmat(col9,mm,1),zeros(mm,1)];
            Temp=[Temp1,((1:mm)+acc)',obj.Part{i,1}.mesh.elements+...
                acc1*ones(mm,col9)];
            fprintf(fid, '%s\n','EBLOCK,19,SOLID,');
            fprintf(fid, '%s\n','(19i8)');
            for j=1:size(Temp,1)
                fprintf(fid,'%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i\n',Temp(j,1:13)');
            end
        case '8'
            mm=obj.Part{i,1}.NumElements;
            acc=obj.Part{i,1}.acc_el;
            acc1=obj.Part{i,1}.acc_node;
            col1=obj.Part{i,1}.mesh.elementMaterialID;
            col2=obj.Part{i,1}.ET;
            col3=obj.Part{i,1}.RealConstants;
            % col4=0;
            col5=obj.Part{i,1}.ESYS;
            % col6=0;
            % col7=0;
            % col8=0;
            col9=size(obj.Part{i,1}.mesh.elements(1,:)',1);
            % col10=0;
            Temp1=[col1,repmat(col2,mm,1),repmat(col3,mm,1),zeros(mm,1),...
                repmat(col5,mm,1),zeros(mm,1),zeros(mm,1),...
                zeros(mm,1),repmat(col9,mm,1),zeros(mm,1)];
            Temp=[Temp1,((1:mm)+acc)',obj.Part{i,1}.mesh.elements+...
                acc1*ones(mm,col9)];
            fprintf(fid, '%s\n','EBLOCK,19,SOLID,');
            fprintf(fid, '%s\n','(19i8)');
            for j=1:size(Temp,1)
                fprintf(fid,'%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i\n',Temp(j,1:13)');
            end
        case '10'
            mm=obj.Part{i,1}.NumElements;
            acc=obj.Part{i,1}.acc_el;
            acc1=obj.Part{i,1}.acc_node;
            col1=obj.Part{i,1}.mesh.elementMaterialID;
            col2=obj.Part{i,1}.ET;
            col3=obj.Part{i,1}.RealConstants;
            % col4=0;
            col5=obj.Part{i,1}.ESYS;
            % col6=0;
            % col7=0;
            % col8=0;
            col9=size(obj.Part{i,1}.mesh.elements(1,:)',1);
            % col10=0;
            Temp1=[col1,repmat(col2,mm,1),repmat(col3,mm,1),zeros(mm,1),...
                repmat(col5,mm,1),zeros(mm,1),zeros(mm,1),...
                zeros(mm,1),zeros(mm,1),zeros(mm,1)];
            Temp=[Temp1,((1:mm)+acc)',obj.Part{i,1}.mesh.elements+...
                acc1*ones(mm,col9)];
            fprintf(fid, '%s\n','EBLOCK,19,SOLID,');
            fprintf(fid, '%s\n','(19i8)');
            for j=1:size(Temp,1)
                fprintf(fid,'%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i\n',Temp(j,1:13)');
            end
        case '11'
            mm=obj.Part{i,1}.NumElements;
            acc=obj.Part{i,1}.acc_el;
            acc1=obj.Part{i,1}.acc_node;
            col1=obj.Part{i,1}.mesh.elementMaterialID;
            col2=obj.Part{i,1}.ET;
            col3=obj.Part{i,1}.RealConstants;
            % col4=0;
            col5=obj.Part{i,1}.ESYS;
            % col6=0;
            % col7=0;
            % col8=0;
            col9=size(obj.Part{i,1}.mesh.elements(1,:)',1);
            % col10=0;
            Temp1=[col1,repmat(col2,mm,1),repmat(col3,mm,1),zeros(mm,1),...
                repmat(col5,mm,1),zeros(mm,1),zeros(mm,1),...
                zeros(mm,1),repmat(col9,mm,1),zeros(mm,1)];
            Temp=[Temp1,((1:mm)+acc)',obj.Part{i,1}.mesh.elements+...
                acc1*ones(mm,col9)];
            for j=1:size(Temp,1)
                fprintf(fid,'%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i\n',Temp(j,1:13)');
            end
        case '14'
            mm=obj.Part{i,1}.NumElements;
            acc=obj.Part{i,1}.acc_el;
            acc1=obj.Part{i,1}.acc_node;
            % col1=0;
            col2=obj.Part{i,1}.ET;
            col3=obj.Part{i,1}.RealConstants;
            % col4=0;
            % col5=0;
            % col6=0;
            % col7=0;
            % col8=0;
            col9=2;
            % col10=0;
            Temp1=[zeros(mm,1),repmat(col2,mm,1),repmat(col3,mm,1),zeros(mm,1),...
                zeros(mm,1),zeros(mm,1),zeros(mm,1),...
                zeros(mm,1),repmat(col9,mm,1),zeros(mm,1)];
            Temp=[Temp1,((1:mm)+acc)',obj.Part{i,1}.mesh.elements+...
                acc1*ones(mm,col9)];
            fprintf(fid, '%s\n','EBLOCK,19,SOLID,');
            fprintf(fid, '%s\n','(19i8)');
            for j=1:size(Temp,1)
                fprintf(fid,'%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i\n',Temp(j,1:13)');
            end
        case '16'
            mm=obj.Part{i,1}.NumElements;
            acc=obj.Part{i,1}.acc_el;
            acc1=obj.Part{i,1}.acc_node;
            col1=obj.Part{i,1}.mesh.elementMaterialID;
            col2=obj.Part{i,1}.ET;
            col3=obj.Part{i,1}.RealConstants;
            % col4=0;
            col5=obj.Part{i,1}.ESYS;
            % col6=0;
            % col7=0;
            % col8=0;
            col9=size(obj.Part{i,1}.mesh.elements(1,:)',1);
            % col10=0;
            Temp1=[col1,repmat(col2,mm,1),repmat(col3,mm,1),zeros(mm,1),...
                repmat(col5,mm,1),zeros(mm,1),zeros(mm,1),...
                zeros(mm,1),repmat(col9,mm,1),zeros(mm,1)];
            Temp=[Temp1,((1:mm)+acc)',obj.Part{i,1}.mesh.elements+...
                acc1*ones(mm,col9)];
            fprintf(fid, '%s\n','EBLOCK,19,SOLID,');
            fprintf(fid, '%s\n','(19i8)');
            for j=1:size(Temp,1)
                fprintf(fid,'%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i\n',Temp(j,1:13)');
            end
        case '20'
            mm=obj.Part{i,1}.NumElements;
            acc=obj.Part{i,1}.acc_el;
            acc1=obj.Part{i,1}.acc_node;
            col1=obj.Part{i,1}.mesh.elementMaterialID;
            col2=obj.Part{i,1}.ET;
            col3=obj.Part{i,1}.RealConstants;
            % col4=0;
            col5=obj.Part{i,1}.ESYS;
            % col6=0;
            % col7=0;
            % col8=0;
            col9=size(obj.Part{i,1}.mesh.elements(1,:)',1);
            % col10=0;
            Temp1=[col1,repmat(col2,mm,1),repmat(col3,mm,1),zeros(mm,1),...
                repmat(col5,mm,1),zeros(mm,1),zeros(mm,1),...
                zeros(mm,1),repmat(col9,mm,1),zeros(mm,1)];
            Temp=[Temp1,((1:mm)+acc)',obj.Part{i,1}.mesh.elements+...
                acc1*ones(mm,col9)];
            fprintf(fid, '%s\n','EBLOCK,19,SOLID,');
            fprintf(fid, '%s\n','(19i8)');
            for j=1:size(Temp,1)
                fprintf(fid,'%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i\n',Temp(j,1:13)');
            end
        case '23'
            mm=obj.Part{i,1}.NumElements;
            acc=obj.Part{i,1}.acc_el;
            acc1=obj.Part{i,1}.acc_node;
            col1=obj.Part{i,1}.mesh.elementMaterialID;
            col2=obj.Part{i,1}.ET;
            col3=obj.Part{i,1}.RealConstants;
            % col4=0;
            col5=obj.Part{i,1}.ESYS;
            % col6=0;
            % col7=0;
            % col8=0;
            col9=size(obj.Part{i,1}.mesh.elements(1,:)',1);
            % col10=0;
            Temp1=[col1,repmat(col2,mm,1),repmat(col3,mm,1),zeros(mm,1),...
                repmat(col5,mm,1),zeros(mm,1),zeros(mm,1),...
                zeros(mm,1),repmat(col9,mm,1),zeros(mm,1)];
            Temp=[Temp1,((1:mm)+acc)',obj.Part{i,1}.mesh.elements+...
                acc1*ones(mm,col9)];
            fprintf(fid, '%s\n','EBLOCK,19,SOLID,');
            fprintf(fid, '%s\n','(19i8)');
            for j=1:size(Temp,1)
                fprintf(fid,'%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i\n',Temp(j,1:13)');
            end
        case '24'
            mm=obj.Part{i,1}.NumElements;
            acc=obj.Part{i,1}.acc_el;
            acc1=obj.Part{i,1}.acc_node;
            col1=obj.Part{i,1}.mesh.elementMaterialID;
            col2=obj.Part{i,1}.ET;
            col3=obj.Part{i,1}.RealConstants;
            % col4=0;
            col5=obj.Part{i,1}.ESYS;
            % col6=0;
            % col7=0;
            % col8=0;
            col9=size(obj.Part{i,1}.mesh.elements(1,:)',1);
            % col10=0;
            Temp1=[col1,repmat(col2,mm,1),repmat(col3,mm,1),zeros(mm,1),...
                repmat(col5,mm,1),zeros(mm,1),zeros(mm,1),...
                zeros(mm,1),repmat(col9,mm,1),zeros(mm,1)];
            Temp=[Temp1,((1:mm)+acc)',obj.Part{i,1}.mesh.elements+...
                acc1*ones(mm,col9)];
            fprintf(fid, '%s\n','EBLOCK,19,SOLID,');
            fprintf(fid, '%s\n','(19i8)');
            for j=1:size(Temp,1)
                fprintf(fid,'%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i\n',Temp(j,1:14)');
            end
        case '39'
            mm=obj.Part{i,1}.NumElements;
            acc=obj.Part{i,1}.acc_el;
            acc1=obj.Part{i,1}.acc_node;
            % col1=0;
            col2=obj.Part{i,1}.ET;
            col3=obj.Part{i,1}.RealConstants;
            % col4=0;
            % col5=0;
            % col6=0;
            % col7=0;
            % col8=0;
            col9=2;
            % col10=0;
            Temp1=[zeros(mm,1),repmat(col2,mm,1),repmat(col3,mm,1),zeros(mm,1),...
                zeros(mm,1),zeros(mm,1),zeros(mm,1),...
                zeros(mm,1),repmat(col9,mm,1),zeros(mm,1)];
            Temp=[Temp1,((1:mm)+acc)',obj.Part{i,1}.mesh.elements+...
                acc1*ones(mm,col9)];
            fprintf(fid, '%s\n','EBLOCK,19,SOLID,');
            fprintf(fid, '%s\n','(19i8)');
            for j=1:size(Temp,1)
                fprintf(fid,'%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i\n',Temp(j,1:13)');
            end
        case '42'
            mm=obj.Part{i,1}.NumElements;
            acc=obj.Part{i,1}.acc_el;
            acc1=obj.Part{i,1}.acc_node;
            col1=obj.Part{i,1}.mesh.elementMaterialID;
            col2=obj.Part{i,1}.ET;
            col3=obj.Part{i,1}.RealConstants;
            col4=obj.Part{i,1}.Sec;
            col5=obj.Part{i,1}.ESYS;
            % col6=0;
            % col7=0;
            % col8=0;
            col9=4;
            % col10=0;
            Temp1=[col1,repmat(col2,mm,1),repmat(col3,mm,1),repmat(col4,mm,1),...
                repmat(col5,mm,1),zeros(mm,1),zeros(mm,1),...
                zeros(mm,1),repmat(col9,mm,1),zeros(mm,1)];

            ENum=size(obj.Part{i,1}.mesh.elements,2);
            switch ENum
                case 4
                    Temp=[Temp1,((1:mm)+acc)',obj.Part{i,1}.mesh.elements+...
                        acc1*ones(mm,4)];
                case 3
                    Temp=[Temp1,((1:mm)+acc)',obj.Part{i,1}.mesh.elements(:,1:3)+...
                        acc1*ones(mm,3),obj.Part{i,1}.mesh.elements(:,3)+...
                        acc1*ones(mm,1)];
            end
            fprintf(fid, '%s\n','EBLOCK,19,SOLID,');
            fprintf(fid, '%s\n','(19i8)');
            for j=1:size(Temp,1)
                fprintf(fid,'%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i\n',Temp(j,1:15)');
            end

        case '44'
            mm=obj.Part{i,1}.NumElements;
            acc=obj.Part{i,1}.acc_el;
            acc1=obj.Part{i,1}.acc_node;
            col1=obj.Part{i,1}.mesh.elementMaterialID;
            col2=obj.Part{i,1}.ET;
            col3=obj.Part{i,1}.RealConstants;
            col4=obj.Part{i,1}.Sec;
            col5=obj.Part{i,1}.ESYS;
            % col6=0;
            % col7=0;
            % col8=0;
            col9=size(obj.Part{i,1}.mesh.elements(1,:)',1);
            % col10=0;
            Temp1=[col1,repmat(col2,mm,1),repmat(col3,mm,1),repmat(col4,mm,1),...
                repmat(col5,mm,1),zeros(mm,1),zeros(mm,1),...
                zeros(mm,1),repmat(col9,mm,1),zeros(mm,1)];
            Temp=[Temp1,((1:mm)+acc)',obj.Part{i,1}.mesh.elements+...
                acc1*ones(mm,col9)];
            fprintf(fid, '%s\n','EBLOCK,19,SOLID,');
            fprintf(fid, '%s\n','(19i8)');
            for j=1:size(Temp,1)
                fprintf(fid,'%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i\n',Temp(j,1:14)');
            end
        case '45'
            mm=obj.Part{i,1}.NumElements;
            acc=obj.Part{i,1}.acc_el;
            acc1=obj.Part{i,1}.acc_node;
            col1=obj.Part{i,1}.mesh.elementMaterialID;
            col2=obj.Part{i,1}.ET;
            col3=obj.Part{i,1}.RealConstants;
            col4=obj.Part{i,1}.Sec;
            col5=obj.Part{i,1}.ESYS;
            % col6=0;
            % col7=0;
            % col8=0;
            col9=8;
            % col10=0;
            Temp1=[col1,repmat(col2,mm,1),repmat(col3,mm,1),repmat(col4,mm,1),...
                repmat(col5,mm,1),zeros(mm,1),zeros(mm,1),...
                zeros(mm,1),repmat(col9,mm,1),zeros(mm,1)];

            ENum=size(obj.Part{i,1}.mesh.elements,2);
            switch ENum
                case 8
                    Temp=[Temp1,((1:mm)+acc)',obj.Part{i,1}.mesh.elements+...
                        acc1*ones(mm,8)];
                case 6
                    Temp=[Temp1,((1:mm)+acc)',obj.Part{i,1}.mesh.elements(:,1:3)+...
                        acc1*ones(mm,3),obj.Part{i,1}.mesh.elements(:,3)+...
                        acc1*ones(mm,1),obj.Part{i,1}.mesh.elements(:,4:6)+...
                        acc1*ones(mm,3),obj.Part{i,1}.mesh.elements(:,6)+...
                        acc1*ones(mm,1)];
                case 4
                    Temp=[Temp1,((1:mm)+acc)',obj.Part{i,1}.mesh.elements(:,1:3)+...
                        acc1*ones(mm,3),obj.Part{i,1}.mesh.elements(:,3)+...
                        acc1*ones(mm,1),repmat(obj.Part{i,1}.mesh.elements(:,4)+...
                        acc1*ones(mm,1),1,4)];
            end
            fprintf(fid, '%s\n','EBLOCK,19,SOLID,');
            fprintf(fid, '%s\n','(19i8)');
            for j=1:size(Temp,1)
                fprintf(fid,'%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i\n',Temp(j,1:19)');
            end

        case '46'
            mm=obj.Part{i,1}.NumElements;
            acc=obj.Part{i,1}.acc_el;
            acc1=obj.Part{i,1}.acc_node;
            col1=obj.Part{i,1}.mesh.elementMaterialID;
            col2=obj.Part{i,1}.ET;
            col3=obj.Part{i,1}.RealConstants;
            % col4=0;
            col5=obj.Part{i,1}.ESYS;
            % col6=0;
            % col7=0;
            % col8=0;
            col9=size(obj.Part{i,1}.mesh.elements(1,:)',1);
            % col10=0;
            Temp1=[col1,repmat(col2,mm,1),repmat(col3,mm,1),zeros(mm,1),...
                repmat(col5,mm,1),zeros(mm,1),zeros(mm,1),...
                zeros(mm,1),repmat(col9,mm,1),zeros(mm,1)];
            Temp=[Temp1,((1:mm)+acc)',obj.Part{i,1}.mesh.elements+...
                acc1*ones(mm,col9)];
            fprintf(fid, '%s\n','EBLOCK,19,SOLID,');
            fprintf(fid, '%s\n','(19i8)');
            for j=1:size(Temp,1)
                fprintf(fid,'%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i\n',Temp(j,1:19)');
            end
        case '54'
            mm=obj.Part{i,1}.NumElements;
            acc=obj.Part{i,1}.acc_el;
            acc1=obj.Part{i,1}.acc_node;
            col1=obj.Part{i,1}.mesh.elementMaterialID;
            col2=obj.Part{i,1}.ET;
            col3=obj.Part{i,1}.RealConstants;
            % col4=0;
            col5=obj.Part{i,1}.ESYS;
            % col6=0;
            % col7=0;
            % col8=0;
            col9=size(obj.Part{i,1}.mesh.elements(1,:)',1);
            % col10=0;
            Temp1=[col1,repmat(col2,mm,1),repmat(col3,mm,1),zeros(mm,1),...
                repmat(col5,mm,1),zeros(mm,1),zeros(mm,1),...
                zeros(mm,1),repmat(col9,mm,1),zeros(mm,1)];
            Temp=[Temp1,((1:mm)+acc)',obj.Part{i,1}.mesh.elements+...
                acc1*ones(mm,col9)];
            fprintf(fid, '%s\n','EBLOCK,19,SOLID,');
            fprintf(fid, '%s\n','(19i8)');
            for j=1:size(Temp,1)
                fprintf(fid,'%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i\n',Temp(j,1:13)');
            end
        case '63'
            mm=obj.Part{i,1}.NumElements;
            acc=obj.Part{i,1}.acc_el;
            acc1=obj.Part{i,1}.acc_node;
            col1=obj.Part{i,1}.mesh.elementMaterialID;
            col2=obj.Part{i,1}.ET;
            col3=obj.Part{i,1}.RealConstants;
            col4=obj.Part{i,1}.Sec;
            col5=obj.Part{i,1}.ESYS;
            % col6=0;
            % col7=0;
            % col8=0;
            col9=4;
            % col10=0;
            Temp1=[col1,repmat(col2,mm,1),repmat(col3,mm,1),repmat(col4,mm,1),...
                repmat(col5,mm,1),zeros(mm,1),zeros(mm,1),...
                zeros(mm,1),repmat(col9,mm,1),zeros(mm,1)];

            ENum=size(obj.Part{i,1}.mesh.elements,2);
            switch ENum
                case 4
                    Temp=[Temp1,((1:mm)+acc)',obj.Part{i,1}.mesh.elements+...
                        acc1*ones(mm,4)];
                case 3
                    Temp=[Temp1,((1:mm)+acc)',obj.Part{i,1}.mesh.elements(:,1:3)+...
                        acc1*ones(mm,3),obj.Part{i,1}.mesh.elements(:,3)+...
                        acc1*ones(mm,1)];
            end
            fprintf(fid, '%s\n','EBLOCK,19,SOLID,');
            fprintf(fid, '%s\n','(19i8)');
            for j=1:size(Temp,1)
                fprintf(fid,'%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i\n',Temp(j,1:15)');
            end


        case '82'
            mm=obj.Part{i,1}.NumElements;
            acc=obj.Part{i,1}.acc_el;
            acc1=obj.Part{i,1}.acc_node;
            col1=obj.Part{i,1}.mesh.elementMaterialID;
            col2=obj.Part{i,1}.ET;
            col3=obj.Part{i,1}.RealConstants;
            col4=obj.Part{i,1}.Sec;
            col5=obj.Part{i,1}.ESYS;
            % col6=0;
            % col7=0;
            % col8=0;
            col9=8;
            % col10=0;
            Temp1=[col1,repmat(col2,mm,1),repmat(col3,mm,1),repmat(col4,mm,1),...
                repmat(col5,mm,1),zeros(mm,1),zeros(mm,1),...
                zeros(mm,1),repmat(col9,mm,1),zeros(mm,1)];

            ENum=size(obj.Part{i,1}.mesh.elements,2);
            switch ENum
                case 8
                    Temp=[Temp1,((1:mm)+acc)',obj.Part{i,1}.mesh.elements+...
                        acc1*ones(mm,8)];
                case 6
                    Temp=[Temp1,((1:mm)+acc)',obj.Part{i,1}.mesh.elements(:,1:3)+...
                        acc1*ones(mm,3),obj.Part{i,1}.mesh.elements(:,3)+...
                        acc1*ones(mm,1),obj.Part{i,1}.mesh.elements(:,4:5)+...
                        acc1*ones(mm,2),obj.Part{i,1}.mesh.elements(:,5)+...
                        acc1*ones(mm,1),obj.Part{i,1}.mesh.elements(:,6)+...
                        acc1*ones(mm,1)];
            end
            fprintf(fid, '%s\n','EBLOCK,19,SOLID,');
            fprintf(fid, '%s\n','(19i8)');
            for j=1:size(Temp,1)
                fprintf(fid,'%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i\n',Temp(j,1:19)');
            end
        case '93'
            mm=obj.Part{i,1}.NumElements;
            acc=obj.Part{i,1}.acc_el;
            acc1=obj.Part{i,1}.acc_node;
            col1=obj.Part{i,1}.mesh.elementMaterialID;
            col2=obj.Part{i,1}.ET;
            col3=obj.Part{i,1}.RealConstants;
            col4=obj.Part{i,1}.Sec;
            col5=obj.Part{i,1}.ESYS;
            % col6=0;
            % col7=0;
            % col8=0;
            col9=8;
            % col10=0;
            Temp1=[col1,repmat(col2,mm,1),repmat(col3,mm,1),repmat(col4,mm,1),...
                repmat(col5,mm,1),zeros(mm,1),zeros(mm,1),...
                zeros(mm,1),repmat(col9,mm,1),zeros(mm,1)];

            ENum=size(obj.Part{i,1}.mesh.elements,2);
            switch ENum
                case 8
                    Temp=[Temp1,((1:mm)+acc)',obj.Part{i,1}.mesh.elements+...
                        acc1*ones(mm,8)];
                case 6
                    Temp=[Temp1,((1:mm)+acc)',obj.Part{i,1}.mesh.elements(:,1:3)+...
                        acc1*ones(mm,3),obj.Part{i,1}.mesh.elements(:,3)+...
                        acc1*ones(mm,1),obj.Part{i,1}.mesh.elements(:,4:5)+...
                        acc1*ones(mm,2),obj.Part{i,1}.mesh.elements(:,5)+...
                        acc1*ones(mm,1),obj.Part{i,1}.mesh.elements(:,6)+...
                        acc1*ones(mm,1)];
            end
            fprintf(fid, '%s\n','EBLOCK,19,SOLID,');
            fprintf(fid, '%s\n','(19i8)');
            for j=1:size(Temp,1)
                fprintf(fid,'%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i\n',Temp(j,1:19)');
            end

        case '95'
            mm=obj.Part{i,1}.NumElements;
            acc=obj.Part{i,1}.acc_el;
            acc1=obj.Part{i,1}.acc_node;
            col1=obj.Part{i,1}.mesh.elementMaterialID;
            col2=obj.Part{i,1}.ET;
            col3=obj.Part{i,1}.RealConstants;
            col4=obj.Part{i,1}.Sec;
            col5=obj.Part{i,1}.ESYS;
            % col6=0;
            % col7=0;
            % col8=0;
            col9=20;
            % col10=0;
            Temp1=[col1,repmat(col2,mm,1),repmat(col3,mm,1),repmat(col4,mm,1),...
                repmat(col5,mm,1),zeros(mm,1),zeros(mm,1),...
                zeros(mm,1),repmat(col9,mm,1),zeros(mm,1)];

            ENum=size(obj.Part{i,1}.mesh.elements,2);
            switch ENum
                case 20
                    Temp=[Temp1,((1:mm)+acc)',obj.Part{i,1}.mesh.elements+...
                        acc1*ones(mm,col9)];
                case 15
                    Temp=[Temp1,((1:mm)+acc)',obj.Part{i,1}.mesh.elements(:,1:3)+...
                        acc1*ones(mm,3),obj.Part{i,1}.mesh.elements(:,3)+...
                        acc1*ones(mm,1),obj.Part{i,1}.mesh.elements(:,4:6)+...
                        acc1*ones(mm,3),obj.Part{i,1}.mesh.elements(:,6)+...
                        acc1*ones(mm,1),obj.Part{i,1}.mesh.elements(:,7:8)+...
                        acc1*ones(mm,2),obj.Part{i,1}.mesh.elements(:,3)+...
                        acc1*ones(mm,1),obj.Part{i,1}.mesh.elements(:,9:11)+...
                        acc1*ones(mm,3),obj.Part{i,1}.mesh.elements(:,6)+...
                        acc1*ones(mm,1),obj.Part{i,1}.mesh.elements(:,12:15)+...
                        acc1*ones(mm,4),obj.Part{i,1}.mesh.elements(:,15)+...
                        acc1*ones(mm,1)];
                case 10
                    Temp=[Temp1,((1:mm)+acc)',obj.Part{i,1}.mesh.elements(:,1:3)+...
                        acc1*ones(mm,3),obj.Part{i,1}.mesh.elements(:,3)+...
                        acc1*ones(mm,1),repmat(obj.Part{i,1}.mesh.elements(:,4),1,4)+...
                        acc1*ones(mm,4),obj.Part{i,1}.mesh.elements(:,5:6)+...
                        acc1*ones(mm,2),obj.Part{i,1}.mesh.elements(:,3)+...
                        acc1*ones(mm,1),obj.Part{i,1}.mesh.elements(:,7)+...
                        acc1*ones(mm,1),repmat(obj.Part{i,1}.mesh.elements(:,4),1,4)+...
                        acc1*ones(mm,4),obj.Part{i,1}.mesh.elements(:,8:10)+...
                        acc1*ones(mm,3),obj.Part{i,1}.mesh.elements(:,10)+...
                        acc1*ones(mm,1)];
            end

            fprintf(fid, '%s\n','EBLOCK,19,SOLID,');
            fprintf(fid, '%s\n','(19i8)');
            for j=1:size(Temp,1)
                fprintf(fid,'%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i\n',Temp(j,1:19)');
                fprintf(fid,'%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i\n',Temp(j,20:31)');
            end

        case '180'
            mm=obj.Part{i,1}.NumElements;
            acc=obj.Part{i,1}.acc_el;
            acc1=obj.Part{i,1}.acc_node;
            col1=obj.Part{i,1}.mesh.elementMaterialID;
            col2=obj.Part{i,1}.ET;
            col3=obj.Part{i,1}.RealConstants;
            % % col4=0;
            col5=obj.Part{i,1}.ESYS;
            % col6=0;
            % col7=0;
            % col8=0;
            col9=size(obj.Part{i,1}.mesh.elements(1,:)',1);
            % col10=0;
            Temp1=[col1,repmat(col2,mm,1),repmat(col3,mm,1),zeros(mm,1),...
                repmat(col5,mm,1),zeros(mm,1),zeros(mm,1),...
                zeros(mm,1),repmat(col9,mm,1),zeros(mm,1)];
            Temp=[Temp1,((1:mm)+acc)',obj.Part{i,1}.mesh.elements+...
                acc1*ones(mm,col9)];
            fprintf(fid, '%s\n','EBLOCK,19,SOLID,');
            fprintf(fid, '%s\n','(19i8)');
            for j=1:size(Temp,1)
                fprintf(fid,'%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i\n',Temp(j,1:13)');
            end
        case '181'
            mm=obj.Part{i,1}.NumElements;
            acc=obj.Part{i,1}.acc_el;
            acc1=obj.Part{i,1}.acc_node;
            col1=obj.Part{i,1}.mesh.elementMaterialID;
            col2=obj.Part{i,1}.ET;
            col3=obj.Part{i,1}.RealConstants;
            col4=obj.Part{i,1}.Sec;
            col5=obj.Part{i,1}.ESYS;
            % col6=0;
            % col7=0;
            % col8=0;
            col9=4;
            % col10=0;
            Temp1=[col1,repmat(col2,mm,1),repmat(col3,mm,1),repmat(col4,mm,1),...
                repmat(col5,mm,1),zeros(mm,1),zeros(mm,1),...
                zeros(mm,1),repmat(col9,mm,1),zeros(mm,1)];

            ENum=size(obj.Part{i,1}.mesh.elements,2);
            switch ENum
                case 4
                    Temp=[Temp1,((1:mm)+acc)',obj.Part{i,1}.mesh.elements+...
                        acc1*ones(mm,4)];
                case 3
                    Temp=[Temp1,((1:mm)+acc)',obj.Part{i,1}.mesh.elements(:,1:3)+...
                        acc1*ones(mm,3),obj.Part{i,1}.mesh.elements(:,3)+...
                        acc1*ones(mm,1)];
            end
            fprintf(fid, '%s\n','EBLOCK,19,SOLID,');
            fprintf(fid, '%s\n','(19i8)');
            for j=1:size(Temp,1)
                fprintf(fid,'%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i\n',Temp(j,1:15)');
            end

        case '182'
            mm=obj.Part{i,1}.NumElements;
            acc=obj.Part{i,1}.acc_el;
            acc1=obj.Part{i,1}.acc_node;
            col1=obj.Part{i,1}.mesh.elementMaterialID;
            col2=obj.Part{i,1}.ET;
            col3=obj.Part{i,1}.RealConstants;
            col4=obj.Part{i,1}.Sec;
            col5=obj.Part{i,1}.ESYS;
            % col6=0;
            % col7=0;
            % col8=0;
            col9=4;
            % col10=0;
            Temp1=[col1,repmat(col2,mm,1),repmat(col3,mm,1),repmat(col4,mm,1),...
                repmat(col5,mm,1),zeros(mm,1),zeros(mm,1),...
                zeros(mm,1),repmat(col9,mm,1),zeros(mm,1)];

            ENum=size(obj.Part{i,1}.mesh.elements,2);
            switch ENum
                case 4
                    Temp=[Temp1,((1:mm)+acc)',obj.Part{i,1}.mesh.elements+...
                        acc1*ones(mm,4)];
                case 3
                    Temp=[Temp1,((1:mm)+acc)',obj.Part{i,1}.mesh.elements(:,1:3)+...
                        acc1*ones(mm,3),obj.Part{i,1}.mesh.elements(:,3)+...
                        acc1*ones(mm,1)];
            end
            fprintf(fid, '%s\n','EBLOCK,19,SOLID,');
            fprintf(fid, '%s\n','(19i8)');
            for j=1:size(Temp,1)
                fprintf(fid,'%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i\n',Temp(j,1:15)');
            end
        case '183'
            mm=obj.Part{i,1}.NumElements;
            acc=obj.Part{i,1}.acc_el;
            acc1=obj.Part{i,1}.acc_node;
            col1=obj.Part{i,1}.mesh.elementMaterialID;
            col2=obj.Part{i,1}.ET;
            col3=obj.Part{i,1}.RealConstants;
            col4=obj.Part{i,1}.Sec;
            col5=obj.Part{i,1}.ESYS;
            % col6=0;
            % col7=0;
            % col8=0;
            col9=8;
            % col10=0;
            Temp1=[col1,repmat(col2,mm,1),repmat(col3,mm,1),repmat(col4,mm,1),...
                repmat(col5,mm,1),zeros(mm,1),zeros(mm,1),...
                zeros(mm,1),repmat(col9,mm,1),zeros(mm,1)];

            ENum=size(obj.Part{i,1}.mesh.elements,2);
            switch ENum
                case 8
                    Temp=[Temp1,((1:mm)+acc)',obj.Part{i,1}.mesh.elements+...
                        acc1*ones(mm,8)];
                case 6
                    Temp=[Temp1,((1:mm)+acc)',obj.Part{i,1}.mesh.elements(:,1:3)+...
                        acc1*ones(mm,3),obj.Part{i,1}.mesh.elements(:,3)+...
                        acc1*ones(mm,1),obj.Part{i,1}.mesh.elements(:,4:5)+...
                        acc1*ones(mm,2),obj.Part{i,1}.mesh.elements(:,5)+...
                        acc1*ones(mm,1),obj.Part{i,1}.mesh.elements(:,6)+...
                        acc1*ones(mm,1)];
            end
            fprintf(fid, '%s\n','EBLOCK,19,SOLID,');
            fprintf(fid, '%s\n','(19i8)');
            for j=1:size(Temp,1)
                fprintf(fid,'%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i\n',Temp(j,1:19)');
            end

        case '185'
            mm=obj.Part{i,1}.NumElements;
            acc=obj.Part{i,1}.acc_el;
            acc1=obj.Part{i,1}.acc_node;
            col1=obj.Part{i,1}.mesh.elementMaterialID;
            col2=obj.Part{i,1}.ET;
            col3=obj.Part{i,1}.RealConstants;
            col4=obj.Part{i,1}.Sec;
            col5=obj.Part{i,1}.ESYS;
            % col6=0;
            % col7=0;
            % col8=0;
            col9=8;
            % col10=0;
            Temp1=[col1,repmat(col2,mm,1),repmat(col3,mm,1),repmat(col4,mm,1),...
                repmat(col5,mm,1),zeros(mm,1),zeros(mm,1),...
                zeros(mm,1),repmat(col9,mm,1),zeros(mm,1)];

            ENum=size(obj.Part{i,1}.mesh.elements,2);
            switch ENum
                case 8
                    Temp=[Temp1,((1:mm)+acc)',obj.Part{i,1}.mesh.elements+...
                        acc1*ones(mm,8)];
                case 6
                    Temp=[Temp1,((1:mm)+acc)',obj.Part{i,1}.mesh.elements(:,1:3)+...
                        acc1*ones(mm,3),obj.Part{i,1}.mesh.elements(:,3)+...
                        acc1*ones(mm,1),obj.Part{i,1}.mesh.elements(:,4:6)+...
                        acc1*ones(mm,3),obj.Part{i,1}.mesh.elements(:,6)+...
                        acc1*ones(mm,1)];
                case 4
                    Temp=[Temp1,((1:mm)+acc)',obj.Part{i,1}.mesh.elements(:,1:3)+...
                        acc1*ones(mm,3),obj.Part{i,1}.mesh.elements(:,3)+...
                        acc1*ones(mm,1),repmat(obj.Part{i,1}.mesh.elements(:,4)+...
                        acc1*ones(mm,1),1,4)];
            end
            fprintf(fid, '%s\n','EBLOCK,19,SOLID,');
            fprintf(fid, '%s\n','(19i8)');
            for j=1:size(Temp,1)
                fprintf(fid,'%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i\n',Temp(j,1:19)');
            end
        case '186'
            mm=obj.Part{i,1}.NumElements;
            acc=obj.Part{i,1}.acc_el;
            acc1=obj.Part{i,1}.acc_node;
            col1=obj.Part{i,1}.mesh.elementMaterialID;
            col2=obj.Part{i,1}.ET;
            col3=obj.Part{i,1}.RealConstants;
            col4=obj.Part{i,1}.Sec;
            col5=obj.Part{i,1}.ESYS;
            % col6=0;
            % col7=0;
            % col8=0;
            col9=20;
            % col10=0;
            Temp1=[col1,repmat(col2,mm,1),repmat(col3,mm,1),repmat(col4,mm,1),...
                repmat(col5,mm,1),zeros(mm,1),zeros(mm,1),...
                zeros(mm,1),repmat(col9,mm,1),zeros(mm,1)];

            ENum=size(obj.Part{i,1}.mesh.elements,2);
            switch ENum
                case 20
                    Temp=[Temp1,((1:mm)+acc)',obj.Part{i,1}.mesh.elements+...
                        acc1*ones(mm,col9)];
                case 15
                    Temp=[Temp1,((1:mm)+acc)',obj.Part{i,1}.mesh.elements(:,1:3)+...
                        acc1*ones(mm,3),obj.Part{i,1}.mesh.elements(:,3)+...
                        acc1*ones(mm,1),obj.Part{i,1}.mesh.elements(:,4:6)+...
                        acc1*ones(mm,3),obj.Part{i,1}.mesh.elements(:,6)+...
                        acc1*ones(mm,1),obj.Part{i,1}.mesh.elements(:,7:8)+...
                        acc1*ones(mm,2),obj.Part{i,1}.mesh.elements(:,3)+...
                        acc1*ones(mm,1),obj.Part{i,1}.mesh.elements(:,9:11)+...
                        acc1*ones(mm,3),obj.Part{i,1}.mesh.elements(:,6)+...
                        acc1*ones(mm,1),obj.Part{i,1}.mesh.elements(:,12:15)+...
                        acc1*ones(mm,4),obj.Part{i,1}.mesh.elements(:,15)+...
                        acc1*ones(mm,1)];
                case 10
                    Temp=[Temp1,((1:mm)+acc)',obj.Part{i,1}.mesh.elements(:,1:3)+...
                        acc1*ones(mm,3),obj.Part{i,1}.mesh.elements(:,3)+...
                        acc1*ones(mm,1),repmat(obj.Part{i,1}.mesh.elements(:,4),1,4)+...
                        acc1*ones(mm,4),obj.Part{i,1}.mesh.elements(:,5:6)+...
                        acc1*ones(mm,2),obj.Part{i,1}.mesh.elements(:,3)+...
                        acc1*ones(mm,1),obj.Part{i,1}.mesh.elements(:,7)+...
                        acc1*ones(mm,1),repmat(obj.Part{i,1}.mesh.elements(:,4),1,4)+...
                        acc1*ones(mm,4),obj.Part{i,1}.mesh.elements(:,8:10)+...
                        acc1*ones(mm,3),obj.Part{i,1}.mesh.elements(:,10)+...
                        acc1*ones(mm,1)];
            end

            fprintf(fid, '%s\n','EBLOCK,19,SOLID,');
            fprintf(fid, '%s\n','(19i8)');
            for j=1:size(Temp,1)
                fprintf(fid,'%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i\n',Temp(j,1:19)');
                fprintf(fid,'%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i\n',Temp(j,20:31)');
            end
        case '187'
            mm=obj.Part{i,1}.NumElements;
            acc=obj.Part{i,1}.acc_el;
            acc1=obj.Part{i,1}.acc_node;
            col1=obj.Part{i,1}.mesh.elementMaterialID;
            col2=obj.Part{i,1}.ET;
            col3=obj.Part{i,1}.RealConstants;
            col4=obj.Part{i,1}.Sec;
            col5=obj.Part{i,1}.ESYS;
            % col6=0;
            % col7=0;
            % col8=0;
            col9=10;
            % col10=0;
            Temp1=[col1,repmat(col2,mm,1),repmat(col3,mm,1),repmat(col4,mm,1),...
                repmat(col5,mm,1),zeros(mm,1),zeros(mm,1),...
                zeros(mm,1),repmat(col9,mm,1),zeros(mm,1)];

            Temp=[Temp1,((1:mm)+acc)',obj.Part{i,1}.mesh.elements+...
                acc1*ones(mm,col9)];

            fprintf(fid, '%s\n','EBLOCK,19,SOLID,');
            fprintf(fid, '%s\n','(19i8)');
            for j=1:size(Temp,1)
                fprintf(fid,'%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i\n',Temp(j,1:19)');
                fprintf(fid,'%8i%8i\n',Temp(j,20:21)');
            end

        case '188'
            mm=obj.Part{i,1}.NumElements;
            acc=obj.Part{i,1}.acc_el;
            acc1=obj.Part{i,1}.acc_node;
            col1=obj.Part{i,1}.mesh.elementMaterialID;
            col2=obj.Part{i,1}.ET;
            col3=obj.Part{i,1}.RealConstants;
            col4=obj.Part{i,1}.Sec;
            col5=obj.Part{i,1}.ESYS;
            % col6=0;
            % col7=0;
            % col8=0;
            col9=size(obj.Part{i,1}.mesh.elements(1,:)',1);
            % col10=0;
            Temp1=[col1,repmat(col2,mm,1),repmat(col3,mm,1),repmat(col4,mm,1),...
                repmat(col5,mm,1),zeros(mm,1),zeros(mm,1),...
                zeros(mm,1),repmat(col9,mm,1),zeros(mm,1)];
            Temp=[Temp1,((1:mm)+acc)',obj.Part{i,1}.mesh.elements+...
                acc1*ones(mm,col9)];
            fprintf(fid, '%s\n','EBLOCK,19,SOLID,');
            fprintf(fid, '%s\n','(19i8)');
            for j=1:size(Temp,1)
                fprintf(fid,'%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i\n',Temp(j,1:14)');
            end
        case '214'
            mm=obj.Part{i,1}.NumElements;
            acc=obj.Part{i,1}.acc_el;
            acc1=obj.Part{i,1}.acc_node;
            % col1=0;
            col2=obj.Part{i,1}.ET;
            col3=obj.Part{i,1}.RealConstants;
            % col4=0;
            % col5=0;
            % col6=0;
            % col7=0;
            % col8=0;
            col9=2;
            % col10=0;
            Temp1=[zeros(mm,1),repmat(col2,mm,1),repmat(col3,mm,1),zeros(mm,1),...
                zeros(mm,1),zeros(mm,1),zeros(mm,1),...
                zeros(mm,1),repmat(col9,mm,1),zeros(mm,1)];
            Temp=[Temp1,((1:mm)+acc)',obj.Part{i,1}.mesh.elements+...
                acc1*ones(mm,col9)];
            fprintf(fid, '%s\n','EBLOCK,19,SOLID,');
            fprintf(fid, '%s\n','(19i8)');
            for j=1:size(Temp,1)
                fprintf(fid,'%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i\n',Temp(j,1:13)');
            end
        case '281'
            mm=obj.Part{i,1}.NumElements;
            acc=obj.Part{i,1}.acc_el;
            acc1=obj.Part{i,1}.acc_node;
            col1=obj.Part{i,1}.mesh.elementMaterialID;
            col2=obj.Part{i,1}.ET;
            col3=obj.Part{i,1}.RealConstants;
            col4=obj.Part{i,1}.Sec;
            col5=obj.Part{i,1}.ESYS;
            % col6=0;
            % col7=0;
            % col8=0;
            col9=8;
            % col10=0;
            Temp1=[col1,repmat(col2,mm,1),repmat(col3,mm,1),repmat(col4,mm,1),...
                repmat(col5,mm,1),zeros(mm,1),zeros(mm,1),...
                zeros(mm,1),repmat(col9,mm,1),zeros(mm,1)];

            ENum=size(obj.Part{i,1}.mesh.elements,2);
            switch ENum
                case 8
                    Temp=[Temp1,((1:mm)+acc)',obj.Part{i,1}.mesh.elements+...
                        acc1*ones(mm,8)];
                case 6
                    Temp=[Temp1,((1:mm)+acc)',obj.Part{i,1}.mesh.elements(:,1:3)+...
                        acc1*ones(mm,3),obj.Part{i,1}.mesh.elements(:,3)+...
                        acc1*ones(mm,1),obj.Part{i,1}.mesh.elements(:,4:5)+...
                        acc1*ones(mm,2),obj.Part{i,1}.mesh.elements(:,5)+...
                        acc1*ones(mm,1),obj.Part{i,1}.mesh.elements(:,6)+...
                        acc1*ones(mm,1)];
            end
            fprintf(fid, '%s\n','EBLOCK,19,SOLID,');
            fprintf(fid, '%s\n','(19i8)');
            for j=1:size(Temp,1)
                fprintf(fid,'%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i\n',Temp(j,1:19)');
            end

    end
    fprintf(fid, '%s\n',num2str(-1));
    sen=strcat('CM,part',num2str(i),',ELEM');
    fprintf(fid, '%s\n',sen);
    fprintf(fid, '%s\n','ESEL,NONE');
end

m=size(obj.Cnode_Mat,1);
if m~=0
    for i=1:m
        fprintf(fid, '%s\n','EBLOCK,19,SOLID,');
        fprintf(fid, '%s\n','(19i8)');
        if ~isempty(obj.Cnode_Mat(i,1))
            col1=0;
            col2=obj.Cnode_Mat(i,1);
            col3=obj.Cnode_Mat(i,1);
            col4=0;
            col5=0;
            col6=0;
            col7=0;
            col8=0;
            col9=1;
            col10=0;
            Temp1=[col1,col2,col3,col4,...
                col5,col6,col7,...
                col8,col9,col10];
            Temp=[Temp1,obj.Summary.Total_El+i,size(obj.V,1)+i];
            fprintf(fid,'%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i%8i\n',Temp');
        end
        fprintf(fid, '%s\n',num2str(-1));
        sen=strcat('CM,MASS',num2str(i),',ELEM');
        fprintf(fid, '%s\n',sen);
        fprintf(fid, '%s\n','ESEL,NONE');
    end
    fprintf(fid, '%s\n','ESEL,ALL');
end