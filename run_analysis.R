## Script

##### PART 1 #####

## Change to a temporary directory
setwd(Sys.getenv("TEMP"))

## Data url
url <- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

## Use local user temp file
destfile <- paste0(Sys.getenv("TEMP"),"\\projectdata.zip")

## Download and unzip
download.file(url, destfile)
unzip(destfile)

## Change workdir to local temp dir
setwd(paste0(Sys.getenv("TEMP"),"\\UCI HAR Dataset"))


## Read "features" names
features <- read.table("./features.txt",as.is=TRUE)

## Read "train" files
X_train <- read.table("./train/X_train.txt")
subject_train <- read.table("./train/subject_train.txt")
y_train <- read.table("./train/y_train.txt")

# Column bind files
train <- cbind(X_train,subject_train,y_train)

# Attribute names to columns
names(train) <- c(features$V2,"Subject","Activity")

# Check
#head(train)

## Repeat on "test" dataset
X_test <- read.table("./test/X_test.txt")
subject_test <- read.table("./test/subject_test.txt")
y_test <- read.table("test/y_test.txt")

# Column bind  and attribute names to "test"
test <- cbind(X_test,subject_test,y_test)
names(test) <- c(features$V2,"Subject","Activity")

# Check "test"
#head(test)

## Merging datasets 
all <- rbind(train,test)

#Check
#head(all)
#tail(all)
#dim(all)

#####  PART 2 #####

## Select column with mean and std

filter <- grep("mean|std",names(all))
filter <- c(filter,562,563) # selected columns + Subject and Activity
all2 <- all[,filter]

##### PART 3 #####

## Read the "activity_labels" file
activity_labels <- read.table("./activity_labels.txt",as.is=TRUE)
all2$Activity <- factor(all2$Activity,labels = activity_labels$V2)

## Rename activities
all2$Activity <- gsub("_","",tolower(all2$Activity))

##### PART 4  #####

## Label the dataset
names(all2) <- gsub("\\(|\\)|-|,","",tolower(names(all2)))

##### PART 5 #####

## Use packages reshape2 and plyr
library(reshape2)
library(plyr)

tmp <- melt(all2, id=c("subject","activity") ,na.rm=TRUE)
resp <- ddply(tmp,.(subject,activity,variable),summarize,media=mean(value,na.rm=T))

resp2 <- dcast(resp,paste(subject,activity,sep="-") ~ variable)
id <- sapply(strsplit(resp2[,1],"-"),"[",1)
act <- sapply(strsplit(resp2[,1],"-"),"[",2)

resp3 <- cbind(subject=id,activity=act,resp2[,-1])

## Write txt file
filename <- paste0(Sys.getenv("USERPROFILE"),"\\Desktop\\","final.txt")
write.table(resp3,file=filename,row.names=FALSE)


