% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/model_eval_visitation_rate.R
\name{model_eval_visitation_rate}
\alias{model_eval_visitation_rate}
\title{Plot of yield curves}
\usage{
model_eval_visitation_rate(Crop, visit_rate)
}
\arguments{
\item{Crop}{non-latin name of the crop (e.g. "Apple", "Blueberry", etc.)}

\item{visit_rate}{visitation rate measured in the center of a given field}
}
\value{
Plot showing the observed yield and visitation rates as well as the max. yield and the visitation rates necessary to obtain it  
works if the Crop is in the referred table otherwise an error message will be produced
}
\description{
Function that creates yield curves based on the data in the tables crop_parameter_table 
and yield_parameter_table.
To estimate visitation rates we assume that visits should occur while the flowers are receptive,
and assuming 6 hr of daily pollinator activity.
}
\details{
The number of days of flower receptivity is extracted from Garibaldi et al (2020) table 1. 
To estimate visitation rates we assume that selfing is equal to zero (self = 0).

The following functions are needed to run the function below:
crop_parameter_table.R, curve_ovule_parameters.R functions, evolution_ovules.R,
yield_parameter_table.R, shape_par_exp_decay.R, non_inflicted_yield.R
}
\examples{
model_eval_visitation_rate(Crop ="Blueberry", 11)

}
