#' Non-inflected curve function
#'
#' Creates a non inflected curve function (Exponential decay - increasing form) for the plot_yield_curves function
#'
#'@param a obtained percentage of max. yield without pollinators present
#'@param b Max. yield attained for the crop 
#'@param c Shape of the curve 
#'@param visit_rate observed visitation rate (visits in 100 flowers during 1 hour)
#'
#'@return Yield curve function for increasing number of pollinators used in the plot_yield_curves
#'
#'@export

non_inflicted_yield <- function(a, b, c, visit_rate){
  a2 <- (b*a)/100
  b2 <- b-a2
  return(a2+b2*(1-exp(-c*visit_rate)))
}
