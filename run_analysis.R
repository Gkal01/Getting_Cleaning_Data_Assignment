library("dplyr")

filename <- "Q4_Assignment.zip"

if (!file.exists(filename)){
      url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
      download.file(url, destfile = filename)
}

#Checking if folder exists
if (!file.exists("UCI HAR Dataset")){
      unzip(filename)
}

#Assigning proper names to each file/data frame
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n", "functions"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/Y_test.txt", col.names = "code")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/Y_train.txt", col.names = "code")


#Merge the two data sets
x_merged <- rbind(x_test, x_train)
y_merged <- rbind(y_test, y_train)
subject_merged <- rbind(subject_test, subject_train)
FUll_merged <- cbind(subject_merged, y_merged, x_merged)

#Extracting only measurements of the mean and std
tidy_df <- select(FUll_merged, subject, code, contains("mean"), contains("std"))


#Adjusting the activiry names in the tidy_df
tidy_df$code <- activities[tidy_df$code, 2]

#Adjusting the variable names in the tidy_df
names(tidy_df)[2] <- "Activity"
names(tidy_df) <- gsub("^t", "Time_", names(tidy_df))
names(tidy_df) <- gsub("^f", "Frequency_", names(tidy_df))
names(tidy_df) <- gsub("Gravity", "Gravity_", names(tidy_df), ignore.case = TRUE)
names(tidy_df) <- gsub("Body", "Body_", names(tidy_df))
names(tidy_df) <- gsub("Acc", "Accelerometer_", names(tidy_df))
names(tidy_df) <- gsub("Gyro", "Gyroscope_", names(tidy_df))
names(tidy_df) <- gsub("angle.", "Angle_", names(tidy_df))
names(tidy_df) <- gsub("Body_Body_", "Body_", names(tidy_df))
names(tidy_df) <- gsub("mag", "Magnitude_", names(tidy_df), ignore.case = TRUE)
names(tidy_df) <- gsub(".mean", "Mean", names(tidy_df))
names(tidy_df) <- gsub(".std", "STD", names(tidy_df))
names(tidy_df) <- gsub("tBody", "Time_Body", names(tidy_df))

#New Data set containing the average of each variable for each subject and each activity
new_df <- tidy_df %>% group_by(subject, Activity) %>% summarise_all(mean)

write.table(new_df, "FinalDF.txt", row.name=FALSE)
