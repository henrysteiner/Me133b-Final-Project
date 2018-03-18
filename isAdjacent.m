function [ adjTruth ] = isAdjacent( point1, point2 )
    % This function takes in two points and returns a boolean which denotes
    % whether the points are adjacent or not.
    
    xPos = [point1(1)-1; point1(1); point1(1)+1];
    yPos = [point1(2)-1; point1(2); point1(2)+1];
    
    xTrue = 0;
    yTrue = 0;
    
    for i=1:3
        if point2(1) == xPos(i)
            xTrue = 1;
        end
        if point2(2) == yPos(i)
            yTrue = 1;
        end
    end
    
    adjTruth = xTrue && yTrue;
end

