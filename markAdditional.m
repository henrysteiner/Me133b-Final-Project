function [ visited ] = markAdditional( xList, yList, visited, i, j )
    % This function marks all adjacent cells to the inputted i,j cell as
    % visited, unless they are in the list of next cells to go to. 
    
    % Sets all the adjacent to visited
    for x = i-1:i+1
        for y = j-1:j+1
            % Check that x is less than the number of rows and nonneg
            if x <= size(visited,1) && x > 0
                % Check that y is less than the number of cols and nonneg
                if y <= size(visited,2) && y > 0
                    % Check that we are not looking at the current cell
                    if x ~= i || y ~= j
                        visited(x,y) = 1;
                    end
                end
            end
        end
    end
    
    % Set all in xList to not visited
    for x=1:length(xList)
        visited(xList(x), yList(x)) = 0;
    end


end