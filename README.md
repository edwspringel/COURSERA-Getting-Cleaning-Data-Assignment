# COURSERA-Getting-Cleaning-Data-Assignment
used a lot of data.table

This is my repo for the Coursera Course: Getting & Cleaning Data
Assignment

The Script run_analysis.R will:

1. Download and Unzip the data
2. Loads the "activityLabels and "Features" then just takes 
mean and std dev of each
3. Loads the Test and Training Data 
4. Merges Test and Training Data
5. Melts and Recasts them so that 
  -Observations are Subject and Activity
  -Variables are the means and std devs for aspects of motion
6. Outputs a Tidy Data File: "SamsungTidyDataSet" both as a csv ot as a txt file
  
  (for further detail see the UCI website description)
