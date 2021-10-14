#' format raw data from ScienceBase for plotting in Base R
#' 
#' Takes raw data downloaded from ScienceBase and prepares it for plotting by adding
#' `col` (color), `pch` (point shapes), and `n_prof` (# of profiles) columns
#' for future plotting
#' 
#' @param file_in String, file location for raw ScienceBase data
#' @param col String vector, vector of colors for plotting. One color per model. Model order is pb, dl, pgdl.
#' @param pch Numeric vector, vector of `pch` values. One pch for each model. Model order is pb, dl, pgdl.
#' @param file_out String, name and path for processed file
#' 
prep_data <- function(file_in, col = c('#1b9e77', '#d95f02', '#7570b3'), pch = c(21:23),  file_out = '2_process/out/model_summary_results.csv'){
  # Prepare the data for plotting
  eval_data <- readr::read_csv(file_in, col_types = 'iccd') %>%
    filter(str_detect(exper_id, 'similar_[0-9]+')) %>%
    mutate(col = case_when(
      model_type == 'pb' ~ col[1],
      model_type == 'dl' ~ col[2],
      model_type == 'pgdl' ~ col[3]
    ), pch = case_when(
      model_type == 'pb' ~ pch[1],
      model_type == 'dl' ~ pch[2],
      model_type == 'pgdl' ~ pch[3]
    ), n_prof = as.numeric(str_extract(exper_id, '[0-9]+')))
  
  # save output data
  readr::write_csv(eval_data, file = file_out)

  return(eval_data)
}