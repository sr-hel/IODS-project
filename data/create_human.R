# Sami Raatikainen / 26.11.2020
# Introduction to Open Data Science / Exercise 5
# Data source reference: http://hdr.undp.org/en/content/human-development-index-hdi

# Exercise 4

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

colnames(hd) <- c("HDIrank", "country", "HDI", "lifeexp", "eduexp", "edumean", "GNI", "GNIHDI")
colnames(gii) <- c("GIIrank", "country", "GII", "mort", "birth", "parli", "edu2f", "edu2m", "labf", "labm")

# Create two new ratio variables in gii

library(dplyr)

gii <- mutate(gii, edu2r = edu2f/edu2m)
gii <- mutate(gii, labr = labf/labm)

# We join the data sets and keep only the countries present in both data sets.

human <- inner_join(hd, gii, by = "country")

dim(human)
str(human)

# The combined data set has 195 observations of 19 variables, as expected.

# We store the data set.

write.csv(human, file = "data/human.csv", row.names = FALSE)

# Exercise 5

# We read in the data and explore its dimensions and structure.

human <- read.csv("data/human.csv")

dim(human)
str(human)

# The human data set consists of 195 observations of 19 variables. The variables
# are related to Human Development Index (HDI) and Gender Inequality Index (GII).

# We transform the GNI variable to numeric

library(stringr)

human <- mutate(human, GNI = str_replace(human$GNI, pattern=",", replace ="") %>% as.numeric())

# Exclude unneeded variables

keep <- c("country", "edu2r", "labr", "eduexp", "lifeexp", "GNI", "mort", "birth", "parli")
human <- select(human, one_of(keep))

# Remove all rows with missing values

human <- filter(human, complete.cases(human) == TRUE)

# Remove observations which relate to regions instead of countries

last <- nrow(human) - 7
human <- human[1:last, ]

# Define the row names of the data by the country names 

rownames(human) <- human$country
human <- select(human, -country)

# The data set has 155 observations of 8 variables, as expected.

# We store the data set

write.csv(human, file = "data/human.csv")
