% todo
% 1. expand buttonPressed function to add logic

classdef mineEngine

    properties
        minefield
        numfield
        window
        buttons
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

            % init empty figure 10x10
            obj.window = figure('Name','ElianisAgenius',...
                'NumberTitle','off',...
                'Visible', 'off');
            
            % init buttons
            obj.buttons = gobjects(rows, cols);
            
            for i = 1:rows
                for j = 1:cols
                    obj.buttons(i,j) = uicontrol('Style','Pushbutton',...
                        'position',[10+j*34,10+i*34,35,35], ...
                        'Callback', @obj.buttonPressed, ...
                        'ButtonDownFcn', @obj.flagBomb, ...
                        'String', int8(obj.numfield(i,j)), ...
                        'UserData', [i, j, 0,0]);
                end
            end

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
                    set(src, 'UserData', [row, col, 1,0]);

                % if the current button is flagged
                elseif flagStatus == 1

                    set(src, 'Callback', @obj.buttonPressed)
                    disp("unflagged")
                    set(src, 'String', '')
                    set(src, 'UserData', [row,col,0,0])

                end
                

            end

        end

        %Recursive Function
        function obj = recursionSquares(obj,A,row,col)
            gridMap = fliplr(rot90(reshape(A,[height(obj.minefield),width(obj.minefield)]),1)); % Reformatted array button matrix

            buttData = get(gridMap(row,col), 'UserData');
            visited = buttData(4); % Whether square was pressed

            if obj.numfield(row,col)==0 &&visited == 0

                % Identifying numField == 0
                set(gridMap(row,col), 'Callback', '','BackgroundColor', 'g', 'String', 'Y');
                set(gridMap(row,col), 'UserData', [row, col, 0,1]);
                try % Checking for adjacent rows/cols for recursion uncover
                    if row > 1
                    obj.recursionSquares(A,row-1, col)
                    end
                    if row < height(obj.minefield)
                        obj.recursionSquares(A,row+1, col)
                    end
                    if col > 1
                        obj.recursionSquares(A,row, col-1)
                    end
                    if col < height(obj.minefield)
                        obj.recursionSquares(A,row, col+1)   
                    end
                    if row > 1 && col >1
                        obj.recursionSquares(A,row-1, col-1)
                    end
                    if row > 1 && col < height(obj.minefield)
                        obj.recursionSquares(A,row-1, col+1)
                    end
                    if row < height(obj.minefield) && col > 1
                        obj.recursionSquares(A,row+1, col-1)
                    end
                    if row < height(obj.minefield) && col < height(obj.minefield)
                        obj.recursionSquares(A,row+1+1, col+1)  
                    end
                catch
                end
            elseif obj.numfield(row,col)~=0 &&visited == 0 % Closing recursion (non-zero in Numfield)
                set(gridMap(row,col), 'Callback', '','BackgroundColor', 'g', 'String', int8(obj.numfield(row,col)));
                set(gridMap(row,col), 'UserData', [row, col, 0,1]);
            end
      
        end
        % uncover function
        function obj = buttonPressed(obj, src, evt)

            buttonData = get(src, 'UserData');
            row = buttonData(1);
            col = buttonData(2);

            figureHand = ancestor(src, 'figure');
            
            check = obj.minefield(row,col);

            % if they click on a bomb, gameover
            if check
                obj.gamestate = 'gameover';

                set(src, 'BackgroundColor', 'r', 'String', 'X');

                figureHandle = ancestor(src, 'figure');
                buttonNum = length(figureHandle.Children);

                % disable all the buttons
                for i = 1:buttonNum
                    set(figureHandle.Children(i), 'Callback', '')
                end

            else
                obj.recursionSquares(figureHand.Children,row,col);
            end

        
        end

        
        
    end
end

