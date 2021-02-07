SourceFunctions <- function(path, print = TRUE) {
  # This function sources all the functions in (sub)-directories of path
  # 
  # ARGS
  #   path      [character]  the directory path
  #   print     [logical]    print sourced files if TRUE (default)
  #   recursive [logical]    source sub-directories if TRUE (default)
  #   
  # RETURN
  #   it sources all the files into the current environment
  
  files <- list.files(path, pattern = "[.][Rr]$", recursive = TRUE)
  
  for (file in files) {
    if (print) {
      cat(file)
    } 
    
    source(file.path(path, file), local = FALSE)
    
    if (print) {
      cat("\n")
    } 
  }
}