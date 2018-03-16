function [val, rVals, cVals] = getAdjRel(arr, cur, visited, maxFlag)
    % if the max input = 1, then we find the max
    % if it = 0, then we find the min
    i = cur(1);
    j = cur(2);
    
    if maxFlag == 1
        val = 0;
    else
        val = size(arr,1)*size(arr,1);
    end
    
    rVals = [];
    cVals = [];
    
    for r = i-1:i+1
        for c = j-1:j+1
            % Check that x is less than the number of rows and nonneg
            if r <= size(arr,1) && r > 0
                % Check that y is less than the number of cols and nonneg
                if c <= size(arr,2) && c > 0
                    % Check that we are not looking at the current cell
                    if r ~= i || c ~= j
                        % Check if looking for min or max
                        if maxFlag == 1
                            % Find the max value whether or not the max has
                            % been visited
                            if arr(r,c) >= val
                                val = arr(r,c);
                            end
                        else
                            % Find the min value whether or not the min has
                            % been visited
                            if arr(r,c) <= val
                                val = arr(r,c);
                            end
                        end
                    end
                end
            end
        end
    end
    
    for r = i-1:i+1
        for c = j-1:j+1
            % Check that x is less than the number of rows and nonneg
            if r <= size(arr,1) && r > 0
                % Check that y is less than the number of cols and nonneg
                if c <= size(arr,2) && c > 0
                    % Check that we are not looking at current cell
                    if r ~= i || c ~= j
                        % Only add the values that haven't been visited
                        if arr(r,c) == val && visited(r,c) ~= 1
                            rVals = [rVals;r];
                            cVals = [cVals;c];
                        end
                    end
                end
            end
        end
    end
            
end