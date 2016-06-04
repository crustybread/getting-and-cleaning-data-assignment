library(dplyr)
library(plyr)
library(tidyr)
library(data.table)

rm(list=ls())


#function to parse train and test data

proc <- function(a) {

  #preprocessing for feature dataset
  dx <- read.table("./data/UCI_HAR_Dataset/features.txt", header = F, stringsAsFactors = FALSE); dx <- dx$V2
  d <- read.table(paste("./data/UCI_HAR_Dataset/", a, "/x_", a, ".txt", sep = ""), header = F, stringsAsFactors = FALSE)
  
  #preparing passed argument ("test" or "train") for reading files
  s <- "subject_"
  y <- "y_"
  x <- "x_"
  
  o <- paste("./data/UCI_HAR_Dataset/", a, "/", sep = "")
  t <- paste(o, "/inertial_signals/", sep = "")
  
  #create list of factor and inertial signal variables

  isf <- list.files(t)
  isv <- gsub(paste(a, ".txt", sep = ""),"",isf)
  isv <- as.character(gsub("_","",isv))
  isv1 <<- isv
  
  k <- data.frame(1)
  
  for (i in 1:128) {
    g <- lapply(isv, function(x) paste(x,i,sep = ""))
    g <- as.character(unlist(g))
    k <- cbind(k,g)
  }

  k <- as.matrix(k)
  k1 <- as.character(unlist(k[1,])); k1 <- k1[-1]
  k2 <- as.character(unlist(k[2,])); k2 <- k2[-1]
  k3 <- as.character(unlist(k[3,])); k3 <- k3[-1]
  k4 <- as.character(unlist(k[4,])); k4 <- k4[-1]
  k5 <- as.character(unlist(k[5,])); k5 <- k5[-1]
  k6 <- as.character(unlist(k[6,])); k6 <- k6[-1]
  k7 <- as.character(unlist(k[7,])); k7 <- k7[-1]
  k8 <- as.character(unlist(k[8,])); k8 <- k8[-1]
  k9 <- as.character(unlist(k[9,])); k9 <- k9[-1]
  #f <- c("subject", "activity")
  
  k <- c(k1,k2,k3,k4,k5,k6,k7,k8,k9)
  k1 <<- k
  
  #reading subject list
  p <- paste(o, s, a, ".txt", sep = "")
  p <- read.table(p, header = F, stringsAsFactors = FALSE)
  p <<- as.vector(unlist(p))
  
  #reading activity cross-reference table
  b <- "./data/UCI_HAR_Dataset/activity_labels.txt"
  b <- read.table(b, header = F) 
  
  #reading activity list 
  q <- paste(o, y, a, ".txt", sep = "")
  q <- read.table(q, header = F, stringsAsFactors = FALSE)
  q <- match(q$V1,b$V1)
  q <- b[q,]
  q <- tolower(q$V2)
  q1 <<- data.frame(q)
  
  m <- data.frame(1); m <- select(m, -1)
  
  #reading inertial signal data files, by type
  for (i in 1:9) {
    u <- as.character(isf[i])
    v <- paste(t,u, sep = "")
    v <- read.table(v, header = F, stringsAsFactors = FALSE)
    m <- cbind(m,v)
  }
  
  #assigning column headers to data and re-ordering
  names(m) <- k
  m[,"subject"] <- p 
  m[,"activity"] <- q
  
  refcols <- c("subject","activity")
  m <- m[, c(refcols, setdiff(names(m), refcols))]
  m <<- data.frame(m)
  
  names(d) <- dx
  d[,"subject"] <- p 
  d[,"activity"] <- q
  
  refcols <- c("subject","activity")
  d <- d[, c(refcols, setdiff(names(d), refcols))]
  d <<- data.frame(d)
}

#initiating function and combining final datasets

proc("train")
d1 <- m; d3 <- d

proc("test")
d2 <- m; d4 <- d

data <- rbind(d1,d2)  #observational values
data1 <- rbind(d3,d4)  #calculated features


#NB: I could have combined the observational and feature datasets into one giant dataset, but I don't think that's "tidy"




#perform mean and sd calculation of all 128 measurements, by inertial signal types, for all 10299 records in the dataset  

cdata <- select(data, -subject, -activity)
cd1 <- data.frame(1, stringsAsFactors = F); cd1 <- select(cd1, -1)
cd2 <- data.frame(1, stringsAsFactors = F); cd2 <- select(cd2, -1)
cd3 <- data.frame(1, stringsAsFactors = F); cd3 <- select(cd3, -1)

for (z in 1:9) {
  z <- isv1[z]
  z1 <- paste("^", z, sep = "")
  dms <- grep(z1, names(cdata))
  dmsmin <- dms[1]
  dmsmax <- dms[128]
  cdatanew <- subset(cdata, select = dmsmin:dmsmax)
  cdm <- rowMeans(cdatanew); cdm <- mean(cdm)
  csm <- apply(cdatanew,1,sd); csm <- sd(csm)
  z <- as.data.frame(z)
  cd1 <- rbind(cd1,z)
  cd2 <- rbind(cd2,cdm)
  cd3 <- rbind(cd3,csm)
  result <- cbind(cd1,cd2,cd3)
  names(result) <- c("Inertial Signal Type","Mean","Stdev")
}

print(result)





#average of each variable for each activity/subject (uploaded "tidy" dataset)

groupColumns <- c("subject", "activity")
dataColumns <- k1
mn2 = ddply(data, groupColumns, function(x) colMeans(x[dataColumns]))
head(mn2,10)
write.table(mn2, "assign.txt", row.names = F)

