# download the file 
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
zipfile<-"UCI HAR Dataset.zip"
if (!file.exists(zipfile)) {
        download.file(fileUrl, zipfile ,mode ="wb")
}

# unzip file
data<- "UCI HAR Dataset"
if (!file.exists(data)) {
        unzip(zipfile)
}

# read data


 # read training data

trainingSubjects <- read.table(file.path(data, "train", "subject_train.txt"))
trainingFeatures <- read.table(file.path(data, "train", "X_train.txt"))
trainingActivity <- read.table(file.path(data, "train", "y_train.txt"))

 # read test data

testSubjects <- read.table(file.path(data, "test", "subject_test.txt"))
testFeatures <- read.table(file.path(data, "test", "X_test.txt"))
testActivity <- read.table(file.path(data, "test", "y_test.txt"))


# 1) merge the training and the test sets to create 1 dataset

subject <- rbind(trainingSubjects, testSubjects)
activity<- rbind(trainingActivity, testActivity)
features<- rbind(trainingFeatures, testFeatures)

names(subject)<-c("subject")
names(activity)<- c("activity")
dataFeaturesNames <- read.table(file.path(data, "features.txt"),head=FALSE)
names(features)<- dataFeaturesNames$V2

dataCombine <- cbind(subject, activity)
completeData <- cbind(features, dataCombine)


# 2) extract the mean and standard deviation for each measurement

columns <- grepl("subject|activity|mean|std", colnames(completeData))

completeData<-completeData[,columns]

# 3) use descriptive activity names to name the activities in the data set

activities <- read.table(file.path(data, "activity_labels.txt") , header = FALSE)

completeData$activity <- factor(completeData$activity, 
                                 levels = activities[, 1], labels = activities[, 2])

# 4) appropriately label the data set with descriptive variable names


names(completeData)<-gsub("^t", "time", names(completeData))
names(completeData)<-gsub("^f", "frequency", names(completeData))
names(completeData)<-gsub("Acc", "Accelerometer", names(completeData))
names(completeData)<-gsub("Gyro", "Gyroscope", names(completeData))
names(completeData)<-gsub("Mag", "Magnitude", names(completeData))
names(completeData)<-gsub("BodyBody", "Body", names(completeData))

# second, independent tudy data set

library(plyr);
Data2<-aggregate(. ~subject + activity, completeData, mean)
Data2<-Data2[order(Data2$subject,Data2$activity),]
write.table(Data2, file = "tidydata.txt",row.name=FALSE)
;

