## Reading the Text Files by unziping from a given URL

## Downloaded the Zip file in working direcotory if not exits
url<- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
dir<- "UCI HAR Dataset"
fileName<- paste0("./",dir)
filtype<- paste0(".","zip")

if(!file.exists(fileName)){
    download.file(url,destfile = paste0(fileName,filtype), method =  "curl") 
}

# File unzip verification. If the directory does not exist, unzip the downloaded file.
if(!file.exists(dir)){
    unzip(paste0(dir,filtype), files = NULL, exdir=".") ## or use unzip(paste0(dir,filtype))
}

## Read Data
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")     ## u can use "./" as below
X_test <- read.table("UCI HAR Dataset/test/X_test.txt")                 ## u can use "./" as below
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")                 ## u can use "./" as below

subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")  ## u can use "./" as below
X_train <- read.table("UCI HAR Dataset/train/X_train.txt")              ## u can use "./" as below
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")              ## u can use "./" as below

activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt",header=FALSE)  ## use Header = FALSE also
features <- read.table("./UCI HAR Dataset/features.txt")  


##Step -4:Uses descriptive activity names to name the activities in the data set
# add column name for label files
names(y_train) <- "activity"
names(y_test) <- "activity"

# add column name for subject files
names(subject_train) <- "Subject"
names(subject_test) <- "Subject"

# add column names for measurement files
names(X_train) <- features$V2
names(X_test) <- features$V2

## Step-1 : Merges the training and the test sets to create one data set.
# Merging the files into one dataset
train <- cbind(subject_train, y_train, X_train)
test <- cbind(subject_test, y_test, X_test)
combined <- rbind(train, test)

#Step-2: Extracts only the measurements on the mean and standard deviation for each measurement.
# Extract only the measurements on the mean and standard deviation for each measurement.
extract_features <- grepl("mean|std|Subject|activity", names(combined))


## implemneting the measurement on data set i.e removing unnecessary columns
combined <- combined[, extract_features]

#step-4: Appropriately labels the data set with descriptive variable names.
# convert the activity column from integer to factor
combined$activity <- factor(combined$activity, labels=c("WALKING","WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LAYING"))

#step-5: Creates a tidy data set with the average of each variable for each activity and each subject.
# create the tidy data set
melted <- melt(combined, id=c("Subject","activity"))
tidy <- dcast(melted, Subject+activity ~ variable, mean)


write.table(tidy,file="tidydata.txt")


