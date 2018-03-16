function line = findClosest(posX, posY, voronoi) 
[rows,cols]=size(voronoi);


minDistance = 10000;
closeX = 0;
closeY = 0;
for i=1:rows
    pathX = voronoi(i,1);
    pathY = voronoi(i,2);
    
    distance = sqrt((pathX-posX)^2+(pathY-posY)^2);
    if distance < minDistance
        minDistance = distance;
        closeX = pathX;
        closeY = pathY;
    end
end

line = plot(posX,closeX,posY,closeY);



end

