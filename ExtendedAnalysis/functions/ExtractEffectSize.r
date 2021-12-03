ExtractEffectSize <- function(data, preference) {
  
  N1 <- data[gender == 0 & GDPquant == 4, .N]
  N2 <- data[gender == 1 & GDPquant == 4, .N]
  
  M1 <- data[gender == 0 & GDPquant == 4, mean(eval(as.name(preference)))]
  M2 <- data[gender == 1 & GDPquant == 4, mean(eval(as.name(preference)))]
  S1 <- data[gender == 0 & GDPquant == 4, sd(eval(as.name(preference)))]
  S2 <- data[gender == 1 & GDPquant == 4, sd(eval(as.name(preference)))]
  Sp <- sqrt( ( (N1 - 1) * S1^2 + (N2 - 1) * S2^2 ) / (N1 + N2 -2) )
  d_cohen <- M1 - M2 / Sp
  
  return(d_cohen)
}