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
%  it's just minesweeper
% 
%==========================================================================

clear
close all
clc

fprintf(['welcome to...\n\n' ...      
'        .__                                                    ._.           \n' ...
'  _____ |__| ____   ____     ____   ____ ______   ___________  | |           \n' ...
' /     \\|  |/    \\_/ __ \\  _/ __ \\_/ __ \\\\____ \\_/ __ \\_  __ \\ | |  \n' ...
'|  Y Y  \\  |   |  \\  ___/  \\  ___/\\  ___/|  |_> >  ___/|  | \\/  \\|     \n' ...
'|__|_|  /__|___|  /\\___  >  \\___  >\\___  >   __/ \\___  >__|     __       \n' ...
'      \\/        \\/     \\/       \\/     \\/|__|        \\/         \\/  \n\n'])

prompt ='Choose difficulty: custom grid = 0, easy = 1, intermediate = 2, hard = 3 (type 0,1, 2, or 3) \n';
custom_prompt = 'Input how big you want the grid to be. ex: Inputting 3 would return 3 by 3 grid.\n';
User_output = input(prompt);

%Creating the grid
while true
    if (User_output == 1)
        number = 5;
        mines = 4;
        fprintf('easy? lol\n')
        break;
    elseif (User_output== 2)
        number = 10;
        mines = 15;
        fprintf('ok nice\n')
        break;
    elseif (User_output == 3)
        number = 15;
        mines = 35;
        fprintf('damn ok\n')
        break;
    elseif (User_output == 0)
        while true
            number = round(input(strcat('\n', custom_prompt)));
            if number > 0
                mines = round(0.15 * number^2); 
                fprintf('nice\n')
                break
            else
                fprintf('bro. please. it has to be above 0\n\n')
            end
        end
        break;
    else 
        fprintf('Invalid answer. Choose 0,1,2, or 3.\n\n') 
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


