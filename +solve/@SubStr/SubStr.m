classdef SubStr < Component
    % Class SubStr
    % Author: Xie Yu
    
    properties(Hidden, Constant)

        paramsExpectedFields = {
            'Name' %名称
            'Freq' % Frequency range
            'NMode'
            'CMSMethod'
            };

        inputExpectedFields = {
            'SubStr'
            'Master' % PartNum,NodeNum,Type
            };

        outputExpectedFields = {
            'Nodes'
            'Geom'
            'Path'
            };

        baselineExpectedFields = {
            };
        default_Name='SubStr1';
        default_Freq=[0,100000];
        default_NMode=50;
        default_CMSMethod="FIX";

    end
    methods

        function obj = SubStr(paramsStruct,inputStruct)
            obj = obj@Component(paramsStruct,inputStruct);
            obj.documentname='SubStr.pdf';
        end

        function obj = solve(obj)
            Ass=Assembly(obj.params.Name);
            Ass=AddAssembly(Ass,obj.input.SubStr);
            %% Solution
            opt.ANTYPE=7;% SUBSTR solve
            opt.SEOPT={obj.params.Name,2,1,1};
            opt.CMSOPT=[obj.params.CMSMethod,obj.params.NMode,obj.params.Freq(1),obj.params.Freq(2),'FAUTO',0,'TCMS'];
            Ass=AddSolu(Ass,opt);
            Part=obj.input.Master.PartNum;
            Type=obj.input.Master.Type;
            Node=obj.input.Master.NodeNum;
            for i=1:size(Node,1)
                Ass=AddSubStrM(Ass,Part(i,1),Node(i,1),'Type',Type(i,1));
            end
            for i=1:size(Ass.SubStrM.Node,1)
                value=GetSubStrMNum(Ass,i);
                obj.output.Nodes=[obj.output.Nodes;value];
            end
            ANSYS_Output(Ass,'Name','Intial','CDBWrite',1);
            delete(strcat(obj.params.Name,'.cdb'));
            delete(strcat(obj.params.Name,'.rst'));
            delete(strcat(obj.params.Name,'.tcms'));
            delete(strcat(obj.params.Name,'.sub'));
            ANSYSSolve(Ass,'Name','Intial');
            [Shell,Beam,Face,MNode,Con]=GetFace(Ass,obj.input.Master);
            Geom.Shell=Shell;
            Geom.Beam=Beam;
            Geom.Face=Face;
            Geom.MNode=MNode;
            Geom.Con=Con;
            obj.output.Geom=Geom;
            obj.output.Path=pwd;
       end

    end
end
