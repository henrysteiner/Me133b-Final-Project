%% Initial Image Processing

% Read in the image
I = imread('img/square.jpg');
a = max(size(I)); 
scale = 400/max(size(I));

% Convert to grayscale
I = rgb2gray(I);
reI = imresize(I, scale);

% Conduct matlab edge detection using the 'log' method with
%   automatic thresholding values.
binArr = edge(reI, 'log');
% imshow(binArr);

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

binArr2 = imresize(binArr, scale);
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

% Continuously iterate and add new numbers. Stop when no more 0's are
% found.
while(temp ~= 0 && newTemp ~= temp)
    
    % Keep searching for numbers and replacing empty adjacent ones with
    % the number incremented.
    newTemp = temp;
    [r,c] = find(ismember(imArr, cur));
    
    for i=1:length(r)
        imArr = replaceAdj(imArr, r(i), c(i), cur);
    end
    
    cur = cur+1;
    % Number of 0's remaining.
    temp = length(find(ismember(imArr,0)))
end

%% Voronoi Attempt2: Find Midpoints between Obstacles and Draw Path

voronoi = zeros(size(imArr));
v_points = [];

% Loop through all points and run the check cell function on each pair
% of points is. This function looks for the ratio of lower adjacents to
% higher adjacents.
for i=1:size(imArr,1)
    for j=1:size(imArr,2)
        cur = [i,j];
        if checkCell(imArr, cur)
            cur
            v_points = [v_points; cur];
            voronoi(cur(1), cur(2)) = 1;
        end
    end
end

%% Make Adjacency Matrix and Graph out of Voronoi Points

adjMat = zeros(length(v_points));
% Loop through all the voronoi points. If two points are adjacent to each
% other in the image array, it means there should be an edge between them.
for i=1:length(v_points)
    for j=1:length(v_points)
        adjMat(i,j) = isAdjacent(v_points(i,:), v_points(j,:));
    end
end

% Creates a graph out of this adjacency matrix.
G = graph(adjMat);
% plot(G);

%% Draw Voronoi Diagram

% First, display the black and white image with the path overlayed on it.
figure;
imshow(reI);
hold on
scatter(v_points(:,2),v_points(:,1), 5, 'red','square', 'filled');
hold on

% Use data cursor to select robot point and export point as "robot" and "goal" to workspace
disp('Choose [robot] starting location')
pause;

xr = robot.Position(1);
yr = robot.Position(2);

xg = goal.Position(1);
yg = goal.Position(2);   

% Ensure that the robot and goal positions are valid. 
if (imArr(xr, yr) == 1 || imArr(xg, yg) == 1)
    disp ('Error: Robot and Goal should not be within an obstacle');
    xr = robot.Position(1);
    yr = robot.Position(2);
    
    xg = robot.Position(1);
    yg = robot.Position(2);
else
    % If valid, plot the robot and goal point.
    scatter(xr,yr,200,'y','filled')
    hold on
    scatter(xg,yg,200,'g','filled')
    hold on

    % Search for the closest point on the voronoi path.
    [closestRX,closestRY] = findClosest(xr,yr,v_points);
    plot([xr closestRX], [yr closestRY], 'blue', 'LineWidth',2)
    hold on
    [closestGX,closestGY] = findClosest(xg,yg,v_points);
    plot([xg,closestGX], [yg,closestGY], 'blue', 'LineWidth',2)

    % Find the index of the robot closest and goal closest since that
    % represents the node number.
    [indexR, indexG] = findIndex(v_points, [closestRY, closestRX], [closestGY, closestGX]);
    
    % Get the path of nodes that represents the shortest path from the
    % robot to the goal.
    P = shortestpath(G, indexR, indexG);
    path = zeros(length(P), 2);
    
    % Follow the shortest path and add each point to the path list. 
    for i=1:length(P)
        point = v_points(P(i), :);
        path(i,:) = point;
    end

    plot(path(:,2), path(:,1), 'blue', 'LineWidth',2);
end

hold off





