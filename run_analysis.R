###############################################################################

# Filename: run_analysis.R
# Date created: 21 June 2015
#
# This R script is used to clean up the UCI HAR Dataset obtained from the following link,
# Link: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
#
# This script implements following frive requirements,
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names. 
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
#
###############################################################################

# Clear workspace
rm(list=ls())

# Set working directory
work_dir = "/Users/samridhsharma/Coursera/jhopdatasci/C-getncleandata/project"
setwd(work_dir)


# Read and set appropriate column names for training tables
activity_labels = read.table('./activity_labels.txt', header=FALSE);
colnames(activity_labels) = c('activityId', 'activityType');

subject_train = read.table('./train/subject_train.txt', header=FALSE);
colnames(subject_train) = "subjectId";

y_train = read.table('./train/y_train.txt', header=FALSE);
colnames(y_train) = "activityId";

features = read.table('./features.txt', header=FALSE);
x_train = read.table('./train/x_train.txt', header=FALSE);
colnames(x_train) = features[,2];

# Create preliminary training dataset combining all tables from above
training_data = cbind(subject_train, y_train, x_train);


# Read and set appropriate column names for test tables
subject_test = read.table('./test/subject_test.txt', header=FALSE);
colnames(subject_test) = "subjectId";

y_test = read.table('./test/y_test.txt', header=FALSE);
colnames(y_test) = "activityId";

x_test = read.table('./test/x_test.txt', header=FALSE);
colnames(x_test) = features[,2];

# Create preliminary test dataset combining all tables from above
test_data = cbind(subject_test,y_test,x_test);


# REQ 1: Merges the training and the test sets to create one data set.
full_dataset = rbind(training_data, test_data);


# Get all column names
allcolnames = colnames(full_dataset);

# Logical vector to get extrcat specific attributes - means and std devs.
colname_filter = ( grepl("subject..",allcolnames) 
                   | grepl("activity..",allcolnames) 
                   | grepl("-mean()",allcolnames) 
                   | grepl("-std()",allcolnames) 
                   & !grepl("..-meanFreq()",allcolnames)
                   & !grepl("-meanFreq..-",allcolnames)
                   & !grepl("-mean..-",allcolnames) 
                   & !grepl("-std..-",allcolnames) );

# REQ 2: Extract only Means and Std Devs for measurements.
final_dataset = full_dataset[colname_filter==TRUE];


# REQ 3: Required dataset is merged with activity dataset to get activity names.
final_dataset = merge(final_dataset,activity_labels,by='activityId',all.x=TRUE);


# Get final column names
final_colnames = colnames(final_dataset);

# REQ 4: Label dataset with descriptive variable names.
for (i in 1:length(final_colnames)) 
{
  final_colnames[i] = gsub("\\()","",final_colnames[i])
  final_colnames[i] = gsub("-std$","StdDev",final_colnames[i])
  final_colnames[i] = gsub("-mean","Mean",final_colnames[i])
  final_colnames[i] = gsub("^(t)","time-",final_colnames[i])
  final_colnames[i] = gsub("^(f)","freq-",final_colnames[i])
  final_colnames[i] = gsub("([Gg]ravity)","Gravity",final_colnames[i])
  final_colnames[i] = gsub("([Bb]ody[Bb]ody|[Bb]ody)","Body",final_colnames[i])
  final_colnames[i] = gsub("[Gg]yro","Gyro",final_colnames[i])
  final_colnames[i] = gsub("AccMag","AccMagnitude",final_colnames[i])
  final_colnames[i] = gsub("([Bb]odyaccjerkmag)","BodyAccJerkMagnitude",final_colnames[i])
  final_colnames[i] = gsub("JerkMag","JerkMagnitude",final_colnames[i])
  final_colnames[i] = gsub("GyroMag","GyroMagnitude",final_colnames[i])
};


# Assign fixed variable names to dataset column names.
colnames(final_dataset) = final_colnames;

# Temporarily remove activity type column for further processing
prelim_dataset = final_dataset[,colnames(final_dataset) != 'activityType'];

# Aggregate the dataset for mean values along the activityId and subjectId.
prelim_tidydata = aggregate(prelim_dataset[,colnames(prelim_dataset) != c('activityId','subjectId')],
                     by = list(activityId = prelim_dataset$activityId,
                               subjectId = prelim_dataset$subjectId), mean);

# Merge the new dataset with activity names
tidy_dataset = merge(prelim_tidydata, activity_labels, by='activityId', all.x=TRUE);

# REQ 5: Write the tidy dataset to tody.txt using write.table.
write.table(tidy_dataset, './tidy_data.txt', row.names=TRUE, sep='\t', eol='\n');
