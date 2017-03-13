setwd("C:/Users/Trent/Desktop/Data Science Specialization/Course 3 - Get_Clean/data")

#Load in the 561 features
setwd("UCI HAR Dataset")
ftrs <- read.table("features.txt", sep = " ") #column 2 for list of features

#Load in the activity labels
act.lab <- read.table("activity_labels.txt", sep = " ") #column 2 for labels, c1 to link

#Load in test and train data 
setwd("test")
test.df <- read.table("X_test.txt")
test.activity <- read.table("y_test.txt")
test.activity <- merge(test.activity, act.lab, by.x = "V1", by.y = "V1")
sub.test <- read.table("subject_test.txt")
#add the "Subject" and "Activity Columns to test.df
test.df$Subject <- sub.test$V1
test.df$Activity <- test.activity$V2

setwd("../train")
train.df <- read.table("X_train.txt")
sub.train <- read.table("subject_train.txt")
train.activity <- read.table("y_train.txt")
train.activity <- merge(train.activity, act.lab, by.x = "V1", by.y = "V1")
#add "Subject" and "Activity" columns to train.df
train.df$Subject <- sub.train$V1
train.df$Activity <- train.activity$V2

#Combine the train / test data and add column names
all.data <- rbind(test.df, train.df)
colnames(all.data) <- c(as.character(ftrs$V2), "Subject", "Activity")

#Extract only mean and std measurements
ind <- c(sort(c(grep(".*mean", names(all.data), ignore.case=T), grep(".*std()", names(all.data)))), 562,563)
final.tidy <- all.data[,ind]

#From the data set created above, creates a second, independent tidy data set with the average of each 
#variable for each activity and each subject.
library(dplyr)
data_submit <- final.tidy %>% group_by(Activity, Subject) %>% summarize_all(funs(mean))

write.table(data_submit, "final_data.txt", row.names=F)
#write.csv(data_submit, "final_data.csv", row.names=F) #to view the .csv file if necessary
