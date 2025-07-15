classdef DNVGL_0361 < Component
    % DNVGL_0361 SN Curve
    % Author: Yu Xie
    
    properties (Hidden, Constant)
        
        paramsExpectedFields = {
            'Beta_k' % Notch factor
            'Gamma_m' % Material safety factor
            'Sps'% Survival probability
            'j0'
            'Echo'
            };
        
        inputExpectedFields = {
            'Mat' % 材料属性
            't' % Wall thickness [mm]
            'deff' % 有效直径 [mm]
            'Rz' % 表面粗糙度
            'R' % Stress ratio 
            'Sigma_m' %  Mean stress
            'j'
            
            };
        
        outputExpectedFields = {
            'Sigma_b' % Tensile strength (normative) [MPa]
            'Sigma_0d2' % Yield strength (normative) [MPa]
            'Ft' % Technology factor
            'Fo' % Surface roughness factor
            'Fot' % Combined surface and technology factor
            'Fotk' % Total influencing factor
            'm1' % Slope1 of SN curve
            'm2' %  Slope2 of SN curve
            'Sigma_w' % Fatigue strength of polished sprcimen [MPa]
            'M' % Mean stress sensitivity
            'Sigma_wk' % Fatigue strength of component [MPa]
            'Sigma_A' % Stress amplitude at knee of S/N curve [MPa]
            'Delta_Sigma_1' % Upper limit of fatigue life [MPa]
            'Delta_Sigma_A' % Upgraded stress range at knee of S/N curve [MPa]
            'Sd' % Quality level
            'St' % Wall thickness-dependent values 
            'S' % Total upgrading factor 
            'ND' % Number of load cycles at knee of S/N curve
            'N1' % Number of load cycles at upper fatigue limit
            };

        baselineExpectedFields = {
            };

        default_Beta_k=1
        default_Gamma_m=1.265
        default_Sps=2/3
        default_Echo=1
        default_j0=0

    end
    methods
        
        function obj = DNVGL_0361(paramsStruct,inputStruct)
            obj = obj@Component(paramsStruct,inputStruct);
            obj.documentname='DNVGL_0361.pdf'; % Set help file name, put it in the folder "Document"
        end
        
        function obj = solve(obj)
            if ~isempty(obj.input.deff)
                inputStruct.deff=obj.input.deff;
                inputStruct.Mat=obj.input.Mat;
                paramsStruct=struct();
                obj1= method.FKM.FKM_Cal(paramsStruct, inputStruct);
                [~,~,Rm,Rp] = Size_Factor_Cal(obj1);
            else
                Rm=obj.input.Mat.FKM.RmN;
                Rp=obj.input.Mat.FKM.RpN;
            end

            Type=obj.input.Mat.Type;

            switch Type
                case "Through hardening steel"
                    obj = CalForgedRolledParts(obj,Rm,Rp);
                case "case hardening steel"
                    obj = CalForgedRolledParts(obj,Rm,Rp);obj = CalForgedRolledParts(obj,Rm,Rp);
                case "Nitriding steel"
                    obj = CalForgedRolledParts(obj,Rm,Rp);
                case "Cast iron spherioidal graphite GJS"
                    obj = CalGJS(obj,Rm,Rp);
            end

            if obj.params.Echo
                fprintf('Successfully calculate SN curve caccording to DNVGL_0361 ! .\n');
            end

        end


        function obj = Plot(obj)
            N1=obj.output.N1;
            ND=obj.output.ND;
            Delta1=obj.output.Delta_Sigma_1;
            DeltaA=obj.output.Delta_Sigma_A;
            m1=obj.output.m1;
            m2=obj.output.m2;


            x1=log10(N1);
            xD=log10(ND);
            Temp=[1:floor(x1),x1,ceil(x1):floor(xD),xD,ceil(xD):13];
            x=10.^(Temp);
            y=Delta1.*(x<=N1)+...
                (ND*DeltaA^m1./x).^(1/m1).*(and(x>N1,x<=ND))+...
                (ND*DeltaA^m2./x).^(1/m2).*(x>ND);
            loglog(x,y,'LineWidth',2);
            grid on
            xlabel('Number of Cycles')
            ylabel('Stress Range (Mpa)')
            title(strcat(obj.input.Mat.Name,' SN Curve'));

        end


    end
        

end