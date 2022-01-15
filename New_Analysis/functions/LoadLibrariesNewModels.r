LoadLibrariesNewModels <- function() {
  
  # Libraries
  library(MASS)     # for the polr function
  library(lmtest)
  library(GGally)
  library(reshape2)
  library(lme4)
  require(compiler)
  require(parallel)
  require(boot)
  require(lattice)
  library(nnet)     # for the multinom function
  library(stargazer)
  library(oglmx)    # for oglm function
  library(ordinal)  # for clm function
  # library(brms)     # for the brm function
}
