run_analysis <- function(){

    library(plyr)
    
    ## Setup variables
    datadir <- "UCI_HAR_Dataset/"

    ## load the feature names
    features <- read.table(paste0(datadir,"features.txt"),col.names=c("index","name"))
    activities <- read.table(paste0(datadir,"activity_labels.txt"),col.names=c("index","name"))
    
    ## load the data and name the columns as we load them up
    x_test <- read.table(paste0(datadir,"test/X_test.txt"),col.names=features$name)
    y_test <- read.table(paste0(datadir,"test/y_test.txt"),col.names="activity")
    subject_test <- read.table(paste0(datadir,"test/subject_test.txt"),col.names="subject")
    x_train <- read.table(paste0(datadir,"train/X_train.txt"),col.names=features$name)
    y_train <- read.table(paste0(datadir,"train/y_train.txt"),col.names="activity")
    subject_train <- read.table(paste0(datadir,"train/subject_train.txt"),col.names="subject")
    
    ## Merge the data so that it now looks like:
    ## s | y | 
    ## t | t | 
    ## e | e | xtest 
    ## s | s |  
    ## t | t | 
    ##   |   |  
    ## s | y | 
    ## t | t | 
    ## r | r | xtrain
    ## a | a | 
    ## i | i | 
    ## n | n |  
    df <- rbind(cbind(subject_test,y_test,x_test),cbind(subject_train,y_train,x_train))


    ## Rename the activities indices to their full name
    df$activity <- mapvalues(df$activity,from=activities$index,to=as.character(activities$name))


}
