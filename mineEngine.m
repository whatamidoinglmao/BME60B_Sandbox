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
            ySpace = 120;
            figureWidth = xoff+(rows*spaceWidth)+xSpace;
            figureHeight = yoff+(cols*spaceWidth)+ySpace;

            % init empty figure 10x10
            obj.window = figure('Name','mine eepy..',...
                'NumberTitle','off',...
                'Position', [500, 300, figureWidth, figureHeight], ...
                'Resize', 'off', ...
                'Visible', 'off', ...
                'Toolbar', 'None');
            
            %-------extra stuff in figure that should stay constant--------

            % number of extra elements in figure (UPDATE WHENEVER YOU ADD SOMETHING)
            obj.xtraUI = 13;

            % figure axes
            axes('Units', 'pixels', ...
                'PlotBoxAspectRatio', [1,1,1], ...
                'Position', [xoff+spaceWidth,yoff+spaceWidth, rows*spaceWidth, cols*spaceWidth], ... % if we change the position of the buttons this position has to match the first button
                'XLim', [0, cols*35], ...
                'YLim', [0, rows*35], ...
                'Box', 'on', ...
                'Xtick', [], ...
                'Ytick', [], ...
                'Color', 1/255*[210,210,210], ...
                'LineWidth', 0.5, ...
                'XColor', 1/255*[180,180,180], ...
                'YColor', 1/255*[180,180,180]);
            disableDefaultInteractivity(gca)

            % new game button
            uicontrol('Style', 'Pushbutton', ...
                'Position', [xoff+(rows*spaceWidth)+100, yoff+((cols+1)/2)*spaceWidth-100, 100, 50], ...
                'Callback', @obj.newGame, ...
                'String', 'new game :)', ...
                'FontName', 'Comic Sans MS', ...
                'FontSize', 10);

            % mine counter
            uicontrol('Style','Text', ...
                'Position', [xoff+(rows*spaceWidth)+100, yoff+((cols+1)/2)*spaceWidth, 100, 30], ...
                'String', num2str(numMines), ...
                'FontName', 'Comic Sans MS', ...
                'FontSize', 15, ...
                'FontWeight', 'bold');

            % "remaining:"
            uicontrol('Style','Text', ...
                'Position', [xoff+(rows*spaceWidth)+100, yoff+((cols+1)/2)*spaceWidth+30, 100, 30], ...
                'String', 'remaining:', ...
                'FontName', 'Comic Sans MS', ...
                'FontSize', 13);

            % mine eeper title
            uicontrol('Style','Text', 'String', 'm', 'FontName', 'Comic Sans MS', 'FontSize', 18, ...
                'Position', [(figureWidth/2)-166, figureHeight-56, 40, 40]);
            uicontrol('Style','Text', 'String', 'i', 'FontName', 'Comic Sans MS', 'FontSize', 18, ...
                'Position', [(figureWidth/2)-129, figureHeight-81, 40, 40]);
            uicontrol('Style','Text', 'String', 'n', 'FontName', 'Comic Sans MS', 'FontSize', 18, ...
                'Position', [(figureWidth/2)-96, figureHeight-62, 40, 40]);
            uicontrol('Style','Text', 'String', 'e', 'FontName', 'Comic Sans MS', 'FontSize', 18, ...
                'Position', [(figureWidth/2)-68, figureHeight-47, 40, 40]);
            uicontrol('Style','Text', 'String', 'e', 'FontName', 'Comic Sans MS', 'FontSize', 18, ...
                'Position', [(figureWidth/2)+10, figureHeight-62, 40, 40]);
            uicontrol('Style','Text', 'String', 'e', 'FontName', 'Comic Sans MS', 'FontSize', 18, ...
                'Position', [(figureWidth/2)+40, figureHeight-77, 40, 40]);
            uicontrol('Style','Text', 'String', 'p', 'FontName', 'Comic Sans MS', 'FontSize', 18, ...
                'Position', [(figureWidth/2)+73, figureHeight-76, 40, 40]);
            uicontrol('Style','Text', 'String', 'e', 'FontName', 'Comic Sans MS', 'FontSize', 18, ...
                'Position', [(figureWidth/2)+111, figureHeight-52, 40, 40]);
            uicontrol('Style','Text', 'String', 'r', 'FontName', 'Comic Sans MS', 'FontSize', 18, ...
                'Position', [(figureWidth/2)+140, figureHeight-40, 40, 40]);

            %--------------------------------------------------------------

            % draw grid lines in axes
            for i = 1:rows
                line('XData',[0, cols*buttonWidth], ...
                    'YData',[i*buttonWidth, i*buttonWidth],...
                    'Color', 1/255*[180, 180, 180], ...
                    'LineWidth', 0.25);
            end
            
            for i = 1:cols
                line('XData',[i*buttonWidth, i*buttonWidth], ...
                    'YData',[0, rows*buttonWidth],...
                    'Color', 1/255*[180, 180, 180], ...
                    'LineWidth', 0.25);
            end

            % init buttons for the game
            mineButtons = gobjects(rows, cols);
            
            for i = 1:rows
                for j = 1:cols
                    mineButtons(i,j) = uicontrol('Style','Pushbutton',...
                        'position',[xoff+j*spaceWidth,yoff+i*spaceWidth,buttonWidth,buttonWidth], ...
                        'Callback', @obj.buttonPressed, ...
                        'ButtonDownFcn', @obj.flagBomb, ...
                        'UserData', [i, j, 0,0], ...
                        'FontName', 'Comic Sans MS', 'FontSize', 20, ...
                        'ForegroundColor', 1/255*[230,68,32]);
                end
            end

        end
        
        % flagging a tile
        function flagBomb(obj, src, ~)

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

                    set(src, 'Callback', '', ... % prevents being able to uncover tile
                        'String', 'O', 'FontSize', 18, ...
                        'UserData', [row,col,1,0], ...
                        'BackgroundColor', 1/255*[200,200,200])

                    remaining = remaining - 1;
                    set(remainingText, 'String', num2str(remaining))

                    % CHECK FOR A WIN
                    if remaining == 0
                        numUI = numel(figHandle.Children);
                        mineButtonEnd = numUI - obj.xtraUI;
                        buttonArray = figHandle.Children(1:mineButtonEnd);
                        flagCells = get(buttonArray, 'UserData');
                        flagMap = fliplr(rot90(reshape(flagCells,[height(obj.minefield),width(obj.minefield)]),1)); % Reformatted array button matrix

                        % finding where player put flags
                        flags = false(size(flagMap));
                        for i = 1:obj.gameStats(1)
                            for j = 1:obj.gameStats(1)
                                data = cell2mat(flagMap(i,j));
                                flags(i,j) = data(3);
                            end
                        end

                        % comparing to actual minefield
                        if flags == obj.minefield
                            msgbox('WOOOOOO you won!', 'win!')
                            buttonMap = fliplr(rot90(reshape(buttonArray,[height(obj.minefield),width(obj.minefield)]),1));
                            set(buttonMap(flags), 'Callback', '', 'ButtonDownFcn', '') % disable mines
                        end

                    end

                % if the current button is flagged
                elseif flagStatus == 1

                    set(src, 'Callback', @obj.buttonPressed, ...
                        'String', '', 'FontSize', 20,...
                        'UserData', [row,col,0,0], ...
                        'BackgroundColor', 1/255*[240,240,240])

                    remaining = remaining + 1;
                    set(remainingText, 'String', num2str(remaining))

                end

            end

        end

        % button press function
        function buttonPressed(obj, src, ~)

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
                set(mines, 'BackgroundColor', 'r', 'String', 'X', ...
                    'ForegroundColor', 'k');

                msgbox('u died lol', 'gameover', 'error')

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
            if num == 0 && visited == 0

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

            elseif num~=0 && visited == 0 % Closing recursion (non-zero in Numfield)

                set(gridMap(row,col),'Visible', 'off');

                % draws number when a nonzero tile is uncovered
                a = text('Position', [((col-0.5)*35)-5, ((row-0.5)*35)+1.5], ...
                    'String', num2str(obj.numfield(row, col)), ...
                    'FontName', 'Comic Sans MS', ...
                    'FontSize', 14);

                % set color based on number
                if num == 1
                    set(a, 'Color', 1/255*[14,60,200])
                elseif num == 2
                    set(a, 'Color', 1/255*[31, 145, 59])
                elseif num == 3
                    set(a, 'Color', 1/255*[212, 70, 70])
                elseif num == 4
                    set(a, 'Color', 1/255*[103, 87, 153])
                elseif num == 5
                    set(a, 'Color', 1/255*[143, 57, 20])
                elseif num == 6
                    set(a, 'Color', 1/255*[23, 191, 183])
                elseif num == 7
                    set(a, 'Color', 1/255*[64, 64, 64])
                elseif num == 8
                    set(a, 'Color', 1/255*[45,45,45])
                end

                set(gridMap(row,col), 'UserData', [row, col, 0, 1]);

            end
      
        end

        % start a new game without closing the figure
        function newGame(obj,src,~)

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

            % draw lines again
            for i = 1:rows
                line('XData',[0, cols*buttonWidth], ...
                    'YData',[i*buttonWidth, i*buttonWidth],...
                    'Color', 1/255*[180, 180, 180], ...
                    'LineWidth', 0.25);
            end
            
            for i = 1:cols
                line('XData',[i*buttonWidth, i*buttonWidth], ...
                    'YData',[0, rows*buttonWidth],...
                    'Color', 1/255*[180, 180, 180], ...
                    'LineWidth', 0.25);
            end

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
                        'UserData', [i, j, 0,0], ...
                        'FontName', 'Comic Sans MS', 'FontSize', 20, ...
                        'ForegroundColor', 1/255*[230,68,32]);
                end
            end
        end

    end
end

