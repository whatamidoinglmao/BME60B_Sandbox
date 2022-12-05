% todo
% 1. expand buttonPressed function to add logic

classdef mineEngine

    properties 
        minefield
        numfield
        window
        gameStats 
        numMineButtons
        xtraUI
    end
    
    methods
        
        % init method
        function obj = mineEngine(rows, cols, numMines)
            
            % stores game stats in case they want to start new game
            % #3 is the number of buttons, important for buttonPressed 
            obj.gameStats = [rows, numMines, rows*cols];

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

            % set each mine location to -1 (mainly debugging purposes)
            obj.numfield(obj.minefield) = -1;

            % parameters for drawing figure
            buttonWidth = 35;
            spaceWidth = 34;
            xoff = 10;
            yoff = 10;
            xSpace = 250;
            ySpace = 100;

            % init empty figure 10x10
            obj.window = figure('Name','mine eeper',...
                'NumberTitle','off',...
                'Position', [500, 300, xoff+(rows*spaceWidth)+xSpace, yoff+(cols*spaceWidth)+ySpace], ...
                'Resize', 'off', ...
                'Visible', 'off');
            
            %-------extra stuff in figure that should stay constant--------

            % number of extra elements in figure (UPDATE WHENEVER YOU ADD SOMETHING)
            obj.xtraUI = 3;

            % figure axes
            axes('Units', 'pixels', ...
                'PlotBoxAspectRatio', [1,1,1], ...
                'Position', [xoff+spaceWidth,yoff+spaceWidth, rows*spaceWidth, cols*spaceWidth], ... % if we change the position of the buttons this position has to match the first button
                'XLim', [0, cols*35], ...
                'YLim', [0, rows*35]);

            % new game button
            uicontrol('Style', 'Pushbutton', ...
                'Position', [xoff+(rows*spaceWidth)+100, yoff+(cols/5)*spaceWidth, 100, 50], ...
                'Callback', @obj.newGame, ...
                'String', "new game");

            % mine counter
            uicontrol('Style','Text', ...
                'Position', [xoff+((rows/2)*spaceWidth), yoff+cols*spaceWidth+50, 50, 50], ...
                'String', num2str(numMines));

            %--------------------------------------------------------------

            % init buttons for the game
            mineButtons = gobjects(rows, cols);
            
            for i = 1:rows
                for j = 1:cols
                    mineButtons(i,j) = uicontrol('Style','Pushbutton',...
                        'position',[xoff+j*spaceWidth,yoff+i*spaceWidth,buttonWidth,buttonWidth], ...
                        'Callback', @obj.buttonPressed, ...
                        'ButtonDownFcn', @obj.flagBomb, ...
                        'UserData', [i, j, 0,0]);
                end
            end

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

            numUI = numel(figHandle.Children);
            remainingText = figHandle.Children(numUI-2);
            remainingString = get(remainingText, 'String');
            remaining = str2double(remainingString);
            
            % checks if it is a right click
            if strcmp(click, 'alt')
                
                % if the current button isn't flagged
                if flagStatus == 0

                    set(src, 'Callback', '') % prevents being able to uncover tile
                    set(src, 'String', 'F')
                    set(src, 'UserData', [row,col,1,0]);

                    remaining = remaining - 1;
                    set(remainingText, 'String', num2str(remaining))


                % if the current button is flagged
                elseif flagStatus == 1

                    set(src, 'Callback', @obj.buttonPressed)
                    set(src, 'String', '')
                    set(src, 'UserData', [row,col,0,0])

                    remaining = remaining + 1;
                    set(remainingText, 'String', num2str(remaining))

                end

            end

        end

        % button press function
        function buttonPressed(obj, src, evt)

            buttData = get(src, 'UserData');
            row = buttData(1);
            col = buttData(2);
            numButtons = obj.gameStats(3);

            figHandle = ancestor(src, 'figure');
            numUI = numel(figHandle.Children);
            mineButtonEnd = numUI - obj.xtraUI;
            buttonArray = figHandle.Children(1:mineButtonEnd);
            gridMap = fliplr(rot90(reshape(buttonArray,[height(obj.minefield),width(obj.minefield)]),1)); % Reformatted array button matrix
            
            check = obj.minefield(row,col);

            % if they click on a bomb, gameover
            if check

                mines = gridMap(obj.minefield);
                set(mines, 'BackgroundColor', 'r', 'String', 'X');

                % disable all the buttons
                for i = 1:numButtons
                    set(gridMap, 'Callback', '', 'ButtonDownFcn', '')
                end

            % if not a bomb, uncover the squares
            else
                obj.recursionSquares(gridMap,row,col,figHandle);
            end

        
        end


        % Recursive Function (basically function to uncover squares)
        function recursionSquares(obj,gridMap,row,col,figHandle)

            buttData = get(gridMap(row,col), 'UserData');
            visited = buttData(4); % Whether square was pressed
            flagStatus = buttData(3);
            num = obj.numfield(row,col);

            % if you manage to uncover a flagged tile, +1 to remaining
            if flagStatus == 1
                    remainingText = figHandle.Children(end-2);
                    remainingString = get(remainingText, 'String');
                    remaining = str2double(remainingString);
                    remaining = remaining + 1;
                    set(remainingText, 'String', num2str(remaining));
            end

            % Identifying numField == 0
            if obj.numfield(row,col) == 0 && visited == 0

                set(gridMap(row,col), 'Visible', 'off');
                set(gridMap(row,col), 'UserData', [row, col, 0,1]);
                try % Checking for adjacent rows/cols for recursion uncover
                    if row > 1
                        obj.recursionSquares(gridMap,row-1, col, figHandle);
                    end
                    if row < height(obj.minefield)
                        obj.recursionSquares(gridMap,row+1, col, figHandle);
                    end
                    if col > 1
                        obj.recursionSquares(gridMap,row, col-1, figHandle);
                    end
                    if col < height(obj.minefield)
                        obj.recursionSquares(gridMap,row, col+1, figHandle);   
                    end
                    if row > 1 && col >1
                        obj.recursionSquares(gridMap,row-1, col-1, figHandle);
                    end
                    if row > 1 && col < height(obj.minefield)
                        obj.recursionSquares(gridMap,row-1, col+1, figHandle);
                    end
                    if row < height(obj.minefield) && col > 1
                        obj.recursionSquares(gridMap,row+1, col-1, figHandle);
                    end
                    if row < height(obj.minefield) && col < height(obj.minefield)
                        obj.recursionSquares(gridMap,row+1, col+1, figHandle);
                    end
                catch
                end

            elseif obj.numfield(row,col)~=0 && visited == 0 % Closing recursion (non-zero in Numfield)

                set(gridMap(row,col),'Visible', 'off');

                % draws number when a nonzero tile is uncovered
                text('Position', [((col-0.5)*35)-3, ((row-0.5)*35)+2], ...
                    'String', num2str(obj.numfield(row, col)));

                set(gridMap(row,col), 'UserData', [row, col, 0, 1]);

            end
      
        end

        % start a new game (experimental)
        function newGame(obj,src,evt)

            % delete everything from prev game
            figHandle = ancestor(src, 'figure');
            numUI = numel(figHandle.Children);
            mineButtonEnd = numUI - obj.xtraUI;
            mineButtons = figHandle.Children(1:mineButtonEnd);
            delete(mineButtons);
            a = figHandle.Children(end);
            text = a.Children(1:end);
            delete(text);

            % retrieve game states then create new minefield and buttons (same code as init)
            rows = obj.gameStats(1);
            cols = obj.gameStats(1);
            numMines = obj.gameStats(2);
            ranNums = randperm(rows*cols, rows*cols);
            tempMines = reshape(ranNums, rows, cols);
            obj.minefield = tempMines <= numMines;
            obj.numfield = zeros(rows, cols);
            rShiftUp = 1:rows-1;
            rShiftDown = 2:rows;
            cShiftLeft = 1:cols-1;
            cShiftRight = 2:cols;
            % adding up the numfield below
            obj.numfield(rShiftUp,:) = obj.numfield(rShiftUp,:)+obj.minefield(rShiftDown,:); 
            obj.numfield(rShiftDown,:) = obj.numfield(rShiftDown,:)+obj.minefield(rShiftUp,:);
            obj.numfield(:,cShiftLeft) = obj.numfield(:,cShiftLeft)+obj.minefield(:,cShiftRight);
            obj.numfield(:,cShiftRight) = obj.numfield(:,cShiftRight)+obj.minefield(:,cShiftLeft);
            obj.numfield(rShiftUp,cShiftLeft) = obj.numfield(rShiftUp,cShiftLeft)+obj.minefield(rShiftDown,cShiftRight);
            obj.numfield(rShiftUp,cShiftRight) = obj.numfield(rShiftUp,cShiftRight)+obj.minefield(rShiftDown,cShiftLeft);
            obj.numfield(rShiftDown,cShiftLeft) = obj.numfield(rShiftDown,cShiftLeft)+obj.minefield(rShiftUp,cShiftRight);
            obj.numfield(rShiftDown,cShiftRight) = obj.numfield(rShiftDown,cShiftRight)+obj.minefield(rShiftUp,cShiftLeft);
            % set each mine location to -1 (mainly debugging purposes)
            obj.numfield(obj.minefield) = -1;
            % parameters for drawing figure
            buttonWidth = 35; spaceWidth = 34; xoff = 10; yoff = 10; % IMPORTANT ********** UPDATE THIS IF YOU UPDATE IT AT THE START

            remainingText = figHandle.Children(end - 2);
            set(remainingText, 'String', num2str(numMines))

            % init buttons for the game
            mineButtons = gobjects(rows, cols);
            
            for i = 1:rows
                for j = 1:cols
                    mineButtons(i,j) = uicontrol('Style','Pushbutton',...
                        'position',[xoff+j*spaceWidth,yoff+i*spaceWidth,buttonWidth,buttonWidth], ...
                        'Callback', @obj.buttonPressed, ...
                        'ButtonDownFcn', @obj.flagBomb, ...
                        'UserData', [i, j, 0,0]);
                end
            end
        end

    end
end

