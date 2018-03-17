function [closeX,closeY] = findClosest(posX, posY, v_points) 

vy = v_points(:,1);
vx = v_points(:,2);

minDistance = 999999999;
closeX = 0;
closeY = 0;
for i=1:length(vx)
     distance = sqrt((vx(i)-posX)^2+(vy(i)-posY)^2);
     if distance < minDistance
         minDistance = distance;
         closeX = vx(i);
         closeY = vy(i);
     end
end
end

