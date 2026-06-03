function filename = GetFileName(path)
% GetFileName - Extract filename from full path
%   Input:  path - Full file path (e.g., 'C:\Users\file.txt')
%   Output: filename - Extracted filename without extension
%
% Example:
%   filename = GetFileName('C:\folder\subfolder\myfile.txt')
%   Returns: 'myfile'
%
% Author : Xie Yu

% Extract filename with extension
[~, name, ext] = fileparts(path);

% Return filename without extension
filename = name;

end
