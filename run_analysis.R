
# 0 Downloads and unzips raw data to working directory:
dsURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(dsURL, "Dataset.zip", method = "curl", mode = "wb")
unzip("Dataset.zip")

# -------
# 1 Merges the training and the test sets to create one data set:

# loads training and test sets
train <- read.table("./UCI HAR Dataset/train/X_train.txt") 
test <- read.table("./UCI HAR Dataset/test/X_test.txt") 

library(dplyr)
ds <- bind_rows(train, test) 


# -------
# 2 Extracts only the measurements on the mean and standard deviation for each 
#   measurement; and saves in subset 'ds1':

# loads list of all character features, then renames 'ds' variables 
features <- read.table("./UCI HAR Dataset/features.txt") 
colnames(ds) <- features[,2] 

ds1 <- select(ds, contains(c("mean", "std")) ) 
       

# -------
# 3 Uses descriptive activity names to name the activities in the data set:

# loads training and test numeric labels 
trainLabel <- read.table("./UCI HAR Dataset/train/Y_train.txt") 
testLabel <- read.table("./UCI HAR Dataset/test/Y_test.txt") 

# joins training and test numeric labels maintaining the same index order
dsLabel <- bind_rows(trainLabel,testLabel)  

# loads activity legend key, then joins with numeric labels to extract descriptive 
# activity names
act_legend <- read.table("./UCI HAR Dataset/activity_labels.txt") 
dsLabel <- left_join(dsLabel, act_legend, by = "V1") 

ds1 <- bind_cols(ds1, activity = dsLabel$V2) 


# -------
# 4 Cleans up labels of data set 'ds1' with descriptive variable names.

names(ds1) <- gsub("[- () ,]","", names(ds1)) 
names(ds1) <- gsub("^t","time", names(ds1))
names(ds1) <- gsub("^f","frequency", names(ds1))
names(ds1) <- tolower(names(ds1)) 


#--------       
# 5 From data set 'ds1' creates a second, independent tidy data set
#   'ds2' with the average of each variable for each activity and each subject:

# loads numeric subject data for training and test 
trainSubject <- read.table("./UCI HAR Dataset/train/subject_train.txt") 
testSubject <- read.table("./UCI HAR Dataset/test/subject_test.txt")
dsSubjects <- bind_rows(trainSubject,testSubject) 

# adds subjects data to 'ds1'
ds1 <- bind_cols(ds1, subject = dsSubjects$V1) 

# creates 'ds2' 
library(reshape2)
ds1melt <- melt(ds1, id.vars = c("activity", "subject"))
ds2 <-dcast(ds1melt, activity + subject ~ variable, mean)

# data set 'ds2ver' is the vertical version of tidy data set 'ds2'
library(tidyr)
ds2ver <- gather(ds2, key = "variable", value = "average", 3:88)




        