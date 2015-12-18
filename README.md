Getting and Cleaning Data Course Project
========================================
Author: Marc T. Henry de Frahan

Project description
-------------------

> The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.

> One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

> http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

> Here are the data for the project:

> https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

> You should create one R script called run_analysis.R that does the following.
> Merges the training and the test sets to create one data set.
> Extracts only the measurements on the mean and standard deviation for each measurement.
> Uses descriptive activity names to name the activities in the data set
> Appropriately labels the data set with descriptive variable names.
> From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

> Good luck!


Generating the final result
-------------------------------

* Run the R script `run_analysis.R` in a folder containing the UCI_HAR_Dataset folder (which contains the data)


Output
----------------
* Tidy dataset file `SummaryHumanSmartphoneData.txt` (tab-delimited text)

Code description
----------------

1) Load the required libraries `tidyr` and `dplyr`
```r
    library(dplyr)
    library(tidyr)
    library(knitr)
```

2) Set data directory and load the files
```r
    ## Setup variables
    datadir <- "UCI_HAR_Dataset/"

    ## load the feature and activity names
    features <- read.table(paste0(datadir,"features.txt"),col.names=c("index","name"))
    activities <- read.table(paste0(datadir,"activity_labels.txt"),col.names=c("activity_index","activity"))

    ## load the data and name the columns as we load them up
    x_test <- read.table(paste0(datadir,"test/X_test.txt"))
    y_test <- read.table(paste0(datadir,"test/y_test.txt"),col.names="activity_index")
    subject_test <- read.table(paste0(datadir,"test/subject_test.txt"),col.names="subject")
    x_train <- read.table(paste0(datadir,"train/X_train.txt"))
    y_train <- read.table(paste0(datadir,"train/y_train.txt"),col.names="activity_index")
    subject_train <- read.table(paste0(datadir,"train/subject_train.txt"),col.names="subject")
```

3) Extract the mean and std for each measurement
```r
    idx <- grepl("mean\\(\\)|std\\(\\)",features$name)
    x_test <- x_test[,idx]
    x_train <- x_train[,idx]
    features <- features[idx,]
```

4) Format the features data table for easier manipulation later
```r
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
```

5) Merge the data so that it now looks like:
```r
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
```

6) Next we gather the measurements columns (exclude subject and activity)
```r
    df <- df %>% gather(index,value,-subject,-activity_index)
```

7) Next we rename the measurements to something more meaningful based on the features files which matches indices with the feature names
```r
    df <- df %>%
            mutate(index = extract_numeric(index)) %>%
            ## match measurement indices with names
            left_join(features) %>%
            ## remove the index column
            select(-index)
    df <- droplevels(df) ## remove unused levels (to clean a bit)
```

8) Order by increasing subject id
```r
    df <- df %>%
          arrange(subject,activity_index)
```

9) Rename the activities indices to their full name
```r
    df <- df %>%
            left_join(activities) %>%
            ## remove the index column
            select(-activity_index)
```

10) Rearrange the order of the data frame
```r
    df <- df[c("subject","activity","domain","acceleration","instrument","jerk","magnitude","axis","variable","value")]
```

11) Create a data set with the average of each variable for each activity and each subject.
```r
    tidydf <- df %>%
            group_by(subject,activity,domain,acceleration,instrument,jerk,magnitude,axis,variable) %>%
            summarize(mean=mean(value))
```

12) Write out the solution to a file
```r
    ofname="SummaryHumanSmartphoneData.txt"
    write.table(tidydf,ofname,row.names=FALSE,quote=FALSE,sep="\t")
```