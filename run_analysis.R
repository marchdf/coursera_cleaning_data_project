run_analysis <- function(){

    ## Load libraries
    library(dplyr)
    library(tidyr)
    
    ## Setup variables
    datadir <- "UCI_HAR_Dataset/"

    ## load the feature and activity names
    features <- read.table(paste0(datadir,"features.txt"),col.names=c("index","name"))
    activities <- read.table(paste0(datadir,"activity_labels.txt"),col.names=c("activity_index","activity"))

    ## load the data and name the columns as we load them up
    x_test <- read.table(paste0(datadir,"test/X_test.txt"), nrows = 100)
    y_test <- read.table(paste0(datadir,"test/y_test.txt"),col.names="activity_index", nrows = 100)
    subject_test <- read.table(paste0(datadir,"test/subject_test.txt"),col.names="subject", nrows = 100)
    x_train <- read.table(paste0(datadir,"train/X_train.txt"), nrows = 100)
    y_train <- read.table(paste0(datadir,"train/y_train.txt"),col.names="activity_index", nrows = 100)
    subject_train <- read.table(paste0(datadir,"train/subject_train.txt"),col.names="subject", nrows = 100)
    
    ## Before merging the data, let's extract only the measurements on
    ## the mean and std for each measurement (i.e. get only the
    ## columns that have the word mean or std in the name)
    idx <- grepl("mean\\(\\)|std\\(\\)",features$name)
    x_test <- x_test[,idx]
    x_train <- x_train[,idx]
    features <- features[idx,]

    ## Format the features data table for easier manipulation later
    fnames <- as.character(features$name)
    fnames <- sub("^t","Time",fnames)
    fnames <- sub("^f","Frequency",fnames)
    fnames <- sub("Acc","Accelerometer",fnames)
    fnames <- sub("Gyro","Gyroscope",fnames)
    fnames <- sub("Mag","Magnitude",fnames)
    fnames <- sub("-mean\\(\\)","Mean",fnames)
    fnames <- sub("-std\\(\\)","Std",fnames)
    fnames <- sub("-","",fnames)

    ## store the formatted names back to features
    features$name <- fnames
    
    ## Using these names, make new columns based on the different
    ## features of the test
    features <- features %>%
        ## Get the domain (Time or Frequency)
        mutate(domain=ifelse(grepl("Time",name),yes="Time",no="Frequency")) %>%
        ## Get the acceleration type (Body, Gravity, or NA)
        mutate(acceleration=ifelse(grepl("Body",name),yes="Body",no=ifelse(grepl("Gravity",name),yes="Gravity",no=NA))) %>%
        ## Get the instrument (Accelerometer or Gyroscope)
        mutate(instrument=ifelse(grepl("Accelerometer",name),yes="Accelerometer",no="Gyroscope")) %>%
        ## Get the jerk (Jerk or NA)
        mutate(jerk=ifelse(grepl("Jerk",name),yes="Jerk",no=NA)) %>%
        ## Get the magnitude (Magnitude or NA)
        mutate(magnitude=ifelse(grepl("Magnitude",name),yes="Magnitude",no=NA)) %>%
        ## Get the type of variable (Mean or Std)
        mutate(variable=ifelse(grepl("Mean",name),yes="Mean",no="Std")) %>%
        ## Get the axis (X, Y, Z, or NA)
        mutate(axis=ifelse(grepl("-X",name),yes="X",no=ifelse(grepl("-Y",name),yes="Y",no=ifelse(grepl("-Z",name),yes="Z",no=NA)))) %>%
        ## Remove the formatted names    
        select(-name)
    

    
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

    ## Next we gather the measurements columns (exclude subject and activity)
    df <- df %>% gather(index,value,-subject,-activity_index)

    ## Next we rename the measurements to something more meaningful
    ## based on the features files which matches indices with the
    ## feature names
    df <- df %>%
        mutate(index = extract_numeric(index)) %>%
        ## match measurement indices with names
        left_join(features) %>%
        ## remove the index column
        select(-index)
    df <- droplevels(df) ## remove unused levels (to clean a bit)

    ## Order by increasing subject id
    df <- df %>%
        arrange(subject,activity_index)
    
    ## Rename the activities indices to their full name
    df <- df %>%
        left_join(activities) %>%
        ## remove the index column
        select(-activity_index)

    ## rearrange the order of the data frame
    df <- df[c("subject","activity","domain","acceleration","instrument","jerk","magnitude","variable","axis","value")]

    ## Write out the solution

}
