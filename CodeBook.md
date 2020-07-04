Course Project
================
ED
7/2/2020

This code book describes the source of the data, variables and
transformations done to create a tidy data set. The project represents
the final assignment for the Getting and Cleaning Data course by John
Hopkins University in Coursera.

### Data

The data used for this project was obtained from the following site:
<https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip>

The data comes from the experiment of Human Activity Recognition Ver 1.0
published in 2012 by Smartlab, which represents data collected and
derived from the accelerometer and gyroscope of smartophone Samsung
Galaxy S II. The ‘UCI HAR Dataset/README.txt’ file within ‘Dataset.zip’
provides the full description of the raw data set and included files
structure.

### Variables

The raw data includes 561 of combined time and frequency domain
variables from the accelerometer and gyroscope 3-axial raw signals. The
full description of such variables are explained in ‘UCI HAR
Dataset/features\_info.txt’.

Two additional numeric variables are provided that capture the activity
label and the subject who performed the activity for each observation in
the data set.

### Transformation

The code for the steps describes here are recorded in script
`run_analysis.R`

1.  The training (7352 obs.) and the test (2947 obs.) sets are merged to
    create one data set named ‘ds’ of dimension:

<!-- end list -->

    ## [1] 10299   561

2.  ‘ds’ variables are renamed using ‘UCI HAR Dataset/features.txt’;
    which allow to select the measurements on the mean and standard
    deviation. The new subset is saved as ‘ds1’ of dimension:

<!-- end list -->

    ## [1] 10299    88

3.  The training (7352 obs.) and test (2947 obs.) numeric labels are
    joined together maintaining the same index order as ‘ds’ in step 1.
    Subsequently, the activity legend key in ‘UCI HAR
    Dataset/activity\_labels.txt’ is used to to extract the descriptive
    activity names which are added to ‘ds1’ under variable name
    ‘activity’. The resultant unique count per activity names in ‘ds1’
    are:

| activity            | count |
| :------------------ | ----: |
| LAYING              |  1944 |
| SITTING             |  1777 |
| STANDING            |  1906 |
| WALKING             |  1722 |
| WALKING\_DOWNSTAIRS |  1406 |
| WALKING\_UPSTAIRS   |  1544 |

4.  The variable names of data set ‘ds1’ are cleaned up to a more
    descriptive format, removing all special characters, replacing ^t
    and ^f with “time” and “frequency”; and finally converting all upper
    to lower case.  
    i. `names(ds1[1]) "tBodyAcc-mean()-X"` *original*  
    ii. `names(ds1[1]) "timeBodyAccmeanX"`  
    iii. `names(ds1[1])"timebodyaccmeanx"` *final*

5.  The numeric subject data for training (7352 obs.) and test (2947
    obs.) are joined together maintaining the same index order as ‘ds’
    in step 1; and then merged with ‘ds1’. From data set ‘ds1’ a second,
    independent tidy data set ’ds2’is created which contains the average
    of each variable for each activity and each subject, which dimension
    is:

<!-- end list -->

    ## [1] 180  88

‘ds2’ with 188 variables can be difficult to visualize in the console:

``` r
head(ds2[,1:10])
```

    ##   activity subject timebodyaccmeanx timebodyaccmeany timebodyaccmeanz
    ## 1   LAYING       1        0.2215982      -0.04051395       -0.1132036
    ## 2   LAYING       2        0.2813734      -0.01815874       -0.1072456
    ## 3   LAYING       3        0.2755169      -0.01895568       -0.1013005
    ## 4   LAYING       4        0.2635592      -0.01500318       -0.1106882
    ## 5   LAYING       5        0.2783343      -0.01830421       -0.1079376
    ## 6   LAYING       6        0.2486565      -0.01025292       -0.1331196
    ##   timegravityaccmeanx timegravityaccmeany timegravityaccmeanz
    ## 1          -0.2488818           0.7055498           0.4458177
    ## 2          -0.5097542           0.7525366           0.6468349
    ## 3          -0.2417585           0.8370321           0.4887032
    ## 4          -0.4206647           0.9151651           0.3415313
    ## 5          -0.4834706           0.9548903           0.2636447
    ## 6          -0.4767099           0.9565938           0.1758677
    ##   timebodyaccjerkmeanx timebodyaccjerkmeany
    ## 1           0.08108653          0.003838204
    ## 2           0.08259725          0.012254788
    ## 3           0.07698111          0.013804101
    ## 4           0.09344942          0.006933132
    ## 5           0.08481648          0.007474608
    ## 6           0.09634820         -0.001145292

hence a vertical version of ‘ds2’ is also offered ‘ds2ver’:

    ##   activity subject         variable   average
    ## 1   LAYING       1 timebodyaccmeanx 0.2215982
    ## 2   LAYING       2 timebodyaccmeanx 0.2813734
    ## 3   LAYING       3 timebodyaccmeanx 0.2755169
    ## 4   LAYING       4 timebodyaccmeanx 0.2635592
    ## 5   LAYING       5 timebodyaccmeanx 0.2783343
    ## 6   LAYING       6 timebodyaccmeanx 0.2486565
