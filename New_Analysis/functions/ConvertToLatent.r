ConvertToLatent <- function(model) {
  
  thresholds <- model$alpha
  slopes <- model$beta
  intercept <- 1.0
  sigma <- 0.0
  K <- length(thresholds) + 1
  sigmaNew <- unname((K - 2) / (thresholds[K - 1] - thresholds[1]))
  interceptNew <- unname(0.5 - (sigmaNew * thresholds[1]))
  
  respThresh <- sigmaNew * thresholds + interceptNew
  respSigma <- sigmaNew * sigma
  
  respB0 <- sigmaNew * intercept + interceptNew
  respSlopes <- sigmaNew * slopes
  
  return(list(sigma = respSigma,
              b0 = respB0,
              coefficients = respSlopes,
              thresholds = respThresh))
}