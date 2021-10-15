#' Save processed data from ScienceBase
#' 
#' Saves processed data in a user-specified location
#' 
#' @param data_in tbl, processed model results from ScienceBase
#' @param file_out string, complete file path where processed data will be saved
#' 
save_processed_data <- function(data_in, file_out = '3_process/out/model_summary_results.csv'){
  readr::write_csv(data_in, file = file_out)
  return(file_out)
}
