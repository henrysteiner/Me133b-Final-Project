function [ truth ] = checkCell(arr, cur, visited)

    i = cur(1);
    j = cur(2);
    valHigher = 0; 
    valLower = 0;
    
    rCoords = [];
    cCoords = [];
    
    for r = i-1:i+1
        for c = j-1:j+1
            % Check that x is less than the number of rows and nonneg
            if r <= size(arr,1) && r > 0
                % Check that y is less than the number of cols and nonneg
                if c <= size(arr,2) && c > 0
                    % Check that we are not looking at the current cell
                    if r ~= i || c ~= j
                        if arr(r,c) >= arr(i,j)
                            valHigher = valHigher + 1;
                        else
                            valLower = valLower + 1;
                        end
                    end
                end
            end
        end
    end
    
    truth = valLower > valHigher;
end

