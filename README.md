# Getting-and-Cleaning-Data

The file run_analysis.R is an r script which works as follows:

1) Set the working directory to a temporary directory
2) Download and unzip the files from the provided url
3) Read, merge and attribute names to the "train" files
4) Read, merge and attribute names to the "test" files
5) Merge both data sets 
6) Select the desired columns
7) Read and name the activities in the data set
8) Label the dataset
9) Take the average of each variable for each activity and each subject, thus creating a new data set
10) Write a .txt file with row.name = FALSE using the write.table() function

The output is a tidy data set 


