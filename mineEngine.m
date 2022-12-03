% todo
% 1. expand buttonPressed function to add logic

classdef mineEngine

    properties
        minefield
        numfield
        gamestate
    end
    
    methods
        
        % init method
        function obj = mineEngine(rows, cols, numMines)
            
            % create random array to make a logical minefield
            ranNums = randperm(rows*cols, rows*cols);
            tempMines = reshape(ranNums, rows, cols);

            obj.minefield = tempMines <= numMines;

            % create array with numbers of mines around square
            obj.numfield = zeros(rows, cols);

            % shift indexes
            rShiftUp = 1:rows-1;
            rShiftDown = 2:rows;
            cShiftLeft = 1:cols-1;
            cShiftRight = 2:cols;

            % adding up the numfield
            obj.numfield(rShiftUp,:) = obj.numfield(rShiftUp,:)+obj.minefield(rShiftDown,:);
            obj.numfield(rShiftDown,:) = obj.numfield(rShiftDown,:)+obj.minefield(rShiftUp,:);
            obj.numfield(:,cShiftLeft) = obj.numfield(:,cShiftLeft)+obj.minefield(:,cShiftRight);
            obj.numfield(:,cShiftRight) = obj.numfield(:,cShiftRight)+obj.minefield(:,cShiftLeft);
            obj.numfield(rShiftUp,cShiftLeft) = obj.numfield(rShiftUp,cShiftLeft)+obj.minefield(rShiftDown,cShiftRight);
            obj.numfield(rShiftUp,cShiftRight) = obj.numfield(rShiftUp,cShiftRight)+obj.minefield(rShiftDown,cShiftLeft);
            obj.numfield(rShiftDown,cShiftLeft) = obj.numfield(rShiftDown,cShiftLeft)+obj.minefield(rShiftUp,cShiftRight);
            obj.numfield(rShiftDown,cShiftRight) = obj.numfield(rShiftDown,cShiftRight)+obj.minefield(rShiftUp,cShiftLeft);

            % set the game state to start
            obj.gamestate = 'start';

        end

        % flagging a tile
        function flagBomb(obj, src, evt)

            figHandle = ancestor(src, 'figure');
            click = get(figHandle, 'SelectionType');

            buttData = get(src, 'UserData');

            % define data for ease of use
            row = buttData(1);
            col = buttData(2);
            flagStatus = buttData(3);
            
            % checks if it is a right click
            if strcmp(click, 'alt')
                
                % if the current button isn't flagged
                if flagStatus == 0

                    set(src, 'Callback', '') % prevents being able to uncover tile
                    disp("flagged") % DELETE debugging purposes
                    set(src, 'String', 'F')
                    set(src, 'UserData', [row, col, 1]);

                % if the current button is flagged
                elseif flagStatus == 1

                    set(src, 'Callback', @obj.buttonPressed)
                    disp("unflagged")
                    set(src, 'String', '')
                    set(src, 'UserData', [row,col,0])

                end
                

            end

        end

        % uncover function
        function buttonPressed(obj, src, evt)
           
            set(src, 'Visible','off');
        
        end

        % check for mine (very basic function, will need rewriting)
        function [check,state] = checkBomb(obj, row,col)
            check = obj.minefield(row,col);

            % if they click on a bomb, gameover
            if check
                state = 'gameover';
            else
                state = obj.gamestate;
            end
        end
        
    end
end

