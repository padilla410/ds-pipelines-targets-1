#' Fetch Lake Mendota model results from ScienceBase
#'
#' Downloads root mean squared error (RMSE) results from
#' "Process-guided deep learning water temperature predictions: 
#' 6a Lake Mendota detailed evaluation data" from ScienceBase
#' 
#' Returns full file path for the downloaded file
#'
#' @param path_out string, location where ScienceBase data will be saved

fetch_data <- function(path_out){
  # Create output file path and get data from ScienceBase
  mendota_file <- file.path(path_out, '/model_RMSEs.csv')
  sbtools::item_file_download('5d925066e4b0c4f70d0d0599', names = 'me_RMSE.csv', 
                     destinations = mendota_file, overwrite_file = TRUE)
}



