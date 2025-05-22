classdef  RotDynPIDController < matlab.mixin.Heterogeneous & handle
    % Superclass (abstract) for pid controller for the AMB-force

    %   Outputs a force to a certain node, that is closest to position, to
    %   maintain the desired displacement at that node
    %   First calculates the current controller current:
    %   I = Kp*e(t) + Ki*int(e(tau),t) + Kd*de(t)/dt
    %   In every integrator step it calclates the force from a model
    %   force = f(x,I)


    % Description of some properties
    % cumError = 0 % cummulated error
    % prevError = 0 % error in the previus step
    % prevTime = 0 % time of the previous step
    % current = 0 % A, current controller current

    properties
        Direction; % 'Ux','Uy','Uz','Rotx','Roty','Rotz'
        Type
        Target
        Node
        Node1

        P; % A/mm
        I; % A/(mm*s)
        D; % As/mm

        cumError = 0
        prevError = 0
        prevTime = 0
        current = 0

        Table
        Ki

        % force = [I, x]*A*[I^2;x^2] + [I,x]*B*[I;x] + cT*[I;x] + d
        A
        B
        C
        cT
        d
    end
    methods
        function obj=RotDynPIDController(cnfg)
            % Constructor
            obj.Node = cnfg.Node;
            obj.Direction = cnfg.Direction;
            obj.Type = cnfg.Type;
            obj.Target = cnfg.Target;
            obj.P = cnfg.P;
            obj.I = cnfg.I;
            obj.D = cnfg.D;
            if isfield(cnfg,'Node1')
                obj.Node1=cnfg.Node1;
            end

            if isfield(cnfg,'Table')
                obj.Table=cnfg.Table;
            end

            if isfield(cnfg,'Ki')
                obj.Ki = cnfg.Ki;%[N/A], proportionality between controller current and force, force = ki*I
            end

            if isfield(cnfg,'A')
                obj.A = cnfg.A;
            end

            if isfield(cnfg,'B')
                obj.B = cnfg.B;
            end

            if isfield(cnfg,'C')
                obj.C = cnfg.C;
            end

            if isfield(cnfg,'cT')
                obj.cT = cnfg.cT;
            end

            if isfield(cnfg,'d')
                obj.d = cnfg.d;
            end

        end

        function current = get_controller_current(obj,tCurr,y)
            % Provides the controller current in ampere
            %    :parameter obj: Object of type pidController
            %    :type obj: object
            %    :parameter tcurr: Time-vector of solution
            %    :type tcurr: vector
            %    :parameter y: position vector at the corresponding controller node
            %    :type y: vector
            %    :return: Controller current

            % get the contoller-current i with unit A (ampere)
            % gets called at the controller-frequency
            %   obj: pidController-object
            %   t: time-vector of solution
            %   y: position vector at the corresponding controller node

            p = obj.P*1000; % Unit A/mm --> A/m
            i = obj.I*1000; % Unit A/(mms) --> A/(ms)
            d = obj.D*1000; %#ok<PROPLC> % Unit As/mm --> As/m

            dof_name = {'Ux','Uy','Uz','Rotx','Roty','Rotz'};
            dof_loc = [3,1,2,6,4,5];
            ldof = containers.Map(dof_name,dof_loc);
            entryNo = ldof(obj.Direction);

            currVal = y(entryNo);
            dt = tCurr - obj.prevTime;

            target = obj.Target/1000; % Unit mm -->m

            % "loop"
            % P
            error = target - currVal;
            pCor = p * error;
            % I
            obj.cumError = obj.cumError + error;
            iCor = i * obj.cumError * dt;
            % D
            slopeError = (error - obj.prevError) / dt;
            dCor = d * slopeError; %#ok<PROPLC>
            obj.prevError = error;
            obj.prevTime = tCurr;

            cor = pCor + iCor + dCor;

            % Stellgroessenbegrenzung
            % if cor > maxCor, cor = maxCor; end
            % if cor < minCor, cor = minCor; end

            current = cor;

            % write new values to controller object

            obj.current = current;


        end

        function force= get_controller_force(obj,time,displacement)
            % Provides the controller force from LUT
            %
            %    :parameter tcurr: Time-vector of solution
            %    :type tcurr: vector
            %    :parameter displacement: Displacement
            %    :type displacement: vector
            %    :return: Controller force

            switch obj.Type
                case 1
                    force = obj.Ki * obj.current;
                case 2
                    % force = [I, x]*A*[I^2;x^2] + [I,x]*B*[I;x] + cT*[I;x] + d

                    dof_name = {'Ux','Uy','Uz','Rotx','Roty','Rotz'};
                    dof_loc = [3,1,2,6,4,5];
                    ldof = containers.Map(dof_name,dof_loc);
                    entryNo = ldof(obj.Direction);

                    Z = [obj.current; displacement(entryNo)*1000];% Unit m --> mm

                    force = Z.'*obj.A*(Z.^2) + Z.'*obj.B*Z + obj.cT*Z + obj.d;

                case 3
                    dof_name = {'Ux','Uy','Uz','Rotx','Roty','Rotz'};
                    dof_loc = [3,1,2,6,4,5];
                    ldof = containers.Map(dof_name,dof_loc);
                    entryNo = ldof(obj.Direction);

                    u = displacement(entryNo);

                    uTable = obj.Table.displacement/1000; % Unit mm-->m
                    iTable = obj.Table.current;
                    fTable = obj.Table.force;
                    force = interp2(uTable,iTable,fTable,u,obj.current);
                    if u > max(uTable)
                        warning(['Extrapolation of force for pidCOntroller from Look-Up-Table ',...
                            'at displacement of more than max(table.displacement)=',...
                            num2str(max(uTable)),'. ',...
                            'Results may be inaccurate!']);
                    end

                    if obj.current > max(iTable)
                        warning(['Extrapolation of force for pidCOntroller from Look-Up-Table ',...
                            'at current of more than max(table.current)=',...
                            num2str(max(iTable)),'. ',...
                            'Results may be inaccurate!']);
                    end

            end


        end
    end


end