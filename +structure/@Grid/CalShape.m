function obj=CalShape(obj)
% Calculate shape of grid
% Author : Xie Yu
L=Layer(obj.params.Name,'Echo',0);
lx=obj.input.lx;
ly=obj.input.ly;
lz=obj.input.lz;
ny=obj.input.ny;
nx=obj.input.nx;

switch obj.params.Type
    case 1
        L=AddGrid(L,lx,ly,nx,ny);
        L=AddGrid(L,lx,ly,nx-2,ny-2);
        L=Move(L,[-lx*(nx-1)/2,-ly*(ny-1)/2,0],'Lines',1);
        L=Move(L,[-lx*(nx-3)/2,-ly*(ny-3)/2,lz],'Lines',2);
        L=Move(L,[-lx*(nx-1)/2,-ly*(ny-1)/2,0],'Points',1);
        L=Move(L,[-lx*(nx-3)/2,-ly*(ny-3)/2,lz],'Points',2);

        Seq1=1:nx;
        Temp=0:ny-1;
        Seq1=repmat(Seq1,ny,1);
        Temp=repmat(Temp',1,nx);
        Seq1=Seq1+Temp*nx;

        Seq2=1:nx-2;
        Temp=0:ny-3;
        Seq2=repmat(Seq2,ny-2,1);
        Temp=repmat(Temp',1,nx-2);
        Seq2=Seq2+Temp*(nx-2);

        TempSeq1=Seq1(2:ny-1,2:nx-1);
        % 竖杆
        L=ConnectPoints(L,1,2,reshape(TempSeq1',[],1),(1:(nx-2)*(ny-2))');

        %斜腹杆
        TempSeq1=Seq1(2:ny-1,[1:(nx-1)/2,(nx+1)/2+1:nx]);
        TempSeq2=Seq2(:,[1:(nx-3)/2,(nx-1)/2,(nx-1)/2,(nx-1)/2+1:nx-2]);

        L=ConnectPoints(L,1,2,reshape(TempSeq1',[],1),reshape(TempSeq2',[],1));

        TempSeq1=Seq1([1:(ny-1)/2,(ny+1)/2+1:ny],2:nx-1);
        TempSeq2=Seq2([1:(ny-3)/2,(ny-1)/2,(ny-1)/2,(ny-1)/2+1:ny-2],:);

        L=ConnectPoints(L,1,2,reshape(TempSeq1',[],1),reshape(TempSeq2',[],1));
    case 2
        L=AddGrid(L,lx,ly,nx,ny,'Type',2);
        L=AddGrid(L,lx,ly,nx-1,ny-1,'Type',3);
        L=Move(L,[-lx*(nx-1)/2,-ly*(ny-1)/2,0],'Lines',1);
        L=Move(L,[-lx*(nx-2)/2,-ly*(ny-2)/2,lz],'Lines',2);
        L=Move(L,[-lx*(nx-1)/2,-ly*(ny-1)/2,0],'Points',1);
        L=Move(L,[-lx*(nx-2)/2,-ly*(ny-2)/2,lz],'Points',2);

        Seq11=1:nx;
        Temp=0:ny-1;
        Seq11=repmat(Seq11,ny,1);
        Temp=repmat(Temp',1,nx);
        Seq11=Seq11+Temp*nx;

        Seq12=nx*ny+1:nx*ny+nx-1;
        Temp=0:ny-2;
        Seq12=repmat(Seq12,ny-1,1);
        Temp=repmat(Temp',1,nx-1);
        Seq12=Seq12+Temp*(nx-1);

        Seq21=1:nx-1;
        Temp=0:ny-2;
        Seq21=repmat(Seq21,ny-1,1);
        Temp=repmat(Temp',1,nx-1);
        Seq21=Seq21+Temp*(nx-1);

        Seq22=(nx-1)*(ny-1)+1:(nx-1)*(ny-1)+nx-2;
        Temp=0:ny-3;
        Seq22=repmat(Seq22,ny-2,1);
        Temp=repmat(Temp',1,nx-2);
        Seq22=Seq22+Temp*(nx-2);

        TempSeq11=Seq12;
        TempSeq12=Seq11(2:(ny-1),2:(nx-1));
        % 竖杆
        L=ConnectPoints(L,1,2,[reshape(TempSeq11',[],1);reshape(TempSeq12',[],1)],...
            (1:(nx-1)*(ny-1)+(nx-2)*(ny-2))');

        %斜腹杆1
        MaxSpan=(min(nx,ny)-1)*2;
        Span1=2:2:(nx+ny-3)*2;
        Span2=(nx+ny-3)*2:-2:2;
        Span=min(Span1',Span2');
        Span(Span>MaxSpan,:)=MaxSpan;
        Sx=[nx-1:-1:1,ones(1,ny-2)];
        Sy=[ones(1,nx-1),2:ny-1];
        
        acc=0;
        TempSeq21=NaN(1,sum(Span));TempSeq22=NaN(1,sum(Span));
        for i=1:nx+ny-3
            Temp_Span=Span(i,1);
            k=0;
            Col=Sx(i);
            Row=Sy(i);
            for j=1:Temp_Span          
                if j<=Temp_Span/2
                    if k==0
                        TempSeq21(1,acc+1)=Seq11(Row+floor((j+1)/2)-1,Col+floor((j+1)/2)-1);
                        TempSeq22(1,acc+1)=Seq21(Row+floor((j+1)/2)-1,Col+floor((j+1)/2)-1);
                        k=1;
                    else
                        TempSeq21(1,acc+1)=Seq12(Row+floor((j+1)/2)-1,Col+floor((j+1)/2)-1);
                        TempSeq22(1,acc+1)=Seq22(Row+floor((j+1)/2)-1,Col+floor((j+1)/2)-1);
                        k=0;
                    end
                else
                    if k==0
                        TempSeq21(1,acc+1)=Seq12(Row+floor((j+1)/2)-1,Col+floor((j+1)/2)-1);
                        TempSeq22(1,acc+1)=Seq22(Row+floor((j+1)/2)-2,Col+floor((j+1)/2)-2);
                        k=1;
                    else
                        TempSeq21(1,acc+1)=Seq11(Row+floor((j+1)/2),Col+floor((j+1)/2));
                        TempSeq22(1,acc+1)=Seq21(Row+floor((j+1)/2)-1,Col+floor((j+1)/2)-1);
                        k=0;
                    end
                end
                acc=acc+1;

            end

        end
        L=ConnectPoints(L,1,2,reshape(TempSeq21(1:acc)',[],1),reshape(TempSeq22(1:acc)',[],1));
        %斜腹杆2

        Sx=[2:1:nx,ones(1,ny-2)*nx];
        Sy=[ones(1,nx-1),2:ny-1];
        
        acc=0;
        TempSeq31=NaN(1,sum(Span));TempSeq32=NaN(1,sum(Span));
        for i=1:nx+ny-3
        % for i=1:3
            Temp_Span=Span(i,1);
            k=0;
            Col=Sx(i);
            Row=Sy(i);
            for j=1:Temp_Span          
                if j<=Temp_Span/2
                    if k==0
                        TempSeq31(1,acc+1)=Seq11(Row+floor((j+1)/2)-1,Col-floor((j+1)/2)+1);
                        TempSeq32(1,acc+1)=Seq21(Row+floor((j+1)/2)-1,Col-floor((j+1)/2));
                        k=1;
                    else
                        TempSeq31(1,acc+1)=Seq12(Row+floor((j+1)/2)-1,Col-floor((j+1)/2));
                        TempSeq32(1,acc+1)=Seq22(Row+floor((j+1)/2)-1,Col-floor((j+1)/2)-1);
                        k=0;
                    end
                else
                    if k==0
                        TempSeq31(1,acc+1)=Seq12(Row+floor((j+1)/2)-1,Col-floor((j+1)/2));
                        TempSeq32(1,acc+1)=Seq22(Row+floor((j+1)/2)-2,Col-floor((j+1)/2));
                        k=1;
                    else
                        TempSeq31(1,acc+1)=Seq11(Row+floor((j+1)/2),Col-floor((j+1)/2));
                        TempSeq32(1,acc+1)=Seq21(Row+floor((j+1)/2)-1,Col-floor((j+1)/2));
                        k=0;
                    end
                end
                acc=acc+1;

            end
           
        end
        L=ConnectPoints(L,1,2,reshape(TempSeq31(1:acc)',[],1),reshape(TempSeq32(1:acc)',[],1));
    case 3
        L=AddGrid(L,lx,ly,nx,ny);
        L=AddGrid(L,lx,ly,nx-1,ny-1);
        L=Move(L,[-lx*(nx-1)/2,-ly*(ny-1)/2,0],'Lines',1);
        L=Move(L,[-lx*(nx-2)/2,-ly*(ny-2)/2,lz],'Lines',2);
        L=Move(L,[-lx*(nx-1)/2,-ly*(ny-1)/2,0],'Points',1);
        L=Move(L,[-lx*(nx-2)/2,-ly*(ny-2)/2,lz],'Points',2);

        Seq1=1:nx;
        Temp=0:ny-1;
        Seq1=repmat(Seq1,ny,1);
        Temp=repmat(Temp',1,nx);
        Seq1=Seq1+Temp*nx;

        Seq2=1:nx-1;
        Temp=0:ny-2;
        Seq2=repmat(Seq2,ny-1,1);
        Temp=repmat(Temp',1,nx-1);
        Seq2=Seq2+Temp*(nx-1);
        %斜腹杆1
        TempSeq11=Seq1(1:ny-1,1:nx-1);
        TempSeq12=Seq2;
        TempSeq21=Seq1(2:ny,2:nx);
        TempSeq22=Seq2;

        L=ConnectPoints(L,1,2,[reshape(TempSeq11',[],1);reshape(TempSeq21',[],1)]...
            ,[reshape(TempSeq12',[],1);reshape(TempSeq22',[],1)]);
        %斜腹杆2
        TempSeq11=Seq1(1:ny-1,2:nx);
        TempSeq12=Seq2;
        TempSeq21=Seq1(2:ny,1:nx-1);
        TempSeq22=Seq2;

        L=ConnectPoints(L,1,2,[reshape(TempSeq11',[],1);reshape(TempSeq21',[],1)]...
            ,[reshape(TempSeq12',[],1);reshape(TempSeq22',[],1)]);
    case 4
        L=AddGrid(L,lx,ly,nx,ny,'Type',4);
        L=AddGrid(L,lx,ly,nx,ny);
        L=Move(L,[-lx*(nx-1)/2,-ly*(ny-1)/2,0],'Lines',1);
        L=Move(L,[-lx*(nx-1)/2,-ly*(ny-2)/2,lz],'Lines',2);
        L=Move(L,[-lx*(nx-1)/2,-ly*(ny-1)/2,0],'Points',1);
        L=Move(L,[-lx*(nx-1)/2,-ly*(ny-2)/2,lz],'Points',2);

        Seq11=1:nx;
        Temp=0:ny;
        Seq11=repmat(Seq11,ny+1,1);
        Temp=repmat(Temp',1,nx);
        Seq11=Seq11+Temp*nx;

        Seq12=nx*(ny+1)+1:nx*(ny+1)+nx+1;
        Temp=0:ny-1;
        Seq12=repmat(Seq12,ny,1);
        Temp=repmat(Temp',1,nx+1);
        Seq12=Seq12+Temp*(nx+1);

        Seq21=1:nx;
        Temp=0:ny-1;
        Seq21=repmat(Seq21,ny,1);
        Temp=repmat(Temp',1,nx);
        Seq21=Seq21+Temp*nx;

        %斜腹杆1
        TempSeq11=Seq11(1:ny,1:nx);
        TempSeq12=Seq21;
        TempSeq21=Seq11(2:ny+1,1:nx);
        TempSeq22=Seq21;

        L=ConnectPoints(L,1,2,[reshape(TempSeq11',[],1);reshape(TempSeq21',[],1)]...
            ,[reshape(TempSeq12',[],1);reshape(TempSeq22',[],1)]);
        %斜腹杆2
        TempSeq11=Seq12(1:ny,1:nx);
        TempSeq12=Seq21;
        TempSeq21=Seq12(1:ny,2:nx+1);
        TempSeq22=Seq21;

        L=ConnectPoints(L,1,2,[reshape(TempSeq11',[],1);reshape(TempSeq21',[],1)]...
            ,[reshape(TempSeq12',[],1);reshape(TempSeq22',[],1)]);

end

%% Parse
obj.output.Shape=L;
%% Print
if obj.params.Echo
    fprintf('Successfully calculate shape .\n');
end
end