#' Compute Cortisol Sine Score (CSS)
#'
#' Calculates the Cortisol Sine Score using timepoint-specific sine weights
#' extracted from column names like "time_0200", "time_1400", etc.
#'
#' @param data A data.frame or tibble with subject ID in the first column and cortisol values in time_* columns.
#'             The time columns must be named using 24-hour format, e.g. time_0200, time_1400, etc.
#' @param verbose Logical; if TRUE, returns the contribution of each timepoint to the CSS.
#'
#' @return A tibble with subject ID and cortisol_sin_score. If `verbose = TRUE`, includes individual contributions.
#' @export
#'
#' @examples
#' df <- tibble::tibble(
#'   subject_ID = c("S1", "S2"),
#'   time_0200 = c(2, 1),
#'   time_0600 = c(5, 2),
#'   time_1000 = c(4, 3),
#'   time_1400 = c(3, 2),
#'   time_1800 = c(1, 1),
#'   time_2200 = c(0.5, 0.3)
#' )
#' compute_css(df)

compute_css <- function(data, verbose = FALSE) {
  stopifnot(is.data.frame(data))

  # Identify timepoint columns (must start with time_XXXX)
  time_cols <- grep("^time_[0-9]{4}$", names(data), value = TRUE)

  if (length(time_cols) < 4) {
    stop("At least 4 cortisol timepoint columns required.")
  }

  # ==== SAFETY CHECK: non-numeric, NA, or NaN ====
  invalid_cols <- purrr::keep(time_cols, function(col) {
    !is.numeric(data[[col]]) || any(!is.finite(data[[col]]))
  })

  if (length(invalid_cols) > 0) {
    stop("Invalid values in time columns: ",
         paste(invalid_cols, collapse = ", "),
         ". All time_* columns must be numeric and contain no NA, NaN, or Inf.")
  }

  # ==== Extract hour from column names ====
  extract_hour <- function(x) as.numeric(sub("time_", "", x)) %/% 100
  hour_values <- sapply(time_cols, extract_hour)
  names(hour_values) <- time_cols

  # ==== Structural check ====
  if (sum(hour_values < 12) < 2 || sum(hour_values >= 12) < 2) {
    stop("At least 2 timepoints must be before 12:00 and 2 after 12:00.")
  }

  # ==== Compute sine weights ====
  sine_weights <- sin(2 * pi * hour_values / 24)
  names(sine_weights) <- time_cols

  # ==== Debug message ====
  n_subjects <- nrow(data)
  n_timepoints <- length(time_cols)
  msg <- paste0(
    "Building Cortisol Sine Score for ", n_subjects, " subjects with ",
    n_timepoints, " timepoints: ",
    paste(time_cols, collapse = ", ")
  )
  message(msg)

  # ==== Compute CSS ====
  out <- data %>%
    dplyr::rowwise() %>%
    dplyr::mutate(
      cortisol_sin_score = sum(dplyr::c_across(dplyr::all_of(time_cols)) * sine_weights, na.rm = TRUE)
    ) %>%
    dplyr::ungroup()

  # ==== Optional: add contributions per timepoint ====
  if (verbose) {
    for (col in time_cols) {
      out[[paste0("contrib_", col)]] <- out[[col]] * sine_weights[col]
    }
  }

  # Return subject ID + CSS + optional breakdown
  final_cols <- c(names(data)[1], "cortisol_sin_score", grep("^contrib_", names(out), value = TRUE))
  out <- out[, final_cols]

  return(out)
}
