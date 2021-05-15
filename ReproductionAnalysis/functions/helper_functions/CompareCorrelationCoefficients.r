CompareCorrelationCoefficients <- function(corr1, corr2, n1, n2) {
  
  r_prime1 <- 0.5 * log((1 + corr1) / (1 - corr1))
  r_prime2 <- 0.5 * log((1 + corr2) / (1 - corr2))
  
  z <- (r_prime1 - r_prime2) / sqrt((1 / (n1 - 3)) + (1 / (n2 - 3)))
  
  return(z)
}
