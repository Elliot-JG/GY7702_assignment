# Question 1 --------------------------------------------------------------

# Survey data 

#  1 = completely disagree
#  2 = disagree
#  3 = somehow disagree
#  4 = neither agree nor disagree
#  5 = somehow agree
#  6 = agree
#  7 = completely agree
#  NA = missing value

num <- c(NA, 3, 4, 4, 5, 2, 4, NA, 6, 3, 5, 4, 0, 5, 7, 5, NA, 5, 2, 4, NA, 3, 3, 5, NA)

# Remove NA values
num <- na.omit(num)

# Return whether students either completely agree or disagree
students_agree_complete <- all(num == 7)
students_disagree_complete <- all(num == 1)

# Return the index of students that at least somehow agree or more
students_agree <- which(num %in% c(5:7))


# Question 2  -------------------------------------------------------------

library(tidyverse)
library(palmerpenguins)
library(dplyr)
library(knitr)
library(readr)
library(lubridate)

# Remove NA values from the table 
 pen <- na.omit(penguins)
 
# Start pipe 
 pen %>%
   
# Select the appropriate attributes from 'pen'
 select(species, island, bill_length_mm, body_mass_g, bill_depth_mm) %>%
   
# Select the species "Gentoo"
 filter(species == "Gentoo")%>%

# Order body_mass_g in ascending 
 arrange(-body_mass_g)%>%
 
# Return the 10 heaviest gentoo penguins 
 slice_head(n = 10)

# Order the data by bill length (mm) in ascending/ descending order
 pen %>%
   
# Select bill length (mm) and island 
 select(species, island, bill_length_mm, bill_depth_mm,)%>%
   
# Sort by bill length (mm)
 arrange(bill_length_mm)%>%
   
# Group the elements by the attribute 'island'
 group_by(island)%>%

# Calculate the average bill length (mm) for every penguin, per island
 mutate(avg_bill_length = mean(bill_length_mm))%>%
   
# Group the elements by attribute 'species'
 group_by(species)%>%
   
# Calculate min, median and maximum proportion between bill length and bill depth 
 mutate(min_bl_bd = min(bill_length_mm) / min(bill_depth_mm))%>%
 mutate(med_bl_bd = median(bill_length_mm) / median(bill_depth_mm))%>%
 mutate(max_bl_bd = max(bill_length_mm) / max(bill_depth_mm))%>%
 kable()  

 
 
# Question 3  -------------------------------------------------------------

 ##   RUN THIS TO GET COVID DATA !!
 
# Read in Covid-19 data 
covid_data <- read_csv("C:/Users/44792/Desktop/R for data science/covid19_cases_20200301_20201017.csv")
Dudley_complete_covid_data <- covid_data %>%
  tidyr::complete(specimen_date, area_name)%>%
  dplyr::group_by(area_name)%>%
  dplyr::arrange(specimen_date)%>%
  tidyr::fill(newCasesBySpecimenDate, cumCasesBySpecimenDate)%>%
  tidyr::replace_na(list(newCasesBySpecimenDate = 0))%>%
  tidyr::replace_na(list(cumCasesBySpecimenDate = 0))%>%
  filter(area_name == "Dudley")%>%
  subset(select = -c(area_name))


# Create a copy of `[area]_complete_covid_data`, i.e., as another variable named `[area]_day_before`.
Dudley_day_before <- Dudley_complete_covid_data


# create a new column named `day_to_match`
Dudley_day_before$day_to_match <- Dudley_day_before$specimen_date

# that reports the day after the day reported in the column `specimen_date`,
Dudley_day_before$day_to_match <- as.Date(Dudley_day_before$day_to_match)+1


Dudley_covid_development_pipe_test <- Dudley_day_before %>%
  
# Drop the `specimen_date` and `cumCasesBySpecimenDate` columns from the `[area]_day_before` table
subset(select = -c(specimen_date, cumCasesBySpecimenDate)) %>%

# Rename the `newCasesBySpecimenDate` column of the the `[area]_day_before` table to `newCases_day_before`
rename(newCases_day_before = newCasesBySpecimenDate) %>%

# Join `[area]_day_before` with `[area]_complete_covid_data`, where the column `specimen_date` of `[area]_complete_covid_data` is equal to the column `day_to_match` of `[area]_day_before
left_join(Dudley_complete_covid_data,., by= c("specimen_date" = "day_to_match")) %>%

# number of new cases as a percentage of the number of new cases of the day before
mutate(percentage_of_new_cases = (newCasesBySpecimenDate/newCases_day_before)*100)

# Remove any trailing 0's from percentage_of_new_cases
mutate(percentage_of_new_cases = round(percentage_of_new_cases, 0)) %>%
  
# If there is any infinite values in the table, set these to NA 
mutate_if(is.numeric, list(~na_if(., Inf))) 
  
# Question 3 --------------------------------------------------------------


### Question 3.1

# Run this to get Dudley COVID data 

covid_data_na <- any(is.na(covid_data))


Dudley_complete_covid_data <- 
  covid_data %>% 
  filter(area_name == "Dudley", "Plymouth")%>%
  subset(select = -c(area_name))


# Question 3.3
Dudley_day_before_pipe_test <- Dudley_complete_covid_data

# Duplicate the specimen date column 
Dudley_day_before_pipe_test$day_before <- Dudley_day_before_pipe_test$specimen_date

# Subtract day from day before column
Dudley_day_before_pipe_test$day_before <- as.Date(Dudley_day_before_pipe_test$day_before)-1

