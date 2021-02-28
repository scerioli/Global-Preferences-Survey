CreateModelGender_SimpleModels <- function(dataComplete) {
  # This function creates a model for each country including only gender as a 
  # predictor for the categorical ordered variable "posrecip".
  
  dt_posrecip_coeff <- c()
  models_list_gender <- list()
  i <- 0
  
  # This cycle will take a while... (~10 minutes)
  for (C in unique(dataComplete$country)) {
    
    i <- i + 1

    # Create the starting model
    m_posrecip_tmp <- map(alist(posrecip_round ~ dordlogit(phi, c(a1, a2, a3, a4,
                                                                  a5, a6, a7, a8)),
                                phi <- 0,
                                c(a1, a2, a3, a4, a5, a6, a7, a8) ~ dnorm(0, 10)),
                          data = dataComplete[country == C],
                          start = list(a1 = -4, a2 = -3, a3 = -2, a4 = 0, a5 = 2,
                                       a6 = 3, a7 = 4, a8 = 4.5))

    # Add the predictors
    m_posrecip_pred_tmp <- map(alist(posrecip_round ~ dordlogit(phi, c(a1, a2, a3, a4,
                                                                       a5, a6, a7, a8)),
                                     phi <- bG * gender,
                                     c(bG) ~ dnorm(0, 10),
                                     c(a1, a2, a3, a4, a5, a6, a7, a8) ~ dnorm(0, 10)),
                               data = dataComplete[country == C],
                               start = as.list(m_posrecip_tmp@coef))
    
    # Save the coefficients, the country and the preference in a data table
    dt_coeff_tmp <- data.table(country = C,
                               namesCoeff = names(m_posrecip_pred_tmp@coef),
                               coefficients = m_posrecip_pred_tmp@coef,
                               sd = precis(m_posrecip_pred_tmp, depth = 2)[[2]],
                               preference = "posrecip")
    
    # Save the model itself
    models_list_gender[[i]] <- m_posrecip_pred_tmp
    save(m_posrecip_pred_tmp, 
         file = paste0("tmp/SimpleModels/models_gender/model_posrecip_gender_", C, ".RData"))
    
    # Save the data table
    dt_posrecip_coeff <- rbind(dt_posrecip_coeff, dt_coeff_tmp)
    
    
    cat(paste0("\nCompleted ", C, " model! Step ", i, " out of ", 
               length(unique(dataComplete$country)), " completed...\n"))
  }
  
  return(list(dataTable = dt_posrecip_coeff, model = models_list_gender))
}