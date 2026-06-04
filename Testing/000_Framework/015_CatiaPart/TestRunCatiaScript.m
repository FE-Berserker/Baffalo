clc
clear
close all
% Test RunCatiaScript - Run Ball.catvbs
% Author : Xie Yu

% Get current directory
currentDir = fileparts(mfilename('fullpath'));

% Script file path
scriptPath = fullfile(currentDir, 'Ball.catvbs');

% Run the CATIA script
RunCatiaScript(scriptPath);
