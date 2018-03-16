function [val, xVals, yVals] = getAdjRel(arr, i, j, visited, maxFlag)
    % if the max input = 1, then we find the max
    % if it = 0, then we find the min
    
    if maxFlag == 1
        val = 0;
    else
        val = size(arr,1);
    end
    
    xVals = [];
    yVals = [];
    
    for x = i-1:i+1
        for y = j-1:j+1
            % Check that x is less than the number of rows and nonneg
            if x <= size(arr,1) && x > 0
                % Check that y is less than the number of cols and nonneg
                if y <= size(arr,2) && y > 0
                    % Check that we are not looking at the current cell
                    if x ~= i || y ~= j
                        % Check if looking for min or max
                        if maxFlag == 1
                            if arr(x,y) > val && visited(x,y) ~= 1
                                val = arr(x,y);
                            end
                        else
                            if arr(x,y) < val && visited(x,y) ~= 1
                                val = arr(x,y);
                            end
                        end
                    end
                end
            end
        end
    end
    
    for x = i-1:i+1
        for y = j-1:j+1
            % Check that x is less than the number of rows and nonneg
            if x < size(arr,1) && x > 0
                % Check that y is less than the number of cols and nonneg
                if y < size(arr,2) && y > 0
                    % Check that we are not looking at current cell
                    if x~= i && y~= j
                        if arr(x,y) == val && visited(x,y) ~= 1
                            xVals = [xVals;x];
                            yVals = [yVals;y];
                        end
                    end
                end
            end
        end
    end
            
end