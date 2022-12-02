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
graphics = figure('Name','ElianisAgenius',...
    'NumberTitle','off',...
    'Visible', 'off');
for i = 1:rows
    for j = 1:cols
        uicontrol('Style','Pushbutton',...
            'position',[10+j*34,10+i*34,35,35]);
    end
end

% open the figure
set(graphics,'Visible','on')
