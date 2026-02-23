function S_fw_prime = getFatigueStrength(mat, S_ut, isShotPeened)
    % getFatigueStrength - Return torsional fatigue strength
    %
    % S_fw_prime is a percentage of S_ut

    % Cold-drawn carbon steel
    if  any(strcmp(mat.ASTM, {'A229','A230','A232', 'A401'}))
        % Default use A228 music wire data
        if isShotPeened
            percent1 = 0.67*0.9;
            percent2 = 0.49;
            percent3 = 0.47;
            percent4 = 0.46;
        else
            percent1 = 0.67*0.9;
            percent2 = 0.42;
            percent3 = 0.4;
            percent4 = 0.38;
        end
    else
        if isShotPeened
            percent1 = 0.67*0.9;
            percent2 = 0.42;
            percent3 = 0.39;
            percent4 = 0.36;
        else
            percent1 = 0.67*0.9;
            percent2 = 0.36;
            percent3 = 0.33;
            percent4 = 0.30;
        end
    end

    percent=[percent1;percent2;percent3;percent4];
    Cycle=[1e3;1e5;1e6;1e7];
    S_fw_prime = [Cycle,percent * S_ut];
end
