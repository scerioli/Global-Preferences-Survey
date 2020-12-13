ExtractModelSummary <- function(dat, var1, var2 = NULL) {
    
    if (!is.null(var2)) {
        mod <- dlply(dat, var2, function(dt) 
            lm(log(avgGDPpc) ~ eval(as.name(var1)), data = dt))
        dt <- data.table(formula = character(), correlation = character(), 
                         r2 = double(), pvalue = character())
        for (i in 1:length(mod)) {
            names(mod[[i]]$coefficients)[2] <- var1
            formula <- sprintf("italic(y) == %.2f % +.2f * italic(x)",
                               round(coef(mod[[i]])[1], 5), round(coef(mod[[i]])[2], 5))
            r <- cor(log(dat[eval(as.name(var2)) == names(mod)[i], avgGDPpc]), 
                     dat[eval(as.name(var2)) == names(mod)[i], eval(as.name(var1))])
            correlation <- sprintf("correlation = %.5f", r)
            r2 <- sprintf("R^2 = %.5f", r^2)
            p_value <- summary(mod[[i]])$coefficients[,"Pr(>|t|)"][2]
            pvalue <- ifelse(p_value < 0.0001, "p < 0.0001", sprintf("p = %.4f", p_value))
            
            dt_tmp <- data.table(formula = formula, correlation = correlation, r2 = r2, 
                             pvalue = pvalue, stringsAsFactors = FALSE)
            dt <- rbind(dt, dt_tmp)
        }
        
    } else {
        mod <- lm(log(avgGDPpc) ~ eval(as.name(var1)), data = dat)
        names(mod$coefficients)[2] <- var1
        formula <- sprintf("italic(y) == %.2f % +.2f * italic(x)",
                           round(coef(mod)[1], 5), round(coef(mod)[2], 5))
        r <- cor(log(dat$avgGDPpc), dat[, eval(as.name(var1))])
        correlation <- sprintf("correlation = %.5f", r)
        r2 <- sprintf("R^2 = %.5f", r^2)
        p_value <- summary(mod)$coefficients[,"Pr(>|t|)"][2]
        pvalue <- ifelse(p_value < 0.0001, "p < 0.0001", sprintf("p = %.4f", p_value))
        
        dt <- data.table(formula = formula, correlation = correlation, r2 = r2, 
                         pvalue = pvalue, stringsAsFactors = FALSE)
    }
    
    return(dt)
}