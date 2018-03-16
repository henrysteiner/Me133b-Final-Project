function [minVal, sumVal] = getAdjVals(imArr, i, j)
    minVal = max(size(imArr,1),size(imArr,2));
    sumVal = 0;
  
    for x = i-1:i+1
        for y = j-1:j+1
            % Check that x is less than the number of rows and nonneg
            if x < size(imArr,1) && x > 0
                % Check that y is less than the number of cols and nonneg
                if y < size(imArr,2) && y > 0
                    
                    if x ~= i || y ~= j
                        % Check that the value is nonzero
                        if imArr(x,y) ~= 0 && imArr(x,y) < minVal
                            minVal = imArr(x,y);
                        end

                        % Accumulate the sum of the adjacent values
                        sumVal = sumVal + imArr(x, y);
                    end
                end
            end
        end
    end
end

