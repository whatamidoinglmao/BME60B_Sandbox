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


prompt ='Choose difficulty: easy = 1, intermediate = 2, hard = 3 (type 1, 2, or 3) \n';
User_output = input(prompt);

if (User_output == 1)
    number = 5;
    mines = 4;
elseif (User_output== 2)
    number = 10;
    mines = 15;
elseif (User_output == 3)
    number = 15;
    mines = 35;
else 
    fprintf('Invalid answer. Choose 1,2, or 3.') 
    User_output = input(prompt);
end 
% modifiable game values
rows = number;
cols = number;
numMines = mines;

% initialize game engine
engine = mineEngine(rows, cols, numMines);

% open the figure
set(engine.window,'Visible','on')


