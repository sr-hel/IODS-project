# Sami Raatikainen / 06.11.2020
# Introduction to Open Data Science / Exercise 2
# Using data by Kimmo Vehkalahti, see: https://www.mv.helsinki.fi/home/kvehkala/JYTmooc/JYTOPKYS3-meta.txt

# Read in the data and explore the dimensions and structure

lrn14 <- read.table("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt", sep="\t", header=TRUE)

dim(lrn14)
str(lrn14)

# The data consists of 183 rows (observations) and 60 columns (variables). Most 
# of the columns contain answers with values in the range 1-5, and the last few 
# columns contain the age, attitude, points and gender.

# Combine questions and scale all combination variables

library(dplyr)

deep_questions <- c("D03","D11","D19","D27","D07","D14","D22","D30","D06","D15","D23","D31")
surface_questions <- c("SU02","SU10","SU18","SU26","SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")
strategic_questions <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")

deep_columns <- select(lrn14, one_of(deep_questions))
lrn14$deep <- rowMeans(deep_columns)

surface_columns <- select(lrn14, one_of(surface_questions))
lrn14$surf <- rowMeans(surface_columns)

strategic_columns <- select(lrn14, one_of(strategic_questions))
lrn14$stra <- rowMeans(strategic_columns)

lrn14$attitude <- lrn14$Attitude / 10

# Pick our columns, rename them for consistency and exclude data with points = 0

keep_columns <- c("gender", "Age", "attitude", "deep", "stra", "surf", "Points")
learning2014 <- select(lrn14, one_of(keep_columns))

colnames(learning2014)[2] <- "age"
colnames(learning2014)[7] <- "points"

learning2014 <- filter(learning2014, points > 0)

# Save the dataset

write.csv(learning2014, file = "data/learning2014.csv", row.names = FALSE)

# Read back the dataset

learning2014 <- read.csv("data/learning2014.csv")

str(learning2014)
head(learning2014)

# The data we read in is consistent with what we saved, we still have 166
# observations of 7 variables.
