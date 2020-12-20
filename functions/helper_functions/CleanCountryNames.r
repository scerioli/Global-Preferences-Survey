CleanCountryNames <- function(data, indicator) {
  # Function to clean the country names from GDP data to be equivalent to the
  # names in the Global Preferences Survey
  # 
  # ARGS:
  # - data       [data table] Data from the Global Preferences Survey
  # - indicator  [data table] Data to be cleaned
  # 
  # RETURN:
  # - indicator  [data table]
  
  # Countries in the first dataset that are not in the second one
  # These countries are the ones that we need to match "by hand"
  outOfSet_countries <- setdiff(data[, unique(country)], 
                                indicator[, unique(`Country Name`)])
  outOfSet_countries <- sort(outOfSet_countries)
  
  # Substitute the country names
  indicator[`Country Name` %like% "Bosnia and Herzegovina", `Country Name` := outOfSet_countries[1]]
  indicator[`Country Name` %like% "Egypt, Arab Rep.", `Country Name` := outOfSet_countries[2]]
  indicator[`Country Name` %like% "Iran, Islamic Rep.", `Country Name` := outOfSet_countries[3]]
  indicator[`Country Name` %like% "Russian Federation", `Country Name` := outOfSet_countries[4]]
  indicator[`Country Name` %like% "Korea, Rep.", `Country Name` := outOfSet_countries[5]]
  indicator[`Country Name` %like% "Venezuela, RB", `Country Name` := outOfSet_countries[6]]
  
  
  return(indicator)
}