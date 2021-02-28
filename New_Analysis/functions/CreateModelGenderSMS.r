CreateModelGenderSMS <- function(dataComplete) {
  
  models_list_SMS <- list()
  i <- 0
  # Add the ordered predictor
  # NOTE: This cycle takes reeeeeeaally long! (~5 hours)
  for (C in unique(dataComplete$country)) {
    i <- i + 1
    
    dataList <- list(posrecip_round = dataComplete[country == C, posrecip_round],
                     gender = dataComplete[country == C, gender],
                     SMS = dataComplete[country == C, subj_math_skills],
                     alpha = rep(2, 11))
    
    m_posrecip_pred_tmp <- ulam(alist(posrecip_round ~ dordlogit(phi, kappa),
                                      phi <- bSMS * sum(delta_j[1:SMS]) + bG * gender,
                                      kappa ~ normal(0, 1.5),
                                      c(bSMS, bG) ~ normal(0, 1),
                                      vector[12]: delta_j <<- append_row(0, delta),
                                      simplex[11]: delta ~ dirichlet(alpha)),
                                data = dataList, chains = 4, cores = 4, 
                                control = list(adapt_delta = 0.99,
                                               max_treedepth = 15))
    
    # Save the model itself
    models_list_SMS[[i]] <- m_posrecip_pred_tmp
    save(m_posrecip_pred_tmp, file = paste0("model_posrecip_gender_SMS_", C, ".RData"))
  
    cat(paste0("\nCompleted ", C, " model! Step ", i, " out of ", 
          length(unique(dataComplete$country)), " completed...\n"))
  }
  
  return(models_list_SMS)
}