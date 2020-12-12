################################################################################
#####################  ANALYSIS OF GLOBAL PREFERENCIES  ########################
################################################################################
# Reference article: https://science.sciencemag.org/content/362/6412/eaas9899
# DOI: 10.1126/science.aas9899

# =============================== #
#### 0. LOAD DATA AND SET PATH ####
# =============================== #

# Set the path
setwd("/Users/sara/Desktop/Projects/Global_Preferences_Survey/")

# Source helper functions
source("functions/SourceFunctions.r")
SourceFunctions(path = "functions/helper_functions/", trace = TRUE)

# Load libraries
LoadRequiredLibraries()

# Select the directory
path_GPS_dir <- "files/GPS_Dataset/GPS_dataset_individual_level/"
path_Index_dir <- "files/Data_Extract_From_World_Development_Indicators/"

# Load the data
data <- read_dta(paste0(path_GPS_dir, "individual_new.dta")) 
indicators <- read_csv(file = paste0(path_Index_dir, "Data.csv"), na = "..")

# ========================= #
#### 1. PREPARE THE DATA ####
# ========================= #

# Select specific columns of indicators
indicators <- indicators %>% select(c(names(indicators)[1], 
                                      names(indicators)[5:14]))

# Set the data to data table
setDT(data)
setDT(indicators)

# Clean the names of the countries
indicators <- CleanCountryNamesGDP(data, indicators)

# Merge information of the indicators into the dataset
data <- data %>% merge(indicators, by.x = "country", by.y = "Country Name") 



# Create a division between age
# TODO: Create a division between generations rather than by age
# https://en.wikipedia.org/wiki/Generation
data_age <- data %>% group_by(gender) %>% 
  summarise(young = quantile(age, 0.25, na.rm = TRUE),
            middle_age = quantile(age, 0.50, na.rm = TRUE),
            old = quantile(age, 0.75, na.rm = TRUE))

data[age <= quantile(age, 0.25, na.rm = TRUE), age_quant := "young"]
data[is.na(age_quant) & age <= quantile(age, 0.50, na.rm = TRUE), age_quant := "middle_age"]
data[is.na(age_quant), age_quant := "old"]



ggplot(data[!is.na(risktaking)], aes(fill = factor(gender))) +
  geom_histogram(aes(x = risktaking), bins = 30, position = "identity", alpha = 0.5)

ggplot(data[!is.na(age) & country == "Russia"], aes(fill = factor(gender))) +
  geom_histogram(aes(x = risktaking), position = "identity", alpha = 0.7)

ggplot(data[!is.na(risktaking) & country == "Russia"], aes(fill = factor(age_quant))) +
  geom_histogram(aes(x = risktaking), position = "identity", alpha = 0.7)

ggplot(data[!is.na(patience) & country == "Russia"], aes(fill = factor(gender))) +
  geom_histogram(aes(x = patience), position = "identity", alpha = 0.7) +
  facet_grid(vars(age_quant)) 

