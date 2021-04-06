SourceFunctions <- function(path) {
  # This function sources all the functions in (sub)-directories of path
  # 
  # ARGS
  #   path      [character]  the directory path
  #   
  # RETURN
  #   it sources all the files into the current environment
  
  files <- list.files(path, pattern = "[.][Rr]$", recursive = TRUE)
  
  for (file in files) {
    source(file.path(path, file), local = FALSE)
  }
}