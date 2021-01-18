Normalize <- function(x) {
  # Function returning the normalized value from the input
  return ((x - min(x, na.rm = TRUE)) / (max(x, na.rm = TRUE) - min(x, na.rm = TRUE))) }
