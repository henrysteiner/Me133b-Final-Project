function arr = replaceAdj(arr, i, j, target)
    for x=i-1:i+1
        for y = j-1:j+1
            if x < size(arr,1) && x > 0
                if y < size(arr,2) && y > 0
                    if x ~= i || y ~= j
                        if arr(x,y) == 0
                            arr(x,y) = target+1;
                        end
                    end
                end
            end
        end
    end
end