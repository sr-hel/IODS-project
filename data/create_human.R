# Sami Raatikainen / 20.11.2020
# Introduction to Open Data Science / Exercise 4
# Data source reference: http://hdr.undp.org/en/content/human-development-index-hdi

# We read in the data and explore its dimensions and structure.

hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F)
gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors = F, na.strings = "..")

dim(hd)
str(hd)

dim(gii)
str(gii)

summary(hd)
summary(gii)

# The hd data set consists of 195 observations of 8 variables. The gii data set
# consists of 195 observations of 10 variables.

# We rename the variables with shorter descriptive names

colnames(hd)[1] <- "HDIrank"
colnames(hd)[2] <- "country"
colnames(hd)[3] <- "HDI"
colnames(hd)[4] <- "lifeexp"
colnames(hd)[5] <- "eduexp"
colnames(hd)[6] <- "edumean"
colnames(hd)[7] <- "GNI"
colnames(hd)[8] <- "GNIHDI"

colnames(gii)[1] <- "GIIrank"
colnames(gii)[2] <- "country"
colnames(gii)[3] <- "GII"
colnames(gii)[4] <- "mort"
colnames(gii)[5] <- "birth"
colnames(gii)[6] <- "parli"
colnames(gii)[7] <- "edu2f"
colnames(gii)[8] <- "edu2m"
colnames(gii)[9] <- "labf"
colnames(gii)[10] <- "labm"

# Create two new ratio variables in gii

gii <- mutate(gii, edu2r = edu2f/edu2m)
gii <- mutate(gii, labr = labf/labm)

# We join the data sets and keep only the students present in both data sets.

library(dplyr)

human <- inner_join(hd, gii, by = "country")

dim(human)
str(human)

# The combined data set has 195 observations of 19 variables, as expected.

# We store the data set.

write.csv(human, file = "data/human.csv", row.names = FALSE)
