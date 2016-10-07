# Getting & Cleaning Data: CodeBook.md

## Introduction
The purpose of this `CodeBook` is to describe the variables, dataset, and any transformations that take place in the `run_analysis.R` script. 

The `CodeBook` contains five sections:

* Introduction (_You Are Here_)
* Dataset Background
* Modeling Problem
* Data Import, Prep, and Staging
* Tidy Data

## Dataset Background
The dataset file contains data split into `train` and `test` sets. There are a total of `10,299` records (tuples) across `561` features (attributes). A total of `30` subjects were used. Each subject is represented by numbers `1` through `30`, with record labels contained in either the `subject_train.txt` or `subject_test.txt` files.

_Note_: the information below is sourced from `features_info.txt` in the dataset file parent folder.

### Activities
Each record reflects datum from each feature, across `1` of `6` activity types (ordered below):

1. Walking
2. Walking Upstairs
3. Walking Downstairs
4. Sitting
5. Standing
6. Laying

### Features
There are `17` base features. Each `XYZ` represents `1` of `3` possible suffixes (one for `X`, `Y`, and `Z`):

* tBodyAcc-XYZ
* tGravityAcc-XYZ
* tBodyAccJerk-XYZ
* tBodyGyro-XYZ
* tBodyGyroJerk-XYZ
* tBodyAccMag
* tGravityAccMag
* tBodyAccJerkMag
* tBodyGyroMag
* tBodyGyroJerkMag
* fBodyAcc-XYZ
* fBodyAccJerk-XYZ
* fBodyGyro-XYZ
* fBodyAccMag
* fBodyAccJerkMag
* fBodyGyroMag
* fBodyGyroJerkMag

Each of these `17` features contains `1` of `17` suffixes:

* _mean()_: mean value
* _std()_: standard deviation
* _mad()_: median absolute deviation 
* _max()_: largest value in array
* _min()_: smallest value in array
* _sma()_: signal magnitude area
* _energy()_: energy measure. Sum of the squares divided by the number of values.
* _iqr()_: interquartile range 
* _entropy()_: signal entropy
* _arCoeff()_: autoregression coefficients with Burg order equal to 4
* _correlation()_: correlation coefficient between two signals
* _maxInds()_: index of the frequency component with largest magnitude
* _meanFreq()_: weighted average of the frequency components to obtain a mean frequency
* _skewness()_: skewness of the frequency domain signal 
* _kurtosis()_: kurtosis of the frequency domain signal 
* _bandsEnergy()_: energy of a frequency interval within the 64 bins of the FFT of each window
* _angle()_: angle between to vectors

In total, there are `10,299` records across `561` features.

## Modeling Problem
The modeling problem is to merge the `train` and `test` sets, keeping only features which contain measurements for `mean` and `standard deviation`. Additionally, each activity should include a descriptive name (in addition to numeric representation), and each feature should be appropriately labeled. 

From the resulting dataset above, create a second dataset for the average (arithmetic mean) for each of `6` activities and each of `30` subjects, for a total of `180` records.

## Data Import, Prep, and Staging
The process used to import, prep, and stage data in accordance with the first part of the modeling problem is described below. 

Objects loaded to `R` are stored using a standard naming convention. _For example_: each object starts with `gcd` for "Getting and Cleaning Data", followed by either `trn` to represent the `train` dataset, or `tst` for the test dataset.

1. If the dataset file already exists in the user's home directory, nothing is done; else the file is downloaded.
2. Feature names are loaded (`561`) from `features.txt` and stored as an object named `gcd.cn`.
3. Feature names are corrected using regular expressions:
    i. All parentheses at the end of feature names are removed.
    ii. Any dashes or commas within the feature names are replaced with underscores.
    iii. Any parentheses pairs within the feature names are removed.
    iv. Any remaining open parentheses are replaced with underscores.
    v. Any remaining closing parentheses are removed (feature `556`).
4. Activity names are loaded (`6`) from `activity_labels.txt` and stored as an object named `gcd.act`.
5. The `train` dataset is loaded:
    i. Raw data are loaded from `X_train.txt` and stored as an object named `gcd.trn.raw`.
    ii. Subject labels are loaded from `subject_train.txt` and stored as an object named `gcd.trn.sub`. 
    iii. Activity labels are loaded from `y_train.txt` and stored as an object named `gcd.trn.act`.
    iv. The three objects above are merged and stored as an object named `gcd.trn`.
    v. To tidy the workspace, the three objects are removed from the global environment.
6. The `test` dataset is loaded:
    i. Raw data are loaded from `X_test.txt` and stored as an object named `gcd.tst.raw`.
    ii. Subject labels are loaded from `subject_test.txt` and stored as an object named `gcd.tst.sub`. 
    iii. Activity labels are loaded from `y_test.txt` and stored as an object named `gcd.tst.act`.
    iv. The three objects above are merged and stored as an object named `gcd.tst`.
    v. To tidy the workspace, the three objects are removed from the global environment.
7. Before `gcd.trn` and `gcd.tst` are combined, a logical check is done to verify column names are identical in name and order.
8. Both `gcd.trn` and `gcd.tst` are merged, stored as an object named `gcd.comb`, then removed from the global environment.
9. In accordance with the modeling problem, a regular expression is used to create an object named `gcd.cn.keep` which contains a list of all variables which contain either `mean`, `std`, `subject_lab`, or `activity_lab`.
10. The `gcd.comb` dataset is trimmed to only contain the columns from `gcd.cn.keep`.
11. A new feature, `activity_name`, is created in `gcd.comb` which contains the descriptive activity labels.
12. Any remaining objects (other than `gcd.comb`) are removed from the global environment.

This satisfies the first part of the modeling problem.

## Tidy Data
The second part of the modeling problem is to create a separate and distinct tidy dataset from `gcd.comb`. The process used to create this dataset is described below.

1. The `{dplyr}` library is loaded.
2. The `gcd.comb` dataset is grouped by `subject_lab` then by `activity_name`.
3. The mean of each feature within each group is calculated.
4. The result is stored as an object named `gcd.tidy` which contains `180` records across `82` features.

This satisfies the second part of the modeling problem.

