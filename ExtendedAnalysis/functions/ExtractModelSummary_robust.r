ExtractModelSummary_robust <- function(dat, var1, var2, var3 = NULL) {
  # This function has the purpose to extract the important parameters from the
  # model(s). If var3 is given, it means that there is the need to make the
  # model run on the same variable grouped by different rows.
  #
  # ARGS
  # - dat   [data table] is the data we are giving to the model
  # - var1  [character]  the independent variable
  # - var2  [character]  is the column name of the variable we want to put
  #                      in the model in correlation to var1
  # - var3  [character]  is the column name of the variable that we want to
  #                      group by. Default is NULL and means that only one
  #                      model is produced
  # RETURN
  # - dt    [data table] a data table with the statistical values of interest.
  #                      If var3 is not NULL, the number of rows of this data
  #                      table is the same number as the unique values in the
  #                      column given by var3
  
  if (!is.null(var3)) {
    mod <- dlply(dat, var3, function(dt)
      rlm(eval(as.name(var1)) ~ eval(as.name(var2)), data = dt))
    dt <- data.table(formula     = character(),
                     correlation = character(),
                     r2          = double(),
                     pvalue      = character())
    dt[, ((var3)) := character()]
    # For each model, save a data table containing the statistical values
    # of interest
    for (i in 1:length(mod)) {
      # Reassign the correct name of the variable
      names(mod[[i]]$coefficients)[2] <- var2
      formula <- sprintf("y == %.2f % +.2f * x",
                         round(coef(mod[[i]])[1], 5),
                         round(coef(mod[[i]])[2], 5))
      r <- cor(x = dat[eval(as.name(var3)) == names(mod)[i],
                       eval(as.name(var1))],
               y = dat[eval(as.name(var3)) == names(mod)[i],
                       eval(as.name(var2))])
      correlation <- sprintf("correlation = %.5f", r)
      r2 <- sprintf("R^2 = %.5f", r^2)
      p_value <- summary(mod[[i]])$coefficients[,"Pr(>|t|)"][2]
      pvalue <- ifelse(p_value < 0.0001,
                       "p < 0.0001",
                       sprintf("p = %.4f", p_value))
      # Save the data
      dt_tmp <- data.table(formula     = formula,
                           correlation = correlation,
                           r2          = r2,
                           pvalue      = pvalue,
                           stringsAsFactors = FALSE)
      dt_tmp[, ((var3)) :=  names(mod)[i],]
      dt <- rbind(dt, dt_tmp)
    }
    
  } else {
    mod <- rlm(eval(as.name(var1)) ~ eval(as.name(var2)), data = dat)
    # Reassign the correct name of the variable
    names(mod$coefficients)[2] <- var2
    formula <- sprintf("y == %.2f % +.2f * x",
                       round(coef(mod)[1], 5),
                       round(coef(mod)[2], 5))
    r <- cor(x = dat[, eval(as.name(var1))],
             y = dat[, eval(as.name(var2))])
    correlation <- sprintf("correlation = %.5f", r)
    r2 <- sprintf("R^2 = %.5f", r^2)
    p_value <- summary(mod)$coefficients[,"Pr(>|t|)"][2]
    pvalue <- ifelse(p_value < 0.0001,
                     "p < 0.0001",
                     sprintf("p = %.4f", p_value))
    # Save the data
    dt <- data.table(formula     = formula,
                     correlation = correlation,
                     r2          = r2,
                     pvalue      = pvalue,
                     stringsAsFactors = FALSE)
  }
  
  return(dt)
}
