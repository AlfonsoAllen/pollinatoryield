#' Plot of yield curves
#' 
#' Function that creates yield curves based on the data in the synthetic_table 
#' To generate the yield curve we use the lower target visitation rate in the previous table. 
#'
#'@param Crop non-latin name of the crop (e.g. "Apple", "Blueberry", etc.)
#'@param visit_rate visitation rate measured in the center of a given field
#'
#'@return Plot showing the observed yield and visitation rates as well as the max. yield and the visitation rates necessary to obtain it  
#'works if the Crop is in the referred tabl otherwise an error message will be produced
#'
#'@examples 
#'eval_visitation_rate(Crop ="Blueberry", 11)
#'
#'@export
#'
#'@import tidyverse
#'@import ggplot2

eval_visitation_rate <- function(Crop,visit_rate){
  
  # Load synthetic for Crop_name
  demo_table <- load("data/demo_table.RData")
  
  vector_crops <- demo_table %>% select(Crop_name) %>% 
    pull() %>% unique()
  
  demo_table <- demo_table %>% filter(Crop_name == Crop)
  
  if(nrow(demo_table)>0){
    
    # % of yield witout pollinators
    demo_table$perc_yield_no_pollinators <- 100 * demo_table$Intercept_production / demo_table$Max_production
    
    # Asses shape parameter for non-inflected yield curves
    demo_table$shape_parameter_lower <- shape_par_exp_decay(demo_table$perc_yield_no_pollinators,
                                                            demo_table$Max_production,
                                                            demo_table$Target_visitation_rate_lower )
    
    # To plot the non-inflected curves we use 101 values of visitation rate between 0 and 1.5 x target value
    # We will store those values in a dataframe
    vist_rate_upper_limit <- 1.5 * max(demo_table$Target_visitation_rate_lower)
    
    # Create df
    df_vist_rate <- data.frame(Crop_name = rep(Crop,101),
                               visit_rate = seq(from = 0, to = vist_rate_upper_limit, length.out = 101))
    
    figure_curve <- demo_table %>% left_join(df_vist_rate, by = "Crop_name")
    
    figure_curve$yield <- non_inflicted_yield(figure_curve$perc_yield_no_pollinators,
                                              figure_curve$Max_production,
                                              figure_curve$shape_parameter_lower,
                                              figure_curve$visit_rate)
    
    
    figure_points <- demo_table
    
    figure_points$opt_yield <- non_inflicted_yield(figure_points$perc_yield_no_pollinators,
                                                   figure_points$Max_production,
                                                   figure_points$shape_parameter_lower,
                                                   figure_points$Target_visitation_rate_lower)
    
    figure_points$real_yield <- non_inflicted_yield(figure_points$perc_yield_no_pollinators,
                                                    figure_points$Max_production,
                                                    figure_points$shape_parameter_lower,
                                                    visit_rate)
    
    ggplot(figure_curve, aes(x = visit_rate, y = yield, group = Intercept_production, color = Crop_var)) +
      geom_line()+
      geom_point(data = figure_points, aes(x = Target_visitation_rate_lower, y = opt_yield))+
      geom_segment(data = figure_points, aes(x = Target_visitation_rate_lower, y = 0,
                                             xend = Target_visitation_rate_lower, yend = opt_yield),
                   linetype = "dashed")+
      geom_point(data = figure_points, aes(x = visit_rate, y = real_yield))+
      geom_segment(data = figure_points, aes(x = visit_rate, y = 0,
                                             xend = visit_rate, yend = real_yield),
                   linetype = "dashed")+
      facet_wrap(~Production_unit+Main_pollinators)+
      labs(x = "Visits per 100 flowers during 1 hour", y = "Yield", color = "Variety", title = Crop)
    
    
  }else{
    print("That crop is not included in our database. Please, select one of the following crops:")
    
    print(paste(vector_crops,collapse = ", "))
  }
  
  
}
