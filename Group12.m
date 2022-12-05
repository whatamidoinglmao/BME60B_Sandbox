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

prompt ='Choose difficulty: custom grid = 0, easy = 1, intermediate = 2, hard = 3 (type 0,1, 2, or 3) \n';
custom_prompt = 'Input how big you want the grid to be. ex: Inputting 3 would return 3 by 3 grid.\n';
User_output = input(prompt);

%Creating the grid
while true
    if (User_output == 1)
        number = 5;
        mines = 4;
        break;
    elseif (User_output== 2)
        number = 10;
        mines = 15;
        break;
    elseif (User_output == 3)
        number = 15;
        mines = 35;
        break;
    elseif (User_output == 0)
        number = input(custom_prompt);
        mines = round(0.15 * number^2); 
        break;
    else 
        fprintf('Invalid answer. Choose 0,1,2, or 3.') 
        User_output = input(prompt);
    end 
end

% modifiable game values
rows = number;
cols = number;
numMines = mines;

% initialize game engine
engine = mineEngine(rows, cols, numMines);

% open the figure
set(engine.window,'Visible','on')


