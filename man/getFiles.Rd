% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/getDataSHIELDInfo.R
\name{getFiles}
\alias{getFiles}
\title{Get the session information of the DataSHIELD server}
\usage{
getFiles(..., recursive = FALSE)
}
\arguments{
\item{...}{Path to files}

\item{recursive}{Path to files}
}
\value{
list of session infos returned from \code{sessionInfo()} of each machine
}
\description{
This method returns \code{sessionInfo()} from the used DataSHIELD servers.
The main purpose is for testing and checking the environment used on the remote servers.
}
\author{
Daniel S.
}
