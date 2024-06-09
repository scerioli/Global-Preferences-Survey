SummaryRLR <- function(dat, predictor, var1, var2) {
  # This function creates a summary output for a robust linear regression
  # performed using 2 variables. The output gives the variable names, the slope
  # coefficient estimate, the standard deviation, and the p-value (converted 
  # from the t-values of the rlm function). 
  
  mod <- rlm(eval(as.name(predictor)) ~ eval(as.name(var1)) + eval(as.name(var2)), 
             data = dat)
  # Reassign the correct name of the variable
  names(mod$coefficients)[2] <- var1
  names(mod$coefficients)[3] <- var2

  stddev_b1 <- summary(mod)$coefficients[2, 2]
  stddev_b2 <- summary(mod)$coefficients[3, 2]
  
  t_value1 <- summary(mod)$coefficients[, "t value"][2]
  p_value1 <- 2 * pt(q = t_value1, 
                    df = length(mod$residuals) - 2, 
                    lower.tail = F)
  pvalue1 <- ifelse(p_value1 < 0.0001,
                   "<0.0001",
                   sprintf("%.4f", round(p_value1, 4)))
  
  t_value2 <- summary(mod)$coefficients[, "t value"][3]
  p_value2 <- 2 * pt(q = t_value2, 
                     df = length(mod$residuals) - 2, 
                     lower.tail = F)
  pvalue2 <- ifelse(p_value2 < 0.0001,
                    "<0.0001",
                    round(p_value2, 4))
  
  beta_coef1 <- sprintf("%.2f (%.2f)", 
                       summary(mod)$coefficients[, 1][2], stddev_b1)
  beta_coef2 <- sprintf("%.2f (%.2f)", 
                        summary(mod)$coefficients[, 1][3], stddev_b2)
  
  # Save the data
  dt <- data.table(Variable = c(var1, var2),
                   `Slope coeff.` = c(beta_coef1, beta_coef2),
                   `Std Dev`    = c(stddev_b1, stddev_b2),
                   `p-value`     = c(pvalue1, pvalue2),
                   stringsAsFactors = FALSE)
  
  return(dt)
}
