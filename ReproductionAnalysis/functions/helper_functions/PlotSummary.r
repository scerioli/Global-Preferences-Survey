PlotSummary <- function(data, var1, var2, var3 = NULL, fill = "white",
                        regression = TRUE, robust = FALSE, corr = TRUE, 
                        labs = NULL, display = FALSE, save = NULL) {
  # This function is plotting in a standardized way the meaningful variables.
  # The function takes as input a data table, 2 columns of it that should be the
  # x-axis and the y-axis, a 3rd column that can be NULL, and a column that
  # should indicate if one wants to specify the filling of the points (otherwise
  # just white is taken).
  #
  # ARGS
  # - dat   [data table] is the data we are giving to be plotted
  # - var1  [character]  the variable on the x-axis
  # - var2  [character]  the variable on the y-axis
  # - var3  [character]  is the column name of the variable that we want to
  #                      group by, in case we are producing many plots. This
  #                      variable, if not NULL, permits to display the facets.
  #                      Default is NULL and means that only one plot (and
  #                      model) is produced
  # - fill  [character]  is the column name of the variable we want to highlight
  #                      while plotting.
  #                      Default is "white"
  # - regression [logical] to plot the regression line and the coefficients
  #                        related to that or not
  # - corr [logical]     to plot the regression line ans the correlation (TRUE)
  #                      or the slope of the regression line (FALSE). Only valid
  #                      if regression is TRUE
  # - robust [logical]   if the regression to be done and plotted is simple
  #                      (OLS) or robust. Default is FALSE (simple regression).
  #                      To be used in combination with regression.
  # - labs  [character]  it is a vector of two strings writing the labels of the
  #                      x- and the y-axis
  # - display [logical]  if it is set to FALSE, it doesn't return the plot.
  #                      Default is FALSE
  # - save [logical]     if it is not NULL, it saves the current plot with
  #                      the name indicated in parenthesis. Default is NUL

  # RETURN
  # - plot [ggplot object] is the plot we produced


  plot <- ggplot(data = data, aes(x = eval(as.name(var1)), y = eval(as.name(var2)))) +
    geom_text(aes(label = isocode), color = "gray20", size = 3,
              check_overlap = F, hjust = -0.5) +
    xlab(var1) + ylab(var2) +
    theme_bw() +
    theme(panel.grid.major = element_blank(), 
          panel.grid.minor = element_blank()) +
    scale_fill_brewer(palette = "Set1")

  if (fill == "white") {
    plot <- plot +
      geom_point(shape = 21, size = 3, fill = fill) +
      labs(fill = "")
  } else {
    plot <- plot +
      geom_point(data = data, shape = 21, size = 3, aes(fill = eval(as.name(fill)))) +
      labs(fill =  fill)
  }

  if (!is.null(var3)) {
    # Rename the preferences
    preferences_names <- c(
      `altruism` = "Altruism (+)", 
      `trust` = "Trust (+)", 
      `posrecip` = "Pos. Recip. (+)",
      `negrecip` = "Neg. Recip. (-)", 
      `risktaking` = "Risk Taking (-)", 
      `patience` = "Patience (-)"
    )
    
    plot <- plot + 
      facet_wrap(~ eval(as.name(var3)), ncol = 2, labeller = as_labeller(preferences_names)) +
      theme(legend.title = element_blank(),
            strip.background = element_rect(colour = "white", fill = "white"),
            legend.position = "none",
            strip.text.x = element_text(size = 12))
  }

  if (regression) {
    # Perform a robust linear regression
    if (robust) {
      # Create annotation for the correlation and p-value
      labels_idx <- data %>%
        do(ExtractModelSummary(., var1, var2, var3, robust = TRUE)) %>%
        setDT(.)
      
      # Take only complete cases of the dataset to prevent NAs to appear
      xpos <- data[complete.cases(c(eval(as.name(var1))), eval(as.name(var2))), 
                   min(eval(as.name(var1)))]
      ypos <- 0.95 * data[complete.cases(c(eval(as.name(var1))), eval(as.name(var2))), 
                          max(eval(as.name(var2)))]
      
      if (corr) {
        plot <- plot +
          geom_smooth(method = MASS::rlm, color = "red") +
          geom_text(x = xpos, y = ypos, data = labels_idx, aes(label = correlation), hjust = 0) +
          geom_text(x = xpos, y = ypos - 0.12 * ypos, data = labels_idx, aes(label = pvalue), hjust = 0)
      } else {
        plot <- plot +
          geom_smooth(method = MASS::rlm, color = "red") +
          geom_text(x = xpos, y = ypos, data = labels_idx, aes(label = beta_coef), hjust = 0) +
          geom_text(x = xpos, y = ypos - 0.12 * ypos, data = labels_idx, aes(label = pvalue), hjust = 0)
      }
      # Perform a OLS
    } else {
      # Create annotation for the correlation and p-value
      labels_idx <- data %>%
        do(ExtractModelSummary(., var1, var2, var3)) %>%
        setDT(.)
      
      # Take only complete cases of the dataset to prevent NAs to appear
      xpos <- data[complete.cases(c(eval(as.name(var1))), eval(as.name(var2))), 
                   min(eval(as.name(var1)))]
      ypos <- 0.95 * data[complete.cases(c(eval(as.name(var1))), eval(as.name(var2))), 
                          max(eval(as.name(var2)))]
      
      if (corr) {
        plot <- plot +
          geom_smooth(method = "lm", color = "red") +
          geom_text(x = xpos, y = ypos, data = labels_idx, aes(label = correlation), hjust = 0) +
          geom_text(x = xpos, y = ypos - 0.12 * ypos, data = labels_idx, aes(label = pvalue), hjust = 0)
      } else {
        plot <- plot +
          geom_smooth(method = "lm", color = "red") +
          geom_text(x = xpos, y = ypos, data = labels_idx, aes(label = beta_coef), hjust = 0) +
          geom_text(x = xpos, y = ypos - 0.12 * ypos, data = labels_idx, aes(label = pvalue), hjust = 0)
      }
    }
    
    
  }

  if (!is.null(labs)) {
    if (length(labs) == 3) {
      plot <- plot + labs(x = labs[[1]], y = labs[[2]], title = labs[[3]])
    } else {
      plot <- plot + labs(x = labs[[1]], y = labs[[2]])
    }
    
  }

  if (display) {
    return(plot)
  }
  
  if (!is.null(save)) {
    ggsave(filename = eval(as.character(save)), plot = plot)
  }

}
