PlotSummary <- function(data, var1, var2, var3 = NULL, fill = "white",
                        regression = TRUE, labs = NULL, display = FALSE) {
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
  # - labs  [character]  it is a vector of two strings writing the labels of the
  #                      x- and the y-axis
  # - display [logical]  if it is set to FALSE, it doesn't return the plot.
  #                      Default is FALSE

  # RETURN
  # - plot [ggplot object] is the plot we produced


  plot <-  ggplot(data = data, aes(x = eval(as.name(var1)), y = eval(as.name(var2)))) +
    geom_text(aes(label = isocode), color = "gray20", size = 3,
              check_overlap = F, hjust = -0.5) +
    xlab(var1) + ylab(var2) +
    theme_bw() +
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
    # Create annotation for the correlation and p-value
    labels_idx <- data %>%
      do(ExtractModelSummary(., var1, var2, var3)) %>%
      setDT(.)

    xpos <- data[, min(eval(as.name(var1)))]
    ypos <- 0.95 * data[, max(eval(as.name(var2)))]

    plot <- plot +
      geom_smooth(method = "lm", color = "red") +
      geom_text(x = xpos, y = ypos, data = labels_idx, aes(label = correlation), hjust = 0) +
      geom_text(x = xpos, y = ypos - 0.12 * ypos, data = labels_idx, aes(label = pvalue), hjust = 0)
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

}
