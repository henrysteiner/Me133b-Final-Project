function points = voronoiAttempt(imArr, adjSum)
    % This function runs our voronoi algorithm. It operates by popping a
    % cell off the stack and checking to see which of the adjacent ones
    % should belong to the voronoi path. It then adds these to the stack.
    % It continues running until the stack is empty.
    
    visited = zeros(size(imArr));
    points = [];
    stack = [1,1];

    while(~isempty(stack))

        % Pop off the stack
        cur = stack(end,:);
        stack = stack(1:end-1, :);

        % Add it to the path of points we have visited
        points = [points; cur];

        % Base case, In this case do nothing and let this iteration complete
        if((imArr(cur(1), cur(2)) == 1 && (cur(1)~=1||cur(2)~=1)))
            disp('base case')
            visited(cur(1), cur(2)) = 1;
        % If not the base case, see what other points we should explore.
        else
            % Get the max value surrounding as well as the cells that
            % contain that value
            [max, xMax, yMax] = getAdjRel(imArr, cur, visited);
            xList = [];
            yList = [];

            % If that maximum value is larger or equal than the current cell value
            if max >= imArr(cur(1), cur(2))
                xList = xMax;
                yList = yMax;
            % If the max value is not larger, it means we need to trace a line
            % back to the edge. We do this by looking at the unvisited adjacent cell that
            % has the minimum adjacent cell sum.
            else
                [~, xMax, yMax] = getAdjRel(adjSum, cur, visited);
                xList = xMax;
                yList = yMax;
            end

            % Since we have chosen not to visit the rest of them, we can mark
            % the remaining cells as visited. 
            visited = markAdditional(xList,yList,visited, cur(1), cur(2));

            % If only one possible cell to go to based on x/y list
            if length(xList) == 1
                newPoint = [xList(1),yList(1)];
                stack = [stack;newPoint];
            % If a split is necessary
            elseif length(xList) > 1
                % For every new point to go to we add it to the stack
                for i=1:length(xList)
                    disp("needs to split");
                    newPoint = [xList(i), yList(i)];
                    % The function is called on the next coordinates to go
                    % to.
                    stack = [stack; newPoint];
                end
            else
                disp('no possible found')
            end
        end 

        % Since we have found all the values to explore, we can mark this as
        % visited.
        visited(cur(1), cur(2)) = 1;

    end
end