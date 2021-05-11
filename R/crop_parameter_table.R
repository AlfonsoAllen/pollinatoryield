#' Creates a table with crop-parameters to be used in the "model_eval_visitation_rate.R" function
#' 
#' Create crop_parameter_table for estimating the dependence of yield on visitation rates
#' To estimate visitation rates we assume that visits should occur while the flowers are receptive,
#' and assuming 6 hr of daily pollinator activity
#' 
#' @return  returns a table with parameters to be used in "model_eval_visitation_rate.R" function
#' 
#' Depends on curve_ovule_parameters.R function and evolution_ovules.R function
#' 
#' @import tidyverse
#'
#' @references The number of days of flower receptivity is extracted from Garibaldi et al (2020) table 1.
#'
crop_parameter_table <- function(){
  
  pollen_table <- visits_table_syn
  flower_receptivity_table <- table_garibaldi2019 %>%
    select(Crop_name,Days_flower_receptivity,`References for days of flower receptivity`) %>%
    rename(references_flower_receptivity = `References for days of flower receptivity`)
  
  
  list_crops_pollen <- pollen_table$Crop_name %>% unique()
  
  ovule_parameters <- NULL
  
  for(Crop.i in list_crops_pollen){
    ovule_parameters <- bind_rows(ovule_parameters,curve_ovule_parameters(Crop.i, self = 0))
    
  }
  
  crop_parameters <- ovule_parameters %>% left_join(flower_receptivity_table,by ="Crop_name") %>%
    filter(!is.na(Days_flower_receptivity))  %>%
    mutate(target_visitation_rate = target_visits * 100/(Days_flower_receptivity*6),
           optimal_visitation_rate = min_visits * 100/(Days_flower_receptivity*6))
  
  return(crop_parameters)
}

