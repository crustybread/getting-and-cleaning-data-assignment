Run_Analysis.R Program Objectives
===========================

The folder structure of the data.

/UCI_HAR_Dataset
	/test
		/inertial_signals
		 subject_test.txt
		 x_test.txt
		 y_test.txt
	/train
		/inertial_signals
		 subject_train.txt
		 x_train.txt
		 y_train.txt
		 
	activity_labels.txt
	features.txt
	features_info.txt
	readme.txt

The inertial_signal_ and _test sub-folders each contain 9 files. Each file respresents a different type of observation from either the accelerometer or gyroscope sensor; each subject file contains 7352 (test/2947) records of 128 numeric measurements taken approximately 2.5 seconds apart. This is the "raw" observational data. For the purpose of this assignment, this data will not be used.

subject_train and subject_test each have 7352 records and 2947 records respectively. Each have 1 column of data, a factor from 1 to 30 identifying the participant of the study (70% of subjects are in train and 30% in test, mutually exclusive). 

y_train and y_test each have 7352 records and 2947 records respectively. Each have 1 column of data, a factor from 1 to 6 identifying the type of activity

x_train and x_test each have 7352 and 2947 records respectively with 561 columns of numeric values (as identified in features.txt) calculated from the sensors' inertial signals data. The mean and standard deviation columns of this data will have to be extracted. 

The goal of the program is to build a train and a test dataframe. First column will be subject, next column will be activity and the remaining columns will be the mean and standard deviation columns. We'll rbind these dataframes and then create a new dataframe with groups the data by subject and then activity, and takes the column mean of the measurements. 


Pseudo Code
===========
1) Load libraries
2) Clear existing namespace variables and set the working directory to the path containing the features.txt and activity_labels.txt files
3) Read in the features.txt and activity_labels.txt files
4) Add headers to the "activity labels" table; convert activity label text descriptions to lower case
5) Load "proc" function to read and parse the subject, activity and measurement files for "train" and "test" datasets sequentially
6) In each pass, change the working directory and read in the train and test files to corresponding tables
7) Add appropriate column headers
8) join the activity table to the activity label table to "swap" the activity ID with its corresponding text description, and remove the redundant activity id column
9) grep the measurement dataframe for "mean" and "std" in the header; create a new dataframe that selects only those columns
10) cbind the subject, activity, and measurement dataframes into one dataframe, which is the output of the function
11) Initiate the "proc" function with "train" dataset first, then "test" dataset
12) rbind the result of each function run into the "data" dataframe; then arrange data by subject, then activity
13) Create a vector of columns to group by: subject/activity
14) Create a new dataframe based on data to remove subject/activity columns; then extract column headers in this dataframe to their own variable
15) Run ddply on the data dataframe to group by subject/activity, then run colMeans on data
16) Write the output to main.txt file

 