# Drop the specimen_date and cumCases
Dudley_day_before_pipe_test <- subset(Dudley_day_before_pipe_test, select =  -c(specimen_date, cumCasesBySpecimenDate))
  
# Rename the newCasesBySpecimenDate column of the the [area]_day_before table to newCases_day_before.
Dudley_day_before_pipe_test <- rename(Dudley_day_before_pipe_test, newCases_day_before = newCasesBySpecimenDate)

# Join Dudley_day_before and Dudley_complete_covid_data by the column day_before in Dudley_day_before
Dudley_day_before_pipe_test <- left_join(Dudley_complete_covid_data, Dudley_day_before_pipe_test, by= c("specimen_date" = "day_before"))

# Calculate a new column in the joined table, containing the number of new cases as a percentage of the number of new cases of the day before
Dudley_day_before_pipe_test <- mutate(Dudley_day_before_pipe_test, percentage_of_new_cases = (newCases_day_before/newCasesBySpecimenDate)*100)

# I think the way this is working is newCases_day_before actually states the cases on the specimen date. The amount of new cases by end of play 
# on that specific day 

# The newCases_by_specimen_date are lagging behind by one day, they state the cases at 00:00 on that day. 
# This is the only way that this makes sense to me

# By newCases_day_before / newCasesBySpecimenDate you see the increase as percentage from the beginning, to the end of the day 



# Q3.3 PIPE TESTING -------------------------------------------------------

# Putting together what will go in the Markdown 
# Code from above is copied down below to form into pipe

# DO NOT TOUCH CODE ABOVE
# It works and gets you to the end result
# Just need to manipulate it into Pipes now 

Dudley_day_before_pipe_test <- Dudley_complete_covid_data
Dudley_day_before_pipe_test$day_before <- Dudley_day_before_pipe_test$specimen_date
Dudley_day_before_pipe_test$day_before <- as.Date(Dudley_day_before_pipe_test$day_before)-1


Dudley_day_before_pipe_test %>%
  subset(select = -c(specimen_date, cumCasesBySpecimenDate))%>%
  rename(newCases_day_before = newCasesBySpecimenDate)%>%
  left_join(Dudley_complete_covid_data, ., by= c("specimen_date" = "day_before"))%>%
  mutate(percentage_of_new_cases = (newCases_day_before/newCasesBySpecimenDate)*100)%>%
  
  # Set percentage_of_new_cases to 2 significant digits
  mutate(percentage_of_new_cases = signif(percentage_of_new_cases, 2)) %>%
  
  # Remove any trailing 0's from percentage_of_new_cases
  mutate(percentage_of_new_cases = round(percentage_of_new_cases, 0)) %>%
  
  # If there is any infite values in the table, set these to NA 
  mutate_if(is.numeric, list(~na_if(., Inf))) %>%
  
  # Replace all NA values to 0 
  mutate_if(is.numeric, replace_na, 0)%>%
  kable()


# Plotting Dudley data
ggplot(data = Dudley_day_before_out, mapping = aes(x = specimen_date, format = "%Y-%m-%d", y = percentage_of_new_cases)) +
  geom_path() + scale_x_date(date_breaks = "1 month", date_labels = "%m")

# Question 4 --------------------------------------------------------------


# Read in population data  
pop <- read_csv("C:/Users/44792/Desktop/R for data science/lad19_population.csv")

# Renaming population attribute 'lad19_area_name' to allow for join
# This is bad practice but it is currently working for this example 
names(pop)[names(pop) == "lad19_area_name"] <- "area_name"

# Joining the Covid-19 and population data sets 
cov_pop <- left_join(covid_data, pop)

# String of different places to pull out of Cov_pop
places <- c("Dudley","Plymouth")

# Filter out places from cov_pop
Dudley_Plymouth_covid_data <- 
  cov_pop %>% 
  filter(area_name %in% places) %>%
  
  # Remove area_name and newcasesbyspeciendate
  subset(select = -c(lad19_area_code, newCasesBySpecimenDate))%>%

  # Form column showing cumulative cases as proportion of population 
  mutate(CumCases_percentage_of_pop = (cumCasesBySpecimenDate / area_population)*100)%>%

  # Remove the area_population 
  subset(select = -c(area_population, cumCasesBySpecimenDate))

  # Form a column for Plymouth CumCases_percentage_of_pop and Dudley CumCases_percentage_of_pop
Dudley_Plymouth_wide <- pivot_wider(Dudley_Plymouth_covid_data, names_from = area_name, values_from = c(CumCases_percentage_of_pop))

  # Plotting just Dudley
ggplot(data = Dudley_Plymouth_wide, mapping = aes(x = specimen_date, format = "%Y-%m-%d")) + geom_line(aes(y = Dudley), colour = "darkred") + scale_x_date(date_breaks ="1 month", date_labels = "%m") +xlab("Month in 2020") +ylab("Cumulative cases per population (%)")

  # Pivoting back to the original data 
Dudley_Plymouth_long <- pivot_longer(Dudley_Plymouth_wide, cols = -specimen_date, names_to = c("CumCases_percentage_of_pop"))

  # Plotting Plymouth and Dudley 
ggplot(Dudley_Plymouth_covid_data, aes(x = specimen_date, format = "%Y-%m-%d", y = CumCases_percentage_of_pop, colour = area_name)) + geom_line() + scale_x_date(date_breaks ="1 month", date_labels = "%m")  
  

  
  

