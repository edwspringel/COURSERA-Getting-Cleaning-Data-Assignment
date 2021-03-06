
### COURSERA GETTING AND CLEANING DATA ASSIGNMENT #########################

#####Review Criteria####

# The submitted data set is tidy
# The GitHub Repo contains the required scripts
# GitHub has a Codebook that modifies and updates the available Codebooks with all the data
# to indicate the variables and summaries calculated, along with units, 
# and any other relevant info.
# The README that explains the analysis files is clear and understandable
# The work submitted is the work of the student


##### Deliverables - You need a ..####
# CodeBook.md
# README.md
# R script
# TidyDataSet

### Create an R Script that does the following:
# 1. Merge the Training and the Test sets to create one data set
# 2. Extract only the measuremtns on the mean and std dev for each measurement
# 3. uses descriptive activity names to name the activities in the data set.
# 4. appropriately labels the data set with descriptive variable names.
# 5. From the data in step 4, create a second, independent tidy data set


# load the required libraries
library("data.table")
library("reshape2")

# set working directory
setwd("/Users/edwardspringel/Desktop/COURSERA/data")
path<-getwd()

# get and unzip the data:
if (!file.exists("./data/UCI HAR Dataset"))
{    
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, file.path(path, "assignmentData.zip"))
unzip(zipfile = "assignmentData.zip")
}
## Unzipping results in "UCI HAR Dataset" file

## So I looked at the files and I see the names of collected data.


## Load "activityLabels" and "features"
activityLabels <- fread(file.path(path, "UCI HAR Dataset/activity_labels.txt"), col.names = c("classLabels", "activityName"))
names(activityLabels)
activityLabels  ## ok- looks like it makes sense and they're appropriately-enough named.

features <- fread(file.path(path, "UCI HAR Dataset/features.txt"), col.names = c("index", "featureNames"))
names(features)
features  ## I think this is what we want from the features (variables) in the data.
## I don't know what I would re-name these to make them more intuitive.
## Even after reading the description from the UCI website- 
## I'm not going to bother changing these.


## 2. Extract JUST the Mean and Std Dev of each dataset: as there's skewness, kurtosis,
# and all sorts of stuff in the features
featuresExtracted <- grep(".*mean.*|.*std.*", features[, featureNames])
featuresExtracted
measurements <- features[featuresExtracted, featureNames]
measurements
measurements <- gsub('[-()]', '', measurements)
measurements

# Load train datasets
train <- fread(file.path(path, "UCI HAR Dataset/train/X_train.txt"))[, featuresExtracted, with = FALSE]
data.table::setnames(train, colnames(train), measurements)
# I'm just using the same names here so far.
trainActivity <- fread(file.path(path, "UCI HAR Dataset/train/Y_train.txt"), col.names = c("Activity"))
trainSubjectNum <- fread(file.path(path, "UCI HAR Dataset/train/subject_train.txt"), col.names = c("SubjectNum"))
# then cbind the train tables together:
train <- cbind(trainSubjectNum, trainActivity, train)
names(train)

# Load test datasets
test <- fread(file.path(path, "UCI HAR Dataset/test/X_test.txt"))[, featuresExtracted, with = FALSE]
data.table::setnames(test, colnames(test), measurements)
colnames(test)
testActivity <- fread(file.path(path, "UCI HAR Dataset/test/Y_test.txt"), col.names = c("Activity"))
testSubjectNum <- fread(file.path(path, "UCI HAR Dataset/test/subject_test.txt"), col.names = c("SubjectNum"))
# then cbind the tables together
test <- cbind(testSubjectNum, testActivity, test)
names(test)
## Good! the names in the train set and the test set are the same!!- so I just use rbind.

# 1. Merge the Training and the Test sets to create one data set
Merged <-rbind(train, test)

# Convert classLabels to activityName basically. More explicit.
activityLabels$classLabels # 1-6 
activityLabels$activityName # the category of activity
Merged[["Activity"]] <- factor(Merged[, Activity] , levels = activityLabels[["classLabels"]], labels = activityLabels[["activityName"]])
names(Merged)
Merged$Activity 
#180 Observations
Merged[["SubjectNum"]] <- as.factor(Merged[, SubjectNum])
names(Merged) 
Merged$SubjectNum
# 30 Subjects

## I think this completes part 4, but I really don't ;know what the hell to re-name
## these variables to make them more descriptive, but activities are intelligible.
## So I will melt and recast the data to make the final Tidy Dataset
## from the merged dataset.
## Using reshape is new for me, a little hard to get. 

Merged <- reshape2::melt(data = Merged, id = c("SubjectNum", "Activity"))
Merged <- reshape2::dcast(data = Merged, SubjectNum + Activity ~ variable, fun.aggregate = mean)
View(Merged)
data.table::fwrite(x = Merged, file = "SamsungTidyDataSet.csv", quote = FALSE)  # I like CSV
write.table(x= Merged, file= "SamsungTidyDataSet.txt", sep="\t", row.names = FALSE) # but we're to make a text

## I inspected the CSV and TXT and my it looks "tidy".

### CREATING A CODE BOOK
colnames(Merged)
## Looks ok.. I think

