#' Calculatiion of efficiency parameter for subsequent pollinator visits
#' 
#' Auxiliary function to calculate the penalisation parameter "eff" for subsequent visits 
#' in dependence of the parameters:
#' 
#' @param svd Single Visit Pollen Deposition of different bee species on a certain crop obtained from data measured in the field 
#' @param ovu mean number of ovules of the inspected crop
#' @param self number of pollen grains present on the stigmas before first bee visit to account for selfing (default = 0)
#' @param eff (ovu-self)/(svd + ovu - self) minimum efficiency to achieve full fertilization
#' @param x number of accumulated visits
#' 
#' @return  the proportion of fertilized ovules after x visits
#' 
#' to be used in curve_ovule_parameters.R function
#' @examples data_crop <- curve_ovule_parameters("Blueberry",0)
#'
#' i=14 # Visitor: Colletes sp. 
#'
#' svd <- data_crop$svd[i]
#' ovu <- data_crop$ovu[i]
#' self <- data_crop$self[i]
#' example_1 <- tibble(visits=c(0:60),
#'                    perc_fecundated_ovules = evolution_ovules(svd,ovu,self,1,c(0:60)),
#'                    efficiency = paste0("eff. = 1.00"))
#'
#' ggplot(example_1, aes(x=visits,y=perc_fecundated_ovules,color =efficiency))+
#' geom_point()+
#' geom_line()+
#' labs(x="Visits",y="Percentage of fecundated ovules",
#'      color="Fertilization\n Efficiency",
#'      title = data_crop$Species[i])
#'
#'
#' @export
evolution_ovules <- function(svd,ovu,self,eff,x){
  
  if(eff==1){
    
    aux <- 100*((self+svd*x)/ovu)
    aux[aux > 100] <- 100
    return(aux)
    
  }else{
    
    aux <- (100*((self/ovu) + (svd*eff/ovu)*(eff^x-1)/(eff-1)))
    aux[aux>100] <- 100
    return(aux)
    
  }
  
}
