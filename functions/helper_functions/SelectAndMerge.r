SelectAndMerge <- function(dt, dt_residuals) {
  # Select the interesting columns to keep
  dt_residuals <- dt_residuals %>% select(c(starts_with("residuals"), "country"))
  # Merge the two data tables
  dt <- merge(dt, dt_residuals, by = "country")

  return(dt)
}
