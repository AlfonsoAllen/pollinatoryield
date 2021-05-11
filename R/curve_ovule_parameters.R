#' Estimation of max. and min. numbers of visits for full fertilization
#'
#' Function to estimate the max. and min. number of visits to full fertilization.
#' It depends on "evolution_ovules.R" function, used in the crop_parameter_table.R function
#' @param Crop Crop species (botanical name) to be evaluated
#' @param self number of pollen grains present on the stigmas before first bee visit to account for selfing (default = 0)
#'
#' External parameters used in the function:
#'
#' svd = Single Visit Pollen Deposition of different bee species on a certain crop obtained from data measured in the field 
#' ovu = mean number of ovules of the inspected crop
#' eff_min = (ovu-self)/(svd + ovu - self) minimum efficiency to achieve full fertilization
#' target_visits = target number of visit for full fertilization. It is obtained by using eff_min
#' min_visits = minimum number of visit for full fertilization. It is obtained by using eff = 1
#'
#' @return table with curve parameters to calculate ovule fertilization curves for different crop/pollinator/pollination efficiency scenarios (also to be used in crop_parameter_table)
#' 
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
#' @export
#' 
#' @import tidyverse
#' 
curve_ovule_parameters <- function(Crop, self = 0){
  
  #load visits_table
  visits_table_raw <- visits_table_syn
  
  # Identify the crops in visits_table
  vector_crops_latin <- visits_table_raw$Crop_species %>% unique()
  vector_crops_common <- visits_table_raw$Crop_name %>% unique()
  
  # Select the records for the "Crop" defined by the user
  visits_table_latin <- visits_table_raw %>% filter(Crop_species == Crop) #is it neccesary to use the filters in this "side-function" or will it be enough to implement it in the main function where we will use this side function?
  visits_table_common <- visits_table_raw %>% filter(Crop_name == Crop)
  
  visits_table <- bind_rows(visits_table_latin,visits_table_common)
  
  if(nrow(visits_table)>0){
    
    curve_parameters <- visits_table[,c(2:4,6)]
    
    # Add single visit deposition
    curve_parameters$svd <- visits_table$Pollen_depo_single_sp
    
    #sometimes the researchers measured deposition of pollen grains and sometimes pollen tetrads (4 grains) - how do we account for that? 
    curve_parameters$svd[visits_table$Pollen_depo_unit_short == "tetrads"] <- 4*
      curve_parameters$svd[visits_table$Pollen_depo_unit_short == "tetrads"]
    
    
    #No. of ovules 
    curve_parameters$ovu <- visits_table$No_ovules_per_flower
    
    # % Selfing
    curve_parameters$self <- self
    
    #Function
    curve_parameters$eff <- (curve_parameters$ovu - self)/
      (curve_parameters$ovu - self + curve_parameters$svd) 
    
    
    # Estimating maximum visits for full fertilization (by using eff = eff_min)
    
    curve_parameters$target_visits <- NA
    
    for(j in 1:nrow(curve_parameters)){
      curve_yield_aux <- evolution_ovules(curve_parameters$svd[j],curve_parameters$ovu[j],
                                          self,curve_parameters$eff[j],1:1000)
      
      curve_parameters$target_visits[j] <- 1 + sum(round(curve_yield_aux)<100)
    }
    
    # Estimating minimum visits for full fertilization( by using eff = 1)
    
    curve_parameters$min_visits <- NA
    
    for(j in 1:nrow(curve_parameters)){
      curve_yield_aux <- evolution_ovules(curve_parameters$svd[j],curve_parameters$ovu[j],
                                          self,1,1:1000)
      sum(round(curve_yield_aux)<100)
      curve_parameters$min_visits[j] <- 1 + sum(round(curve_yield_aux)<100)
    }
    
    return(curve_parameters)
    
  }else{
    Line_1 <- "This crop species is not included in our database, try something else:"
    list_possible_crops <- c(vector_crops_latin,vector_crops_common) %>% unique()
    Line_2 <- paste(list_possible_crops,collapse = ", ")
    cat(paste0(Line_1," \n",Line_2))
  }
  
}
