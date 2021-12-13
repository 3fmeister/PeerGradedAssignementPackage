# PeerGradedAssignmentPackage
A repo for Coursera Building R Packages Week 4's peer-graded assignment.

The purpose of this assessment is for you to combine your skills of creating, writing, documenting, and testing an R package with releasing that package on GitHub. In this assessment you'll be taking the R files from Week 2's assessment about documentation and putting that file in an R package. 

For this assessment you must

1. write a vignette to include in your package using knitr and R Markdown

2. write at least one test written using testthat

3. put your package on GitHub

4. set up the repository so that the package can be checked and built on Travis

5. Once your package has built on Travis and the build is passing with no errors, warnings, or notes you should add your Travis badge to the README.md file of your package repository.


## Installation

To install this package, you must first install the {devtools} package. Once you do that, run the following command in the console""

devtools::install_github('3fmeister/PeerGradedAssignmentPackage', build_vignettes = TRUE)

And load the {PeerGradedAssignmentPackage} package:

library(PeerGradedAssignmentPackage)



## Vignette

You may want to take a look at the vignette: vignette('fars', package = 'PeerGradedAssignmentPackage').

<!-- badges: start -->
  [![R-CMD-check](https://github.com/3fmeister/PeerGradedAssignementPackage/workflows/R-CMD-check/badge.svg)](https://github.com/3fmeister/PeerGradedAssignementPackage/actions)
  <!-- badges: end -->
