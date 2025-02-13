function dir = whereami()
    %WHEREAMI  Return the root dir of the columbus install. Also throw an
    %error if more than one +columbus package is detected.
    
    if numel(what('+Baffalo')) > 1
        error('Baffalo:whereami:multipleRoTAPackages', ...
            'More than one +RoTA package detected on the path! Could lead to ambiguous calls.');
    end

    dir = fileparts(fileparts(mfilename('fullpath')));
end
