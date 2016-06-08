#loading libraries
library(dplyr)
library(plyr)
library(data.table)

#clearing existing namespace variables and setting the working directory
rm(list=ls())
wd <- "k:/getting and cleaning data/data/UCI_HAR_Dataset/"
setwd(wd)

#reading features and activity_labels files
ft <- read.table("features.txt", header = F, stringsAsFactors = F); ft <- ft$V2
al <- read.table("activity_labels.txt", header = F, stringsAsFactors = F)
names(al) <- c("id","activity")
al$activity <- lapply(al$activity, function(x) tolower(x) )

#function to parse and combine train and test data
proc <- function(a) {
  
  #reading in files and assigning headers
  wd <- paste(wd,a, sep = "")
  setwd(wd)
  
  xf <- paste("x_", a, ".txt", sep = "")
  yf <- paste("y_", a, ".txt", sep = "")
  sf <- paste("subject_", a, ".txt", sep = "")
  
  xf <- read.table(xf, header = F, stringsAsFactors = F)
  yf <- read.table(yf, header = F, stringsAsFactors = F)
  sf <- read.table(sf, header = F, stringsAsFactors = F)

  names(xf) <- ft
  names(sf) <- "subject"
  names(yf) <- "id"
    
  #joining the activity label table with the activity table to swap activity IDs for activity names
  act <- join(yf, al, by = "id")
  act <- select(act, -id)
  act <- as.data.frame(lapply(act, unlist))
  
  #isolating mean and standard deviation columns
  xfms <- c(grep("mean|std", names(xf)))
  xf <- xf[,xfms]
  data <- cbind(sf,act,xf)  
}

#initiating proc function and building the final dataset, sorted by subject and activity
train <- proc("train")
test <- proc("test")
data <- rbind(train,test)
data <- arrange(data, subject, activity)

#taking the mean of each mean and standard deviation variable, grouped by subject and activity (i.e. the "tidy" dataset)
gc <- c("subject", "activity")
dc <- data[, -c(1,2)]
dc <- names(dc)
out <- ddply(data, gc, function(x) colMeans(x[dc]))
head(out,18)
write.table(out, "../main.txt", row.names = F)