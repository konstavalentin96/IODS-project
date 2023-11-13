# Konsta Valkonen 9.11.2023

# Loading packages needed in the assignment
library(dplyr)
library(tidyverse)

### DATA WRANGLING ###

# Reading data from website into R: using tab ("\t") as separator and setting header as TRUE as instructed
learning_data <- read.table("https://www.mv.helsinki.fi/home/kvehkala/JYTmooc/JYTOPKYS3-data.txt", sep = "\t", header = T)


dim(learning_data) # There are 183 observations and 60 variables 

str(learning_data) # several of the variables seem to be questions / statements that the participants have answered in a specific scale



# Creating the columns deep, surf and stra
deep_columns <- learning_data %>% 
  select(one_of(c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D06",  "D15", "D23", "D31")))

surface_columns <- learning_data %>%
  select(one_of(c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")))

strategic_columns <- learning_data %>%
  select(one_of(c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")))



# Create analysis data set
analysis <- learning_data %>%
  select(gender, Age, Attitude,Points)

# Create the variables deep, surf and stra by scaling the variables (taking the means of each column) --> getting the average score of a test in the corresponding category
analysis <- analysis %>%
  mutate("deep" = rowMeans(deep_columns),
         "surf" = rowMeans(surface_columns),
         "stra" = rowMeans(strategic_columns))



# Filter out observations where points is zero
analysis <- analysis %>%
  filter(Points > 0)

dim(analysis) # there are now 166 observations and 7 variables / columns as instructed



# Saving the analysis dataset in the Data folder
setwd("C:/Users/kveu/Work Folders/PhD Research/Courses/IODS/IODS-project/Data")
write_csv(x = analysis, "analysis.csv")

dim(analysis)
str(analysis)
head(analysis)

# Looks good!


