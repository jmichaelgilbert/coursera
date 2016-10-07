#==============================================================================
#==============================================================================
# Getting & Cleaning Data
# Course Project
# Last updated: 2016-10-07 by MJG
#==============================================================================
#==============================================================================

# Load packages
library(dplyr)

#==============================================================================
# Data Import, Prep, and Staging
#==============================================================================

#------------------------------------------------------------------------------
# Download data
#------------------------------------------------------------------------------
if(!file.exists("FUCI_HAR_Dataset.zip")){
    URL = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(url = URL,
                  destfile = "FUCI_HAR_Dataset.zip",
                  method = "libcurl")
    rm(URL)
}

#------------------------------------------------------------------------------
# Import data
#------------------------------------------------------------------------------

#--------------------------------------
# Feature names
#--------------------------------------
# Load column names (features)
gcd.cn = read.table(unz("FUCI_HAR_Dataset.zip",
                        "UCI HAR Dataset/features.txt"),
                    header = FALSE,
                    stringsAsFactors = FALSE)[, 2]

#------------------
# Correct names
#------------------
# Delete all parentheses at end of strings
gcd.cn = gsub(pattern = "\\(\\)$|\\)$",
              replacement = "",
              x = gcd.cn)

# Replace any dash or comma with underscore
gcd.cn = gsub(pattern = "-|,",
              replacement = "_",
              x = gcd.cn)

# Delete remaining parentheses pairs 
gcd.cn = gsub(pattern = "\\(\\)",
              replacement = "",
              x = gcd.cn)

# Replace remaining opening parentheses with underscore
gcd.cn = gsub(pattern = "\\(",
              replacement = "_",
              x = gcd.cn)

# Delete remaining closing parentheses (feature 556)
gcd.cn = gsub(pattern = "\\)",
              replacement = "",
              x = gcd.cn)

#--------------------------------------
# Activity names
#--------------------------------------
# Load column names (features)
gcd.act = read.table(unz("FUCI_HAR_Dataset.zip",
                        "UCI HAR Dataset/activity_labels.txt"),
                     header = FALSE,
                     stringsAsFactors = FALSE)[, 2]

#--------------------------------------
# Training set
#--------------------------------------
# Raw
gcd.trn.raw = read.table(unz("FUCI_HAR_Dataset.zip", 
                             "UCI HAR Dataset/train/X_train.txt"),
                         header = FALSE,
                         col.names = gcd.cn)

# Subject labels
gcd.trn.sub = read.table(unz("FUCI_HAR_Dataset.zip", 
                             "UCI HAR Dataset/train/subject_train.txt"),
                         header = FALSE,
                         col.names = "subject_lab")

# Activity labels
gcd.trn.act = read.table(unz("FUCI_HAR_Dataset.zip", 
                             "UCI HAR Dataset/train/y_train.txt"),
                         header = FALSE,
                         col.names = "activity_lab")

# Combined
gcd.trn = data.frame(gcd.trn.raw,
                     gcd.trn.sub,
                     gcd.trn.act)

# Clean-up
rm(list = ls(pattern = "gcd.trn."))

#--------------------------------------
# Testing set
#--------------------------------------
# Raw
gcd.tst.raw = read.table(unz("FUCI_HAR_Dataset.zip", 
                             "UCI HAR Dataset/test/X_test.txt"),
                         header = FALSE,
                         col.names = gcd.cn)

# Subject labels
gcd.tst.sub = read.table(unz("FUCI_HAR_Dataset.zip", 
                             "UCI HAR Dataset/test/subject_test.txt"),
                         header = FALSE,
                         col.names = "subject_lab")

# Activity labels
gcd.tst.act = read.table(unz("FUCI_HAR_Dataset.zip", 
                             "UCI HAR Dataset/test/y_test.txt"),
                         header = FALSE,
                         col.names = "activity_lab")

# Combined
gcd.tst = data.frame(gcd.tst.raw,
                     gcd.tst.sub,
                     gcd.tst.act)

# Clean-up
rm(list = ls(pattern = "gcd.tst."))

#--------------------------------------
# Merge
#--------------------------------------
# Verify identical column names
ifelse(sum(colnames(gcd.trn) == colnames(gcd.tst)), TRUE, FALSE)

# Merge testing and training sets
gcd.comb = rbind(gcd.trn,
                 gcd.tst)

# Clean-up
rm(list = ls(pattern = "gcd.t"))

#------------------------------------------------------------------------------
# Prep data
#------------------------------------------------------------------------------
# Keep only mean(), std(), subject labels, and activity labels
gcd.cn.keep = grep(pattern = "mean|std|subject_lab|activity_lab",
                   x = colnames(gcd.comb),
                   value = TRUE)

# Drop unnecessary columns
gcd.comb = subset(gcd.comb, select = gcd.cn.keep)

# Name activities
gcd.comb$activity_name = gcd.act[gcd.comb$activity_lab]

# Clean-up
rm(list = ls(pattern = "[^gcd.comb]"))

#==============================================================================
# Tidy Data
#==============================================================================
gcd.tidy = 
    gcd.comb %>%
    group_by(subject_lab,
             activity_name) %>%
    summarize_each(funs(mean))

#==============================================================================
# FIN
#==============================================================================
