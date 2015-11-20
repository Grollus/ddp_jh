library(readr)
library(dplyr)
library(stringr)
animal <- read_csv('Animal_Tag_DATA.csv') 

# remove rows identified as problem when loading in data
index <- problems(animal)$row
animal <- animal[-index,]

# selecting to the variables I will be dealing with. Filtering down to cats and dogs
# Removing rows with no dob values
data <- animal %>%
  select(animal_type, sex, dob, breed_group, primary_breed) %>%
  filter((animal_type == "DOG"|animal_type == "CAT") & is.na(dob) == FALSE)

#Misc data cleaning
data$animal_type <- tolower(data$animal_type)
data$breed_group <- tolower(data$breed_group)
data$primary_breed <- tolower(data$primary_breed)

data$primary_breed <- str_trim(data$primary_breed, side = 'both')
data$breed_group <- str_trim(data$breed_group, side = 'both')

# removing rows with missing breed type
data <- data %>%
  filter((is.na(breed_group) == FALSE) & (is.na(primary_breed) == FALSE))

# create year variable
library(lubridate)
data$year <- year(data$dob)
data$year <- as.integer(data$year)
# Cats and Dogs data frames
cats <- data %>%
  filter(animal_type =="cat")
dogs <- data %>%
  filter(animal_type =="dog")

library(ggplot2)
dogs %>%
  filter(primary_breed == "rottweiler") %>%
  ggplot(aes(x = year))+
    geom_histogram(binwidth = 1)

dogs %>%
  filter(primary_breed == "maltese") %>%
  ggvis(~year)%>%
  layer_histograms()

dogs %>%
  filter(year >=1980)%>%
  ggvis(~year)%>%
  layer_histograms()


data %>%
  group_by(year, animal_type)%>%
  summarise(count = n())%>%
  filter(year >=1990 & year <= 2000)%>%
  ggvis(~year,~count, stroke = ~animal_type)%>%
  layer_lines()
saveRDS(data, 'animal_data.rds')
