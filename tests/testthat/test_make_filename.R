library(testthat)
library(PeerGradedAssignmentPackage)
library(dplyr)
library(readr)
library(tidyr)
library(magrittr)
library(graphics)
library(maps)


# Test make_filename function
test_that("Testing the make_filename function", {
        years <- c(2013, 2014, 2015)
        # Select random year to test the make_filename function
        random_year <- sample(years, 1)
        expect_equal(make_filename(random_year), paste0("accident_", random_year, ".csv.bz2"))})
