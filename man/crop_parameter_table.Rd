% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/crop_parameter_table.R
\name{crop_parameter_table}
\alias{crop_parameter_table}
\title{Creates a table with crop-parameters to be used in the "model_eval_visitation_rate.R" function}
\usage{
crop_parameter_table()
}
\value{
returns a table with parameters to be used in "model_eval_visitation_rate.R" function

Depends on curve_ovule_parameters.R function and evolution_ovules.R function
}
\description{
Create crop_parameter_table for estimating the dependence of yield on visitation rates
To estimate visitation rates we assume that visits should occur while the flowers are receptive,
and assuming 6 hr of daily pollinator activity
}
\references{
The number of days of flower receptivity is extracted from Garibaldi et al (2020) table 1.
}
