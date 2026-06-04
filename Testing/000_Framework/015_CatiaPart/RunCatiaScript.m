function RunCatiaScript(scriptPath)
% RunCatiaScript - Execute CATIA VBScript from MATLAB via command line
%   RunCatiaScript(scriptPath)
%
%   Input:  scriptPath - Full path to .catvbs file
%
%   Example:
%       RunCatiaScript('D:\path\to\Ball.catvbs')
%
% Author : Xie Yu

if nargin < 1
    error('Please provide script path: RunCatiaScript(''path/to/script.catvbs'')');
end

% Check if script file exists
if ~exist(scriptPath, 'file')
    error('Script file not found: %s', scriptPath);
end

% Get absolute path
scriptPath = fullfile(pwd, scriptPath);
if ~exist(scriptPath, 'file')
    scriptPath = which(scriptPath);
end

% CATIA installation path
% B32: D:\Software\Dassault Systemes\B32\win_b64\code\bin\CNEXT.exe
catiaPaths = {
    'D:\Software\Dassault Systemes\B32\win_b64\code\bin\CNEXT.exe';
    'C:\Program Files\Dassault Systemes\B32\win_b64\code\bin\CNEXT.exe';
    'D:\Software\Dassault Systemes\B29\win_b64\code\bin\CNEXT.exe';
    'C:\Program Files\Dassault Systemes\B29\win_b64\code\bin\CNEXT.exe';
    'D:\Software\Dassault Systemes\B28\win_b64\code\bin\CNEXT.exe';
    'C:\Program Files\Dassault Systemes\B28\win_b64\code\bin\CNEXT.exe'
};

% Find valid CATIA installation
catiaExe = '';
for i = 1:length(catiaPaths)
    if exist(catiaPaths{i}, 'file')
        catiaExe = catiaPaths{i};
        fprintf('Found CATIA at: %s\n', catiaExe);
        break;
    end
end

if isempty(catiaExe)
    error(['Cannot find CATIA installation. Please modify catiaPaths ' ...
           'in the script with your CATIA installation path.']);
end

% Normalize path for Windows
scriptPath = regexprep(scriptPath, '/', '\\');

% Construct command using CNEXT.exe
% Syntax: CNEXT.exe -macro script_path (no quotes around script path)
cmd = sprintf('"%s" -macro %s', catiaExe, scriptPath);

fprintf('Executing command...\n');
fprintf('Script: %s\n', scriptPath);
fprintf('Command: %s\n', cmd);

% Execute command
[status, cmdout] = system(cmd);

if status == 0
    fprintf('Script executed successfully!\n');
else
    warning('Execution failed with status %d', status);
    fprintf('Command output:\n%s\n', cmdout);
end

end
