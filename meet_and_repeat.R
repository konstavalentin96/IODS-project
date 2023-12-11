# Load needed packages

library(tidyverse)

# Load the data sets

bprs <- read.csv("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt", sep = " ")
rats <- read.csv("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt", sep = "\t", header = TRUE)


# Take a look at the data sets

dim(bprs)
dim(rats)
str(bprs)
str(rats)

# Summaries of the data sets

summary(bprs)
summary(rats)

# In the wide format, each row/observation has values of the same variable in different columns based on the time point when the measurement was taken.


# Convert categorical variables in the data sets to factors

bprs <- bprs %>% 
  mutate(treatment = factor(treatment),
         subject = factor(subject))

rats <- rats %>% 
  mutate(ID = factor(ID),
         Group = factor(Group))

# Convert the wide format data sets into long format

bprsl <-  pivot_longer(bprs, cols = -c(treatment, subject),
                       names_to = "weeks", values_to = "bprs") %>% # names_to indicates a new column name where the old column names are collected and values_to indicates the new column where the values of the old columns are collected
  arrange(weeks)

ratsl <- pivot_longer(rats, cols = -c(ID, Group),
                      names_to = "WD", values_to = "Weight") %>% 
  arrange(WD)

# Add a 'week' variable to bprsl and a 'time' variable to ratsl

bprsl <- bprsl %>% 
  mutate(week = as.integer(substr(weeks, 5,5)))

ratsl <- ratsl %>% 
  mutate(time = as.integer(substr(WD,3,4)))


# What the long form sets look like now

colnames(bprsl) #column names: "treatment", "subject", "weeks", "bprs" and "week"

colnames(ratsl) # column names: "ID", "Group", "WD", "Weight" and "time"

summary(bprsl)
summary(ratsl)

# We have converted the wide format data sets into long format. This means that while we only had
# one row for each observation/subject in the wide format and multiple columns of the same "variable" based on
# the number of measurements, now we have multiple rows for each observation/subject based on the number
# of measurements, and a single variable column where all the measurements are collected. In addition, we 
# now have a variable indicating the time point for the individual measurements. The long format allows us
# to plot the data and make analyses with it while still retaining all the data. Long format allows
# us to use both the measurement values and time as variables, which is of course crucial in longitudinal
# data analysis. 

# Writing the wrangled data sets to the data folder

setwd("C:/Users/kveu/Work Folders/PhD Research/Courses/IODS/IODS-project/Data")
write_csv(x = bprsl, "bprs.csv")
write_csv(x = ratsl, "rats.csv")
