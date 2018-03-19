# Me133b-Final-Project

How to Run:

Open edgeDetect.m. If you would like to find the voronoi path for a different
image, add it to the img folder and modify the filename variable. Following
this, run Section 1. This will run the edge detection and display an image where
obstacles are colored white and free space is colored black. 

Next, run Section 2 which will conduct the brushfire method. We know that this has 
completed when the temp variable (outputted on the command line) has the value 0, 
since this indicates that no zeroes are left. 

Next, run Section 4 which has the succesful Voronoi attempt. 

Next, run Section 5 which creates the adjacency matrix. If you would like to view
the graph of the voronoi path nodes, uncomment 'plot(G)'.

Lastly, run Section 6. This draws the voronoi path on top of the grayscale input
image. It then prompts you to choose two points. Select the Data Cursor option
on the toolbar. Then right click anywhere in the free
space of the image and choose 'Export Cursor Data to Workspace'. When prompted 
name the point 'robot'. Click somewhere else in the free space and again right
click and choose 'Export Cursor Data to Workspace'. This time, name the point 
'goal'. Finally, click any key and a blue path will be highlighted between the 
robot and goal points. Note that the robot will be denoted by a yellow circle
and the goal will be denoted by a green circle. Close the image and rerun 
Section 6 to choose different robot and goal locations.