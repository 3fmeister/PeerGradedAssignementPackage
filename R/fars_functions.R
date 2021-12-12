
#' Read input file
#'
#' `fars_read` function reads a single archive file based on the provided filename.
#' Filename should be generated with the make_filename function.
#' The archive file (CSV) contains the data from the US National Highway Traffic Safety
#' Administration's Fatality Analysis Reporting System, which is a nationwide
#' census providing the American public yearly data regarding fatal injuries
#' suffered in motor vehicle traffic crashes.
#'
#' @param filename A character string that represents the name of the input file.
#'
#' @importFrom dplyr tbl_df
#'
#' @importFrom readr read_csv
#'
#' @return The function returns a data frame of the provided data. In case that
#'         there is no file with the provided name, the following error message
#'         will be shown: "file XYZ does not exist".
#'
#' @examples
#' \dontrun{fars_read(filename = "accident_2015.csv.bz2")}
#'
#' @export
fars_read <- function(filename) {
        if(!file.exists(filename))
                stop("file '", filename, "' does not exist")
        data <- suppressMessages({
                readr::read_csv(filename, progress = FALSE)
        })
        dplyr::tbl_df(data)
}


#' Make filename
#'
#' `make_filename` function generates the filename string that will be used in
#' the fars_read function.
#'
#' @param year The only input of the function. It should be a positive number.
#'
#' @return This function returns a string representing the name of the file.
#'         The resulting filename will be in the following format:
#'         accident_YEAR.csv.bz2 .
#'
#' @examples
#' \dontrun{make_filename(year = 2015)}
#'
#' @export
make_filename <- function(year) {
        year <- as.integer(year)
        sprintf("accident_%d.csv.bz2", year)
}




#' Read years
#'
#' `fars_read_years` function utilizes the make_filename() as well as the
#' fars_read() functions to import years. Under the hood the function performs
#' some data manipulation (mutation, selection) and returns the list of the
#' resulting tibbles.
#'
#' @param years Could be a single string or a list of years.
#'
#' @importFrom dplyr mutate select
#'
#' @importFrom magrittr %>%
#'
#' @importFrom rlang .data
#'
#' @return The function returns a list of elements, where each element
#'         contains two columns (MONTH and year). If you pass an incorrect
#'         year (a year for which no data is available) to the function, it will
#'         return the corresponding warning message.
#'
#' @examples
#' \dontrun{fars_read_years(years = 2015)}
#' \dontrun{fars_read_years(years = c(2014, 2015))}
#'
#' @export
fars_read_years <- function(years) {
        lapply(years, function(year) {
                file <- make_filename(year)
                tryCatch({
                        dat <- fars_read(file)
                        dplyr::mutate(dat, year = year) %>%
                                dplyr::select(MONTH, year)
                }, error = function(e) {
                        warning("invalid year: ", year)
                        return(NULL)
                })
        })
}




#' Summarize years
#'
#' `fars_summarize_years` function creates a summary data.frame of car accidents
#' for given year(s). Rows represent months, while different years are represented
#' with columns. For each month in a given year there is a number of accidents that
#' were recorded.
#'
#' @param years Could be a single string or a list of years.
#'
#' @importFrom dplyr bind_rows group_by summarize n
#'
#' @importFrom tidyr spread
#'
#' @return This function returns a tibble (data.frame) with months as rows and
#' years as columns. Each year is represented as a column. Each row contains the
#' number of car accidents given per year (column).
#'
#' @examples
#' \dontrun{fars_summarize_years(c(2013, 2014))}
#'
#' @export
fars_summarize_years <- function(years) {
        dat_list <- fars_read_years(years)
        dplyr::bind_rows(dat_list) %>%
                dplyr::group_by(year, MONTH) %>%
                dplyr::summarize(n = n()) %>%
                tidyr::spread(year, n)
}


#' Map state
#'
#' `fars_map_state` function generates a plot of accidents recorded across the
#' selected state during the given year.
#'
#' @param state.num The code (number) of the state for which to generate a plot.
#'
#' @param year Could be a single string or a list of years.
#'
#' @importFrom dplyr filter
#'
#' @importFrom maps map
#'
#' @importFrom graphics points
#'
#' @return This functions returns a map with points that represent car accidents
#' in the selected state during the given year.
#'
#' @examples
#' \dontrun{fars_map_state(state.num = 1, year = 2015)}
#'
#' @export
fars_map_state <- function(state.num, year) {
        filename <- make_filename(year)
        data <- fars_read(filename)
        state.num <- as.integer(state.num)

        if(!(state.num %in% unique(data$STATE)))
                stop("invalid STATE number: ", state.num)
        data.sub <- dplyr::filter(data, STATE == state.num)
        if(nrow(data.sub) == 0L) {
                message("no accidents to plot")
                return(invisible(NULL))
        }
        is.na(data.sub$LONGITUD) <- data.sub$LONGITUD > 900
        is.na(data.sub$LATITUDE) <- data.sub$LATITUDE > 90
        with(data.sub, {
                maps::map("state", ylim = range(LATITUDE, na.rm = TRUE),
                          xlim = range(LONGITUD, na.rm = TRUE))
                graphics::points(LONGITUD, LATITUDE, pch = 46)
        })
}
