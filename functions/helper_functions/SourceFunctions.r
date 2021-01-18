SourceFunctions <- function(path, trace = TRUE, recursive = TRUE, 
                            local = FALSE) {
  # sources all functions in (sub)-directories of $path
  # 
  # ARGS:
  #   path      = [type: char] # directory path
  #   trace     = [type: logi] # print sourced files if TRUE (default)
  #   recursive = [type: logi] # source sub-directories if TRUE (default)
  # RETURN:
  #   nothing, just sources all files into current environment
  
  files <- list.files(path, pattern="[.][Rr]$", recursive = recursive)
  
  for (file in files) {
    if (trace) cat(file)
    source(file.path(path, file), local = local)
    if (trace) cat("\n")
  }
}