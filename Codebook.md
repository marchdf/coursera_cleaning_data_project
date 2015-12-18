Codebook
========
Codebook was generated on 2015-12-18 16:15:50 at the same time as the data set generation.

Description of variables
------------------------

Variable name    | Description
-----------------|------------
subject          | ID the subject who performed the activity for each window sample (1 to 30)
activity         | Name of the activity
domain       	 | Feature: time domain signal or frequency domain signal (Time or Frequency)
instrument   	 | Feature: measuring instrument used to measure (Accelerometer or Gyroscope)
acceleration 	 | Feature: signal for the acceleration (Body or Gravity)
variable     	 | Feature: variable (Mean or Std)
jerk         	 | Feature: jerk signal (Jerk or NA)
magnitude    	 | Feature: magnitude of the signals calculated using the Euclidean norm (Magnitude or NA)
axis         	 | Feature: 3-axial signals in the X, Y and Z directions (X, Y, Z, or NA)
mean        	 | Average of each variable for each activity and each subject



Additional information
----------------------

* Dataset structure


```r
str(tidydf)
```

```
## Classes 'grouped_df', 'tbl_df', 'tbl' and 'data.frame':	6120 obs. of  10 variables:
##  $ subject     : int  1 1 1 1 1 1 1 1 1 1 ...
##  $ activity    : Factor w/ 6 levels "LAYING","SITTING",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ domain      : chr  "Frequency" "Frequency" "Frequency" "Frequency" ...
##  $ acceleration: chr  "Body" "Body" "Body" "Body" ...
##  $ instrument  : chr  "Accelerometer" "Accelerometer" "Accelerometer" "Accelerometer" ...
##  $ jerk        : chr  "Jerk" "Jerk" "Jerk" "Jerk" ...
##  $ magnitude   : chr  "Magnitude" "Magnitude" NA NA ...
##  $ axis        : logi  NA NA NA NA NA NA ...
##  $ variable    : chr  "Mean" "Std" "Mean" "Std" ...
##  $ mean        : num  -0.933 -0.922 -0.943 -0.952 -0.862 ...
##  - attr(*, "vars")=List of 8
##   ..$ : symbol subject
##   ..$ : symbol activity
##   ..$ : symbol domain
##   ..$ : symbol acceleration
##   ..$ : symbol instrument
##   ..$ : symbol jerk
##   ..$ : symbol magnitude
##   ..$ : symbol axis
##  - attr(*, "drop")= logi TRUE
```

* List columns in the data table


```r
names(tidydf)
```

```
##  [1] "subject"      "activity"     "domain"       "acceleration"
##  [5] "instrument"   "jerk"         "magnitude"    "axis"        
##  [9] "variable"     "mean"
```

* Show a few rows of the dataset


```r
head(tidydf)
```

```
## Source: local data frame [6 x 10]
## Groups: subject, activity, domain, acceleration, instrument, jerk, magnitude, axis [3]
## 
##   subject activity    domain acceleration    instrument  jerk magnitude
##     (int)   (fctr)     (chr)        (chr)         (chr) (chr)     (chr)
## 1       1   LAYING Frequency         Body Accelerometer  Jerk Magnitude
## 2       1   LAYING Frequency         Body Accelerometer  Jerk Magnitude
## 3       1   LAYING Frequency         Body Accelerometer  Jerk        NA
## 4       1   LAYING Frequency         Body Accelerometer  Jerk        NA
## 5       1   LAYING Frequency         Body Accelerometer    NA Magnitude
## 6       1   LAYING Frequency         Body Accelerometer    NA Magnitude
## Variables not shown: axis (lgl), variable (chr), mean (dbl)
```

* Summary of variables


```r
summary(tidydf)
```

```
##     subject                   activity       domain         
##  Min.   : 1.0   LAYING            :1020   Length:6120       
##  1st Qu.: 8.0   SITTING           :1020   Class :character  
##  Median :15.5   STANDING          :1020   Mode  :character  
##  Mean   :15.5   WALKING           :1020                     
##  3rd Qu.:23.0   WALKING_DOWNSTAIRS:1020                     
##  Max.   :30.0   WALKING_UPSTAIRS  :1020                     
##  acceleration        instrument            jerk          
##  Length:6120        Length:6120        Length:6120       
##  Class :character   Class :character   Class :character  
##  Mode  :character   Mode  :character   Mode  :character  
##                                                          
##                                                          
##                                                          
##   magnitude           axis           variable              mean        
##  Length:6120        Mode:logical   Length:6120        Min.   :-0.9977  
##  Class :character   NA's:6120      Class :character   1st Qu.:-0.9632  
##  Mode  :character                  Mode  :character   Median :-0.5313  
##                                                       Mean   :-0.5323  
##                                                       3rd Qu.:-0.1302  
##                                                       Max.   : 0.6446
```

