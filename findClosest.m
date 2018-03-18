function [closeX,closeY] = findClosest(posX, posY, v_points) 
    % This function identifies the closest point on the voronoi path to the
    % inputted point.
    vy = v_points(:,1);
    vx = v_points(:,2);
    
    minDistance = 999999999;
    closeX = 0;
    closeY = 0;
    % Iterate through the list of voronoi points and figure out which one
    % has the minimum distance.
    for i=1:length(vx)
         distance = sqrt((vx(i)-posX)^2+(vy(i)-posY)^2);
         if distance < minDistance
             minDistance = distance;
             closeX = vx(i);
             closeY = vy(i);
         end
    end
end

