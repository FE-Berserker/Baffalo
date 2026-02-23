function Factor = estimateFatigueFactor(tau_max, S_fw_prime, S_ew_prime,Cycle)
% estimateFatigueLife - Estimate fatigue life
%
% Simplified S-N curve estimation

% 10^3 cycles
S_ms = S_fw_prime(1,2);

% above
S_ew = S_ew_prime;

if tau_max<=S_ew
    Factor=1000;
elseif Cycle<=1000
    Sfw=S_ms;
    Factor=Sfw/tau_max;

else
    temp=Cycle./S_fw_prime(:,1);
    row=find(temp>=1,1,'last');
    if row==4
        Sfw=S_fw_prime(4,2);
    else
        S1= S_fw_prime(row,2);
        S2= S_fw_prime(row+1,2);
        N1= S_fw_prime(row,1);
        N2= S_fw_prime(row+1,1);
        b=log10(S2/S1)/log10(N1/N2);
        Sfw=S1*N1^b/(Cycle^(b));
    end

    Factor=Sfw/tau_max;

end


end
