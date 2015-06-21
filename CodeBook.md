Getting and Cleaning Dataset

This is a course specific project for Getting and Cleaning Data under the Coursera Data 
Sciences Specialization.

This code book provides a description of the dataset, the clean script - run_analysis.R 
and the finished dataset.

Original Dataset

Name: Human Activity Recognition Using Smartphones Data Set
Source: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

The experiments have been carried out with a group of 30 volunteers within an age bracket 
of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSATIRS, WALKING_DOWNSTAIRS, 
SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its 
embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular 
velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. 
The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was 
selected for generating the training data and 30% the test data.

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and 
then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). 
The sensor acceleration signal, which has gravitational and body motion components, was separated 
using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is 
assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. 
From each window, a vector of features was obtained by calculating variables from the time and frequency domain.


Final Tidy Dataset

Independent tidy data set that combines the training and test datasets from the source, provides descriptive
variable names and the is aggregated for an average of each variable for each activity and each subject.


Attribute Information

For each record in the dataset it is provided:
- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope.
- A 561-feature vector with time and frequency domain variables.
- Its activity label.
- An identifier of the subject who carried out the experiment. 

Part 1: 

Clear the workspace, set our working directory and read in the following tables,

features.txt
activity_labels.txt
subject_train.txt
y_train.txt
x_train.txt
subject_test.txt
y_test.txt
x_test.txt

Set appropriate column names for each of the tables and column-wise combine tables using the 
cbind() function. Merge the training and test datasets using the rbind() function.

Part 2: 

Create a logical vector using the grepl() function to extract the mean and standard deviation columns
of the measurements.

Part 3: 

Merge the given dataset with activity_labels table to get means and standard deviations for all 
the activity names. Go through the column names and fix abbreviations using a for loop and store 
names is a temp character vector. Assign the new names back to the dataset. 

Part 4:

Aggregate the measures for an average along the activityId and subjectId. Write out the tidy dataset
to a text file using the write.table() function.
