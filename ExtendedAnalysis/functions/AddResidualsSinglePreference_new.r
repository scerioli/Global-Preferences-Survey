AddResidualsSinglePreference_new <- function(dt, robust = FALSE) {
  # This function adds to the summary of the data the residuals from the
  # regression performed on various variables of interest.
  # It returns the summary of the data including these residuals.
  # If the argument robust is set to TRUE, the residuals are calculated using a
  # robust linear regression, otherwise a simple OLS is performed. 
  
  dt_tmp <- data.table(country = unique(dt$country))
  
  # Single preference average gender difference residualised 
  for (pref in unique(dt$preference)) {
    # using the Gender Equality Index
    dt_tmpGEI <- Residualise(dt[preference == pref], 
                             var1 = "GenderIndexStd",
                             var2 = "gender",
                             robust = robust)
    new_nameGEI <- paste0("residualsgenderGEI_", pref)
    dt_tmpGEI[, ((new_nameGEI)) := residualsgender]
    dt_tmpGEI <- select(dt_tmpGEI, "country", ((new_nameGEI)))
    
    # using the Gender Development Index
    dt_tmpGDI <- Residualise(dt[preference == pref], 
                             var1 = "GDIStd",
                             var2 = "gender",
                             robust = robust)
    new_nameGDI <- paste0("residualsgenderGDI_", pref)
    dt_tmpGDI[, ((new_nameGDI)) := residualsgender]
    dt_tmpGDI <- select(dt_tmpGDI, "country", ((new_nameGDI)))
    
    # using the WEF Score
    dt_tmpWEF <- Residualise(dt[preference == pref], 
                             var1 = "ScoreWEFStd",
                             var2 = "gender",
                             robust = robust)
    new_nameWEF <- paste0("residualsgenderWEF_", pref)
    dt_tmpWEF[, ((new_nameWEF)) := residualsgender]
    dt_tmpWEF <- select(dt_tmpWEF, "country", ((new_nameWEF)))
    
    # using the UNDP value
    dt_tmpUN <- Residualise(dt[preference == pref], 
                            var1 = "ValueUNStd",
                            var2 = "gender",
                            robust = robust)
    new_nameUN <- paste0("residualsgenderUN_", pref)
    dt_tmpUN[, ((new_nameUN)) := residualsgender]
    dt_tmpUN <- select(dt_tmpUN, "country", ((new_nameUN)))
    
    # using the logGDP
    dt_tmpGDP <- Residualise(dt[preference == pref], 
                             var1 = "logAvgGDPpcStd",
                             var2 = "gender",
                             robust = robust)
    
    new_nameGDP <- paste0("residualsgenderGDP_", pref)
    dt_tmpGDP[, ((new_nameGDP)) := residualsgender]
    dt_tmpGDP <- select(dt_tmpGDP, "country", ((new_nameGDP)))
    
    # ------- #
    
    # LogGDP residualised using the Gender Equality Index
    dt_logGDP_GEI <- Residualise(dt[preference == pref], 
                                 var1 = "GenderIndexStd",
                                 var2 = "logAvgGDPpcStd",
                                 robust = robust)
    new_nameGEI <- paste0("residualslogAvgGDPpc_GEI_", pref)
    dt_logGDP_GEI[, ((new_nameGEI)) := residualslogAvgGDPpcStd]
    dt_logGDP_GEI <- select(dt_logGDP_GEI, "country", ((new_nameGEI)))
    
    # Gender Equality Index residualised using logGDP
    dt_GEI_logGDP <- Residualise(dt[preference == pref], 
                                 var1 = "logAvgGDPpcStd",
                                 var2 = "GenderIndexStd",
                                 robust = robust)
    new_nameGDP <- paste0("residualsGenderIndex_GDP_", pref)
    dt_GEI_logGDP[, ((new_nameGDP)) := residualsGenderIndexStd]
    dt_GEI_logGDP <- select(dt_GEI_logGDP, "country", ((new_nameGDP)))
    
    
    # LogGDP residualised using the WEF Index
    dt_logGDP_WEF <- Residualise(dt[preference == pref], 
                                 var1 = "ScoreWEFStd",
                                 var2 = "logAvgGDPpcStd",
                                 robust = robust)
    new_nameWEF <- paste0("residualslogAvgGDPpc_WEF_", pref)
    dt_logGDP_WEF[, ((new_nameWEF)) := residualslogAvgGDPpcStd]
    dt_logGDP_WEF <- select(dt_logGDP_WEF, "country", ((new_nameWEF)))
    
    # WEF Index residualised using logGDP
    dt_WEF_logGDP <- Residualise(dt[preference == pref], 
                                 var1 = "logAvgGDPpcStd",
                                 var2 = "ScoreWEFStd",
                                 robust = robust)
    new_nameGDP <- paste0("residualsWEF_GDP_", pref)
    dt_WEF_logGDP[, ((new_nameGDP)) := residualsScoreWEFStd]
    dt_WEF_logGDP <- select(dt_WEF_logGDP, "country", ((new_nameGDP)))
    
    
    # LogGDP residualised using the UNDP Index
    dt_logGDP_UN <- Residualise(dt[preference == pref], 
                                var1 = "ValueUNStd",
                                var2 = "logAvgGDPpcStd",
                                robust = robust)
    new_nameUN <- paste0("residualslogAvgGDPpc_UN_", pref)
    dt_logGDP_UN[, ((new_nameUN)) := residualslogAvgGDPpcStd]
    dt_logGDP_UN <- select(dt_logGDP_UN, "country", ((new_nameUN)))
    
    # UNDP Index residualised using logGDP
    dt_UN_logGDP <- Residualise(dt[preference == pref], 
                                var1 = "logAvgGDPpcStd",
                                var2 = "ValueUNStd",
                                robust = robust)
    new_nameGDP <- paste0("residualsUN_GDP_", pref)
    dt_UN_logGDP[, ((new_nameGDP)) := residualsValueUNStd]
    dt_UN_logGDP <- select(dt_UN_logGDP, "country", ((new_nameGDP)))
    
    
    # LogGDP residualised using the Gender Development Index
    dt_logGDP_GDI <- Residualise(dt[preference == pref], 
                                 var1 = "GDIStd",
                                 var2 = "logAvgGDPpcStd",
                                 robust = robust)
    new_nameGDI <- paste0("residualslogAvgGDPpc_GDI_", pref)
    dt_logGDP_GDI[, ((new_nameGDI)) := residualslogAvgGDPpcStd]
    dt_logGDP_GDI <- select(dt_logGDP_GDI, "country", ((new_nameGDI)))
    
    # Gender Development Index residualised using logGDP
    dt_GDI_logGDP <- Residualise(dt[preference == pref], 
                                 var1 = "logAvgGDPpcStd",
                                 var2 = "GDIStd",
                                 robust = robust)
    new_nameGDP <- paste0("residualsGDI_GDP_", pref)
    dt_GDI_logGDP[, ((new_nameGDP)) := residualsGDIStd]
    dt_GDI_logGDP <- select(dt_GDI_logGDP, "country", ((new_nameGDP)))
    
    list_dt <- list(dt_tmpGDP, dt_tmpGEI, dt_tmpWEF, dt_tmpUN, dt_tmpGDI,
                    dt_logGDP_GEI, dt_GEI_logGDP, dt_logGDP_WEF, dt_WEF_logGDP,
                    dt_logGDP_UN, dt_UN_logGDP, dt_logGDP_GDI, dt_GDI_logGDP)
    
    for (dataset in list_dt) {
      dt_tmp <- merge(dt_tmp, dataset, by = "country", all.x = TRUE)
    }
 
    rm(dt_logGDP_GEI)
    rm(dt_logGDP_GDI)
    rm(dt_logGDP_UN)
    rm(dt_logGDP_WEF)
    rm(dt_GEI_logGDP)
    rm(dt_GDI_logGDP)
    rm(dt_UN_logGDP)
    rm(dt_WEF_logGDP)
  }
  
  dt <- merge(dt, dt_tmp, by = "country", all = TRUE)
  
  return(dt)
}
