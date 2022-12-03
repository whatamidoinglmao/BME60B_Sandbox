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

function GUI_buttons()

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

buttons = gobjects(rows, cols);

for i = 1:rows
    for j = 1:cols
        buttons(i,j) = uicontrol('Style', 'pushbutton',...
            'position',[10+j*34,10+i*34,35,35], 'Callback',@buttonPushed,...
            'UserData', [i, j]);
    end
end

% open the figure
set(graphics,'Visible','on')



% callback function
    function buttonPushed(src, event)
        index = get(gco, 'UserData');
        i = index(1);
        j = index(2);
        set(buttons(i, j), 'Visible','off');

    end
end
