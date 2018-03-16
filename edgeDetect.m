%% Initial Image Processing

% Read in the image
I = imread('deskOverview.png');
% Convert to grayscale
I = rgb2gray(I);

% Conduct matlab edge detection using the 'log' method with
%   automatic thresholding values.
binArr = edge(I, 'log');

% Dilate the image in order to connect the detecting edges to try and get
% actual shapes.
% Use a line structuring element that is length 5 and angle 45
se = strel('line',5,45);
% se = strel('square', 5);
binArr = imdilate(binArr, se);

% Get rid of small blobs and smoothen out the borders
binArr = bwareaopen(binArr, 500);
binArr = imclose(binArr, true(5));

% Fill in the holes
binArr = imfill(binArr, 'holes');

binArr2 = imresize(binArr, 0.5);
tempArr2 = binArr2;

% Set the border to be an obstacle
binArr2([1,end],:) = 1;
binArr2(:,[1,end]) = 1;

% Display the filled in binary image
figure;
imshow(binArr)
 
%% Conduct Wavefront Potential/Brushfire Method

%Convert our binary image to a double array 
imArr = double(binArr2);

% We let 1 denote an obstacle
cur = 1;
temp= length(find(ismember(imArr,0)));
newTemp = 0;

while(temp ~= 0 && newTemp ~= temp)
    newTemp = temp;
    [r,c] = find(ismember(imArr, cur));
    
    for i=1:length(r)
        imArr = replaceAdj(imArr, r(i), c(i), cur);
    end
 
    cur = cur+1;
    temp = length(find(ismember(imArr,0)))
end

adjSum = zeros(size(imArr));
for i=1:size(adjSum,1)
    for j=1:size(adjSum,2)
        [~, sumVal] = getAdjVals(imArr, i, j);
        adjSum(i,j) = sumVal;
    end
end

%% Voronoi Attempt 1: Traverse through all Possible Paths using Stack

visited = zeros(size(imArr));
points = [];
stack = [1,1];

while(~isempty(stack))
    
    % Pop off the stack
    cur = stack(end,:)
    stack = stack(1:end-1, :);
    
    % Add it to the path of points we have visited
    points = [points; cur];
    
    % Base case, In this case do nothing and let this iteration complete
    if((imArr(cur(1), cur(2)) == 1 && (cur(1)~=1||cur(2)~=1)))
        disp('base case')
        visited(cur(1), cur(2)) = 1;
    % If not the base case, see what other points we should explore.
    else
        % Get the max value surrounding as well as the cells that
        % contain that value
        [max, xMax, yMax] = getAdjRel(imArr, cur, visited, 1);
        xList = [];
        yList = [];
        
        % If that maximum value is larger or equal than the current cell value
        if max >= imArr(cur(1), cur(2))
            if length(xMax) > 1
                
                [~, adjX, adjY] = getAdjRel(adjSum, cur, visited, 1);

                for i=1:length(adjX)
                    for j=1:length(xMax)
                        if adjX(i) == xMax(j) && adjY(i) == yMax(j)
                            xList = [xList;xMax(j)];
                            yList = [yList;yMax(j)];
                        end
                    end
                end
            else
                xList = xMax;
                yList = yMax;
            end
        end

        % If the max value is not larger, it means we need to trace a line
        % back to the edge. We do this by looking at the unvisited adjacent cell that
        % has the minimum adjacent cell sum.
        if isempty(xList)
            [~, xMin, yMin] = getAdjRel(adjSum, cur, visited, 0);
            xList = xMin;
            yList = yMin;
        end

        % Since we have chosen not to visit the rest of them, we can mark
        % the remaining cells as visited. 
        % visited = markAdditional(xList,yList,visited, cur(1), cur(2));
        
        % If only one possible cell to go to based on x/y list
        if length(xList) == 1
            newPoint = [xList(1),yList(1)];
            stack = [stack;newPoint];
        % If a split is necessary
        elseif length(xList) > 1
            % For every new point to go to we add it to the stack
            for i=1:length(xList)
                disp("needs to split");
                newPoint = [xList(i), yList(i)];
                % The function is called on the next coordinates to go
                % to.
                stack = [stack; newPoint];
            end
        else
            disp('no possible found')
        end
    end 
    
    % Since we have found all the values to explore, we can mark this as
    % visited.
    visited(cur(1), cur(2)) = 1;
    
end

%% Voronoi Attempt2: Find Midpoints between Obstacles and Draw Path

points = []
for i=1:size(imArr,1)
    for j=1:size(imArr,2)
        cur = [i,j];
        if checkCell(imArr, cur)
            cur
            points = [points; cur];
        end
    end
end

%% Draw Voronoi Diagram

imshow(imresize(I,0.5));
hold on
scatter(points(:,2),points(:,1), 1, 'red', 'filled');

%% Voronoi Built In Attempt

% Attempt using built in voronoi function
[r, c] = find(tempArr2);
voronoi(r,c)
