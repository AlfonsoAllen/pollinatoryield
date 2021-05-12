#' Plot of yield curves
#' 
#' Function that creates yield curves based on the data in the tables crop_parameter_table 
#' and yield_parameter_table.
#' To estimate visitation rates we assume that visits should occur while the flowers are receptive,
#' and assuming 6 hr of daily pollinator activity.
#'
#' The number of days of flower receptivity is extracted from Garibaldi et al (2020) table 1. 
#' To estimate visitation rates we assume that selfing is equal to zero (self = 0).
#'
#' The following functions are needed to run the function below:
#' crop_parameter_table.R, curve_ovule_parameters.R functions, evolution_ovules.R,
#' yield_parameter_table.R, shape_par_exp_decay.R, non_inflicted_yield.R
#'
#' @param Crop non-latin name of the crop (e.g. "Apple", "Blueberry", etc.)
#' @param visit_rate visitation rate measured in the center of a given field
#'
#' @return Plot showing the observed yield and visitation rates as well as the max. yield and the visitation rates necessary to obtain it  
#' works if the Crop is in the referred table otherwise an error message will be produced
#'
#' @examples 
#' model_eval_visitation_rate(Crop ="Blueberry", 11)
#'
#' @export
#' @import tidyverse
#' 
model_eval_visitation_rate <- function(Crop,visit_rate){
 
  yield_table <- yield_parameter_table()
  crop_parameters <- crop_parameter_table() %>% rename(Crop_var_ovules = Crop_var)
  
  yield_pollen_table_aux <- yield_table %>% left_join(crop_parameters,
                                                      by = c("Crop_name","Crop_species")) %>%
    filter(!is.na(target_visits))
  
  vector_crops <- yield_pollen_table_aux %>% select(Crop_species) %>% 
    pull() %>% unique()
  
  yield_pollen_table <- yield_pollen_table_aux %>% filter(Crop_species == Crop)
  
  if(nrow(yield_pollen_table)>0){
    
    # % of yield witout pollinators
    yield_pollen_table$perc_yield_no_pollinators <- 100 * yield_pollen_table$Intercept_production / yield_pollen_table$Max_production
    
    # Asses shape parameter for non-inflected yield curves
    yield_pollen_table$shape_parameter_lower <- shape_par_exp_decay(yield_pollen_table$perc_yield_no_pollinators,
                                                            yield_pollen_table$Max_production,
                                                            yield_pollen_table$target_visitation_rate)
    
    # To plot the non-inflected curves we use 101 values of visitation rate between 0 and 1.5 x target value
    # We will store those values in a dataframe
    vist_rate_upper_limit <- 1.5 * max(yield_pollen_table$target_visitation_rate)
    
    # Create df
    df_vist_rate <- data.frame(Crop_species = rep(Crop,101),
                               visit_rate = seq(from = 0,
                                                to = vist_rate_upper_limit,
                                                length.out = 101))
    
    figure_curve <- yield_pollen_table %>% left_join(df_vist_rate, by = "Crop_species")
    
    figure_curve$yield <- non_inflicted_yield(figure_curve$perc_yield_no_pollinators,
                                              figure_curve$Max_production,
                                              figure_curve$shape_parameter_lower,
                                              figure_curve$visit_rate)
    
    
    figure_points <- yield_pollen_table
    
    figure_points$opt_yield <- non_inflicted_yield(figure_points$perc_yield_no_pollinators,
                                                   figure_points$Max_production,
                                                   figure_points$shape_parameter_lower,
                                                   figure_points$target_visitation_rate)
    
    figure_points$real_yield <- non_inflicted_yield(figure_points$perc_yield_no_pollinators,
                                                    figure_points$Max_production,
                                                    figure_points$shape_parameter_lower,
                                                    visit_rate)
    
    figure_curve$Crop_var[is.na(figure_curve$Crop_var)] <- "Not available"
    
    ggplot(figure_curve, aes(x = visit_rate, y = yield, group = Intercept_production, color = Crop_var)) +
      geom_line()+
      geom_point(data = figure_points, aes(x = target_visitation_rate, y = opt_yield))+
      geom_segment(data = figure_points, aes(x = target_visitation_rate, y = 0,
                                             xend = target_visitation_rate, yend = opt_yield),
                   linetype = "dashed")+
      geom_point(data = figure_points, aes(x = visit_rate, y = real_yield))+
      geom_segment(data = figure_points, aes(x = visit_rate, y = 0,
                                             xend = visit_rate, yend = real_yield),
                   linetype = "dashed")+
      facet_wrap(~Production_unit+Species, scales = "free_y")+
      labs(x = "Visits per 100 flowers during 1 hour", 
           y = "Yield", color = "Variety", title = Crop)
    
    
  }else{
    Line_1 <- "That crop is not included in our database. Please, select one of the following crop species:"
    Line_2 <- paste(vector_crops,collapse = ", ")
    cat(paste0(Line_1," \n",Line_2))
    
  }
    
}
  