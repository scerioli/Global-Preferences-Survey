PlotSummary <- function(data, var1, var2, var3 = NULL, fill = "white") {
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
  # RETURN
  # - plot [ggplot object] is the plot we produced

  # Create annotation for the correlation and p-value
  labels_idx <- data %>% 
    do(ExtractModelSummary(., var1, var2, var3)) %>%
    setDT(.)
  
  xpos <- data[, min(eval(as.name(var1)))]
  ypos <- 0.9 * data[, max(eval(as.name(var2)))]
  
  # Plot the results
  plot <-  ggplot(data = data, aes(x = eval(as.name(var1)), y = eval(as.name(var2)))) +
    geom_smooth(method = "lm", color = "red") +
    geom_text(aes(label = isocode), color = "gray20", size = 3, 
              check_overlap = F, hjust = -0.5) +
    geom_text(x = xpos, y = ypos, data = labels_idx, aes(label = correlation), hjust = 0) +
    geom_text(x = xpos, y = ypos - 0.1 * ypos, data = labels_idx, aes(label = pvalue), hjust = 0) +
    xlab(var1) + ylab(var2) +
    theme_bw() +
    scale_fill_brewer(palette = "Set1")
  
  # TODO: To modify the name of the legend
  if (fill == "white") {
    plot <- plot + geom_point(shape = 21, size = 3, fill = fill)
  } else {
    plot <- plot + geom_point(data = data, shape = 21, size = 3, aes(fill = eval(as.name(fill))))
  }
  
  if (!is.null(var3)) {
    plot <- plot + facet_wrap(vars(eval(as.name(var3))), ncol = 3)
  }
  
  return(plot)
}