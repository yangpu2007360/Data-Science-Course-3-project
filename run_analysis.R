library(reshape2)

## read X, y and subject data for both train and test datasets
xtrain <- read.table("c3data//UCI HAR Dataset/train/X_train.txt")
xtest <- read.table("c3data//UCI HAR Dataset/test/X_test.txt")
ytrain <- read.table("c3data//UCI HAR Dataset/train/y_train.txt")
ytest <- read.table("c3data//UCI HAR Dataset/test/y_test.txt")
subjecttrain <- read.table("c3data//UCI HAR Dataset/train/subject_train.txt")
subjecttest <- read.table("c3data//UCI HAR Dataset/test/subject_test.txt")

## merge X, y and subject data for both train and test datasets, and remove the seperated data
x <- rbind(xtrain, xtest)

rm(xtrain, xtest)

y <- rbind(ytrain, ytest)

rm(ytrain, ytest)

subject <- rbind(subjecttrain, subjecttest)

rm(subjecttrain, subjecttest)
## read in features descriptions
features <- read.table("c3data//UCI HAR Dataset/features.txt")[,"V2"]

## set descriptive names for all columns in merged X, y and subject data
colnames(x) <- features
colnames(y) <- "activity_id"
colnames(subject) <- "subject"

## select features containing measurements on the mean and standard deviation
means <- grep("-mean\\(\\)", features, value=TRUE)
stds <- grep("-std\\(\\)", features, value=TRUE)
exfeatures <- c(means, stds)
x2 <- x[, exfeatures]

## read in activity descriptions
activities <- read.table("c3data//UCI HAR Dataset/activity_labels.txt")
colnames(activities) <- c("activity_id", "activity")

## join activity dataset with descriptive labels
y2 <- merge(y, activities)

## join measurements dataset with activity labels
data <- cbind(x2, y2["activity"])

## write first result data set to csv
write.csv(data, "measurements_mean_std.txt")

## join subject ids
data2 <- cbind(data, subject)

## summarize means per unique (activity, subject) pair 
data2melt <- melt(data2, id=c("subject", "activity"))
data3 <- dcast(data2melt, activity + subject ~ variable, mean)

## write second result data set to csv
write.csv(data3, "activity_subject_means.txt")
