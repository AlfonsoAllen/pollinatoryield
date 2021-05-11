#'Shape parameter (c) for an exponential decay (increasing form)
#' 
#'Creates the shape parameter c for the non_inflected yield function
#'
#'@param a percentage of yield without pollinators
#'@param b Max. yield attained for the crop
#'@param visit_rate_full_fer visits in 100 flowers during 1 hour for full fertilization (Garibaldi 2019) 
#'@param threshold percentage of yield that is considered full fertilization (standard value = 99)
#'
#'@return parameter c for non_inflicted_yield function
#'@export
shape_par_exp_decay <- function(a, b, visit_rate_full_fer, threshold = 99){
  a2 <- (b*a)/100
  b2 <- b-a2
  per <- threshold/100
  return((-1/visit_rate_full_fer)*log((1 - per)*(a2+b2)/b2))
}
