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
% se = strel('square', 3);
binArr = imdilate(binArr, se);

% Get rid of small blobs and smoothen out the borders
binArr = bwareaopen(binArr, 500);
binArr = imclose(binArr, true(5));

% Fill in the holes
binArr = imfill(binArr, 'holes');

tempArr = binArr;

% Set the border to be an obstacle
binArr([1,end],:) = 1;
binArr(:,[1,end]) = 1;

% Display the filled in binary image
% figure;
% imshow(binArr)
%  
%% Conduct Wavefront Potential/Brushfire Method

% Convert our binary image to a double array 
imArr = double(binArr);

% We let 1 denote an obstacle
cur = 1;
temp = length(find(ismember(imArr,0)));

while(temp ~= 0)
    [r,c] = find(ismember(imArr, cur));
    
    for i=1:length(r)
        imArr = replaceAdj(imArr, r(i), c(i), cur);
    end
 
    cur = cur+1;
    temp = length(find(ismember(imArr,0)))
end


for i=1:size(imArr,1)
    for j=1:size(imArr,2)
        if imArr(i,j) == 0
            [minVal, sumVal] = getAdjVals(imArr, i, j);
            imArr(i,j) = minVal + 1;
        end
    end
end

adjSum = zeros(size(imArr));
for i=1:size(adjSum,1)
    for j=1:size(adjSum,2)
        [minVal, sumVal] = getAdjVals(imArr, i, j);
        adjSum(i,j) = sumVal;
    end
end

% %% Conduct Voronoi on the Image
% 
% % We conduct our search starting from each of the 4 corners
% 
% % First we just run it starting from the corner
% % Will contain a 1 if the cell has been visited and a 0 if not
% visited = zeros(size(imArr));
% 
% x = [];
% y = [];
% 
% rC = 1;
% cC = 1;
% iter = 1;
% 
% xStack = [];
% yStack = [];
% 
% while iter < 100
%     
%     visited(rC, cC) = 1;
%     
%     x = [x;rC];
%     y = [y;cC];
%     
%     % Check if we have arrived back at an edge
%     if(iter ~= 1 && imArr(rC, cC) == 1)
%         disp('back at the edge');
%         break
%     end
%     
%     % Gets the largest unvisited value/possible moves
%     [max, xCoords, yCoords] = getAdjRel(imArr, rC, cC, visited, 1);
%     % Case where there is an unvisited larger adjacent
%     if max >= imArr(rC, cC)
%         
%         if length(xCoords) > 1
%             break
%         end
%         for i=1:length(xCoords)
%             xStack = [xStack; xCoords(i)];
%             yStack = [yStack; yCoords(i)];
%         end
%         
%     % Case where the max is lower.
%     else
%         % In this case, we'd want to find the adjacent that has the
%         % smallest sum
%         [min, xCoords, yCoords] = getAdjRel(adjSum, rC, cC, visited, 0);
%         if min <= adjSum(rC, cC)
%             disp('sum')
%             length(xCoords)
%             for i=1:length(xCoords)
%                 xStack = [xStack; xCoords(i)];
%                 yStack = [yStack; yCoords(i)];
%             end
%         end
%         
%     end
%     
%     iter = iter + 1;
%     
%     if(isempty(xStack))
%         disp('stack is empty');
%         break
%     end
%     
%     % Pop from the stack
%     rC = xStack(end);
%     cC = yStack(end);
%     
%     xStack = xStack(1:end-1);
%     yStack = yStack(1:end-1);
% 
%         
% end
% 
% [r,c] = find(tempArr);
% plot(r,c);
% hold on
% scatter(x,y,'red');

%% Voronoi Built In Attempt

% Attempt using built in voronoi function
% [r, c] = find(tempArr);
% voronoi(r,c)

function arr = replaceBlanks(arr, i, j, target)
    
end
