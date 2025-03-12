function obj = CalculateCampbell(obj)
% Calculate campbell of shaft
% Author : Xie Yu

n_ew = obj.params.NMode;
if isempty(obj.input.Speed)
    omega=0;
else
    omega = obj.input.Speed/60*2*pi;
end

if mod(n_ew,2)
    n_ew=n_ew+1;
end

for w = omega
    [mat.A,mat.B] = get_state_space_matrices1(obj.output.RotorSystem,w);
    [V,D] = perform_eigenanalysis1(mat,n_ew);
    Vpos = get_position_entries1(obj.output.RotorSystem,V);
    if w == 0
        [Vpos,D]= get_positive_entries(Vpos,D);
        EW_for = D(1:2:end);
        EV_for = Vpos(:,1:2:n_ew); %#ok<NASGU>
        EW_back = D(2:2:end);
        EV_back = Vpos(:,2:2:n_ew); %#ok<NASGU>
        EW_for = EW_for(1:n_ew/2);
        EW_back = EW_back(1:n_ew/2);
    else
        [~, EW_for, ~,EW_back, ~, ~, ~, ~ ] = ...
            get_separation_eigenvectors(Vpos,D,n_ew);
    end
    obj.output.EWf(:,end+1) = EW_for;
    obj.output.EWb(:,end+1) = EW_back;
end

% Parse campbell
Ewf=imag(obj.output.EWf)/2/pi;
Ewb=imag(obj.output.EWb)/2/pi;
Ew=[Ewf;Ewb];
[~,I]=sort(Ew(:,1));
Sen='Campbell=table(Num,Status';
for i=1:length(omega)
    eval(strcat('rpm',num2str(i),'=Ew(I,i);'))
    Sen=strcat(Sen,',rpm',num2str(i));
end
Sen=strcat(Sen,');');
Num=(1:n_ew)'; %#ok<NASGU>
Status=[repmat("FW",n_ew/2,1);repmat("BW",n_ew/2,1)];
Status=Status(I,:); %#ok<NASGU>
eval(Sen);
obj.output.Campbell=Campbell;
end
