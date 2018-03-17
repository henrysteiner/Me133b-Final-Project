%% Initial Image Processing

% Read in the image
I = imread('img/square.jpg');
scale = 1;

% Convert to grayscale
I = rgb2gray(I);
reI = imresize(I, scale);

% Conduct matlab edge detection using the 'log' method with
%   automatic thresholding values.
binArr = edge(I, 'log');
imshow(binArr);


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


%% Voronoi Attempt2: Find Midpoints between Obstacles and Draw Path

voronoi = zeros(size(imArr));
v_points = [];
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

%% Draw Voronoi Diagram

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

scatter(xr,yr,200,'y','filled')
hold on
scatter(xg,yg,200,'g','filled')
hold on

[closestRX,closestRY] = findClosest(xr,yr,v_points);
plot([xr closestRX],[yr closestRY],'LineWidth',1)
hold on
[closestGX,closestGY] = findClosest(xg,yg,v_points);
plot([xg,closestGX],[yg,closestGY],'LineWidth',1)

hold off




