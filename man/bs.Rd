% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data.R
\docType{data}
\name{bs}
\alias{bs}
\title{Basel power usage data}
\format{
\subsection{\code{bs}}{

A data frame, growing every day, the main two columns (all the others are derived):
\describe{
\item{timestamp}{local time}
\item{gross_energy_kwh}{gross energy ("Bruttolastgang") value in kWh for every 15min}
}
}
}
\source{
\url{https://data.bs.ch/explore/dataset/100233/information/?sort=timestamp_interval_start}
}
\usage{
bs
}
\description{
Open government data with a power consumption data point every 15min for the city of Zurich
}
\details{
Downloaded and pre-processed with the script data-raw/02_get_updated_data
}
\keyword{datasets}
