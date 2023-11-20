# Konsta Valkonen, 20.11.2023, IODS week 3 - Data wrangling (data on student performance obtained from here: https://www.archive.ics.uci.edu/dataset/320/student+performance)


# Reading the data from two data sets: student performance on two subjects; math and portuguese 
math <- read.csv("Data/student-mat.csv", sep = ";")

portuguese <- read.csv("Data/student-por.csv", sep = ";")

# Exploring the dimensions and structure of the datasets
dim(math) # math dataset has 395 observations and 33 columns/variables
dim(portuguese) # portuguese dataset has 649 observations and 33 columns/variables

str(math)
str(portuguese)

# Both datasets have the same variables: grades, demographics, social and school-related features




# Join the two datasets based on specific variables that can be used to identify the subjects, keeping only the students present in both data sets.
# Some variables vary between the datasets and thus cannot be used in the joining process, so let's specify them

free_var <- c("failures", "paid", "absences", "G1", "G2", "G3")

# Specifying the names of the other variables that we'll use in the joining process

join_var <- setdiff(colnames(math), free_var)

# Now join the sets
math_por <- inner_join(math, portuguese, by = join_var, suffix = c(".math", ".por"))

dim(math_por) # We now have 370 observations (students) and 39 variables
str(math_por) # We have the original variables as we as duplicates of the variables in free_var (same variable with a different value depending on the data set)



# Let's get rid of the duplicate variables

# Create a new data set
alc <- select(math_por, all_of(join_var))

# If the duplicate variables are numerical, we will take the mean of the two values for each student. If they are not, we will take either one and leave the other out.
# Save the values in the new alc dataset
for (variable in free_var) {
  both_var <- select(math_por, starts_with(variable))
  var1 <- select(both_var,1)[[1]]
  if (is.numeric(var1)) {
    alc[variable] <- round(rowMeans(both_var))
  } else {
    alc[variable] <- var1
  }
}



# Creating a new variables alc_use and high_use: alc_use = average of the students' alcohol consumption during weekdays and weekends; high_use = average alcohol consumption of more than 2 portions (per week)
alc <- alc %>%
  mutate(alc_use = ((Dalc + Walc) / 2),
         high_use = alc_use > 2)
  

# Taking a look at the data
glimpse(alc) # The data now has 370 observationsand 35 variables  as it should

# Write the data set into the data folder (I'm using company computer and don't want to show the path containing my user name etc., but I set the working directory to the data folder prior to writing the file)
library(readr)
write_csv(x = alc, "alc.csv")
