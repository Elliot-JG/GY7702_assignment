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

# Read in Covid-19 data 
covid_data <- read_csv("C:/Users/44792/Desktop/R for data science/covid19_cases_20200301_20201017.csv")

# Check for NA values in covid_data
any(is.na(covid_data))
## [1] FALSE

## This returns false, meaning that there is not a date in the table that needs data filling in from the previous day
## To be clear, every row contains either 0 or >0

# Start pipe, with a variable named 'covid_data_wide' 
covid_data_wide <- covid_data%>%

# Reshape the table, from long -> wide
# Each day is a row, with new column names from (names_from) area_name.
# Values for these new columns are taken from (values_from) 'newCasesBySpecimenDate' and 'cumCasesBySpecimenDate'
pivot_wider(names_from = area_name, values_from = c(newCasesBySpecimenDate, cumCasesBySpecimenDate))

## Some locations did not have cases in the earlier months (March, April for example) and so were not included in the table in this time period. 
## This means, when every location is considered at every date, NA's arise. In other words, location 'x' may not had been included in the table on 2020-03-01
## and was only added into covid_data on 2020-04-01 (for example), leading to NA's for the entirety of March.

# This can be double checked with....
any(is.na(covid_data_wide))
## [1] TRUE 

# Remove NA values 
covid_data_wide[is.na(covid_data_wide)] <- 0

# Check for NA values again 
any(is.na(covid_data_wide))
## [1] FALSE
## This returns false as NA values have been replaced with 0 

# Reshape again to get area_names back
## This does not work (merge causes R to run out of memory)

# Pivot new cases to longerformat 
covid_data_long_new <- covid_data_wide %>%
  pivot_longer(cols = -specimen_date, names_to = c("newCasesBySpecimenDate","area_name"), names_sep = "_",)%>% 
  
  # Remove the 'newCasesBySpecimenDate' column full of 'newCasesBySpecimenDate' text 
  subset(select = -c(newCasesBySpecimenDate))%>%
  covid_data_long_new[is.na(covid_data_long_new)] <- 0

# Pivot cumulative cases to longer format 
covid_data_long_cum <- covid_data_wide %>%
  pivot_longer(cols = -specimen_date, names_to = c("cumCasesBySpecimenDate","area_name"), names_sep = "_",)
  
# Remove the 'cumCasesBySpecimenDate' column full of 'cumCasesBySpecimenDate' text
  subset(select = -c(cumCasesBySpecimenDate))%>% 
  covid_data_long_cum[is.na(covid_data_long_cum)] <- 0 

# Merge the 2 dataframes to 
merge(covid_data_long_cum,covid_data_long_new, by="area_name")




  
# Subset only the area assigned to your student ID in the table in the appendix (Dudley)
Dudley <- covid_data_wide[which(covid_data_wide$area_name=='Dudley')]

# Question 4 --------------------------------------------------------------

# Read in population data  
pop <- read_csv("C:/Users/44792/Desktop/R for data science/lad19_population.csv")

# Renaming population attribute 'lad19_area_name' to allow for join
# This is bad practice but it is currently working for this example 
names(pop)[names(pop) == "lad19_area_name"] <- "area_name"

# Joining the Covid-19 and population data sets 
cov_pop <- left_join(covid_data, pop)
 
