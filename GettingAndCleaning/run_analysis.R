library(dplyr)

# this helper function will 
# 1. load one set of data (either the training or the test set)
# 2. label the data set with descriptive varaible names
# 3. identify the mean and std dev columns and create a filtered set
#      containing only measurements of the mean and std deviation
# 4. load the activity descriptions from activity_lables.txt and create an
#      enriched data set containing descriptive activity names
# 5. create the full data set by including the subbject identifiers from the 
#       subjects file.
constructDatasetHelper <- function (type)
{
  # construct the filenames
  fileName_data     <- paste( type, "/X_", type, ".txt", sep="")
  fileName_subject  <- paste( type, "/subject_", type, ".txt", sep="")
  fileName_activty  <- paste( type, "/y_", type, ".txt", sep="")
  filename_colNames <- "features.txt"
  filename_labels   <- "activity_labels.txt"

  # load the data.  All data should be numeric in these files
  classes <- rep("numeric",561)
  raw <- read.table(file= fileName_data, header = FALSE, colClasses = classes) 

  # label the data set with descriptive variable names
  cnames <- readLines(filename_colNames)
  names(raw) <- cnames
  
  # create set with the columns we want to keep 
  #    ie those with measurements on the mean or std deviation for each measurement
  #
  # we keep those which contain "std" or "mean". This means we also keep those
  # which contain meanFreq().
  stdevs <- grep("std", cnames)
  means <- grep("mean", cnames)
  filtered <- raw[,sort(c(stdevs,means))]
  names(filtered) = sapply(names(filtered), descriptiveNameHelper)

  # load the activity data and use append the descriptive activity name to the table
  activityId <- as.numeric(readLines(fileName_activty))
  enriched <- cbind(filtered,  activityId)
  labels <- read.table(filename_labels, header=FALSE)
  names(labels) <- c("ID", "Activity")
  enriched <- inner_join(enriched, labels, by = c ( "activityId" = "ID"))

  # load the subject data and append it to the table
  subject    <- as.numeric(readLines(fileName_subject))
  full <- cbind(enriched, subject)
  
  # return the processed table
  full
}

# function to make the name "descriptive"
descriptiveNameHelper <- function(name)
{
    name = gsub("[()]","", name)
    name = gsub("[0-9]+ +", "", name)
    name = gsub("^t", "time", name)
    name = gsub("^f", "frequency", name)
    name = gsub("Acc", "Acceleration", name)
    name = gsub("-", ".", name)
    name = gsub("([XYZ])$", "\\1.Axis.", name)
    name
}

# This function will 
# 1. load the test and training sets
# 2. Merge the training and test sets to create one data set
constructDataset <- function()
{
    trainingSet <- constructDatasetHelper("train")
    testSet     <- constructDatasetHelper("test")
    full        <- rbind(trainingSet, testSet)
    full
}

# This function will create a second, independent, tidy data set
# with the average of each variable for each activity and subject
createSecondTidySet <- function(full)
{
    summ = full %>%
        group_by(Activity, activityId, subject) %>%
        summarize_each(funs(mean)) 
}

full = constructDataset()
tidy = createSecondTidySet(full)

write.table(tidy, "results.txt", row.name=FALSE)
