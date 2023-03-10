% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/utils_module_overview_month.R
\name{plot_month_cumulative}
\alias{plot_month_cumulative}
\title{plot_month_cumulative}
\usage{
plot_month_cumulative(data_ref, data_current, bs_colors)
}
\arguments{
\item{data_ref}{data_ref output from prepare_data_for_monthly_plot function}

\item{data_current}{data_current output from prepare_data_for_monthly_plot function}

\item{bs_colors}{named hex color vector with "light", "secondary" and "success" colors}
}
\value{
ggplot
}
\description{
function to plot the current data vs. a reference range for a month
in a cumulative way. A utility function for the overview module.
}
\keyword{internal}
