#' Creates a table with yield_parameters to be used in the "model_eval_visitation_rate.R" function
#' 
#' Create yield_parameter_table that gives selfing values and max. production values for different crops 
#' 
#' @return  returns a table with parameters to be used in "model_eval_visitation_rate.R" function
#' 
#' @import tidyverse
#' 
#' @references  check .txt file
#'
yield_parameter_table <- function(){
  
  yield_table_raw <- yield_variables %>%
    rename(Source_yield = Source) %>% 
    select(-`Target_flower_visits (Garibaldi or original source)`)
  
  yield_crop_species <- study_meta_data %>% 
    select(Study_ID,Crop_name,Crop_species)
  
  yield_table <- yield_table_raw %>% left_join(yield_crop_species, by =
                                                 c("Study_ID","Crop_name"))
  yield_table <- yield_table[,c(1:3,14,4:13)]
  
  yield_table$Crop_species[yield_table$Crop_species == 
                             "Vaccinium macrocarpon "] <- "Vaccinium macrocarpon"
  
  yield_table$Crop_species[yield_table$Crop_species == 
                             "Vaccinium ashei "] <- "Vaccinium ashei"
  
  yield_table$Crop_species[yield_table$Crop_species == 
                             "Vaccinium ashei "] <- "Vaccinium ashei"
  
  return(yield_table)
  
}

