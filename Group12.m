%==========================================================================
% 
%  BME 60B, Fangyuan Ding, MWF 4:00 - 4:50pm
%  
%  Sandbox Project
%
%  Group 12:
%  Kentstar Samuel Harsono, 
%  Eric Hyun Kim, 
%  Tair Kuzhekov, 
%  Elian Martin Sian Lintag
% 
%  Description:
% it's just minesweeper
% 
%==========================================================================

clear
close all
clc

% modifiable game values
rows = 10;
cols = 10;
numMines = 20;

% initialize game engine
engine = mineEngine(rows, cols, numMines);

% init empty figure 10x10
window = figure('Name','ElianisAgenius',...
    'NumberTitle','off',...
    'Visible', 'off');

% init buttons
buttons = gobjects(rows, cols);

for i = 1:rows
    for j = 1:cols
        buttons(i,j) = uicontrol('Style','Pushbutton',...
            'position',[10+j*34,10+i*34,35,35], ...
            'Callback', @engine.buttonPressed, ...
            'ButtonDownFcn', @engine.flagBomb, ...
            'UserData', [i, j, 0]);
    end
end

% open the figure
set(window,'Visible','on')


