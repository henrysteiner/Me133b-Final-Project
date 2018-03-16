function paths = findPaths( imArr, adjArr, cur, visited, curPath, paths )
    
    cur
    % Base case: Back at the edge
    if((imArr(cur(1), cur(2)) == 1 && (cur(1)~=1||cur(2)~=1)) || (visited(cur(1), cur(2)) == 1))
        disp('back at the edge')
        paths = [paths;curPath];
    else
        visited(cur(1), cur(2)) = 1;
        % Get the max value surrounding as well as the cells that
        % contain that value
        [max, xMax, yMax] = getAdjRel(imArr, cur(1), cur(2), visited, 1);
        xList = [];
        yList = [];
        % If that maximum value is larger or equal than the current cell value
        if max >= imArr(cur(1), cur(2))
            if length(xMax) > 1
                
                [~, adjX, adjY] = getAdjRel(adjArr, cur(1), cur(2), visited, 1);
            
                for i=1:length(adjX)
                    for j=1:length(xMax)
                        if adjX(i) == xMax(j) && adjY(i) == yMax(j)
                            xList = [xList;xMax(j)];
                            yList = [yList;yMax(j)];
                        end
                    end
                end
            else
                xList = xMax;
                yList = yMax;
            end
        end
        
        % If the max value is not larger, it means we need to trace a line
        % back to the edge. We do this by looking at the adjacent cell that
        % has the minimum adjacent cell sum.
        if isempty(xList)
            [a, xMin, yMin] = getAdjRel(adjArr, cur(1), cur(2), visited, 0);
            xList = xMin;
            yList = yMin;
        end
        
        %visited = markAdditional(xList,yList,visited, cur(1), cur(2));
        
        % If only one possible cell to go to based on x/y list
        if length(xList) == 1
            curPath = [curPath; xList(1), yList(1)];
            paths = findPaths( imArr, adjArr, [xList(1), yList(1)], visited, curPath, paths );
        % If a split is necessary
        elseif length(xList) > 1
            % Add the current path to our list of paths
            paths = [paths; curPath];
            % For every new point to go to we make a new curPath list
            % that contains the current value we are on.
            for i=1:length(xList)
                disp("needs to split");
                % The function is called on the next coordinates to go
                % to.
                paths = findPaths(imArr, adjArr, [xList(i), yList(i)], visited, cur, paths);
            end
        else
            disp('no possible found')
            paths = [paths; curPath];
        end
    end 
end

