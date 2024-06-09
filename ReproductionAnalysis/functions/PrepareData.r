PrepareData <- function(data_all) {
  # This function prepares the data by cleaning the country names to be 
  # homogeneous across different data sets, it calculates the mean of some
  # indicators, and in general it prepares the data to be handled with less
  # ambiguity later on.
  
  data          <- as.data.table(data_all$data)
  indicators    <- as.data.table(data_all$indicators)
  timeWomenSuff <- as.data.table(data_all$timeWomenSuff)
  ratioLabor    <- as.data.table(data_all$ratioLabor)
  world_area    <- as.data.table(data_all$world_area)
  WEF           <- as.data.table(data_all$WEF)
  UNindex       <- as.data.table(data_all$UNindex)
  
  ## ----------------------------- 1.1 GDP data ------------------------------- ##
  # Select specific columns of indicators
  indicators <- indicators %>% select(c(names(indicators)[1], 
                                        names(indicators)[5:14]))
  
  # New names for the columns indicating the GDP
  newColsNames <- sapply(strsplit(split = "\\ \\[YR", x = names(indicators)[-1]), 
                         `[`, 1)
  setnames(indicators, old = names(indicators)[-1], new = newColsNames)
  
  # Set the data to data table
  setDT(data)
  setDT(indicators)
  
  # Only the first 217 names are actual country names
  indicators <- indicators[1:217]
  # Clean the names of the countries
  indicators <- CleanCountryNames(data, indicators)
  
  # Calculate the average GDP p/c
  avgGDP <- rowMeans(indicators[, -1])
  indicators[, avgGDPpc := avgGDP]
  
  # Merge information of the indicators into the dataset
  data <- data %>% merge(indicators, by.x = "country", by.y = "Country Name") %>%
    select(country, isocode, region, language, patience, risktaking, posrecip, 
           negrecip, altruism, trust, subj_math_skills, gender, age, avgGDPpc)
  # ---------------------------------------------------------------------------- #
  
  ## ---------------- 1.2 Time since women's complete suffrage ---------------- ##
  # Merge time since women's suffrage into the main dataset
  setnames(timeWomenSuff, old = "Country", new = "country")
  # ---------------------------------------------------------------------------- #
  
  ## ----------------------- 1.3 WEF Gender Gap Index ------------------------- ##
  setnames(WEF, old = "Economy", new = "country")
  # ---------------------------------------------------------------------------- #
  
  ## ------------------------- 1.4 Ratio Labor M/F ---------------------------- ##
  # Select specific columns of indicators
  ratioLabor <- ratioLabor %>% select(c(names(ratioLabor)[1:2],
                                        names(ratioLabor)[48:57]))
  setnames(ratioLabor, old = names(ratioLabor), new = as.character(ratioLabor[1]))
  ratioLabor <- ratioLabor[-1]
  
  # Clean the names
  ratioLabor <- CleanCountryNames(data, ratioLabor)
  setnames(ratioLabor, old = "Country Name", new = "country")
  
  # Calculate average
  avgRatioLabor <- rowMeans(ratioLabor[, c(-1,-2)])
  ratioLabor[, avgRatioLabor := avgRatioLabor]
  ratioLabor <- ratioLabor[, c(1, 13)]
  # ---------------------------------------------------------------------------- #
  
  ## ------------------ 1.5 UN Gender Inequality Index ------------------------ ##
  setnames(UNindex, old = "Country", new = "country")
  # ---------------------------------------------------------------------------- #
  
  data_all$data          <- data
  data_all$indicators    <- indicators
  data_all$timeWomenSuff <- timeWomenSuff
  data_all$ratioLabor    <- ratioLabor
  data_all$world_area    <- world_area
  data_all$WEF           <- WEF
  data_all$UNindex       <- UNindex
  
  
  return(data_all)
}