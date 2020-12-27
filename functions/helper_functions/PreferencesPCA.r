PreferencesPCA <- function(dat) {
  # This function takes a data table with the coefficients of the linear model
  # for each country as an input and returns the principal component analysis
  # of the 6 preferences using the gender coefficient as main variable.
  
  dt_pca <- data.table()
  
  for (C in unique(dat$country)) {
    # Create a transposed data table on country level
    dt_tmp <- as.data.table(t(dat[country == C, .(gender)]))
    # Set new names to identify the preferences
    setnames(dt_tmp, old = names(dt_tmp), new = unique(dat$preference))
    # Add the country information
    dt_tmp[, country := C]
    
    dt_pca <- rbind(dt_pca, dt_tmp)
  }
  # Create a data table with the correct slope as in the article (aestethics only)
  dt_pca_pos <- dt_pca[, .(country, 
                           Trust                  = trust, 
                           Altruism               = altruism, 
                           `Positive Reciprocity` = posrecip, 
                           `Negative Reciprocity` = negrecip * - 1, 
                           `Risk Taking`          = risktaking * - 1, 
                           Patience               = patience * - 1)]
  
  # Perform the principal component analysis
  pca <- prcomp(dt_pca_pos[, -1], scale. = F)
  
  return(pca)
}