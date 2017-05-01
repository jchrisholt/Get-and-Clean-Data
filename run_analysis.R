## run_analysis.R script 
## Produced by JChris Holt on 4/12/2017 
## "Getting and Cleaning Data Course Project"
#
## Load needed packages
library(dplyr)
#
## set working directory
setwd("/Users/JCH/Documents/DataScience/UCI HAR Dataset")
#
## Define variable names for text data files
X_test_file <- "test/X_test.txt"
y_yest_file <- "test/y_test.txt"
X_train_file <- "train/X_train.txt"
y_train_file <- "train/y_train.txt"

# read in the data sets
# if(!file.exists())

# create dataframes from the data provided  
X_test <- read.table("test/X_test.txt", header = FALSE)
y_test <- read.table("test/y_test.txt", header = FALSE)
subject_test <- read.table("test/subject_test.txt", header = FALSE)

X_train <- read.table("train/X_train.txt", header = FALSE)
y_train <- read.table("train/y_train.txt", header = FALSE)
subject_train <- read.table("train/subject_train.txt", header = FALSE)

activity_labels <- read.table("activity_labels.txt", header = FALSE)
features <- read.table("features.txt", header = FALSE)

# Set data column names
# The features text file vector becomes the column names
# Remove the () from the features names to prevent errors
#
features[,2] = gsub('[-()]', '', features[,2])
features[,2] = gsub('mean','Mean', features[,2])
features[,2] = gsub(',', '_', features[,2])
cols_needed <- grep(".*[Mm]ean*.|.*std*.", features[,2])
features <- features[cols_needed,]
features_vect <- features[,2]

#
#colnames(X_test) <- features$V2
colnames(y_test) <- "activity"
colnames(subject_test) <- "subject"
#
#colnames(X_train) <- features$V2
colnames(y_train) <- "activity"
colnames(subject_train) <- "subject"

## Select only the columns needed
X_test_cn <- X_test[,cols_needed]
X_train_cn <- X_train[,cols_needed]

## Name the columns appropriately
colnames(X_test_cn) <- features_vect
colnames(X_train_cn) <- features_vect

## combine the activity with the test data
test_xy <- cbind(y_test,X_test_cn)
train_xy <- cbind(y_train,X_train_cn)

## combine the subject with the test data
test_df <- cbind(subject_test, test_xy)
train_df <- cbind(subject_train, train_xy)

## combine the rows of training and test into one large data set
test_train_df <- rbind(test_df,train_df)

## Convert ativity ids to meaningful labels
test_train_df2 <- test_train_df
test_train_df2$activity <- activity_labels$V2[match(test_train_df2$activity, activity_labels$V1)]

## calculate the mean for each activity/group combination
results <- aggregate(test_train_df2[, 3:88], list(test_train_df2$subject, test_train_df2$activity),mean)
colnames(results)[1:2] <- c("subject","activity")

write.table(results, "TidyDataSet.txt", quote = FALSE, row.name=FALSE)
