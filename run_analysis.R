# Data is assumed to be in a folder called "UCI HAR Dataset" in the working directory.
# Load dplyr
library("dplyr")

#Load names of features and activity labels
features <- read.table("UCI HAR Dataset/features.txt", stringsAsFactors = FALSE)$V2
activity.labels <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("labels","activity"), stringsAsFactors = FALSE)

# Read in training observations, labels and subject dataset and add variable names.
train.obs <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features)
train.labels <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "labels")
train.subject <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")

# Read in test observations, labels and subject dataset and add variable names.
test.obs <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features)
test.labels <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "labels")
test.subject <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")

# Combine observations, labels and subject and merge training and test datasets
train <- bind_cols(train.labels, train.subject, train.obs)
test <- bind_cols(test.labels, test.subject, test.obs)
combined <- bind_rows(train, test)

#Select columns containing mean and standard deviation and add activity names
total.data <- combined %>%
    left_join(activity.labels, by = "labels") %>%
    select(subject, activity, contains("mean"), contains("std"))

# Remove intermediate vaules from memory
rm(train.obs, train.labels, train.subject, test.obs, test.labels, test.subject, train, test, combined, activity.labels)    

#Create tidy dataset with the average of each variable for each activity and each subject
tidy.data <- total.data %>%
    group_by(subject, activity) %>%
    summarise_all(mean)

# Write tidy data to file
write.table(tidy.data, file = "tidy_data.txt", row.names = FALSE)