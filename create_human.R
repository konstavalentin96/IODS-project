# Load needed packages and data
library(readr)
library(tidyverse)
library(dplyr)
hd <- read_csv("https://raw.githubusercontent.com/KimmoVehkalahti/Helsinki-Open-Data-Science/master/datasets/human_development.csv")
gii <- read_csv("https://raw.githubusercontent.com/KimmoVehkalahti/Helsinki-Open-Data-Science/master/datasets/gender_inequality.csv", na = "..")


# Explore the data sets
str(hd)
dim(hd)

str(gii)
dim(gii)

# Summaries of the variables
summary(hd)
summary(gii)


# Replacing spaces and special characters in the column names with dots so the name replacements will be easier
colnames(hd) <- make.names(colnames(hd), unique = T)
colnames(gii) <- make.names(colnames(gii), unique = T)


# Replace column names with easier ones
hd <- hd %>% 
  rename("GNI" = "Gross.National.Income..GNI..per.Capita",
         "Life.Exp" = "Life.Expectancy.at.Birth",
         "Edu.Exp" = "Expected.Years.of.Education",
         "Edu.Mean" = "Mean.Years.of.Education",
         "HDI" = "Human.Development.Index..HDI.",
         "GNI.Minus.HDI" = "GNI.per.Capita.Rank.Minus.HDI.Rank")

gii <- gii %>% 
  rename("GII" = "Gender.Inequality.Index..GII.",
         "Mat.Mor" = "Maternal.Mortality.Ratio",
         "Ado.Birth" = "Adolescent.Birth.Rate",
         "Parli.F" = "Percent.Representation.in.Parliament",
         "Edu2.F" = "Population.with.Secondary.Education..Female.",
         "Edu2.M" = "Population.with.Secondary.Education..Male.",
         "Labo.F" = "Labour.Force.Participation.Rate..Female.",
         "Labo.M" = "Labour.Force.Participation.Rate..Male.")

# Create new variables
gii <- gii %>% 
  mutate(Edu2.FM = Edu2.F / Edu2.M,
         Labo.FM = Labo.F / Labo.M)

# Join the data sets using Country variable 
human <- inner_join(gii, hd, by = "Country")

dim(human) # The new data set has 195 observations and 19 variables as instructed

# Save the data
setwd("C:/Users/kveu/Work Folders/PhD Research/Courses/IODS/IODS-project/Data")
write_csv(x = human, "human.csv")



# Week 5 Data Wrangling

# Load the data
human <- read.csv("C:/Users/kveu/Work Folders/PhD Research/Courses/IODS/IODS-project/Data/human.csv")

# Explore structure and dimensions

str(human) # Data set has one character vector as a column (list of the countries included), other columns are numerical/integers
dim(human) # Data set has 195 observations and 19 variables as it should

## The data set includes information on countries' Human Development Index (HDI) and Gender Inequality Index (GII), which describe achievements in key dimensions of human development (such as a long and healthy life) and on inequalities between genders


# Keep only needed columns

human <- human %>% 
  select("Country", "Edu2.FM", "Labo.FM", "Edu.Exp", "Life.Exp", "GNI", "Mat.Mor", "Ado.Birth", "Parli.F")

# Remove rows with missing values

human <- na.omit(human)

# Remove observations relating to regions instead of countries

tail(human, n = 10) # Last 6 observations need to be removed
last <- nrow(human)-7
human <- human[1:last, ]

dim(human) # Data set has 155 observations and 9 variables including "Country"


# Save the data
setwd("C:/Users/kveu/Work Folders/PhD Research/Courses/IODS/IODS-project/Data")
write_csv(x = human, "human.csv")
