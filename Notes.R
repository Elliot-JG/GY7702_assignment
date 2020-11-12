## Q3.3 OLD (12/11/2020)


# Duplicate the table Dudley_complete_covid_date 
Dudley_day_before <- Dudley_complete_covid_data

# Creating a new column in Dudley_day_before, called 'day_before' that is a duplicate of 'specimen_date'
Dudley_day_before$day_before <- Dudley_day_before$specimen_date

# Using lubricate(), subtract 1 day from the day_before column
Dudley_day_before$day_before <- as.Date(Dudley_day_before$day_before)-1


Dudley_day_before_out <- Dudley_day_before %>%
  # Remove specimen_date and cumcasesbyspecimenDate
  subset(select = -c(specimen_date, cumCasesBySpecimenDate))%>%
  
  # Rename newCasesBySpecimenDate to newCases_day_before 
  rename(newCases_day_before = newCasesBySpecimenDate)%>%
  
  # Join [area]_day_before with Dudley_complete_covid_data, specimen_date is 
  # equal to the day_before 
  left_join(Dudley_complete_covid_data, ., by= c("specimen_date" = "day_before"))%>%
  
  # number of new cases as a percentage of the number of new cases of the day before
  mutate(percentage_of_new_cases = (newCases_day_before/newCasesBySpecimenDate)*100) %>%
  
  # Set percentage_of_new_cases to 2 significant digits
  mutate(percentage_of_new_cases = signif(percentage_of_new_cases, 2)) %>%
  
  # Remove any trailing 0's from percentage_of_new_cases
  mutate(percentage_of_new_cases = round(percentage_of_new_cases, 0)) %>%
  
  # If there is any infinite values in the table, set these to NA 
  mutate_if(is.numeric, list(~na_if(., Inf)))