classdef Foil < Component
    % Class Foil
    % Author: Xie Yu
   
    properties(Hidden, Constant)

        paramsExpectedFields = {
            'Re'
            'Name' % Name
            'Mach'
            'Echo' % Print
            'N' % Number of panel node
            'Iter'
            };

        inputExpectedFields = {
            'Alpha' % Angle
            'FoilName'
            };

        outputExpectedFields = {
            'Coor'
            'Data'
            };

        baselineExpectedFields = {
            };

        default_Name='Foil_1'
        default_Re=1e6;
        default_Mach=0.2;
        default_Echo=1
        default_N=160
        default_Iter=100
        
    end
    methods

        function obj = Foil(paramsStruct,inputStruct)
            obj = obj@Component(paramsStruct,inputStruct);
            % Check input
            if ~ischar(inputStruct.FoilName)  % Either a NACA string or a filename
                error('Please input right foilname !')
            end

            obj.documentname='Foil.pdf';

        end

        function obj = solve(obj)
            rootDir = Baffalo.whereami;
            wd=strcat(rootDir,'\dep\framework\external');
            filename = strcat(rootDir,'\dep\framework\external\xfoil.inp');
            Nalpha=length(obj.input.Alpha);
            % Write xfoil command file
            fid = fopen(filename,'w');
            if ~isempty(regexpi(obj.input.FoilName,'^NACA *[0-9]{4,5}$','once')) % Check if a NACA string
                fprintf(fid,'naca%s\n',obj.input.FoilName(5:end));
            else
                fprintf(fid,'load%s\n',obj.input.FoilName);
            end

            fprintf(fid,'\n\nppar\n');
            fprintf(fid,'n %g\n',obj.params.N);

            fprintf(fid,'\n\npsav coor.txt\n');

            fprintf(fid,'\n\noper\n');
            % set Reynolds and Mach
            fprintf(fid,'re %g\n',obj.params.Re);
            fprintf(fid,'mach %g\n',obj.params.Mach);
            if obj.params.Re>0
                fprintf(fid,'visc\n');
            end
            fprintf(fid,'iter %g\n',obj.params.Iter);

            % Polar accumulation
            fprintf(fid,'pacc\n\n\n');
            % Xfoil alpha calculations
            [file_dump, file_cpwr] = deal(cell(1,Nalpha)); % Preallocate cell arrays

            for ii = 1:Nalpha
                % Individual output filenames
                file_dump{ii} = sprintf('%s_a%06.3f_dump.dat','xfoil',obj.input.Alpha(ii));
                file_cpwr{ii} = sprintf('%s_a%06.3f_cpwr.dat','xfoil',obj.input.Alpha(ii));
                % Commands
                fprintf(fid,'alfa %g\n',obj.input.Alpha(ii));
                fprintf(fid,'dump %s\n',file_dump{ii});
                fprintf(fid,'cpwr %s\n',file_cpwr{ii});
            end
            % Polar output filename
            file_pwrt = sprintf('%s_pwrt.dat','xfoil');
            fprintf(fid,'pwrt\n%s\n',file_pwrt);
            fprintf(fid,'plis\n');
            fprintf(fid,'\nquit\n');
            fclose(fid);

            % execute xfoil
            cmd = sprintf('cd %s && xfoil.exe < xfoil.inp > xfoil.out',wd);
            [status,result] = system(cmd);
            if (status~=0)
                disp(result);
                error([mfilename ':system'],'Xfoil execution failed! %s',cmd);
            end

            % Read dump file
            %    #    s        x        y     Ue/Vinf    Dstar     Theta      Cf       H
            jj = 0;
            ind = 1;
            % Note that
            foil.alpha = zeros(1,Nalpha); % Preallocate alphas
            % Find the number of panels with an inital run
            only = nargout; % Number of outputs checked. If only one left hand operator then only do polar

            if only >1 % Only do the foil calculations if more than one left hand operator is specificed
                for ii = 1:Nalpha
                    jj = jj + 1;

                    fid = fopen([wd filesep file_dump{ii}],'r');
                    if (fid<=0)
                        error([mfilename ':io'],'Unable to read xfoil output file %s',file_dump{ii});
                    else
                        D = textscan(fid,'%f%f%f%f%f%f%f%f','Delimiter',' ','MultipleDelimsAsOne',true,'CollectOutput',1,'HeaderLines',1);
                        fclose(fid);
                        delete([wd filesep file_dump{ii}]);

                        if ii == 1 % Use first run to determine number of panels (so that NACA airfoils work without vector input)
                            Npanel = length(D{1}); % Number of airfoil panels pulled from the first angle tested
                            % Preallocate Outputs
                            [foil.s, foil.x, foil.y, foil.UeVinf, foil.Dstar, foil.Theta, foil.Cf, foil.H] = deal(zeros(Npanel,Nalpha));
                        end

                        % store data
                        if ((jj>1) && (size(D{1},1)~=length(foil(ind).x)) && sum(abs(foil(ind).x(:,1)-size(D{1},1)))>1e-6 )
                            ind = ind + 1;
                            jj = 1;
                        end
                        foil.s(:,jj) = D{1}(:,1);
                        foil.x(:,jj) = D{1}(:,2);
                        foil.y(:,jj) = D{1}(:,3);
                        foil.UeVinf(:,jj) = D{1}(:,4);
                        foil.Dstar(:,jj) = D{1}(:,5);
                        foil.Theta(:,jj) = D{1}(:,6);
                        foil.Cf(:,jj) = D{1}(:,7);
                        foil.H (:,jj)= D{1}(:,8);
                    end

                    foil.alpha(1,jj) = alpha(jj);

                    % Read cp file
                    fid = fopen([wd filesep file_cpwr{ii}],'r');
                    if (fid<=0)
                        error([mfilename ':io'],'Unable to read xfoil output file %s',file_cpwr{ii});
                    else
                        C = textscan(fid, '%10f%9f%f', 'Delimiter', '', 'WhiteSpace', '', 'HeaderLines' ,3, 'ReturnOnError', false);
                        fclose(fid);
                        delete([wd filesep file_cpwr{ii}]);
                        % store data
                        if ii == 1 % Use first run to determine number of panels (so that NACA airfoils work without vector input)
                            NCp = length(C{1}); % Number of points Cp is listed for pulled from the first angle tested
                            % Preallocate Outputs
                            [foil.xcp, foil.cp] = deal(zeros(NCp,Nalpha));
                            foil.xcp = C{1}(:,1);
                        end
                        foil.cp(:,jj) = C{3}(:,1);
                    end
                end
            end

            if only <= 1% clear files for default run
                for ii=1:Nalpha % Clear out the xfoil dump files not used
                    delete([wd filesep file_dump{ii}]);
                    delete([wd filesep file_cpwr{ii}]);
                end
            end

            % Read polar file
            %
            %       XFOIL         Version 6.96
            %
            % Calculated polar for: NACA 0012
            %
            % 1 1 Reynolds number fixed          Mach number fixed
            %
            % xtrf =   1.000 (top)        1.000 (bottom)
            % Mach =   0.000     Re =     1.000 e 6     Ncrit =  12.000
            %
            %   alpha    CL        CD       CDp       CM     Top_Xtr  Bot_Xtr
            %  ------ -------- --------- --------- -------- -------- --------
            fid = fopen([wd filesep file_pwrt],'r');
            if (fid<=0)
                error([mfilename ':io'],'Unable to read xfoil polar file %s',file_pwrt);
            else
                % Header
                % Calculated polar for: NACA 0012
                P = textscan(fid,' Calculated polar for: %[^\n]','Delimiter',' ','MultipleDelimsAsOne',true,'HeaderLines',3);
                pol.name = strtrim(P{1}{1});
                % xtrf =   1.000 (top)        1.000 (bottom)
                P = textscan(fid, '%*s%*s%f%*s%f%s%s%s%s%s%s', 1, 'Delimiter', ' ', 'MultipleDelimsAsOne', true, 'HeaderLines', 2, 'ReturnOnError', false);
                pol.xtrf_top = P{1}(1);
                pol.xtrf_bot = P{2}(1);
                % Mach =   0.000     Re =     1.000 e 6     Ncrit =  12.000
                P = textscan(fid, '%*s%*s%f%*s%*s%f%*s%f%*s%*s%f', 1, 'Delimiter', ' ', 'MultipleDelimsAsOne', true, 'HeaderLines', 0, 'ReturnOnError', false);
                pol.Re = P{2}(1) * 10^P{3}(1);
                pol.Ncrit = P{4}(1);

                % data
                P = textscan(fid, '%f%f%f%f%f%f%f%*s%*s%*s%*s', 'Delimiter',  ' ', 'MultipleDelimsAsOne', true, 'HeaderLines' , 4, 'ReturnOnError', false);
                fclose(fid);
                delete([wd filesep file_pwrt]);
                % store data
                pol.alpha = P{1}(:,1);
                pol.CL  = P{2}(:,1);
                pol.CD  = P{3}(:,1);
                pol.CDp = P{4}(:,1);
                pol.Cm  = P{5}(:,1);
                pol.Top_xtr = P{6}(:,1);
                pol.Bot_xtr = P{7}(:,1);
            end
            if length(pol.alpha) ~= Nalpha % Check if xfoil failed to converge
                warning('One or more alpha values failed to converge. Last converged was alpha = %f. Rerun with ''oper iter ##'' command.\n', pol.alpha(end))
            end

            coorfile=strcat(wd,'\coor.txt');
            obj.output.Coor=load(coorfile);
            obj.output.Data=pol;

            % Delete temp file
            delete(strcat(wd,'\*.dat'))
            delete(strcat(wd,'\coor.txt'))
            delete(strcat(wd,'\xfoil.inp'))
            delete(strcat(wd,'\xfoil.out'))


        end

    end
end

