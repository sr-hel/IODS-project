# Sami Raatikainen / 13.11.2020
# Introduction to Open Data Science / Exercise 3
# Data source reference: 
# P. Cortez and A. Silva. Using Data Mining to Predict Secondary School Student 
# Performance. In A. Brito and J. Teixeira Eds., Proceedings of 5th FUture 
# BUsiness TEChnology Conference (FUBUTEC 2008) pp. 5-12, Porto, Portugal, April,
# 2008, EUROSIS, ISBN 978-9077381-39-7. http://www3.dsi.uminho.pt/pcortez/student.pdf

# We read in the data and explore its dimensions and structure.

mat <- read.table("data/student-mat.csv", sep = ";", header=TRUE)
por <- read.table("data/student-por.csv", sep = ";", header=TRUE)

dim(mat)
str(mat)

dim(por)
str(por)

# The mat data set consists of 395 observations of 33 variables. The por data set
# is larger, with 649 observations of 33 variables.

# We join the data sets and keep only the students present in both data sets.

library(dplyr)

join_by <- c("school","sex","age","address","famsize","Pstatus","Medu","Fedu","Mjob","Fjob","reason","nursery","internet")
matpor <- inner_join(mat, por, by = join_by, suffix = c(".mat", ".por"))

dim(matpor)
str(matpor)

# The combined data set has 382 observations of 53 variables -- we now have some 
# double variables with possibly different answers for each student.

# We average over the numerical double variables and for the other data types
# we simply pick the value from the first data set.

alc <- select(matpor, one_of(join_by))
notjoined_columns <- colnames(mat)[!colnames(mat) %in% join_by]

for(column_name in notjoined_columns) {
  two_columns <- select(matpor, starts_with(column_name))
  first_column <- select(two_columns, 1)[[1]]
  
  if(is.numeric(first_column)) {
    alc[column_name] <- round(rowMeans(two_columns))
  } else { 
    alc[column_name] <- first_column
  }
}

# We average over the weekday and weekend alcohol consumption variables and
# store the result in a new column alc_use. We also create another new column
# high_use, which is TRUE for students with alc_use > 2.

alc <- mutate(alc, alc_use = (Dalc + Walc) / 2)
alc <- mutate(alc, high_use = alc_use > 2)

glimpse(alc)

# The resulting data set has 382 observations of 35 variables, as expected.

# We store the data set.

write.csv(alc, file = "data/alc.csv", row.names = FALSE)
