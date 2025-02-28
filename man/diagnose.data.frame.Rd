% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/diagnose.R
\name{diagnose}
\alias{diagnose}
\alias{diagnose.data.frame}
\title{Diagnose data quality of variables}
\usage{
diagnose(.data, ...)

## S3 method for class 'data.frame'
diagnose(.data, ...)
}
\arguments{
\item{.data}{a data.frame or a \code{\link{tbl_df}}.}

\item{...}{one or more unquoted expressions separated by commas.
You can treat variable names like they are positions.
Positive values select variables; negative values to drop variables.
If the first expression is negative, diagnose() will automatically start with all variables.
These arguments are automatically quoted and evaluated in a context where column names
represent column positions.
They support unquoting and splicing.}
}
\value{
An object of tbl_df.
}
\description{
The diagnose() produces information for diagnosing
the quality of the variables of data.frame or tbl_df.
}
\details{
The scope of data quality diagnosis is information on missing values
and unique value information. Data quality diagnosis can determine variables
that require missing value processing. Also, the unique value information can
determine the variable to be removed from the data analysis.
}
\section{Diagnostic information}{

The information derived from the data diagnosis is as follows.:

\itemize{
\item variables : variable names
\item types : data type of the variable
or to select a variable to be corrected or removed through data diagnosis.
\itemize{
\item integer, numeric, factor, ordered, character, etc.
}
\item missing_count : number of missing values
\item missing_percent : percentage of missing values
\item unique_count : number of unique values
\item unique_rate : ratio of unique values. unique_count / number of observation
}

See vignette("diagonosis") for an introduction to these concepts.
}

\examples{
# Diagnosis of all variables
diagnose(jobchange)

# Select the variable to diagnose
diagnose(jobchange, gender, experience, training_hours)
diagnose(jobchange, -gender, -experience, -training_hours)
diagnose(jobchange, "gender", "experience", "training_hours")
diagnose(jobchange, 4, 9, 13)

# Using pipes ---------------------------------
library(dplyr)

# Diagnosis of all variables
jobchange \%>\%
  diagnose()
# Positive values select variables
jobchange \%>\%
  diagnose(gender, experience, training_hours)
# Negative values to drop variables
jobchange \%>\%
  diagnose(-gender, -experience, -training_hours)
# Positions values select variables
jobchange \%>\%
  diagnose(4, 9, 13)
# Positions values select variables
jobchange \%>\%
  diagnose(-8, -9, -10)
  
# Using pipes & dplyr -------------------------
# Diagnosis of missing variables
jobchange \%>\%
  diagnose() \%>\%
  filter(missing_count > 0)

}
\seealso{
\code{\link{diagnose.tbl_dbi}}, \code{\link{diagnose_category.data.frame}}, \code{\link{diagnose_numeric.data.frame}}.
}
