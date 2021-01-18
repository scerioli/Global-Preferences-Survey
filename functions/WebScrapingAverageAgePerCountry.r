WebScrapingAverageAgePerCountry <- function() {
  # This function is scraping the webpage https://www.worlddata.info/average-age.php
  # to extract information about the world average age per country.
  # There is no input argument to pass, and it returns a csv file where a list 
  # of countries and their relative average age (in years) is provided.
  # As the page state, the data are from 2013.
  
  # Define the url of the page you want to scrape
  url <- 'https://www.worlddata.info/average-age.php'
  webpage <- read_html(url)
  
  # Access the data and transform them to text
  rank_data_html <- html_nodes(webpage, 'script')
  # Choose the specific script needed among the ones provided by the page
  rank_data <- html_text(rank_data_html[[2]])
  
  # First raw splits to isolate the interesting data
  split1 <- strsplit(rank_data, "data.addRows")
  split2 <- strsplit(split1[[1]][[2]], "var options")[[1]][[1]]
  
  # Clean the data
  listOfCountries <- strsplit(split2, "\\[\\{v:")
  listOfCountries <- strsplit(listOfCountries[[1]], "\\'*\\'")[-1]
  listOfCountries <- lapply(listOfCountries, function(x) {
    gsub(",d\\+", "", gsub("\\},*", "", x))
  })
  
  # Create a data table with those element of the list that are interesting
  dt_complete <- data.table()
  
  for (element in listOfCountries) {
    tmp <- data.table(country = element[4],
                      averageAge = element[5])
    dt_complete <- rbind(tmp, dt_complete)
  }
  
  fwrite(dt_complete, file = "files/World_Ages/average_ages.csv")
  
}