AdjustColumns <- function(data) {
  # Add new columns and set the type of variables for both new and existent ones
  
  # Shift the values to have a scale of 0-10
  data[, trustRaw := round(((trust - min(trust)) / 
                              (max(trust) - min(trust))) * 10),
       by = "country"]
  
  # Add the age as category
  data[age <= 32, ageCateg := 1]
  data[age > 32 & age <= 53, ageCateg := 2]
  data[age > 53, ageCateg := 3]

  # Set the correct type for each column
  data[, `:=` (trustNumb = trustRaw,
               gender    = as.factor(gender),
               age       = as.numeric(age),
               ageCateg  = as.factor(ageCateg))]
  
  # Set explicitly the order of the categories
  data$trustRaw <- factor(data$trustRaw, ordered = TRUE, 
                          levels = c("0", "1", "2", "3", "4", "5", 
                                     "6", "7", "8", "9", "10"))
  data$ageCateg <- factor(data$ageCateg, ordered = TRUE,
                          levels = c("1", "2", "3"))
  
  return(data)
}