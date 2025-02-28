% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/tbl_dbi.R
\name{describe.tbl_dbi}
\alias{describe.tbl_dbi}
\title{Compute descriptive statistic}
\usage{
## S3 method for class 'tbl_dbi'
describe(
  .data,
  ...,
  statistics = NULL,
  quantiles = NULL,
  in_database = FALSE,
  collect_size = Inf
)
}
\arguments{
\item{.data}{a tbl_dbi.}

\item{...}{one or more unquoted expressions separated by commas.
You can treat variable names like they are positions.
Positive values select variables; negative values to drop variables.
If the first expression is negative, describe() will automatically start with all variables.
These arguments are automatically quoted and evaluated in a context where column names
represent column positions.
They support unquoting and splicing.}

\item{statistics}{character. the name of the descriptive statistic to calculate.
The defaults is c("mean", "sd", "se_mean", "IQR", "skewness", "kurtosis", "quantiles")}

\item{quantiles}{numeric. list of quantiles to calculate.
The values of elements must be between 0 and 1. and to calculate quantiles,
you must include "quantiles" in the statistics argument value.
The default is c(0, .01, .05, 0.1, 0.2, 0.25, 0.3, 0.4, 0.5, 0.6, 0.7, 0.75, 0.8, 0.9, 0.95, 0.99, 1).}

\item{in_database}{Specifies whether to perform in-database operations.
If TRUE, most operations are performed in the DBMS. if FALSE,
table data is taken in R and operated in-memory. Not yet supported in_database = TRUE.}

\item{collect_size}{a integer. The number of data samples from the DBMS to R.
Applies only if in_database = FALSE.

See vignette("EDA") for an introduction to these concepts.}
}
\value{
An object of the same class as .data.
}
\description{
The describe() compute descriptive statistic of numerical(INTEGER, NUMBER, etc.)
column of the DBMS table through tbl_dbi for exploratory data analysis.
}
\details{
This function is useful when used with the \code{\link{group_by}} function
of the dplyr package.
If you want to calculate the statistic by level of the categorical data
you are interested in, rather than the whole statistic, you can use
grouped_df as the group_by() function.
}
\section{Descriptive statistic information}{

The information derived from the numerical data describe is as follows.

\itemize{
\item n : number of observations excluding missing values
\item na : number of missing values
\item mean : arithmetic average
\item sd : standard deviation
\item se_mean : standard error mean. sd/sqrt(n)
\item IQR : interquartile range (Q3-Q1)
\item skewness : skewness
\item kurtosis : kurtosis
\item p25 : Q1. 25\\% percentile
\item p50 : median. 50\\% percentile
\item p75 : Q3. 75\\% percentile
\item p01, p05, p10, p20, p30 : 1\\%, 5\\%, 20\\%, 30\\% percentiles
\item p40, p60, p70, p80 : 40\\%, 60\\%, 70\\%, 80\\% percentiles
\item p90, p95, p99, p100 : 90\\%, 95\\%, 99\\%, 100\\% percentiles

}
}

\examples{
library(dplyr)

# connect DBMS
con_sqlite <- DBI::dbConnect(RSQLite::SQLite(), ":memory:")

# copy heartfailure to the DBMS with a table named TB_HEARTFAILURE
copy_to(con_sqlite, heartfailure, name = "TB_HEARTFAILURE", overwrite = TRUE)

# Using pipes ---------------------------------
# Positive values select variables
con_sqlite \%>\% 
  tbl("TB_HEARTFAILURE") \%>\% 
  describe(platelets, creatinine, sodium)
  
con_sqlite \%>\% 
  tbl("TB_HEARTFAILURE") \%>\% 
  describe(platelets, creatinine, sodium, 
    statistics = c("mean", "sd", "quantiles"), quantiles = 0.1)

# Negative values to drop variables, and In-memory mode and collect size is 200
con_sqlite \%>\% 
  tbl("TB_HEARTFAILURE") \%>\% 
  describe(-platelets, -creatinine, -sodium, collect_size = 200)

# Using pipes & dplyr -------------------------
# Find the statistic of all numerical variables by 'smoking' and 'death_event',
# and extract only those with 'smoking' variable level is "Yes".
con_sqlite \%>\% 
  tbl("TB_HEARTFAILURE") \%>\% 
  group_by(smoking, death_event) \%>\%
  describe() \%>\%
  filter(smoking == "Yes")

# extract only those with 'sex' variable level is "Male",
# and find 'sodium' statistics by 'smoking' and 'death_event'
con_sqlite \%>\% 
  tbl("TB_HEARTFAILURE") \%>\% 
  filter(sex == "Male") \%>\%
  group_by(smoking, death_event) \%>\%
  describe(sodium)

# Disconnect DBMS   
DBI::dbDisconnect(con_sqlite)

}
\seealso{
\code{\link{describe.data.frame}}, \code{\link{diagnose_numeric.tbl_dbi}}.
}
