# Sami Raatikainen / 04.12.2020
# Introduction to Open Data Science / Exercise 6

# We read in the data and explore it.

BPRS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt", sep="", header=TRUE)
RATS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt", sep="", header=TRUE)

names(BPRS)
str(BPRS)
summary(BPRS)

names(RATS)
str(RATS)
summary(RATS)

# The BPRS data set consists of 40 observations of 11 variables. The RATS data
# set consists of 16 observations of 13 variables.

# We convert the categorical variables to factors

BPRS$treatment <- factor(BPRS$treatment)
BPRS$subject <- factor(BPRS$subject)

RATS$ID <- factor(RATS$ID)
RATS$Group <- factor(RATS$Group)

# We convert the data to long form 

library(dplyr)
library(tidyr)

BPRSL <- BPRS %>% 
  gather(key = weeks, value = bprs, -treatment, -subject) %>% 
  mutate(week = as.integer(substr(weeks, 5, 5)))

RATSL <- RATS %>%
  gather(key = WD, value = Weight, -ID, -Group) %>%
  mutate(Time = as.integer(substr(WD, 3, 4))) 

# Let's look at the new data

names(BPRSL)
str(BPRSL)
summary(BPRSL)

names(RATSL)
str(RATSL)
summary(RATSL)

# Our data is now in long form: the BPRSL data set consists of 360 observations 
# of 5 variables. The RATSL data set consists of 176 observations of 5 variables.

# We store the data sets

write.csv(BPRSL, file = "data/BPRSL.csv")
write.csv(RATSL, file = "data/RATSL.csv")
