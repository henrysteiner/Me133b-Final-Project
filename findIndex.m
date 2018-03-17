function [ indexR, indexG ] = findIndex( v_points, pointR, pointG )
    
    indexR = -1;
    indexG = -1;
    
    for i=1:length(v_points)
        vPoint = v_points(i,:);
        if vPoint(1) == pointR(1) && vPoint(2) == pointR(2)
            indexR = i;
        end
        if vPoint(1) == pointG(1) && vPoint(2) == pointG(2)
            indexG = i;
        end
    end

end

