CleanCountryNamesGDP <- function(data, indicators) {
  # Function to clean the country names from GDP data to be equivalent to the
  # names in the Global Preferences Survey
  # 
  # ARGS:
  # - data       [data table] Data from the Global Preferences Survey
  # - indicators [data table] Data from the GDP
  # 
  # RETURN:
  # - indicators [data table]
  
  
  # Check the names of the countries (this is just for exploratory purpose)
  # data[, unique(country)]
  # indicators[, unique(`Country Name`)][1:217]
  
  # Only the first 217 names are actual country names, so we start with keeping 
  # these
  indicators <- indicators[1:217]
  
  # First intersection of common country names (exploratory purpose)
  # intersect(data[, unique(country)], indicators[, unique(`Country Name`)])
  
  # Countries in the first dataset that are not in the second one
  # These countries are the ones that we need to match "by hand"
  outOfSet_countries <- setdiff(data[, unique(country)], indicators[, unique(`Country Name`)])
  
  # Substitute the country names
  indicators[`Country Name` == "Venezuela, RB", `Country Name` := outOfSet_countries[1]]
  indicators[`Country Name` == "Bosnia and Herzegovina", `Country Name` := outOfSet_countries[2]]
  indicators[`Country Name` == "Iran, Islamic Rep.", `Country Name` := outOfSet_countries[3]]
  indicators[`Country Name` == "Korea, Rep.", `Country Name` := outOfSet_countries[4]]
  indicators[`Country Name` == "Russian Federation", `Country Name` := outOfSet_countries[5]]
  indicators[`Country Name` == "Egypt, Arab Rep.", `Country Name` := outOfSet_countries[6]]
  
  
  return(indicators)
}